import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:powertani/Tanaman/tanaman.dart';

part 'jenisTanaman.g.dart'; // Make sure to run `flutter packages pub run build_runner build` to generate this file

@HiveType(typeId: 1)
class JenisTanaman {
  @HiveField(0)
  String nama;
  @HiveField(1)
  String deskripsi;
  @HiveField(2)
  String img;
  @HiveField(3)
  Widget? widget;
  @HiveField(4)
  List<String> kategori;
  @HiveField(5)
  int id;

  JenisTanaman({
    this.widget,
    required this.nama,
    required this.deskripsi,
    this.id = 0,
    this.img = "",
    this.kategori = const [],
  });

  @override
  String toString() {
    return 'JenisTanaman(nama: $nama, deskripsi: $deskripsi, kategori: $kategori)';
  }

  // You may also implement toMap and fromMap methods if needed for serialization
  factory JenisTanaman.fromMap(Map<String, dynamic> map) {
    return JenisTanaman(
      nama: map['nama'],
      deskripsi: map['deskripsi'],
      kategori: List<String>.from(map['kategori'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
      'deskripsi': deskripsi,
      'kategori': kategori,
    };
  }

  static List<JenisTanaman> daftarTanaman = [
    JenisTanaman(
      nama: "Tanaman Pangan",
      deskripsi:
          "Tanaman yang ditanam sebagai sumber pangan utama bagi manusia.",
      img: "assets/jenis_tanaman/tanaman_pangan.png",
      // List Tanaman Pangan
      kategori: ["Buah", "Umbi", "Serealia", "Sayuran", "Kacang", "Legum"],
    ),
    JenisTanaman(
      nama: "Tanaman Hortikultura",
      deskripsi:
          "Tanaman yang mencakup sayuran, buah-buahan, dan tanaman hias.",
      img: "assets/jenis_tanaman/tanaman_holtikultura.png",
      // List Tanaman Hortikultura
      kategori: ["Sayuran", "Buah", "Tanaman Hias"],
    ),
    JenisTanaman(
      nama: "Tanaman Perkebunan",
      deskripsi:
          "Tanaman yang dibudidayakan dalam skala besar untuk menghasilkan bahan mentah industri atau ekspor.",
      img: "assets/jenis_tanaman/tanaman_perkebunan.png",
      // List Tanaman Perkebunan
      kategori: ["Karet", "Kelapa", "Kopi", "Tebu", "Kakao", "Tembakau"],
    ),
    JenisTanaman(
      nama: "Tanaman Pakan Ternak (Forage)",
      deskripsi:
          "Tanaman yang ditanam untuk kebutuhan pakan ternak, seperti sapi, kambing, dan domba.",
      img: "assets/jenis_tanaman/tanaman_pakan_ternak.png",
      // List Tanaman Pakan Ternak
      kategori: ["Rumput", "Legum", "Biji-Bijian", "Alfalfa"],
    ),
    JenisTanaman(
      nama: "Tanaman Kehutanan",
      deskripsi:
          "Tanaman yang ditanam dalam hutan untuk produksi kayu, konservasi, atau rehabilitasi lingkungan.",
      img: "assets/jenis_tanaman/tanaman_kehutanan.png",
      kategori: [
        "Kayu",
        "Pohon Konservasi",
        "Tanaman Rehabilitasi",
        "Pohon Peneduh"
      ],
    ),
    JenisTanaman(
      nama: "Tanaman Obat",
      deskripsi:
          "Tanaman yang digunakan sebagai bahan baku pembuatan obat-obatan tradisional dan modern.",
      img: "",
      kategori: ["Herbal", "Rempah", "Tanaman Medis", "Aromaterapi"],
    ),
    JenisTanaman(
      nama: "Tanaman Industri",
      deskripsi:
          "Tanaman yang ditanam untuk kebutuhan bahan baku industri, seperti kapas, karet, atau tebu.",
      img: "",
      kategori: ["Karet", "Kapas", "Tebu", "Kenaf", "Rami", "Sagu"],
    ),
    JenisTanaman(
      nama: "Tanaman Energi",
      deskripsi:
          "Tanaman yang dimanfaatkan sebagai sumber energi alternatif, seperti kelapa sawit untuk biodiesel atau jarak pagar.",
      img: "",
      kategori: ["Kelapa Sawit", "Jarak Pagar", "Sorghum Energi", "Bioenergi"],
    ),
    JenisTanaman(
      nama: "Tanaman Hias",
      deskripsi:
          "Tanaman yang ditanam untuk keindahan atau dekorasi, baik di taman maupun dalam ruangan.",
      img: "",
      kategori: [
        "Tanaman Indoor",
        "Tanaman Outdoor",
        "Tanaman Bunga",
        "Tanaman Rambat",
        "Kaktus"
      ],
    ),
    JenisTanaman(
      nama: "Tanaman Rempah dan Bumbu",
      deskripsi:
          "Tanaman yang menghasilkan rempah-rempah dan bumbu untuk memasak, seperti jahe, kunyit, dan lada.",
      img: "",
      kategori: ["Jahe", "Kunyit", "Lada", "Kencur", "Cengkeh", "Sereh"],
    ),
    JenisTanaman(
      nama: "Tanaman Buah-Buahan",
      deskripsi:
          "Tanaman yang menghasilkan buah untuk dikonsumsi, seperti mangga, pisang, dan jeruk.",
      img: "",
      kategori: [
        "Buah Tropis",
        "Buah Musiman",
        "Buah Berries",
        "Buah Apel",
        "Buah Jeruk",
        "Durian"
      ],
    ),
    JenisTanaman(
      nama: "Tanaman Sayuran",
      deskripsi:
          "Tanaman yang menghasilkan sayuran untuk kebutuhan pangan, seperti bayam, tomat, dan wortel.",
      img: "",
      kategori: [
        "Sayuran Hijau",
        "Sayuran Umbi",
        "Sayuran Akar",
        "Sayuran Daun",
        "Sayuran Buah"
      ],
    ),
    JenisTanaman(
      nama: "Tanaman Air",
      deskripsi:
          "Tanaman yang hidup di air atau lingkungan berair, seperti padi, eceng gondok, dan teratai.",
      img: "",
      kategori: [
        "Padi",
        "Tanaman Air Laut",
        "Tanaman Air Tawar",
        "Tanaman Aquatik"
      ],
    ),
    JenisTanaman(
      nama: "Tanaman Penghasil Minyak Atsiri",
      deskripsi:
          "Tanaman yang menghasilkan minyak atsiri untuk parfum, kosmetik, atau terapi, seperti cengkeh dan sereh.",
      img: "",
      kategori: ["Cengkeh", "Sereh", "Lavender", "Peppermint", "Eucalyptus"],
    ),
    JenisTanaman(
      nama: "Tanaman Serat",
      deskripsi:
          "Tanaman yang menghasilkan serat untuk bahan tekstil, seperti kapas, rami, dan agave.",
      img: "",
      kategori: ["Kapas", "Rami", "Agave", "Kenaf", "Jute"],
    ),
  ];
}
