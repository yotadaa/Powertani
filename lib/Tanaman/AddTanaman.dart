import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:powertani/Tanaman/jenisTanaman.dart';
import 'package:powertani/Tanaman/tanaman.dart';
import 'package:powertani/components/AppBar.dart';
import 'package:powertani/components/ImagePickerDisplay.dart';
import 'package:powertani/components/Text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:powertani/components/components.dart';
import 'package:powertani/env.dart';

class AddTanaman extends StatefulWidget {
  const AddTanaman({super.key});

  @override
  _AddTanamanState createState() => _AddTanamanState();
}

class _AddTanamanState extends State<AddTanaman> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController namaTanamanController = TextEditingController();
  final TextEditingController namaLatinController = TextEditingController();
  final TextEditingController deskripsiController = TextEditingController();
  final TextEditingController imgController = TextEditingController();
  final TextEditingController pupukController = TextEditingController();
  final TextEditingController lamaMasaTanamAwalController =
      TextEditingController();
  final TextEditingController lamaMasaTanamAkhirController =
      TextEditingController();

  // Variables
  String selectedJenisTanaman = "";
  String selectedKategori = "";
  List<String> selectedMusim = [];
  List<String> pupukList = [];
  bool isUploading = false;
  List<String> listedJenisTanaman = [];
  List<String> listedKategori = [];
  List<String> kategoriList = [];

  bool isPressingSearch = false;

  // Variables for Dropdowns
  Box<JenisTanaman>? jenisTanaman;

  // Image File
  File? _imageFile;
  File? image;
  final picker = ImagePicker();
  String imgUrl = "";

  @override
  void initState() {
    super.initState();
    _loadJenisTanaman();
  }

  void resetForm() {
    // Reset TextEditingControllers
    _imageFile = null;
    namaTanamanController.clear();
    namaLatinController.clear();
    deskripsiController.clear();
    imgController.clear();
    pupukController.clear();
    lamaMasaTanamAwalController.clear();
    lamaMasaTanamAkhirController.clear();

    // Reset other variables
    selectedJenisTanaman = "";
    selectedKategori = "";
    selectedMusim.clear();
    pupukList.clear();
    isUploading = false;
    listedJenisTanaman.clear();
    listedKategori.clear();
    kategoriList.clear();
    listedJenisTanaman.clear();
  }

  // Function to load JenisTanaman from Hive
  Future<void> _loadJenisTanaman() async {
    Box<JenisTanaman> jenisTanamanBox =
        await Hive.openBox<JenisTanaman>('jenisTanamanBox');

    setState(() {
      jenisTanaman = jenisTanamanBox;
      // selectedJenisTanaman = jenisTanamanBox.values.toList()[0]!.nama;
    });
  }

  // Function to load Kategori based on selected JenisTanaman
  void _loadKategori() async {
    if (listedJenisTanaman.length == 0) return;
    Box<JenisTanaman> jenisTanamanBox =
        await Hive.openBox<JenisTanaman>('jenisTanamanBox');

    List<JenisTanaman?> selectedJenis = listedJenisTanaman.toList().map((o) {
      JenisTanaman foundItem = jenisTanamanBox.values.firstWhere((obj) =>
          obj.nama == jenisTanamanBox.values.toList()[int.parse(o)].nama);
      return foundItem;
    }).toList();

    setState(() {
      kategoriList = selectedJenis.expand((list) => list!.kategori).toList();
      for (var o in kategoriList) {
        print(o);
      }
    });
  }

  // Image Picker Function
  Future<void> _pickImage() async {
    try {
      final _imageFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (_imageFile == null) return;
      final imageTemp = File(_imageFile.path);
      setState(() => this._imageFile = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  // Function to upload image to Firebase Storage
  // Function to upload image to Firebase Storage
  Future<String?> _uploadImageToFirebase(File image) async {
    try {
      String fileName =
          'tanaman_images/${DateTime.now().millisecondsSinceEpoch}.png';
      Reference storageReference =
          FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = storageReference.putFile(image);

      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }

// Function to handle form submission
  Future<void> _submitForm() async {
    setState(() {
      isUploading = true;
    });
    try {
      if (_formKey.currentState!.validate()) {
        String imageUrl = "";

        if (_imageFile != "") {
          imageUrl = await _uploadImageToFirebase(_imageFile!) ?? '';
        }

        var newTanaman = Tanaman(
          namaTanaman: namaTanamanController.text,
          namaLatin: namaLatinController.text,
          deskripsi: deskripsiController.text,
          img: imageUrl,
          kategori: <String>[...listedKategori],
          jenisTanaman: <int>[
            ...listedJenisTanaman.map((o) => int.parse(o))
          ], // Example index for JenisTanaman
          musim: selectedMusim,
          pupuk: <String>[...pupukList],
          lamaMasaTanam: <int>[
            int.parse(lamaMasaTanamAwalController.text),
            int.parse(lamaMasaTanamAkhirController.text)
          ],
        );

        // Check for existing Tanaman and upload or update Firestore
        await _checkAndUploadTanaman(newTanaman, imageUrl);
      }
      setState(() {
        isUploading = false;
        resetForm();
      });
    } catch (e) {
    } finally {
      if (mounted)
        setState(() {
          isUploading = false;
          resetForm();
        });
    }
  }

// Function to check and upload Tanaman to Firestore
  Future<void> _checkAndUploadTanaman(Tanaman newTanaman, String imgUrl) async {
    try {
      CollectionReference tanamanCollection =
          FirebaseFirestore.instance.collection('Tanaman');

      // Query Firestore to check if a Tanaman with the same 'namaLatin' exists
      var querySnapshot = await tanamanCollection
          .where('namaLatin', isEqualTo: newTanaman.namaLatin)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // If a document exists, update it
        var existingDocument = querySnapshot.docs.first;
        String? existingImageUrl = existingDocument['img'];

        // If there's a new image and the image is different, delete the old one
        if (newTanaman.img.isNotEmpty && existingImageUrl != newTanaman.img) {
          await _deleteOldImageFromFirebase(existingImageUrl);
          await _uploadAndUpdateImage(existingDocument.id, newTanaman, imgUrl);
        } else {
          await _updateTanaman(existingDocument.id, newTanaman);
        }

        print(
            "Tanaman with namaLatin '${newTanaman.namaLatin}' has been updated.");
      } else {
        // If no document exists with the same 'namaLatin', add a new document
        await _uploadTanamanToFirestore(newTanaman);
        print(
            "New Tanaman with namaLatin '${newTanaman.namaLatin}' has been added.");
      }
    } catch (e) {
      print("Error checking or uploading Tanaman: $e");
    }
  }

// Function to update Tanaman document in Firestore
  Future<void> _updateTanaman(String docId, Tanaman tanaman) async {
    try {
      CollectionReference tanamanCollection =
          FirebaseFirestore.instance.collection('Tanaman');

      await tanamanCollection.doc(docId).update({
        'namaTanaman': tanaman.namaTanaman,
        'namaLatin': tanaman.namaLatin,
        'deskripsi': tanaman.deskripsi,
        'img': tanaman.img,
        'kategori': tanaman.kategori,
        'jenisTanaman': tanaman.jenisTanaman,
        'musim': tanaman.musim,
        'pupuk': tanaman.pupuk,
        'lamaMasaTanam': tanaman.lamaMasaTanam,
      });
      print("Tanaman document updated.");
    } catch (e) {
      print("Error updating Tanaman document: $e");
    }
  }

// Function to upload a new Tanaman document to Firestore
  Future<void> _uploadTanamanToFirestore(Tanaman tanaman) async {
    try {
      CollectionReference tanamanCollection =
          FirebaseFirestore.instance.collection('Tanaman');

      var tanamanData = {
        'namaTanaman': tanaman.namaTanaman,
        'namaLatin': tanaman.namaLatin,
        'deskripsi': tanaman.deskripsi,
        'img': tanaman.img,
        'kategori': tanaman.kategori,
        'jenisTanaman': tanaman.jenisTanaman,
        'musim': tanaman.musim,
        'pupuk': tanaman.pupuk,
        'lamaMasaTanam': tanaman.lamaMasaTanam,
      };

      await tanamanCollection.add(tanamanData);
      print("Tanaman successfully added to Firestore.");
    } catch (e) {
      print("Failed to upload Tanaman to Firestore: $e");
    }
  }

// Function to handle image deletion from Firebase Storage
  Future<void> _deleteOldImageFromFirebase(String? imageUrl) async {
    try {
      if (imageUrl != null && imageUrl.isNotEmpty) {
        Reference storageReference =
            FirebaseStorage.instance.refFromURL(imageUrl);
        await storageReference.delete();
        print("Old image deleted from Firebase Storage.");
      }
    } catch (e) {
      print("Failed to delete old image: $e");
    }
  }

// Function to upload the new image and update Firestore document
  Future<void> _uploadAndUpdateImage(
      String docId, Tanaman tanaman, String imgUrl) async {
    try {
      // String? newImageUrl = await _uploadImageToFirebase(_imageFile!);

      if (imgUrl != null) {
        await _updateTanaman(
            docId,
            Tanaman(
              namaTanaman: tanaman.namaTanaman,
              namaLatin: tanaman.namaLatin,
              deskripsi: tanaman.deskripsi,
              img: imgUrl,
              kategori: tanaman.kategori,
              jenisTanaman: tanaman.jenisTanaman,
              musim: tanaman.musim, lamaMasaTanam: [], pupuk: [],
              // lamaMasaTanam: tanaman.lamaMasaTanam,
            ));
        print("New image uploaded and Tanaman document updated.");
      }
    } catch (e) {
      print("Failed to upload new image and update Tanaman: $e");
    }
  }

  Future<void> findNamaLatin() async {
    try {
      // Reference to the 'Tanaman' collection
      CollectionReference tanamanCollection =
          FirebaseFirestore.instance.collection('Tanaman');

      // Query Firestore for a document where 'namaLatin' matches the input
      var querySnapshot = await tanamanCollection
          .where('namaLatin', isEqualTo: namaLatinController.text)
          .get();

      // Check if documents are found
      if (querySnapshot.docs.isNotEmpty) {
        var existingDocument = querySnapshot.docs.first;

        print("The tanaman: ");
        print(existingDocument['namaTanaman']);
        print(existingDocument['deskripsi']);
        print(existingDocument['jenisTanaman']);
        print("=============");

        setState(() {
          // Set values for your controllers and state variables
          imgUrl = existingDocument['img'];
          print("namaTanaman");
          namaTanamanController.text =
              existingDocument.get('namaTanaman') ?? '';
          print("deskripsi");
          deskripsiController.text = existingDocument.get('deskripsi') ?? '';

          print("jenis tanaman");
          listedJenisTanaman = [...existingDocument['jenisTanaman']]
              .map((o) => o.toString())
              .toList();
          print("kategori");
          listedKategori = <String>[...existingDocument['kategori']];

          print("musim");
          selectedMusim =
              List<String>.from(existingDocument.get('musim') ?? []);

          print("pupuk");
          pupukList = List<String>.from(existingDocument.get('pupuk') ?? []);

          // Handle lamaMasaTanam safely if it's a list

          print("masa tanamm");
          var lamaMasaTanam = existingDocument.get('lamaMasaTanam');
          if (lamaMasaTanam is List && lamaMasaTanam.length >= 2) {
            lamaMasaTanamAwalController.text =
                lamaMasaTanam[0].toString() ?? '';
            lamaMasaTanamAkhirController.text =
                lamaMasaTanam[1].toString() ?? '';
          }
        });
        // print(FileImage(Uri.parse(imgUrl)));
      } else {
        print("No document found with this 'namaLatin'");
      }
    } catch (e) {
      // Log or print the error
      print("Error finding document: $e");
    }
  }

  // Widget to add Pupuk dynamically
  Widget _buildPupukField() {
    return Column(
      children: [
        TextFormField(
          controller: pupukController,
          decoration: InputDecoration(labelText: 'Pupuk'),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(colors: [
                AppColors.primaryGreenDark,
                AppColors.primaryGreenLight
              ])),
          child: TextButton(
            child: StdText(
                text: "Tambah Pupuk",
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 15),
            onPressed: () {
              if (pupukController.text.isNotEmpty) {
                setState(() {
                  pupukList.add(pupukController.text);
                  pupukController.clear();
                });
              }
            },
          ),
        ),
        ...pupukList.map((pupuk) => ListTile(
              title: Text(pupuk),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  setState(() {
                    pupukList.remove(pupuk);
                  });
                },
              ),
            ))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainAppBar(
      title: "Tambah Tanaman",
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  children: [
                    SizedBox(
                        // height: 10,
                        ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                              colors: [Colors.red, Colors.purple[200]!])),
                      child: TextButton(
                        child: StdText(
                            text: "Reset",
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 15),
                        onPressed: resetForm,
                      ),
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        print(_imageFile);
                      },
                      child: _imageFile != null
                          ? ImagePickerDisplay(
                              imageFile: _imageFile,
                              imgUrl: imgUrl,
                            )
                          : (imgUrl == "")
                              ? Text('No image selected')
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    imgUrl,
                                    height: MediaQuery.of(context).size.width,
                                    width: MediaQuery.of(context).size.width,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(colors: [
                            AppColors.primaryGreenDark,
                            AppColors.primaryGreenLight
                          ])),
                      child: TextButton(
                        child: StdText(
                            text: "Pilih Gambar",
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 15),
                        onPressed: _pickImage,
                      ),
                    ),
                  ],
                ),
                // Nama Tanaman Input
                TextFormField(
                  controller: namaTanamanController,
                  decoration: InputDecoration(labelText: 'Nama Tanaman'),
                  validator: (value) =>
                      value!.isEmpty ? 'Nama Tanaman tidak boleh kosong' : null,
                ),
                // Nama Latin Input
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      fit: FlexFit.loose,
                      child: TextFormField(
                        controller: namaLatinController,
                        decoration: InputDecoration(labelText: 'Nama Latin'),
                        validator: (value) => value!.isEmpty
                            ? 'Nama Latin tidak boleh kosong'
                            : null,
                      ),
                    ),
                    // AnimatedContainer(
                    //   width: isPressingSearch ? 30 : 40,
                    //   height: isPressingSearch ? 30 : 40,
                    //   decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(10),
                    //       gradient: const LinearGradient(
                    //           colors: [
                    //             AppColors.primaryGreenDark,
                    //             AppColors.primaryGreenLight
                    //           ],
                    //           begin: Alignment.centerRight,
                    //           end: Alignment.centerLeft)),
                    //   duration: Duration(milliseconds: 900),
                    //   curve: Curves.bounceInOut,
                    //   child: GestureDetector(
                    //     onTap: () async {
                    //       await findNamaLatin();
                    //       setState(() {
                    //         isPressingSearch = true;
                    //       });
                    //     },
                    //     onTapUp: (_) {
                    //       setState(() {
                    //         isPressingSearch = false;
                    //       });
                    //     },
                    //     onTapCancel: () {
                    //       setState(() {
                    //         isPressingSearch = false;
                    //       });
                    //     },
                    //     child: IconButton(
                    //       onPressed: null,
                    //       icon: Icon(
                    //         Icons.search,
                    //         color: Colors.white,
                    //       ),
                    //       splashColor: Colors.white.withOpacity(0.5),
                    //     ),
                    //   ),
                    // ),
                    PressableIconButton(
                        icon: Icons.search,
                        borderRadius: 10,
                        onTap: () async {
                          await findNamaLatin();
                        }),
                  ],
                ),
                // Caption Input

                // Deskripsi Input
                TextFormField(
                  controller: deskripsiController,
                  decoration: InputDecoration(labelText: 'Deskripsi'),
                  validator: (value) =>
                      value!.isEmpty ? 'Deskripsi tidak boleh kosong' : null,
                ),

                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: DropdownButtonFormField<String>(
                    dropdownColor: Colors.white,
                    value: selectedJenisTanaman,
                    decoration: InputDecoration(labelText: 'Jenis Tanaman'),
                    items: jenisTanaman != null
                        ? [
                            ["", ""],
                            ...jenisTanaman!.values.toList().map((o) {
                              return [o.nama, o.id];
                            }),
                          ].map((jenis) {
                            return DropdownMenuItem<String>(
                              value: jenis[1].toString(),
                              child: jenis[0] == ""
                                  ? Container(
                                      color: listedJenisTanaman.contains(jenis)
                                          ? Colors.grey
                                          : Colors.white,
                                      child: Text(
                                        'Pilih Jenis Tanaman',
                                        style: TextStyle(
                                          color:
                                              listedJenisTanaman.contains(jenis)
                                                  ? Colors.grey
                                                  : Colors.black,
                                        ),
                                      ),
                                    )
                                  : Container(
                                      color: listedJenisTanaman.contains(jenis)
                                          ? Colors.grey
                                          : Colors.white,
                                      child: Text(
                                        jenisTanaman!.values
                                            .toList()[
                                                int.parse(jenis[1].toString())]
                                            .nama
                                            .toString(),
                                        style: TextStyle(
                                          color:
                                              listedJenisTanaman.contains(jenis)
                                                  ? Colors.grey
                                                  : Colors.black,
                                        ),
                                      ),
                                    ),
                            );
                          }).toList()
                        : [
                            const DropdownMenuItem<String>(
                              value: "",
                              child: Text("Tidak ada data"),
                            )
                          ],
                    onChanged: (value) {
                      if (value == "") return;
                      selectedJenisTanaman = value!;
                      setState(() {
                        if (!listedJenisTanaman.contains(value))
                          listedJenisTanaman = [...listedJenisTanaman, value];
                      });
                      _loadKategori();
                    },
                    validator: (value) => value == null || value.isEmpty
                        ? 'Pilih Jenis Tanaman'
                        : null,
                  ),
                ),

                Column(
                  mainAxisSize: MainAxisSize.min, // Shrink-wrap the Column
                  children: [
                    Flexible(
                      fit: FlexFit
                          .loose, // Allow the child to take up only as much space as it needs
                      child: ListView.builder(
                        shrinkWrap:
                            true, // Ensures ListView takes only the space it needs
                        itemCount: listedJenisTanaman.length,
                        itemBuilder: (context, index) {
                          var obj = listedJenisTanaman[index];
                          return ListTile(
                            title: Text(jenisTanaman!.values
                                .toList()[int.parse(obj)]
                                .nama),
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                setState(() {
                                  listedJenisTanaman.remove(obj);
                                  _loadKategori();
                                });
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    // Additional children, if any
                  ],
                ),

                // Kategori Dropdown
                DropdownButtonFormField<String>(
                  value: selectedKategori,
                  decoration: InputDecoration(labelText: 'Kategori'),
                  items: kategoriList == null
                      ? [
                          const DropdownMenuItem<String>(
                            value: "",
                            child: Text("Tidak ada data"),
                          )
                        ]
                      : ["", ...kategoriList.map((o) => o)].map((o) {
                          return DropdownMenuItem<String>(
                            value: o,
                            child: Text(o != "" ? o : "Pilih Kategori"),
                          );
                        }).toList(),
                  onChanged: (value) {
                    if (value == "") return;
                    setState(() {
                      selectedKategori = value!;
                      listedKategori = [...listedKategori, value];
                    });
                  },
                  validator: (value) => value == null ? 'Pilih Kategori' : null,
                ),
                SizedBox(
                  height: 10,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min, // Shrink-wrap the Column
                  children: [
                    Flexible(
                      fit: FlexFit
                          .loose, // Allow the child to take up only as much space as it needs
                      child: ListView.builder(
                        shrinkWrap:
                            true, // Ensures ListView takes only the space it needs
                        itemCount: listedKategori.length,
                        itemBuilder: (context, index) {
                          var obj = listedKategori[index];
                          return ListTile(
                            title: Text(obj),
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                setState(() {
                                  listedKategori.remove(obj);
                                });
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    // Additional children, if any
                  ],
                ),
                // Musim Checkbox
                SizedBox(
                  height: 20,
                ),
                Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Musim'),
                    CheckboxListTile(
                      title: Text("Musim Kemarau"),
                      value: selectedMusim.contains("Musim Kemarau"),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            if (!selectedMusim.contains("Musim Kemarau"))
                              selectedMusim.add("Musim Kemarau");
                          } else {
                            if (selectedMusim.contains("Musim Kemarau"))
                              selectedMusim.remove("Musim Kemarau");
                          }
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: Text("Musim Penghujan"),
                      value: selectedMusim.contains("Musim Penghujan"),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            if (!selectedMusim.contains("Musim Penghujan"))
                              selectedMusim.add("Musim Penghujan");
                          } else {
                            if (selectedMusim.contains("Musim Penghujan"))
                              selectedMusim.remove("Musim Penghujan");
                          }
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: Text("Musim Peralihan"),
                      value: selectedMusim.contains("Musim Peralihan"),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            if (!selectedMusim.contains("Musim Peralihan"))
                              selectedMusim.add("Musim Peralihan");
                          } else {
                            if (selectedMusim.contains("Musim Peralihan"))
                              selectedMusim.remove("Musim Peralihan");
                          }
                        });
                      },
                    ),
                  ],
                ),

                // Pupuk Section (dynamic)
                _buildPupukField(),
                // Lama Masa Tanam Input
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: lamaMasaTanamAwalController,
                        decoration: InputDecoration(labelText: 'Paling Cepat'),
                        validator: (value) => value!.isEmpty
                            ? 'Lama Masa Tanam tidak boleh kosong'
                            : null,
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: lamaMasaTanamAkhirController,
                        decoration: InputDecoration(labelText: 'Paling Lama'),
                        validator: (value) => value!.isEmpty
                            ? 'Lama Masa Tanam tidak boleh kosong'
                            : null,
                      ),
                    ),
                  ],
                ),

                // Submit Button
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(colors: [
                          AppColors.primaryGreenDark,
                          AppColors.primaryGreenLight
                        ])),
                    child: TextButton(
                      child: StdText(
                          text: "Simpan Tanaman",
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 15),
                      onPressed: () {
                        if (true) {
                          _submitForm();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Mohon tunggu ')));
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
