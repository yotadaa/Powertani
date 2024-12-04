import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class Profilecontainer extends StatelessWidget {
  Profilecontainer({super.key, required this.profilePicture, this.size = 90});

  final double size;
  final String? profilePicture;

  Widget build(BuildContext context) {
    return (profilePicture == null || profilePicture == ""
        ? Image.asset(
            'assets/images/logo.png',
            width: 90,
            height: 90,
            fit: BoxFit.cover,
          )
        : ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: CachedNetworkImage(
              imageUrl: profilePicture ?? "",
              width: 90,
              height: 90,
              fit: BoxFit.cover,
              // Show a shimmer effect as a skeleton while the image is loading
              placeholder: (context, url) => Shimmer.fromColors(
                baseColor: Colors.grey[300]!, // Base color of shimmer
                highlightColor: Colors.grey[100]!, // Highlight color of shimmer
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ));
  }
}
