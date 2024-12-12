import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:powertani/Tanaman/tanaman.dart';
import 'package:powertani/components/AppBar.dart';
import 'package:powertani/components/Text.dart';
import 'package:powertani/env.dart';

class ScheduleAdd extends StatefulWidget {
  ScheduleAdd({super.key});

  @override
  State<ScheduleAdd> createState() => _ScheduleAddState();
}

class _ScheduleAddState extends State<ScheduleAdd> {
  final TextEditingController namaTanamanController = TextEditingController();
  Box<Tanaman> tanamanBox = Hive.box<Tanaman>('tanamanBox');
  List<dynamic> filteredTanamanList = [];

  Future<void> loadData() async {
    // Box<Tanaman> temp = await Hive.openBox<Tanaman>('tanaman');
    setState(() {
      // tanamanBox = temp;
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
    // filteredTanamanList = tanamanBox!.values as List<Tanaman>;
  }

  @override
  Widget build(BuildContext context) {
    return MainAppBar(
      title: "Penyiraman",
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Form(
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 1,
                          child: TextFormField(
                            onChanged: (value) {
                              tanamanBox.values
                                  .toList()
                                  .map((o) => print(o.namaLatin));
                              filteredTanamanList = tanamanBox != null
                                  ? tanamanBox!.values
                                      .toList()
                                      .where(
                                        (element) => element.namaTanaman
                                            .toLowerCase()
                                            .contains("tomat".toLowerCase()),
                                      )
                                      .toList()
                                  : [];
                              print(filteredTanamanList);
                              setState(
                                  () {}); // Trigger a rebuild to update the UI
                            },
                            controller: namaTanamanController,
                            decoration: InputDecoration(
                              labelText: 'Nama Tanaman',
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            print("123");
                            print("text: ${namaTanamanController.text}");
                          },
                          child: StdText(text: "Check"),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    color: Colors.red,
                    height: 50,
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
