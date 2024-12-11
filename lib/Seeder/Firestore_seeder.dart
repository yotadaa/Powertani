import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:powertani/Tanaman/jenisTanaman.dart';
import 'package:powertani/Tanaman/tanaman.dart';

class FirestoreSeeder {
  Future<void> uploadJenisTanamanToFirestore() async {
    try {
      // Membuka Box untuk data JenisTanaman dari Hive
      var jenisTanamanBox = await Hive.openBox<JenisTanaman>('jenisTanamanBox');
      List<JenisTanaman> daftarTanaman = jenisTanamanBox.values.toList();

      // Referensi ke koleksi Firestore
      CollectionReference jenisTanamanCollection =
          FirebaseFirestore.instance.collection('jenis_tanaman');

      // Loop untuk meng-upload setiap JenisTanaman ke Firestore
      for (int i = 0; i < daftarTanaman.length; i++) {
        var tanaman = daftarTanaman[i];
        try {
          // Menyiapkan data untuk di-upload ke Firestore
          Map<String, dynamic> dataTanaman = {
            'nama': tanaman.nama,
            'deskripsi': tanaman.deskripsi,
            'img': tanaman.img,
            'kategori': tanaman.kategori,
            'id': i,
          };

          // Mengecek apakah data sudah ada di Firestore berdasarkan 'nama'
          QuerySnapshot existingTanamanSnapshot = await jenisTanamanCollection
              .where('nama', isEqualTo: tanaman.nama)
              .limit(1)
              .get();

          if (existingTanamanSnapshot.docs.isNotEmpty) {
            // Jika sudah ada, update data tersebut
            String documentId = existingTanamanSnapshot.docs.first.id;
            await jenisTanamanCollection.doc(documentId).update(dataTanaman);
            print('JenisTanaman updated in Firestore');
          } else {
            // Jika belum ada, tambah data baru ke Firestore
            await jenisTanamanCollection.add(dataTanaman);
            print('JenisTanaman added to Firestore');
          }
        } catch (e) {
          print('Error adding or updating jenis tanaman in Firestore: $e');
        }
      }

      print("Semua data berhasil diupload ke Firestore");
    } catch (e) {
      print("Gagal mengupload data ke Firestore: $e");
    }
  }

