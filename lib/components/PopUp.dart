import 'dart:ui';

import 'package:flutter/material.dart';

class PopUp extends StatelessWidget {
  final bool show;
  final Widget child;

  PopUp({Key? key, this.show = true, this.child = const SizedBox.shrink()})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return show
        ? Positioned(
            top: 0,
            left: 0,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2), // Shadow color
                    offset: Offset(0, 4), // Shadow offset
                    blurRadius: 10, // Shadow blur
                  ),
                ],
              ),
              child: Stack(
                children: [
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                    child: Container(
                        color: Colors.black.withOpacity(0.1),
                        padding: EdgeInsets.symmetric(vertical: 100),
                        height: MediaQuery.of(context).size.height,
                        child: child),
                  ),
                  // Modal Content (for extra content if needed)
                ],
              ),
            ),
          )
        : const SizedBox.shrink();
  }
}
