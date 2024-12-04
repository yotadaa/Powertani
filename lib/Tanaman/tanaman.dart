import 'package:hive/hive.dart';

part "tanaman.g.dart"; // This part is for code generation

@HiveType(typeId: 0)
class Tanaman {
  @HiveField(0)
  String namaTanaman;
  @HiveField(1)
  String namaLatin;
  @HiveField(2)
  String deskripsi;
  @HiveField(3)
  String img;
  @HiveField(4)
  List<String> kategori;
  @HiveField(5)
  List<int> jenisTanaman;
  @HiveField(6)
  List<String> musim;
  @HiveField(7)
  List<int> lamaMasaTanam;
  @HiveField(8)
  List<String> pupuk;

  Tanaman({
    required this.namaTanaman,
    required this.namaLatin,
    required this.deskripsi,
    required this.img,
    required this.kategori,
    required this.jenisTanaman,
    required this.musim,
    required this.lamaMasaTanam,
    required this.pupuk,
  });
}

// List<Tanaman> tanamanPangan = [
//   // Kategori Buah
//   Tanaman(
//     namaTanaman: "Apel",
//     namaLatin: "Malus domestica",
//     caption: "Buah manis yang kaya akan vitamin dan serat.",
//     deskripsi:
//         "Apel adalah buah yang terkenal karena rasanya yang manis dan segar. Kaya akan vitamin C, apel juga mengandung serat yang baik untuk pencernaan.",
//     img: "",
//     kategori: ["Buah"],
//     jenisTanaman: 0, // Pangan
//     musim: ["Musim Penghujan", "Musim Pancaroba"], // Added musim
//     lamaMasaTanam: [90, 180], // Added lama masa tanam
//   ),
//   Tanaman(
//     namaTanaman: "Mangga",
//     namaLatin: "Mangifera indica",
//     caption: "Buah tropis manis yang sangat populer di Asia.",
//     deskripsi:
//         "Mangga, dengan nama ilmiah Mangifera indica, adalah buah tropis yang terkenal dengan rasa manis dan aroma khas.",
//     img: "",
//     kategori: ["Buah"],
//     jenisTanaman: 0, // Pangan
//     musim: ["Musim Kemarau", "Musim Pancaroba"], // Added musim
//     lamaMasaTanam: [150, 365], // Added lama masa tanam
//   ),
//   Tanaman(
//     namaTanaman: "Pisang",
//     namaLatin: "Musa spp.",
//     caption: "Buah tropis kaya kalium yang mudah tumbuh.",
//     deskripsi:
//         "Pisang adalah buah tropis yang kaya kalium, sangat baik untuk menjaga kesehatan jantung dan tekanan darah.",
//     img: "",
//     kategori: ["Buah"],
//     jenisTanaman: 0, // Pangan
//     musim: ["Musim Kemarau", "Musim Penghujan"], // Added musim
//     lamaMasaTanam: [120, 180], // Added lama masa tanam
//   ),
//   Tanaman(
//     namaTanaman: "Jeruk",
//     namaLatin: "Citrus sinensis",
//     caption: "Buah citrus kaya vitamin C dan antioksidan.",
//     deskripsi:
//         "Jeruk adalah buah yang dikenal karena rasa asam manis dan kandungan vitamin C yang sangat tinggi.",
//     img: "",
//     kategori: ["Buah"],
//     jenisTanaman: 0, // Pangan
//     musim: ["Musim Penghujan"], // Added musim
//     lamaMasaTanam: [180, 365], // Added lama masa tanam
//   ),

//   Tanaman(
//     namaTanaman: "Kentang",
//     namaLatin: "Solanum tuberosum",
//     caption: "Sumber karbohidrat yang sering diolah menjadi berbagai makanan.",
//     deskripsi:
//         "Kentang adalah tanaman umbi yang menjadi bahan utama dalam berbagai hidangan, seperti kentang goreng, mashed potatoes, dan banyak lainnya.",
//     img: "",
//     kategori: ["Umbi"],
//     jenisTanaman: 0, // Pangan
//     musim: ["Musim Kemarau"], // Added musim
//     lamaMasaTanam: [60, 120], // Added lama masa tanam
//   ),
//   Tanaman(
//     namaTanaman: "Ubi Jalar",
//     namaLatin: "Ipomoea batatas",
//     caption: "Umbi yang kaya akan karbohidrat dan vitamin A.",
//     deskripsi:
//         "Ubi jalar adalah umbi yang kaya akan karbohidrat, vitamin A, dan serat. Tanaman ini banyak digunakan dalam berbagai olahan makanan.",
//     img: "",
//     kategori: ["Umbi"],
//     jenisTanaman: 0, // Pangan
//     musim: ["Musim Penghujan", "Musim Pancaroba"], // Added musim
//     lamaMasaTanam: [90, 180], // Added lama masa tanam
//   ),

