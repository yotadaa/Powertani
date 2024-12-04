import 'package:hive_flutter/hive_flutter.dart';
import 'package:powertani/Tanaman/jenisTanaman.dart';

class HiveBoxSeeder {
  void UploadJenisTanaman() async {
    var box = await Hive.openBox<JenisTanaman>('jenisTanamanBox');

    for (var tanaman in JenisTanaman.daftarTanaman) {
      // Check if the item already exists in the box (based on a unique property, like 'nama')
      final existingTanaman = box.values.firstWhere(
          (item) => item.nama == tanaman.nama,
          orElse: () => JenisTanaman(nama: "nama", deskripsi: "deskripsi"));

      if (existingTanaman == null) {
        // If no matching item exists, add it to the box
        await box.add(tanaman);
        print("Added: ${tanaman.nama}");
      } else {
        print("Duplicate found, skipping: ${tanaman.nama}");
      }
    }

    print("JenisTanaman data has been uploaded to Hive.");
  }
}
