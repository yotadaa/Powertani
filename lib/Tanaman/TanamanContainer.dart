import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:powertani/Seeder/Firestore_seeder.dart';

import 'package:powertani/Tanaman/Detail.dart';
import 'package:powertani/Tanaman/jenisTanaman.dart';
import 'package:powertani/Tanaman/tanaman.dart';
import 'package:powertani/components/AppBar.dart';
import 'package:powertani/components/Text.dart';
import 'package:powertani/components/components.dart';
import 'package:powertani/env.dart';
import 'package:hive/hive.dart';

class TanamanContainer extends StatefulWidget {
  final String title;
  final int jenisTanaman;
  final double borderRadius;
  final List<String> kategori;

  TanamanContainer({
    Key? key,
    required this.title,
    required this.kategori,
    required this.jenisTanaman,
    this.borderRadius = 10.0,
  }) : super(key: key);

  @override
  State<TanamanContainer> createState() => _TanamanContainerState();
}

class _TanamanContainerState extends State<TanamanContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  Tanaman? currentTanaman;

  int selectedCategory = 0;

  bool showDetail = false;
  List<Tanaman> daftarTanaman = [];
  Box<JenisTanaman> jenisTanamanBox = Hive.box<JenisTanaman>('jenisTanamanBox');

  late List<bool> isSelected;
  Map<String, dynamic> detail = {
    "title": "Some Title",
    "img": "",
    "description":
        "Some description that i didnt know what to put in this description, but i try to make it long, a long long text. But do you know that Long Long is a data type in CSS, the name is funny, Long Long haha."
  };

  Future<void> getTanaman() async {
    // Open the Hive box
    var boxTanaman = await Hive.openBox<Tanaman>('tanamanBox');
    List<Tanaman> boxTanamanList =
        boxTanaman.values.isEmpty ? [] : boxTanaman.values.toList();

    // Fetch data from Firestore
    var snapshot = await FirebaseFirestore.instance.collection('Tanaman').get();
    List<Tanaman> firestoreTanamanList = snapshot.docs.map((doc) {
      // Convert Firestore document data to Tanaman model
      return Tanaman(
        namaTanaman: doc['namaTanaman'],
        namaLatin: doc['namaLatin'],
        deskripsi: doc['deskripsi'],
        img: doc['img'],
        kategori: List<String>.from(doc['kategori']),
        jenisTanaman: [...doc['jenisTanaman']],
        musim: List<String>.from(doc['musim']),
        lamaMasaTanam: List<int>.from(doc['lamaMasaTanam']),
        pupuk: List<String>.from(doc['pupuk']),
      );
    }).toList();

    List<Tanaman> allTanaman = [];

    // Merge Firestore data with local data (Hive) based on 'namaLatin'
    for (var tanaman in firestoreTanamanList) {
      // Check if Tanaman already exists in local Hive data
      final existingTanaman = boxTanamanList.length > 0
          ? boxTanamanList.firstWhere(
              (boxTanaman) => boxTanaman.namaLatin == tanaman.namaLatin,
              orElse: () => Tanaman(
                deskripsi: "",
                img: "",
                jenisTanaman: [],
                kategori: [],
                namaLatin: "",
                namaTanaman: "",
                musim: [],
                lamaMasaTanam: [],
                pupuk: [],
              ),
            )
          : null;

      if (existingTanaman != null) {
        if (existingTanaman.deskripsi == null ||
            existingTanaman.deskripsi.isEmpty) {
          existingTanaman.deskripsi = tanaman.deskripsi;
        }
        if (existingTanaman.pupuk == null || existingTanaman.pupuk.isEmpty) {
          existingTanaman.pupuk = tanaman.pupuk;
        }
        if (existingTanaman.lamaMasaTanam == null ||
            existingTanaman.lamaMasaTanam.isEmpty) {
          existingTanaman.lamaMasaTanam = tanaman.lamaMasaTanam;
        }

        // After updating the existing Tanaman, add it to the list
        allTanaman.add(existingTanaman);
      } else {
        // If no matching Tanaman exists in local Hive data, add the Firestore Tanaman
        allTanaman.add(tanaman);
      }
    }

    // Optionally, add the remaining Hive Tanaman that were not in Firestore data
    allTanaman.addAll(boxTanamanList.where((boxTanaman) =>
        !firestoreTanamanList.any((firestoreTanaman) =>
            firestoreTanaman.namaLatin == boxTanaman.namaLatin)));

    // Update the UI with the merged list
    if (mounted)
      setState(() {
        daftarTanaman = allTanaman;
      });

    // Optionally, save the merged data back to Hive
    // for (var tanaman in allTanaman) {
    //   await boxTanaman.put(tanaman.namaLatin, tanaman);
    // }
  }

  String _getFirst20Words(String description) {
    int length = 10;
    // Split the description into words
    List<String> words = description.split(' ');

    // If there are fewer than 20 words, return the whole description
    if (words.length <= length) {
      return description;
    } else {
      // Take the first length words and join them back into a string
      return words.take(length).join(' ') +
          ' ...'; // Add "..." to indicate truncation
    }
  }

  @override
  void initState() {
    super.initState();
    // FirestoreSeeder().download();
    // setState(() {
    //   widget.kategori = ["Semua", ...widget.kategori];
    // });

    getTanaman();

    isSelected = List.generate(daftarTanaman.length, (index) => false);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Filter data berdasarkan kategori yang dipilih
    print(widget.jenisTanaman);
    List<Tanaman> filteredData = daftarTanaman
        .where((tanaman) =>
            (tanaman.kategori.contains(widget.kategori[selectedCategory]) ||
                selectedCategory == 0) &&
            (tanaman.jenisTanaman.contains(
                widget.jenisTanaman))) // Check both kategori and jenisTanaman
        .toList();

    return Scaffold(
      body: MainAppBar(
        title: widget.title,
        child: Container(
          color: Colors.white,
          child: Stack(
            children: [
              Column(
                children: [
                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.kategori.length,
                      itemBuilder: (context, index) {
                        final isActive = selectedCategory == index;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedCategory = index;
                            });
                            print("=======================");
                            print("=======================");
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 6.0),
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: isActive
                                      ? [
                                          AppColors.primaryGreenDark,
                                          AppColors.primaryGreenLight,
                                        ]
                                      : [
                                          const Color.fromARGB(
                                              25, 105, 105, 105),
                                          const Color.fromARGB(
                                              25, 105, 105, 105)
                                        ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    widget.kategori[index],
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: isActive
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: filteredData.isEmpty
                        ? Center(child: Text("No data available"))
                        : ListView.builder(
                            itemCount: filteredData.length,
                            itemBuilder: (context, index) {
                              final tanaman = filteredData[index];
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    // print(tanaman.kategori.contains(
                                    //     widget.kategori[selectedCategory]));
                                    currentTanaman = tanaman;
                                    print("Start Tanaman");
                                    print(tanaman.img);
                                    print("End Tanaman");
                                    showDetail = true;
                                    detail['title'] = tanaman.namaTanaman;
                                    detail['img'] = tanaman.img;
                                    detail['description'] = tanaman.deskripsi;
                                  });
                                  print("==============");
                                  print(tanaman.jenisTanaman);
                                  print(widget.jenisTanaman);
                                  print("==============");
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 16.0),
                                  child: AnimatedBuilder(
                                    animation: _scaleAnimation,
                                    builder: (context, child) {
                                      return Container(
                                        padding: EdgeInsets.all(8),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              widget.borderRadius),
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.2),
                                              blurRadius: 5,
                                              offset: const Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      widget.borderRadius),
                                              child: tanaman.img.isNotEmpty
                                                  ? ((tanaman.img.contains(
                                                              "https://") ||
                                                          (tanaman.img.contains(
                                                                  "http://") ||
                                                              (tanaman.img
                                                                  .contains(
                                                                      "gs://")))
                                                      ? CachedNetworkImage(
                                                          imageUrl:
                                                              tanaman.img!,
                                                          width: 80,
                                                          height: 80,
                                                          fit: BoxFit.cover,
                                                        )
                                                      : Image.asset(
                                                          tanaman.img,
                                                          width: 80,
                                                          height: 80,
                                                          fit: BoxFit.cover,
                                                        )))
                                                  : Container(
                                                      width: 80,
                                                      height: 80,
                                                      color: Colors.grey[300],
                                                      child: Icon(
                                                        Icons
                                                            .image_not_supported,
                                                        color: Colors.grey[600],
                                                      ),
                                                    ),
                                            ),
                                            const SizedBox(width: 16),
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 0.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    StdText(
                                                      text: tanaman.namaTanaman,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    const SizedBox(height: 4),
                                                    StdText(
                                                      text: tanaman.namaLatin,
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      fontSize: 12,
                                                      color: Colors.grey,
                                                    ),
                                                    const SizedBox(height: 4),
                                                    StdText(
                                                      text: _getFirst20Words(
                                                          tanaman.deskripsi),
                                                      fontSize: 12,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
              showDetail
                  ? Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.1),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  Colors.black.withOpacity(0.2), // Shadow color
                              offset: Offset(0, 4), // Shadow offset
                              blurRadius: 10, // Shadow blur
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                              child: Container(
                                color: Colors.black.withOpacity(0.1),
                                padding: EdgeInsets.symmetric(vertical: 100),
                                height: MediaQuery.of(context).size.height,
                                child: PlantDetailModal(
                                  closeDetail: () {
                                    setState(() {
                                      showDetail = false;
                                    });
                                  },
                                  imageUrl: detail["img"],
                                  title: detail["title"],
                                  description: detail["description"],
                                  isShowing: showDetail,
                                  tanaman: currentTanaman,
                                  onClose: () {
                                    setState(() {
                                      showDetail = false;
                                    });
                                  },
                                ),
                              ),
                            ),
                            // Modal Content (for extra content if needed)
                          ],
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