//   // Kategori Serealia
//   Tanaman(
//     namaTanaman: "Padi",
//     namaLatin: "Oryza sativa",
//     caption:
//         "Tanaman utama penghasil beras, makanan pokok bagi sebagian besar penduduk dunia.",
//     deskripsi:
//         "Padi adalah tanaman serealia yang menjadi sumber pangan utama di berbagai negara, terutama di Asia.",
//     img: "assets/tanaman/padi.png",
//     kategori: ["Serealia"],
//     jenisTanaman: 0, // Pangan
//     musim: ["Musim Penghujan"], // Added musim
//     lamaMasaTanam: [100, 150], // Added lama masa tanam
//   ),
//   Tanaman(
//     namaTanaman: "Jagung",
//     namaLatin: "Zea mays",
//     caption:
//         "Sumber pangan penting yang juga digunakan untuk pakan ternak dan bahan baku industri.",
//     deskripsi:
//         "Jagung, atau Zea mays, adalah salah satu tanaman pangan penting di dunia. Selain dimanfaatkan sebagai makanan pokok, jagung juga digunakan dalam industri dan pakan ternak.",
//     img: "assets/tanaman/jagung.png",
//     kategori: ["Serealia"],
//     jenisTanaman: 0, // Pangan
//     musim: ["Musim Kemarau"], // Added musim
//     lamaMasaTanam: [90, 180], // Added lama masa tanam
//   ),
//   Tanaman(
//     namaTanaman: "Gandum",
//     namaLatin: "Triticum spp.",
//     caption:
//         "Bahan utama untuk roti, pasta, dan produk tepung, banyak dibudidayakan di dunia.",
//     deskripsi:
//         "Gandum adalah tanaman serealia yang banyak digunakan dalam pembuatan roti, pasta, dan berbagai produk olahan lainnya.",
//     img: "assets/tanaman/gandum.png",
//     kategori: ["Serealia"],
//     jenisTanaman: 0, // Pangan
//     musim: ["Musim Kemarau", "Musim Penghujan"], // Added musim
//     lamaMasaTanam: [90, 150], // Added lama masa tanam
//   ),

//   // Kategori Sayuran
//   Tanaman(
//     namaTanaman: "Bayam",
//     namaLatin: "Spinacia oleracea",
//     caption: "Sayuran berdaun hijau yang kaya zat besi dan vitamin.",
//     deskripsi:
//         "Bayam adalah sayuran yang kaya akan zat besi, vitamin A, C, dan K. Tanaman ini mudah ditanam dan banyak dikonsumsi sebagai bahan sayur.",
//     img: "",
//     kategori: ["Sayuran"],
//     jenisTanaman: 0, // Pangan
//     musim: ["Musim Penghujan"], // Added musim
//     lamaMasaTanam: [30, 60], // Added lama masa tanam
//   ),
//   Tanaman(
//     namaTanaman: "Tomat",
//     namaLatin: "Solanum lycopersicum",
//     caption: "Sayuran buah yang kaya akan vitamin C dan antioksidan.",
//     deskripsi:
//         "Tomat adalah sayuran buah yang kaya akan vitamin C dan antioksidan. Biasanya digunakan dalam berbagai masakan, baik segar maupun olahan.",
//     img: "",
//     kategori: ["Sayuran"],
//     jenisTanaman: 0, // Pangan
//     musim: ["Musim Penghujan", "Musim Pancaroba"], // Added musim
//     lamaMasaTanam: [60, 90], // Added lama masa tanam
//   ),

