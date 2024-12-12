import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:powertani/Tanaman/jenisTanaman.dart';
import 'package:powertani/Tanaman/tanaman.dart';
import 'package:powertani/components/AppBar.dart';
import 'package:powertani/components/Text.dart';

class Pencarian extends StatefulWidget {
  Map<dynamic, dynamic> data;

  Pencarian({super.key, required this.data});

  @override
  State<Pencarian> createState() => _PencarianState();
}

class _PencarianState extends State<Pencarian> {
  Box<Tanaman> tanamanBox = Hive.box<Tanaman>("tanamanBox");
  Box<JenisTanaman> jenisTanamanBox = Hive.box<JenisTanaman>("jenisTanamanBox");
  List<Tanaman> filteredData = [];

  @override
  void initState() {
    super.initState();
    loadData();
    print("data: ${widget.data['filteredResults']}");
  }

  @override
  void dispose() {
    super.dispose();
    filteredData.clear();
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

  void loadData() {
    // var data = widget.data;
    // print("The data: $data");
    setState(() {
      // Extracting namaLatin values from filteredResults
      List<String> namaLatins = widget.data['filteredResults'] != null
          ? List<String>.from(widget.data['filteredResults']
                  .map((result) => result as String) ??
              [])
          : [];

      // Filtering tanamanBox where namaLatin is in the extracted list
      filteredData = tanamanBox.values
          .where((o) => namaLatins.toString().toLowerCase().contains(
              o.namaLatin.toLowerCase())) // Check if namaLatin is in the list
          .toList(); // Convert the Iterable to a List
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainAppBar(
      title: "Hasil Pencarian",
      child: Container(
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.start, // Ensure it starts at the top
            crossAxisAlignment: CrossAxisAlignment
                .stretch, // Stretch the column to fill available space
            children: [
              Center(
                child: StdText(
                  text: widget.data['header'].toString(),
                  fontSize: 13,
                  fontWeight: FontWeight.w300,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              // StdText(
              //   text: widget.data['mode'].toString(),
              //   fontSize: 13,
              //   fontWeight: FontWeight.w300,
              // ),
              SizedBox(
                height: 20,
              ),
              // Ensure minimum height is added when there are few items
              if (filteredData.isEmpty)
                Center(
                  child: StdText(
                    text: "No results found",
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                )
              else
                ...filteredData.map((item) => _result(context, item)).toList(),

              // Add a SizedBox to make sure the screen doesn't end up black when few items are shown
              if (filteredData.isNotEmpty)
                SizedBox(
                    height: MediaQuery.of(context).size.height *
                        0.1), // Adjust as needed to fill space
            ],
          ),
        ),
      ),
    );
  }

  Widget _result(BuildContext context, item) {
    return GestureDetector(
      onTap: () {
        // setState(() {
        //   // print(tanaman.kategori.contains(
        //   //     widget.kategori[selectedCategory]));
        //   currentTanaman = item;
        //   showDetail = true;
        //   detail['title'] = item.namaTanaman;
        //   detail['img'] = item.img;
        //   detail['description'] = item.deskripsi;
        // });
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
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
          child: Column(
            children: [
              Row(
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
            ],
          ),
        ),
      ),
    );
  }
}
