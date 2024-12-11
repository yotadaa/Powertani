import 'package:flutter/material.dart';
import 'package:powertani/components/Text.dart';
import 'package:powertani/env.dart';
import 'package:shimmer/shimmer.dart';

class SearchBox extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSearch;
  final VoidCallback toggleAI;
  bool ai_active = false;
  bool isSearching;

  SearchBox({
    super.key,
    required this.controller,
    required this.onSearch,
    required this.toggleAI,
    required this.ai_active,
    required this.isSearching,
  });

  @override
  State<SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(),
      child: Row(
        children: [
          const SizedBox(width: 8),
          Expanded(
            child: AnimatedContainer(
              // padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  gradient: LinearGradient(colors: [
                    widget.ai_active
                        ? AppColors.primaryGreenLight
                        : Colors.grey[100]!,
                    Colors.grey[100]!,
                  ])),
              duration: Duration(milliseconds: 300),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: TextField(
                        controller: widget.controller,
                        onSubmitted: (value) {
                          if (value.trim().isNotEmpty) {
                            widget.onSearch();
                          }
                        },
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Montserrat',
                        ),
                        decoration: InputDecoration(
                          labelStyle: TextStyle(
                              color: Colors.black54,
                              fontSize: 12,
                              fontFamily: 'Montserrat'),
                          hintText: widget.ai_active
                              ? 'Mencari dengan AI ✨'
                              : 'Search',
                          hintStyle: TextStyle(
                              color: Colors.black54,
                              fontSize: 12,
                              fontFamily: 'Montserrat'),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.search_sharp),
                    onPressed: widget.onSearch,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          AnimatedContainer(
            height: 40,
            width: 40,
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: widget.ai_active
                    ? [
                        AppColors.primaryGreenDark,
                        AppColors.primaryGreenLight,
                      ]
                    : [Colors.white, Colors.grey[200]!],
              ),
              borderRadius: const BorderRadius.all(Radius.circular(40)),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (!widget.isSearching)
                  SizedBox(
                    height: 40,
                    width: 40,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        widget.ai_active
                            ? AppColors.primaryGreenLight
                            : Colors.grey[400]!,
                      ),
                    ),
                  ),
                Center(
                  child: !widget.isSearching
                      ? Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Image.asset(
                            'assets/images/icons/ai_icon_4x_yellow.png',
                            width: 20,
                            height: 20,
                            fit: BoxFit.contain,
                          ),
                        )
                      : TextButton(
                          style: ButtonStyle(
                            iconSize: const WidgetStatePropertyAll(20),
                          ),
                          onPressed: () {
                            widget.toggleAI();
                          },
                          child: Image.asset(
                            'assets/images/icons/ai_icon_4x_yellow.png',
                            width: 20,
                            height: 20,
                            fit: BoxFit.contain,
                          ),
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