//   // Kategori Legum
//   Tanaman(
//     namaTanaman: "Kacang Tanah",
//     namaLatin: "Arachis hypogaea",
//     caption:
//         "Tanaman legum yang menghasilkan kacang yang banyak digunakan dalam masakan.",
//     deskripsi:
//         "Kacang tanah adalah tanaman legum yang menghasilkan kacang yang kaya protein, lemak sehat, dan vitamin.",
//     img: "",
//     kategori: ["Legum"],
//     jenisTanaman: 0, // Pangan
//     musim: ["Musim Kemarau"], // Added musim
//     lamaMasaTanam: [90, 120], // Added lama masa tanam
//   ),
//   Tanaman(
//     namaTanaman: "Kacang Kedelai",
//     namaLatin: "Glycine max",
//     caption:
//         "Sumber protein nabati yang digunakan dalam berbagai produk olahan.",
//     deskripsi:
//         "Kacang kedelai, atau Glycine max, adalah tanaman legum yang sangat kaya akan protein dan banyak digunakan dalam pembuatan produk olahan seperti tempe dan tahu.",
//     img: "",
//     kategori: ["Legum"],
//     jenisTanaman: 0, // Pangan
//     musim: ["Musim Penghujan", "Musim Pancaroba"], // Added musim
//     lamaMasaTanam: [90, 150], // Added lama masa tanam
//   ),
// ];