  Future<void> upload() async {
    var boxTanaman = await Hive.openBox<Tanaman>('tanamanBox');
    List<Tanaman> tanamanList = boxTanaman.values.toList();

    // Get a reference to the Firestore collection
    CollectionReference tanamanCollection =
        FirebaseFirestore.instance.collection('Tanaman');

    // Loop through each Tanaman item in Hive and add it to Firestore
    for (var tanaman in tanamanList) {
      try {
        // Prepare the data to add to Firestore
        Map<String, dynamic> tanamanData = {
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

        if (tanamanData['deskripsi'] == null ||
            tanamanData['deskripsi'].isEmpty) {
          tanamanData['deskripsi'] = tanaman.deskripsi;
        }
        if (tanamanData['pupuk'] == null || tanamanData['pupuk'].isEmpty) {
          tanamanData['pupuk'] = tanaman.pupuk;
        }
        if (tanamanData['lamaMasaTanam'] == null ||
            tanamanData['lamaMasaTanam'].isEmpty) {
          tanamanData['lamaMasaTanam'] = tanaman.lamaMasaTanam;
        }

        // Check if document already exists in Firestore using 'namaLatin'
        QuerySnapshot existingTanamanSnapshot = await tanamanCollection
            .where('namaLatin', isEqualTo: tanaman.namaLatin)
            .limit(1)
            .get();

        if (existingTanamanSnapshot.docs.isNotEmpty) {
          // If the document exists, update it
          String documentId = existingTanamanSnapshot.docs.first.id;
          await tanamanCollection.doc(documentId).update(tanamanData);
          print('Tanaman updated in Firestore');
        } else {
          // If the document does not exist, add it as a new document
          await tanamanCollection.add(tanamanData);
          print('Tanaman added to Firestore');
        }
      } catch (e) {
        print('Error adding or updating tanaman in Firestore: $e');
      }
    }
  }

  void download() async {
    Box<Tanaman> boxTanaman = await Hive.openBox<Tanaman>('tanamanBox');
    // Get all the Tanaman items in Hive
    List<Tanaman> boxTanamanList = boxTanaman.values.toList();

    // Get a reference to the Firestore collection
    CollectionReference tanamanCollection =
        FirebaseFirestore.instance.collection('Tanaman');

    try {
      // Fetch data from Firestore
      var snapshot = await tanamanCollection.get();
      List<Tanaman> firestoreTanamanList = snapshot.docs.map((doc) {
        // Convert Firestore document to Tanaman model
        return Tanaman(
          namaTanaman: doc['namaTanaman'] as String,
          namaLatin: doc['namaLatin'] as String,
          deskripsi: doc['deskripsi'] as String,
          img: doc['img'] as String,
          kategori: List<String>.from(doc['kategori']),
          jenisTanaman: List<int>.from(doc['jenisTanaman']),
          musim: List<String>.from(doc['musim']),
          pupuk: List<String>.from(doc['pupuk']),
          lamaMasaTanam: List<int>.from(doc['lamaMasaTanam']),
        );
      }).toList();

      for (var tanaman in firestoreTanamanList) {
        // Check if this 'namaLatin' already exists in the local Hive database
        Tanaman? existingTanaman = boxTanamanList.firstWhere(
          (localTanaman) => localTanaman.namaLatin == tanaman.namaLatin,
          orElse: () {
            return Tanaman(
              namaTanaman: '',
              namaLatin: "null",
              deskripsi: '',
              img: '',
              kategori: [],
              jenisTanaman: [],
              musim: [],
              pupuk: [],
              lamaMasaTanam: [],
            );
          },
        );

        if (existingTanaman.namaLatin != "null") {
          // If the tanaman exists in Hive, update it
          int index = boxTanamanList.indexOf(existingTanaman);
          await boxTanaman.putAt(
              index, tanaman); // Update the existing entry in Hive
          print('Updated $tanaman in Hive');
        } else {
          // If the tanaman doesn't exist in Hive, add it
          await boxTanaman.add(tanaman); // Add new item to Hive
          print('Added $tanaman to Hive');
        }
      }
    } catch (e) {
      print('Error syncing Firestore data to local database: $e');
    }
  }

  Future<void> downloadJenisTanaman() async {
    var boxJenisTanaman = await Hive.openBox<JenisTanaman>('jenisTanamanBox');
    // Get all the JenisTanaman items in Hive
    List<JenisTanaman> boxJenisTanamanList = boxJenisTanaman.values.toList();

    // Get a reference to the Firestore collection for JenisTanaman
    CollectionReference jenisTanamanCollection =
        FirebaseFirestore.instance.collection('jenis_tanaman');

    try {
      // Fetch data from Firestore
      var snapshot = await jenisTanamanCollection.get();
      List<JenisTanaman> firestoreJenisTanamanList = snapshot.docs.map((doc) {
        // Convert Firestore document to JenisTanaman model
        return JenisTanaman(
          nama: doc['nama'],
          deskripsi: doc['deskripsi'],
          kategori: List<String>.from(doc['kategori'] ?? []),
          id: doc['id'],
          img: doc['img'],
        );
      }).toList();

      for (var jenisTanaman in firestoreJenisTanamanList) {
        // Check if this 'nama' already exists in the local Hive database
        var existingJenisTanaman = boxJenisTanamanList.firstWhere(
          (localJenisTanaman) => localJenisTanaman.nama == jenisTanaman.nama,
          orElse: () => JenisTanaman(
            nama: '',
            deskripsi: '',
            kategori: [],
            img: '',
          ),
        );

        if (existingJenisTanaman != null &&
            existingJenisTanaman.nama.isNotEmpty) {
          // If the jenisTanaman exists in Hive, update it
          int index = boxJenisTanamanList.indexOf(existingJenisTanaman);
          await boxJenisTanaman.putAt(
              index, jenisTanaman); // Update the existing entry in Hive
          print('Updated $jenisTanaman in Hive');
          print(jenisTanaman.img);
        } else {
          // If the jenisTanaman doesn't exist in Hive, add it
          await boxJenisTanaman.add(jenisTanaman); // Add new item to Hive
          print('Added $jenisTanaman to Hive');
        }
      }
    } catch (e) {
      print('Error syncing Firestore data to local JenisTanaman database: $e');
    }
  }
}
