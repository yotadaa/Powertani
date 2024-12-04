import 'package:flutter/material.dart';

class AppColors {
  static const Color baseColor =
      Color.fromARGB(255, 82, 182, 0); // primary green

  // Different shades of the base color
  static const Color lightShade =
      Color.fromARGB(255, 143, 199, 2); // Lighter green
  static const Color darkShade =
      Color.fromARGB(255, 62, 147, 0); // Darker green

  static const Color submitting =
      Color.fromARGB(255, 118, 177, 0); // Muted green

  // For disabled state (a grayish version of the base color)
  static const Color disabled =
      Color.fromARGB(255, 169, 169, 169); // Gray color for disabled state

  static const Color primaryGreenDark = Color.fromARGB(255, 82, 182, 0);
  static const Color primaryGreenLight = Color.fromARGB(255, 143, 199, 2);
  static const Color background = Color(0xFFF5F5F5);
  static const Color textColor = Color(0xFF333333);
}

class Fonts {
  static const String primaryFont = 'Montserrat';
  static const String secondaryFont = 'Roboto';
  static const String fancyFont = 'Comfortaa';
  static const String sansFont = 'Poppins';
}
