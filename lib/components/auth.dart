import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  const AuthTextField({
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
                validator: validator),
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
  final Color bgColor;
  final Color borderColor;
  final double borderWidth;
  final BorderRadiusGeometry borderRadius;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor, // Adjust the blue shade as needed
          padding: const EdgeInsets.symmetric(
              horizontal: 50, vertical: 15), // Adjust padding for size
          textStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold, // Optional: Add font weight
            color: txtColor,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius,
            side: BorderSide(
              color: borderColor,
              width: borderWidth,
            ),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: txtColor,
          ),
        ),
      ),
    );
  }
}