// List<Tanaman> tanamanHortikultura = [
//   Tanaman(
//     namaTanaman: "Tomat",
//     namaLatin: "Solanum lycopersicum",
//     caption: "Sayuran buah yang kaya vitamin C.",
//     deskripsi:
//         "Tomat adalah sayuran buah yang sering digunakan dalam berbagai masakan. Kaya akan vitamin C dan antioksidan.",
//     img: "",
//     kategori: ["Sayuran", "Buah"],
//     jenisTanaman: 1,
//   ),
//   Tanaman(
//     namaTanaman: "Lettuce",
//     namaLatin: "Lactuca sativa",
//     caption: "Sayuran hijau yang sering digunakan dalam salad.",
//     deskripsi:
//         "Lettuce adalah sayuran berdaun hijau yang sering digunakan dalam salad. Kaya akan vitamin A dan K.",
//     img: "",
//     kategori: ["Sayuran"],
//     jenisTanaman: 1,
//   ),
//   Tanaman(
//     namaTanaman: "Strawberry",
//     namaLatin: "Fragaria × ananassa",
//     caption: "Buah manis yang tumbuh di tanah yang subur.",
//     deskripsi:
//         "Strawberry adalah buah manis dan segar yang tumbuh di iklim yang lebih dingin. Kaya akan vitamin C.",
//     img: "",
//     kategori: ["Buah"],
//     jenisTanaman: 1,
//   ),
//   Tanaman(
//     namaTanaman: "Kacang Panjang",
//     namaLatin: "Vigna unguiculata",
//     caption: "Sayuran legum yang digunakan dalam masakan.",
//     deskripsi:
//         "Kacang panjang adalah tanaman legum yang digunakan sebagai bahan masakan yang kaya akan protein.",
//     img: "",
//     kategori: ["Legum"],
//     jenisTanaman: 1,
//   ),
//   Tanaman(
//     namaTanaman: "Paprika",
//     namaLatin: "Capsicum annuum",
//     caption: "Sayuran buah dengan rasa pedas dan manis.",
//     deskripsi:
//         "Paprika adalah jenis sayuran buah yang kaya akan vitamin C dan sering digunakan dalam masakan.",
//     img: "",
//     kategori: ["Sayuran", "Buah"],
//     jenisTanaman: 1,
//   ),
//   Tanaman(
//     namaTanaman: "Timun",
//     namaLatin: "Cucumis sativus",
//     caption: "Sayuran yang menyegarkan.",
//     deskripsi:
//         "Timun adalah sayuran yang sering digunakan dalam salad dan masakan karena memberikan rasa segar.",
//     img: "",
//     kategori: ["Sayuran"],
//     jenisTanaman: 1,
//   ),
//   Tanaman(
//     namaTanaman: "Terong",
//     namaLatin: "Solanum melongena",
//     caption: "Sayuran yang sering digunakan dalam masakan.",
//     deskripsi:
//         "Terong adalah sayuran yang sering digunakan dalam masakan dan kaya akan serat.",
//     img: "",
//     kategori: ["Sayuran"],
//     jenisTanaman: 1,
//   ),
//   Tanaman(
//     namaTanaman: "Cabai",
//     namaLatin: "Capsicum",
//     caption: "Bumbu pedas yang kaya akan vitamin C.",
//     deskripsi:
//         "Cabai adalah bahan makanan yang digunakan untuk memberikan rasa pedas dalam masakan.",
//     img: "",
//     kategori: ["Sayuran", "Bumbu"],
//     jenisTanaman: 1,
//   ),
//   Tanaman(
//     namaTanaman: "Brokoli",
//     namaLatin: "Brassica oleracea",
//     caption: "Sayuran hijau yang kaya akan vitamin K.",
//     deskripsi:
//         "Brokoli adalah sayuran yang kaya akan vitamin K dan banyak digunakan dalam salad dan masakan sehat.",
//     img: "",
//     kategori: ["Sayuran"],
//     jenisTanaman: 1,
//   ),
//   Tanaman(
//     namaTanaman: "Kembang Kol",
//     namaLatin: "Brassica oleracea var. botrytis",
//     caption: "Sayuran dengan bentuk kepala yang padat.",
//     deskripsi:
//         "Kembang kol adalah sayuran yang sering digunakan dalam masakan yang kaya akan serat.",
//     img: "",
//     kategori: ["Sayuran"],
//     jenisTanaman: 1,
//   ),
// ];
// List<Tanaman> tanamanPerkebunan = [
//   Tanaman(
//     namaTanaman: "Kelapa",
//     namaLatin: "Cocos nucifera",
//     caption:
//         "Tanaman perkebunan yang banyak dimanfaatkan untuk minyak, air kelapa, dan produk lainnya.",
//     deskripsi:
//         "Kelapa adalah tanaman perkebunan yang digunakan untuk banyak produk, mulai dari minyak kelapa hingga air kelapa.",
//     img: "",
//     kategori: ["Kelapa"],
//     jenisTanaman: 2,
//   ),
//   Tanaman(
//     namaTanaman: "Kopi",
//     namaLatin: "Coffea spp.",
//     caption: "Sumber utama biji kopi yang digunakan untuk minuman populer.",
//     deskripsi:
//         "Kopi adalah tanaman yang menghasilkan biji kopi yang banyak digunakan untuk minuman yang sangat populer di seluruh dunia.",
//     img: "",
//     kategori: ["Kopi"],
//     jenisTanaman: 2,
//   ),
//   Tanaman(
//     namaTanaman: "Tebu",
//     namaLatin: "Saccharum officinarum",
//     caption: "Tanaman penghasil gula utama di banyak negara tropis.",
//     deskripsi:
//         "Tebu adalah tanaman yang menghasilkan gula dan digunakan sebagai bahan baku utama dalam produksi gula.",
//     img: "",
//     kategori: ["Tebu"],
//     jenisTanaman: 2,
//   ),
//   Tanaman(
//     namaTanaman: "Cengkeh",
//     namaLatin: "Syzygium aromaticum",
//     caption: "Rempah yang digunakan dalam industri makanan dan kesehatan.",
//     deskripsi:
//         "Cengkeh adalah rempah yang banyak digunakan dalam industri makanan dan kesehatan, terutama untuk minyak atsiri.",
//     img: "",
//     kategori: ["Rempah"],
//     jenisTanaman: 2,
//   ),
//   Tanaman(
//     namaTanaman: "Kakao",
//     namaLatin: "Theobroma cacao",
//     caption: "Sumber utama biji kakao untuk produksi coklat.",
//     deskripsi:
//         "Kakao adalah tanaman yang menghasilkan biji yang digunakan dalam industri coklat.",
//     img: "",
//     kategori: ["Kakao"],
//     jenisTanaman: 2,
//   ),
//   Tanaman(
//     namaTanaman: "Karet",
//     namaLatin: "Hevea brasiliensis",
//     caption: "Tanaman penghasil karet alam.",
//     deskripsi:
//         "Karet adalah tanaman yang digunakan untuk menghasilkan getah yang diolah menjadi karet alam.",
//     img: "",
//     kategori: ["Karet"],
//     jenisTanaman: 2,
//   ),
//   Tanaman(
//     namaTanaman: "Pala",
//     namaLatin: "Myristica fragrans",
//     caption: "Rempah dengan aroma khas yang digunakan dalam industri makanan.",
//     deskripsi:
//         "Pala adalah rempah yang digunakan dalam industri makanan dan minuman karena aromanya yang khas.",
//     img: "",
//     kategori: ["Rempah"],
//     jenisTanaman: 2,
//   ),
//   Tanaman(
//     namaTanaman: "Vanili",
//     namaLatin: "Vanilla planifolia",
//     caption:
//         "Tanaman penghasil buah vanili yang banyak digunakan sebagai bahan rasa.",
//     deskripsi:
//         "Vanili adalah tanaman yang menghasilkan buah yang digunakan dalam pembuatan rasa alami pada makanan dan minuman.",
//     img: "",
//     kategori: ["Vanili"],
//     jenisTanaman: 2,
//   ),
//   Tanaman(
//     namaTanaman: "Kelapa Sawit",
//     namaLatin: "Elaeis guineensis",
//     caption: "Tanaman penghasil minyak sawit.",
//     deskripsi:
//         "Kelapa sawit adalah tanaman yang digunakan untuk menghasilkan minyak sawit, bahan baku penting dalam industri makanan dan non-makanan.",
//     img: "",
//     kategori: ["Kelapa Sawit"],
//     jenisTanaman: 2,
//   ),
//   Tanaman(
//     namaTanaman: "Tebu Raksasa",
//     namaLatin: "Saccharum spp.",
//     caption: "Varietas tebu yang digunakan dalam produksi gula industri.",
//     deskripsi:
//         "Tebu raksasa adalah varietas tebu yang digunakan dalam produksi gula industri, menghasilkan banyak sap.",
//     img: "",
//     kategori: ["Tebu"],
//     jenisTanaman: 2,
//   ),
// ];
// List<Tanaman> tanamanPakanTernak = [
//   Tanaman(
//     namaTanaman: "Alfalfa",
//     namaLatin: "Medicago sativa",
//     caption:
//         "Pakan ternak yang sangat bergizi dan sering digunakan sebagai silase.",
//     deskripsi:
//         "Alfalfa adalah tanaman pakan ternak yang sangat bergizi, sering digunakan untuk pakan sapi, kambing, dan domba.",
//     img: "",
//     kategori: ["Legum", "Rumput"],
//     jenisTanaman: 3,
//   ),
//   Tanaman(
//     namaTanaman: "Rumput Gajah",
//     namaLatin: "Pennisetum purpureum",
//     caption: "Rumput untuk pakan ternak besar seperti sapi dan kerbau.",
//     deskripsi:
//         "Rumput Gajah adalah jenis rumput yang biasa digunakan sebagai pakan ternak besar seperti sapi dan kerbau.",
//     img: "",
//     kategori: ["Rumput"],
//     jenisTanaman: 3,
//   ),
//   Tanaman(
//     namaTanaman: "Legum Kacang Tanah",
//     namaLatin: "Arachis hypogaea",
//     caption: "Pakan ternak yang kaya protein.",
//     deskripsi:
//         "Kacang Tanah adalah tanaman legum yang dapat digunakan sebagai pakan ternak berprotein tinggi.",
//     img: "",
//     kategori: ["Legum"],
//     jenisTanaman: 3,
//   ),
//   Tanaman(
//     namaTanaman: "Rumput Kikuyu",
//     namaLatin: "Pennisetum clandestinum",
//     caption: "Rumput pakan ternak yang tahan terhadap kekeringan.",
//     deskripsi:
//         "Rumput Kikuyu adalah rumput yang sangat cocok untuk pakan ternak di daerah yang sering mengalami kekeringan.",
//     img: "",
//     kategori: ["Rumput"],
//     jenisTanaman: 3,
//   ),
//   Tanaman(
//     namaTanaman: "Rumput Odot",
//     namaLatin: "Panicum maximum",
//     caption: "Rumput untuk pakan sapi perah.",
//     deskripsi:
//         "Rumput Odot adalah jenis rumput yang sering digunakan sebagai pakan ternak sapi perah.",
//     img: "",
//     kategori: ["Rumput"],
//     jenisTanaman: 3,
//   ),
//   Tanaman(
//     namaTanaman: "Clovers",
//     namaLatin: "Trifolium spp.",
//     caption:
//         "Legum pakan ternak yang digunakan untuk meningkatkan kualitas pakan.",
//     deskripsi:
//         "Clovers adalah tanaman legum yang sering digunakan dalam pakan ternak karena kandungan proteinnya yang tinggi.",
//     img: "",
//     kategori: ["Legum"],
//     jenisTanaman: 3,
//   ),
//   Tanaman(
//     namaTanaman: "Sorghum",
//     namaLatin: "Sorghum bicolor",
//     caption: "Tanaman pakan ternak yang digunakan sebagai pakan kering.",
//     deskripsi:
//         "Sorghum adalah tanaman yang digunakan dalam pakan ternak, terutama dalam bentuk pakan kering dan silase.",
//     img: "",
//     kategori: ["Legum", "Rumput"],
//     jenisTanaman: 3,
//   ),
//   Tanaman(
//     namaTanaman: "Bermuda Grass",
//     namaLatin: "Cynodon dactylon",
//     caption:
//         "Rumput hijau yang digunakan sebagai pakan ternak dan untuk penutup tanah.",
//     deskripsi:
//         "Bermuda Grass adalah rumput yang sering digunakan sebagai pakan ternak dan juga untuk penutup tanah.",
//     img: "",
//     kategori: ["Rumput"],
//     jenisTanaman: 3,
//   ),
//   Tanaman(
//     namaTanaman: "Clover",
//     namaLatin: "Trifolium repens",
//     caption: "Pakan ternak yang dapat tumbuh baik di tanah lembab.",
//     deskripsi:
//         "Clover adalah tanaman legum yang digunakan sebagai pakan ternak, dikenal karena kemampuannya memperbaiki kualitas tanah.",
//     img: "",
//     kategori: ["Legum"],
//     jenisTanaman: 3,
//   ),
//   Tanaman(
//     namaTanaman: "Sweet Potato Vines",
//     namaLatin: "Ipomoea batatas",
//     caption: "Tanaman pakan ternak yang kaya akan karbohidrat.",
//     deskripsi:
//         "Sweet Potato Vines adalah tanaman yang digunakan sebagai pakan ternak yang kaya akan karbohidrat.",
//     img: "",
//     kategori: ["Umbi"],
//     jenisTanaman: 3,
//   ),
// ];

