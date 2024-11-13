import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../Initial/pages/post_1.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Stack(
        children: [
          Positioned(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: PageView(
              scrollDirection: Axis.horizontal,
              controller: _controller,
              children: [
                MyPost1(text: "Halaman 1"),
                MyPost1(text: "Halaman 2"),
                MyPost1(text: "Halaman 3"),
                MyPost1(text: "Login dan Daftar"),
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
