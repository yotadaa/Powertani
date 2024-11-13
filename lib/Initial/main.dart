import 'package:flutter/material.dart';
import 'package:powertani/Initial/pages/last_page.dart';
import 'package:powertani/screens/home_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'pages/post_1.dart';
import 'pages/post_2.dart';
import 'pages/post_3.dart';

class StartingPage extends StatefulWidget {
  const StartingPage({Key? key}) : super(key: key);

  @override
  _StartingPageState createState() => _StartingPageState();
}

class _StartingPageState extends State<StartingPage> {
  final _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Container(
      // resizeToAvoidBottomInset: true,
      // backgroundColor: Colors.grey[900],
      child: Stack(
        children: [
          Positioned(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: PageView(
              // physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              controller: _controller,
              children: [
                MyPost1(text: "Halaman 1"),
                MyPost1(text: "Halaman 2"),
                MyPost1(text: "Halaman 3"),
                HomeScreen(),
              ],
            ),
          ),
          Positioned(
            bottom: 30.0,
            left: 0,
            right: 0, // This will make the Row take the full width
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Center the SmoothPageIndicator
              children: [
                SmoothPageIndicator(
                  controller: _controller,
                  count: 4,
                  effect: WormEffect(
                    dotHeight: 10,
                    dotWidth: 10,
                    activeDotColor: const Color.fromARGB(255, 101, 214, 101),
                    dotColor: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
