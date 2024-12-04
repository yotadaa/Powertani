import 'package:flutter/material.dart';
import 'package:powertani/Tanaman/musim.dart';
import 'package:powertani/components/AppBar.dart';
import 'package:powertani/components/ImageContainer.dart';
import 'package:powertani/components/Text.dart';
import 'package:powertani/env.dart';

class KalenderMusim extends StatefulWidget {
  KalenderMusim({super.key});

  @override
  _KalenderMusimState createState() => _KalenderMusimState();
}

class _KalenderMusimState extends State<KalenderMusim> {
  PageController _pageController = PageController();
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MainAppBar(
      title: "Kalender Musim Tanaman",
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            ImageContainer(
              borderRadius: 10,
              width: MediaQuery.of(context).size.width,
              image:
                  "assets/images/hujan.png", // Ganti dengan gambar sesuai kebutuhan
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 120,
                        // color: Colors.black
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withOpacity(0.7),
                              Colors.black.withOpacity(0.0),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          StdText(
                            text: "Musim Penghujan",
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                gradient: LinearGradient(
                  colors: [
                    AppColors
                        .primaryGreenDark, // Ganti dengan AppColors.primaryGreenDark
                    AppColors
                        .primaryGreenLight, // Ganti dengan AppColors.primaryGreenLight
                  ],
                ),
                color: Colors.transparent,
              ),
              child: StdText(
                text: "Musim",
                fontWeight: FontWeight.w500,
                color: Colors.black,
                fontSize: 16,
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 140,
              child: PageView.builder(
                controller: _pageController,
                itemCount: Musim.musims.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                      children: [
                        ImageContainer(
                          width: MediaQuery.of(context).size.width,
                          // height: 120,
                          borderRadius: 10,
                          image: Musim.musims[index].img!,
                          child: Stack(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 120,
                                    // color: Colors.black
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      gradient: LinearGradient(
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                        colors: [
                                          Colors.black.withOpacity(0.7),
                                          Colors.black.withOpacity(0.0),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Positioned(
                                left: 0,
                                bottom: 0,
                                right:
                                    0, // Ensure it's stretched across the screen
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Container(
                                    // Allow the container to resize based on the content
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment
                                          .start, // Align the text at the start
                                      children: [
                                        StdText(
                                          text:
                                              "Musim ${Musim.musims[_selectedIndex].name}",
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                        SizedBox(
                                            height:
                                                5), // Add a small space between title and description
                                        // The description should now wrap based on the available width
                                        StdText(
                                          text:
                                              "${Musim.musims[_selectedIndex].description}",
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white,
                                          fontSize: 12,
                                          softWrap:
                                              true, // Ensure the text wraps
                                          maxLines:
                                              null, // Allow text to use multiple lines
                                          overflow: TextOverflow
                                              .visible, // Ensure no text gets clipped
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
                onPageChanged: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
