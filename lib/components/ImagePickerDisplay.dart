import 'dart:io';

import 'package:flutter/material.dart';

class ImagePickerDisplay extends StatelessWidget {
  final File? imageFile; // Image file passed as a parameter
  final double? size;
  final String imgUrl;
  final double borderRadius;

  // Constructor to accept imageFile as a parameter
  const ImagePickerDisplay({
    Key? key,
    this.imageFile,
    this.size,
    this.imgUrl = "",
    this.borderRadius = 8,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // This can be used to trigger image picker when needed (if you add a method to change the image)
      },
      child: Container(
        width: size != null ? size : MediaQuery.of(context).size.width,
        height: size != null ? size : MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.grey[300], // Background color while no image
          image: (imgUrl == "")
              ? (imageFile != null
                  ? DecorationImage(
                      image: FileImage(
                          imageFile!), // Display passed image from file
                      fit: BoxFit
                          .cover, // Ensures image covers the area with cropping if needed
                    )
                  : null)
              : (Uri.parse(imgUrl).isAbsolute
                  ? DecorationImage(
                      image: NetworkImage(
                          imgUrl), // Display image from network URL
                      fit: BoxFit
                          .cover, // Ensures image covers the area with cropping if needed
                    )
                  : null),

          borderRadius:
              BorderRadius.circular(borderRadius), // Optional rounded corners
        ),
        child: imageFile == null
            ? Center(
                child: Icon(
                  Icons.camera_alt, // Show camera icon if no image
                  color: Colors.white,
                ),
              )
            : null,
      ),
    );
  }
}
