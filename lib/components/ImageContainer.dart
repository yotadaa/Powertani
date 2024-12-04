import 'package:flutter/material.dart';

class ImageContainer extends StatefulWidget {
  final Widget child;
  final String image;
  final double? height, width;
  final double opacity, borderRadius;
  final Color overlay;
  final EdgeInsets padding;
  final VoidCallback? anotherCallback;

  ImageContainer({
    Key? key,
    this.borderRadius = 20,
    this.overlay = Colors.black,
    this.height = 120,
    this.opacity = 0,
    this.width,
    this.anotherCallback,
    this.padding = const EdgeInsets.all(0),
    required this.image,
    required this.child,
  }) : super(key: key);

  @override
  State<ImageContainer> createState() => _ImageContainerState();
}

class _ImageContainerState extends State<ImageContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _controller.forward();
        });
      },
      onTapUp: (_) {
        setState(() {
          _controller.reverse();
        });
      },
      onTap: () {
        if (widget.anotherCallback != null) {
          widget.anotherCallback!();
        }
      },
      onTapCancel: () {
        setState(() {
          _controller.reverse();
        });
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: Container(
          height: widget.height,
          width: widget.width,
          child: Stack(
            children: [
              AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: widget.image.isEmpty
                        ? Container(
                            width: widget.width,
                            height: widget.height,
                            color: Colors.grey[
                                300], // Light grey background as placeholder
                            child: Icon(
                              Icons.image_not_supported,
                              color: Colors.grey[600],
                              size: widget.width! * 0.5,
                            ),
                          )
                        : (widget.image.contains("https://") ||
                                widget.image.contains("http://") ||
                                widget.image.contains("gs://"))
                            ? Image.network(
                                widget.image,
                                width: widget.width,
                                height: widget.height,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                widget.image,
                                width: widget.width,
                                height: widget.height,
                                fit: BoxFit.cover,
                              ),
                  );
                },
              ),
              Container(
                width: widget.width,
                height: widget.height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  color: widget.overlay.withOpacity(widget.opacity),
                ),
                padding: widget.padding,
                child: widget.child,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
