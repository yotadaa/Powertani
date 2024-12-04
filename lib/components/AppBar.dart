import 'package:flutter/material.dart';
import 'package:powertani/components/Text.dart';
import 'package:powertani/env.dart';

class MainAppBar extends StatelessWidget {
  MainAppBar({Key? key, required this.child, required this.title})
      : super(key: key);
  final Widget child;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        height: kToolbarHeight +
            MediaQuery.of(context).padding.top, // AppBar + Status Bar
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primaryGreenDark,
              Color.fromARGB(255, 207, 255, 145),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: StdText(
            text: title,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
        ),
        body: Container(color: Colors.white, child: child),
      ),
    ]);
  }
}
