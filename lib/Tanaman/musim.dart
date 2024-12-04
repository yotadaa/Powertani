class Musim {
  Musim({
    required this.name,
    required this.description,
    this.img = "",
  });

  final String name;
  final String description;
  final String? img;

  static List<Musim> musims = [
    Musim(
      name: 'Hujan',
      description:
          'Musim di mana curah hujan tinggi dan suhu udara lebih dingin. Biasanya terjadi antara bulan Oktober hingga Maret.',
      img: 'assets/images/hujan.png',
    ),
    Musim(
      name: 'Kemarau',
      description:
          'Musim dengan cuaca panas dan kering, yang biasanya berlangsung antara bulan April hingga September. Curah hujan sangat rendah pada periode ini.',
    ),
    Musim(
      name: 'Peralihan',
      description:
          'Peralihan antara musim hujan dan musim kemarau, di mana hujan mulai berkurang atau mulai datang. Musim ini terjadi sekitar bulan Maret hingga April dan September hingga Oktober.',
    ),
  ];
}
