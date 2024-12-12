import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:powertani/Tanaman/Selengkapnya/main.dart';
import 'package:powertani/Tanaman/tanaman.dart';
import 'package:powertani/components/Text.dart';

class PlantDetailModal extends StatelessWidget {
  final String? imageUrl;
  final String title;
  final String description;
  final bool isShowing;
  final VoidCallback onClose;
  final VoidCallback closeDetail;

  final Tanaman? tanaman;

  const PlantDetailModal({
    Key? key,
    this.imageUrl,
    this.isShowing = false,
    required this.onClose,
    required this.closeDetail,
    required this.title,
    required this.description,
    this.tanaman,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // If not showing, return an empty container
    if (!isShowing) {
      return const SizedBox.shrink();
    }

    // If showing, display the modal content
    return Container(
      // duration: Duration(milliseconds: 1000),
      // curve: Curves.easeInOut,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 40.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Image or Placeholder
                if (imageUrl != null && imageUrl!.isNotEmpty)
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    child: (imageUrl!.contains("https://") ||
                            imageUrl!.contains("http://") ||
                            imageUrl!.contains("gs://"))
                        ? CachedNetworkImage(
                            imageUrl: imageUrl!,
                            height: 220,
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.cover,
                          )
                        // ?  Image.network(
                        //     imageUrl!,
                        //     width: double.infinity,
                        //     height: 200,
                        //     fit: BoxFit.cover,
                        //   )
                        : Image.asset(
                            imageUrl!,
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                  )
                else
                  Container(
                    width: double.infinity,
                    height: 200,
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    child: const Icon(
                      Icons.image_not_supported,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),

                // Title and Description
                Container(
                  height: 230,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(20),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, right: 16.0, top: 16.0, bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        StdText(
                          text: title.toUpperCase(),
                          font: "Montserrat",
                          fontSize: 18,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 110,
                          child: ClipRect(
                            child: ShaderMask(
                                shaderCallback: (bounds) {
                                  return LinearGradient(
                                    colors: [
                                      Colors.black.withOpacity(0.2),
                                      Colors.black.withOpacity(0.7),
                                      Colors.black.withOpacity(1),
                                      Colors.black.withOpacity(1),
                                      Colors.black.withOpacity(1),
                                      Colors.black.withOpacity(1),
                                      Colors.black.withOpacity(1),
                                      Colors.black.withOpacity(0.7),
                                      Colors.black.withOpacity(0.2),
                                    ],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                  ).createShader(Rect.fromLTWH(
                                      0, 0, bounds.width, bounds.height));
                                },
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      StdText(text: description),
                                    ],
                                  ),
                                )),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          child: Row(
                            children: [
                              Expanded(
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => DetailTanaman(
                                                tanaman: tanaman,
                                              )),
                                    );
                                    closeDetail();
                                  },
                                  child: StdText(
                                    text: 'Selengkapnya',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                    overlayColor: WidgetStatePropertyAll(
                                        Colors.grey.withOpacity(0.2)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Close Button
          Positioned(
            right: 8,
            top: 8,
            child: IconButton(
              onPressed: onClose,
              icon: const CircleAvatar(
                radius: 15,
                backgroundColor: Colors.transparent,
                child: Icon(
                  Icons.close,
                  color: Colors.black,
                  size: 25,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
