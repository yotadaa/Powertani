import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:powertani/Tanaman/jenisTanaman.dart';
import 'package:powertani/Tanaman/tanaman.dart';
import 'package:powertani/components/Text.dart';

// ignore: must_be_immutable
class Classified extends StatelessWidget {
  String title;
  dynamic content;

  Classified({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min, // Shrinks to fit content
      children: [
        StdText(
          text: title,
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: Colors.black54,
        ),
        const SizedBox(height: 10),
        if (content is String)
          StdText(
            text: content,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          )
        else if (content is List<dynamic>)
          for (dynamic item in content)
            StdText(
              text: item.toString(),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            )
      ],
    );
  }
}

// ignore: must_be_immutable
class DetailTanaman extends StatefulWidget {
  DetailTanaman({
    super.key,
    this.tanaman,
  });

  Tanaman? tanaman;

  @override
  State<DetailTanaman> createState() => _DetailTanamanState();
}

class _DetailTanamanState extends State<DetailTanaman> {
  Box<JenisTanaman> jenisTanamanBox = Hive.box<JenisTanaman>('jenisTanamanBox');
  double _scale = 1.0;

  double _scaleL = 1.0;

  void _onTap() {
    setState(() {
      // Shrink the icon immediately
      _scale = 0.8;
    });

    // After a short delay (e.g., 100ms), swell back to the original size
    Future.delayed(Duration(milliseconds: 200), () {
      setState(() {
        // Swell back to the original size
        _scale = 1.0;
      });
    });
  }

  void _onTapL() {
    setState(() {
      // Shrink the icon immediately
      _scaleL = 0.8;
    });

    // After a short delay (e.g., 200ms), swell back to the original size
    Future.delayed(Duration(milliseconds: 200), () {
      setState(() {
        // Swell back to the original size
        _scaleL = 1.0;
      });

      Navigator.pop(context);
    });
  }

  Tanaman? currentTanaman;
  bool showDetail = false;
  Map<String, dynamic> detail = {
    "title": "Some Title",
    "img": "",
    "description":
        "Some description that i didnt know what to put in this description, but i try to make it long, a long long text. But do you know that Long Long is a data type in CSS, the name is funny, Long Long haha."
  };

  Box<Tanaman> tanamanBox = Hive.box<Tanaman>('tanamanBox');

