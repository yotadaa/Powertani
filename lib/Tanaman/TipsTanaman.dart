import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
// import 'package:hive_flutter/hive_flutter.dart';
import 'package:powertani/Seeder/Firestore_seeder.dart';
import 'package:powertani/Tanaman/AddTanaman.dart';
import 'package:powertani/Tanaman/TanamanContainer.dart';
import 'package:powertani/Tanaman/jenisTanaman.dart';
import 'package:powertani/Tanaman/tanaman.dart';
import 'package:powertani/components/AppBar.dart';
import 'package:powertani/components/ImageContainer.dart';
import 'package:powertani/components/Text.dart';
// import 'package:powertani/components/auth.dart';
import 'package:powertani/env.dart';

class TipsTanaman extends StatefulWidget {
  TipsTanaman({super.key, required this.user});

  final Map<dynamic, dynamic> user;

  @override
  State<TipsTanaman> createState() => _TipsTanamanState();
}

class _TipsTanamanState extends State<TipsTanaman> {
  Box<JenisTanaman>? jenisTanamanBox;
  Box<Tanaman>? tanamanBox;

  int getCategoryCount(int categoryX) {
    int count = 0;

    for (var item in tanamanBox!.values.toList()) {
      // Check if category X is in the item['category'] list
      // print("================");
      // print(
      // "${item.jenisTanaman} ${categoryX} ${item.jenisTanaman.contains(categoryX)}");
      if (item.jenisTanaman.contains(categoryX)) {
        count++;
        // print(count);
      }
    }

    // print("================");
    // print(tanamanBox!.values);
    // print(count);
    // print("================");

    return count;
  }

  Future<void> loadData() async {
    Box<JenisTanaman> temp =
        await Hive.openBox<JenisTanaman>('jenisTanamanBox');

    Box<Tanaman> tempTanaman = await Hive.openBox<Tanaman>('tanamanBox');
    setState(() {
      tanamanBox = tempTanaman;
      jenisTanamanBox = temp;
      // print(jenisTanamanBox?.values);
    });
  }

  @override
  void initState() {
    super.initState();
    FirestoreSeeder().download();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return MainAppBar(
      title: "Informasi",
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: (widget.user['admin'] ?? false)
                ? Container(
                    padding: EdgeInsets.all(0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primaryGreenDark,
                          const Color.fromARGB(255, 123, 226, 75)
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                    width: MediaQuery.of(context).size.width,
                    child: TextButton(
                      onPressed: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AddTanaman()),
                        ),
                      },
                      child: StdText(
                        text: 'Tambah Tanaman',
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        overlayColor: WidgetStatePropertyAll(
                            Colors.white.withOpacity(0.1)),
                      ),
                    ),
                  )
                : SizedBox.shrink(),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: jenisTanamanBox != null
                  ? jenisTanamanBox?.values.toList().length
                  : 0,
              itemBuilder: (context, index) {
                final tanaman = jenisTanamanBox!.values.toList()[index];
                print(tanaman.id);
                int count = getCategoryCount(tanaman.id);
                print(count);
                if (true) {
                  double borderRadius = 15;
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    child: ImageContainer(
                      anotherCallback: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TanamanContainer(
                                    title: tanaman.nama,
                                    jenisTanaman: tanaman.id,
                                    kategori: ["Semua", ...tanaman.kategori],
                                  )),
                        );
                      },
                      image: tanaman.img,
                      width: MediaQuery.of(context).size.width,
                      opacity: 0.4,
                      borderRadius: borderRadius,
                      child: Stack(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 60,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(borderRadius),
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      Colors.black.withOpacity(
                                          0.7), // Black with opacity
                                      Colors.black.withOpacity(
                                          0.0), // Fully transparent
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Positioned(
                            bottom: 8,
                            left: 8,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  StdText(
                                    text: "${tanaman.nama} ${tanaman.id}",
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    font: "Montserrat",
                                  ),
                                  Container(
                                    // duration: const Duration(milliseconds: 300),
                                    // curve: Curves.easeInOut,
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    height: 35,
                                    child: StdText(
                                      text: tanaman.deskripsi,
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      font: "Montserrat",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