// List<Tanaman> tanamanKehutanan = [
//   Tanaman(
//     namaTanaman: "Kayu Jati",
//     namaLatin: "Tectona grandis",
//     caption: "Kayu keras yang banyak digunakan untuk furnitur dan konstruksi.",
//     deskripsi:
//         "Kayu Jati adalah pohon yang menghasilkan kayu berkualitas tinggi, digunakan untuk furnitur, kapal, dan bangunan.",
//     img: "",
//     kategori: ["Kayu"],
//     jenisTanaman: 4, // Kehutanan
//   ),
//   Tanaman(
//     namaTanaman: "Kayu Meranti",
//     namaLatin: "Shorea spp.",
//     caption: "Kayu keras yang biasa digunakan untuk bahan bangunan.",
//     deskripsi:
//         "Kayu Meranti banyak digunakan dalam konstruksi, terutama untuk bahan bangunan dan furnitur.",
//     img: "",
//     kategori: ["Kayu"],
//     jenisTanaman: 4, // Kehutanan
//   ),
//   Tanaman(
//     namaTanaman: "Eucalyptus",
//     namaLatin: "Eucalyptus spp.",
//     caption: "Pohon penghasil minyak atsiri dan kayu untuk industri kertas.",
//     deskripsi:
//         "Eucalyptus adalah tanaman hutan yang tumbuh cepat, banyak digunakan untuk produksi minyak atsiri dan kayu.",
//     img: "",
//     kategori: ["Kayu", "Pohon Konservasi"],
//     jenisTanaman: 4, // Kehutanan
//   ),
//   Tanaman(
//     namaTanaman: "Pinus",
//     namaLatin: "Pinus spp.",
//     caption: "Pohon penghasil kayu untuk bahan bangunan dan industri kertas.",
//     deskripsi:
//         "Pinus adalah pohon yang banyak ditanam untuk produksi kayu komersial dan bahan baku industri kertas.",
//     img: "",
//     kategori: ["Kayu"],
//     jenisTanaman: 4, // Kehutanan
//   ),
//   Tanaman(
//     namaTanaman: "Cendana",
//     namaLatin: "Santalum album",
//     caption:
//         "Kayu aromatik yang digunakan untuk bahan baku parfum dan kerajinan.",
//     deskripsi:
//         "Cendana adalah pohon penghasil kayu aromatik yang banyak digunakan untuk parfum dan kerajinan.",
//     img: "",
//     kategori: ["Kayu"],
//     jenisTanaman: 4, // Kehutanan
//   ),
//   Tanaman(
//     namaTanaman: "Mahoni",
//     namaLatin: "Swietenia macrophylla",
//     caption: "Kayu keras yang sangat dicari untuk furnitur dan bahan bangunan.",
//     deskripsi:
//         "Mahoni adalah pohon yang menghasilkan kayu keras dan tahan lama, cocok untuk pembuatan furnitur.",
//     img: "",
//     kategori: ["Kayu"],
//     jenisTanaman: 4, // Kehutanan
//   ),
//   Tanaman(
//     namaTanaman: "Cemara",
//     namaLatin: "Casuarina equisetifolia",
//     caption:
//         "Pohon yang banyak digunakan untuk penghijauan pantai dan sebagai penahan angin.",
//     deskripsi:
//         "Cemara adalah pohon yang sering ditanam untuk penghijauan pantai dan penahan angin, serta untuk produksi kayu.",
//     img: "",
//     kategori: ["Pohon Konservasi"],
//     jenisTanaman: 4, // Kehutanan
//   ),
//   Tanaman(
//     namaTanaman: "Bambu",
//     namaLatin: "Bambusa spp.",
//     caption: "Tanaman penghasil bahan bangunan dan kerajinan.",
//     deskripsi:
//         "Bambu adalah tanaman yang tumbuh cepat dan digunakan dalam berbagai produk seperti furnitur, kerajinan, dan bahan bangunan.",
//     img: "",
//     kategori: ["Tanaman Rehabilitasi", "Kayu"],
//     jenisTanaman: 4, // Kehutanan
//   ),
//   Tanaman(
//     namaTanaman: "Durian Belanda",
//     namaLatin: "Annona muricata",
//     caption: "Pohon yang menghasilkan buah tropis dengan khasiat medis.",
//     deskripsi:
//         "Durian Belanda adalah tanaman tropis yang menghasilkan buah yang sering digunakan dalam pengobatan tradisional.",
//     img: "",
//     kategori: ["Pohon Konservasi"],
//     jenisTanaman: 4, // Kehutanan
//   ),
//   Tanaman(
//     namaTanaman: "Kapur",
//     namaLatin: "Dryobalanops aromatica",
//     caption:
//         "Kayu penghasil minyak kapur yang digunakan dalam produk industri.",
//     deskripsi:
//         "Kapur adalah pohon penghasil minyak yang banyak digunakan dalam industri, terutama dalam pembuatan cat dan produk kimia.",
//     img: "",
//     kategori: ["Kayu"],
//     jenisTanaman: 4, // Kehutanan
//   ),
//   Tanaman(
//     namaTanaman: "Pohon Palem",
//     namaLatin: "Arecaceae spp.",
//     caption:
//         "Pohon yang banyak digunakan untuk penghijauan dan produksi kelapa.",
//     deskripsi:
//         "Pohon Palem banyak digunakan dalam penghijauan serta menghasilkan buah kelapa yang penting untuk berbagai industri.",
//     img: "",
//     kategori: ["Pohon Peneduh", "Tanaman Rehabilitasi"],
//     jenisTanaman: 4, // Kehutanan
//   ),
//   Tanaman(
//     namaTanaman: "Karet",
//     namaLatin: "Hevea brasiliensis",
//     caption: "Pohon penghasil lateks untuk industri karet.",
//     deskripsi:
//         "Pohon karet menghasilkan lateks yang digunakan dalam berbagai produk karet, mulai dari ban hingga produk medis.",
//     img: "",
//     kategori: ["Kayu", "Pohon Konservasi"],
//     jenisTanaman: 4, // Kehutanan
//   ),
//   Tanaman(
//     namaTanaman: "Tamarind",
//     namaLatin: "Tamarindus indica",
//     caption:
//         "Pohon yang menghasilkan buah asam yang banyak digunakan dalam masakan.",
//     deskripsi:
//         "Tamarind menghasilkan buah asam yang digunakan dalam berbagai masakan dan obat-obatan tradisional.",
//     img: "",
//     kategori: ["Pohon Peneduh"],
//     jenisTanaman: 4, // Kehutanan
//   ),
//   Tanaman(
//     namaTanaman: "Coklat",
//     namaLatin: "Theobroma cacao",
//     caption: "Pohon penghasil biji coklat untuk industri pangan.",
//     deskripsi:
//         "Coklat adalah pohon penghasil biji yang digunakan dalam pembuatan produk coklat yang dikenal di seluruh dunia.",
//     img: "",
//     kategori: ["Pohon Peneduh"],
//     jenisTanaman: 4, // Kehutanan
//   ),
// ];