  String excludeFirstWord(String input) {
    int firstSpaceIndex = input.indexOf(' ');

    // Check if there's a space (i.e., more than one word)
    if (firstSpaceIndex != -1) {
      return input.substring(firstSpaceIndex + 1);
    } else {
      // If there's no space, return an empty string (or handle it as you prefer)
      return '';
    }
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

  Widget _similiarItem(item) {
    return GestureDetector(
      onTap: () {
        setState(() {
          // print(tanaman.kategori.contains(
          //     widget.kategori[selectedCategory]));
          currentTanaman = item;
          showDetail = true;
          detail['title'] = item.namaTanaman;
          detail['img'] = item.img;
          detail['description'] = item.deskripsi;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Container(
          padding: EdgeInsets.all(8),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: item.img.isNotEmpty
                    ? ((item.img.contains("https://") ||
                            (item.img.contains("http://") ||
                                (item.img.contains("gs://")))
                        ? CachedNetworkImage(
                            imageUrl: item.img!,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            item.img,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          )))
                    : Container(
                        width: 80,
                        height: 80,
                        color: Colors.grey[300],
                        child: Icon(
                          Icons.image_not_supported,
                          color: Colors.grey[600],
                        ),
                      ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StdText(
                        text: item.namaTanaman,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(height: 4),
                      StdText(
                        text: item.namaLatin,
                        fontStyle: FontStyle.italic,
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 4),
                      StdText(
                        text: _getFirst20Words(item.deskripsi),
                        fontSize: 12,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Tanaman> filteredData = tanamanBox.values
        .toList()
        .where((item) =>
            (item.namaLatin.split(' ')[0].toLowerCase() ==
                widget.tanaman!.namaLatin.split(' ')[0].toLowerCase()) &&
            (item.namaLatin.toLowerCase() !=
                widget.tanaman!.namaLatin
                    .toLowerCase())) // Check both kategori and jenisTanaman
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              // The background image in the stack
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    CachedNetworkImage(
                      imageUrl: widget.tanaman!.img,
                      height: 350,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 300,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        )),
                  ),
                ),
              ),
              Positioned(
                top: 275,
                left: 0,
                right: 0,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                            blurRadius: 10,
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            spreadRadius: 10)
                                      ],
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Center(
                                        child: StdText(
                                          text: "Overlay Content",
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height - 350,
                              child: SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 50.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Classified(
                                            title: "Genus",
                                            content: widget.tanaman!.namaLatin
                                                .split(' ')[0],
                                          ),
                                          Column(
                                            mainAxisSize: MainAxisSize
                                                .min, // Shrinks to fit content
                                            children: [
                                              StdText(
                                                text: "Jenis",
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black54,
                                              ),
                                              const SizedBox(height: 10),
                                              for (dynamic item in widget
                                                  .tanaman!.jenisTanaman)
                                                StdText(
                                                  text: excludeFirstWord(
                                                      jenisTanamanBox.values
                                                          .toList()
                                                          .where((o) =>
                                                              o.id == item)
                                                          .first
                                                          .nama
                                                          .toString()),
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black,
                                                ),
                                            ],
                                          ),
                                          Classified(
                                              title: "Kategori",
                                              content: widget.tanaman!.kategori)
                                        ],
                                      ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      StdText(
                                        text: widget.tanaman!.namaTanaman,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                      StdText(
                                        text: widget.tanaman!.namaLatin,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black87,
                                        fontStyle: FontStyle.italic,
                                        font: "Montserrat",
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      StdText(
                                        text: widget.tanaman!.deskripsi,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black87,
                                        // font: "Mon",
                                      ),
                                      const SizedBox(
                                        height: 40,
                                      ),
                                      const StdText(
                                        text: "Tanaman Sejenis",
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black87,
                                        font: "Montserrat",
                                      ),
                                      if (filteredData.isEmpty)
                                        const StdText(
                                          text:
                                              "Tidak ditemukan tanaman sejenis",
                                          fontSize: 16,
                                          fontWeight: FontWeight.w300,
                                          color: Colors.black87,
                                          // font: "Montserrat",
                                        )
                                      else
                                        for (Tanaman item in filteredData)
                                          _similiarItem(item),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 20,
                right: 20,
                child: GestureDetector(
                  onTap: _onTap, // Detect tap to trigger animation
                  child: AnimatedScale(
                    scale: _scale, // Use the current scale value
                    duration: Duration(
                        milliseconds: 300), // Duration of the animation
                    curve: Curves
                        .easeInOut, // Easing function for smooth animation
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      height: 50,
                      width: 50,
                      child: Center(
                        child: GestureDetector(
                          onTap: _onTap, // Detect tap to trigger animation
                          child: AnimatedScale(
                            scale: _scale, // The current scale value
                            duration: Duration(
                                milliseconds:
                                    200), // Duration of the shrinking/swelling animation
                            curve: Curves
                                .easeInOut, // Easing curve for smooth transition
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 15,
                                      blurStyle: BlurStyle.normal,
                                      color: Colors.black.withOpacity(0.2),
                                      offset: Offset(0, 0),
                                      spreadRadius: 2,
                                    )
                                  ]),
                              height: 50,
                              width: 50,
                              child: Icon(
                                Icons.favorite,
                                color: Colors.red, // Heart color
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 20,
                left: 20,
                child: GestureDetector(
                  onTap: () {
                    _onTapL();
                  }, // Detect tap to trigger animation
                  child: AnimatedScale(
                    scale: _scaleL, // Use the current scale value
                    duration: Duration(
                        milliseconds: 300), // Duration of the animation
                    curve: Curves
                        .easeInOut, // Easing function for smooth animation
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 15,
                              blurStyle: BlurStyle.normal,
                              color: Colors.black.withOpacity(0.2),
                              offset: Offset(0, 0),
                              spreadRadius: 2,
                            )
                          ]),
                      height: 50,
                      width: 50,
                      child: Center(
                        child: GestureDetector(
                          onTap: _onTapL, // Detect tap to trigger animation
                          child: AnimatedScale(
                            scale: _scaleL, // The current scale value
                            duration: Duration(
                                milliseconds:
                                    200), // Duration of the shrinking/swelling animation
                            curve: Curves
                                .easeInOut, // Easing curve for smooth transition
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              height: 50,
                              width: 50,
                              child: Icon(
                                Icons.arrow_back,
                                color: Colors.black, // Heart color
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
