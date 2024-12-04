import 'package:flutter/material.dart';
import 'package:powertani/components/Text.dart';

class PlantDetailModal extends StatefulWidget {
  final String? imageUrl;
  final String title;
  final String description;
  final bool isShowing;
  final VoidCallback onClose;

  const PlantDetailModal({
    Key? key,
    this.imageUrl,
    this.isShowing = false,
    required this.onClose,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  State<PlantDetailModal> createState() => _PlantDetailModalState();
}

class _PlantDetailModalState extends State<PlantDetailModal>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
          milliseconds: 300), // Adjust the duration for smoothness
    );
    _scaleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  // @override
  // void didUpdateWidget(PlantDetailModal oldWidget) {
  //   super.didUpdateWidget(oldWidget);

  //   if (widget.isShowing && !oldWidget.isShowing) {
  //     // _controller.forward(); // Trigger the animation when showing
  //   } else if (!widget.isShowing && oldWidget.isShowing) {
  //     // _controller.reverse(); // Reverse the animation when hiding
  //   }
  // }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // If not showing, return an empty container
    if (!widget.isShowing) {
      return const SizedBox.shrink();
    }

    // If showing, display the modal content
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) => Transform.scale(
        scale: _scaleAnimation.value, // Use the scale animation value
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 60),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 40.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Image or Placeholder
                    if (widget.imageUrl != null && widget.imageUrl!.isNotEmpty)
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                        child: Image.asset(
                          widget.imageUrl!,
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
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(20),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            StdText(
                              text: widget.title.toUpperCase(),
                              font: "Montserrat",
                              fontSize: 18,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            StdText(
                              text: widget.description,
                              font: "Montserrat",
                              fontSize: 14,
                              color: Colors.black87,
                              fontWeight: FontWeight.w400,
                              textAlign: TextAlign.center,
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
                  onPressed: widget.onClose,
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
        ),
      ),
    );
  }
}
