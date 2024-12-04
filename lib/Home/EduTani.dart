import 'package:flutter/material.dart';
import 'package:powertani/components/ImageContainer.dart';
import 'package:powertani/components/Text.dart';

class EduTani extends StatefulWidget {
  const EduTani({Key? key}) : super(key: key);

  @override
  State<EduTani> createState() => _EduTaniState();
}

class _EduTaniState extends State<EduTani> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return ImageContainer(
      anotherCallback: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      image: 'assets/images/agt-1.jpg',
      width: MediaQuery.of(context).size.width,
      opacity: 0.4,
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.7), // Black with opacity
                      Colors.black.withOpacity(0.0), // Fully transparent
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
                    text: "Edukasi Tani",
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    font: "Montserrat",
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: _isExpanded ? 35 : 0,
                    child: StdText(
                      text:
                          "Pelajari strategi bertani modern, hemat biaya, dan ramah lingkungan untuk menghasilkan panen yang melimpah",
                      fontSize: 10,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      font: "Montserrat",
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Row(
              children: [
                TextButton(
                  onPressed: () {},
                  child: StdText(
                    text: "Selengkapnya",
                    fontSize: 13,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    font: "Montserrat",
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
