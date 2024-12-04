import 'package:flutter/material.dart';
import 'package:powertani/components/Text.dart';
import 'package:powertani/env.dart';

class ErrorMessages {
  static String getErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'user-not-found':
        return 'No account found with that email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'invalid-email':
        return 'The email address you entered is invalid.';
      case 'user-disabled':
        return 'Your account has been disabled.';
      case 'email-already-in-use':
        return 'The email address is already in use.';
      case 'too-many-requests':
        return 'Too many login attempts. Please try again later.';
      // Add more cases as needed
      default:
        return 'An unexpected error occurred. Please try again later.';
    }
  }
}

class AuthTextField extends StatelessWidget {
  AuthTextField({
    Key? key,
    required this.hintText,
    required this.controller,
    this.obscureText = false,
    this.validator, // Now optional with the correct type
    this.icon = Icons.person,
    this.disabled = false,
    this.showedText = "", // Optional, predefined text to display
    this.width = 300,
  }) : super(key: key);

  final String hintText;
  final bool obscureText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final IconData icon;
  final bool disabled;
  final String showedText;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      margin: const EdgeInsets.only(bottom: 20.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[400]),
          const SizedBox(width: 16.0),
          Expanded(
            child: TextFormField(
              // Use TextFormField instead of TextField
              controller: controller,
              obscureText: obscureText,
              enabled:
                  !disabled, // Disables the text field if 'disabled' is true
              decoration: InputDecoration(
                hintText: hintText,
                border: InputBorder.none,
              ),
              validator: validator,
              initialValue: showedText.isNotEmpty
                  ? showedText
                  : null, // Show predefined text if available
            ),
          ),
        ],
      ),
    );
  }
}

class AuthButton extends StatelessWidget {
  const AuthButton({
    Key? key,
    this.width = 300,
    this.txtColor = Colors.white,
    this.bgColor = const Color.fromARGB(255, 61, 143, 75),
    this.borderWidth = 0,
    this.borderColor = Colors.black,
    this.borderRadius = const BorderRadius.all(Radius.circular(25)),
    required this.onPressed,
    required this.text,
  }) : super(key: key);

  final double width;
  final String text;
  final Color txtColor;
  final dynamic bgColor;
  final Color borderColor;
  final double borderWidth;
  final BorderRadiusGeometry borderRadius;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
          borderRadius: borderRadius,
          border: Border.all(
            color: borderColor,
            width: borderWidth,
          ),
          gradient: LinearGradient(
              colors: bgColor is List<Color> ? bgColor : [bgColor, bgColor])),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          // surfaceTintColor: Colors.transparent,
          // foregroundColor: Colors.transparent,
          // overlayColor: Colors.transparent,
          shadowColor: Colors.transparent,
          backgroundColor:
              Colors.transparent, // Adjust the blue shade as needed
          padding: const EdgeInsets.symmetric(
              horizontal: 50, vertical: 15), // Adjust padding for size
          textStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold, // Optional: Add font weight
            color: txtColor,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius,
            // side: BorderSide(
            //   color: borderColor,
            //   width: borderWidth,
            // ),
          ),
        ),
        child: StdText(
          text: text,
          color: txtColor,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }
}

class AuthTextShower extends StatelessWidget {
  const AuthTextShower({
    Key? key,
    required this.hintText,
    required this.controller,
    this.obscureText = false,
    this.validator, // Now optional with the correct type
    this.icon = Icons.person,
  }) : super(key: key);

  final String hintText;
  final bool obscureText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      margin: const EdgeInsets.only(bottom: 20.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[400]),
          const SizedBox(width: 16.0),
          Expanded(
            child: TextFormField(
              // Use TextFormField instead of TextField
              controller: controller,
              obscureText: obscureText,
              decoration: InputDecoration(
                hintText: hintText,
                border: InputBorder.none,
              ),
              validator: validator,
            ),
          ),
        ],
      ),
    );
  }
}
