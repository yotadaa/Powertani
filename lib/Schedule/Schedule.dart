import 'package:flutter/material.dart';
import 'package:powertani/Schedule/ScheduleAdd.dart';
import 'package:powertani/components/AppBar.dart';
import 'package:powertani/components/Text.dart';
import 'package:powertani/env.dart';

class Schedule extends StatelessWidget {
  Schedule({super.key, required this.user});

  Map<dynamic, dynamic> user;

  @override
  Widget build(BuildContext context) {
    return MainAppBar(
      title: "Penyiraman",
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Container(
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
                    MaterialPageRoute(builder: (context) => ScheduleAdd()),
                  ),
                },
                child: StdText(
                  text: 'Tambah Jadwal',
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  overlayColor:
                      WidgetStatePropertyAll(Colors.white.withOpacity(0.1)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
