import 'package:flutter/material.dart';
import 'package:powertani/Auth/login_screen.dart';
import 'package:powertani/components/auth.dart';

class PopupLogin extends StatefulWidget {
  const PopupLogin({
    super.key,
    this.height = 300,
    required this.showPopup,
    required this.onClose,
    required BuildContext context,
  });

  final double height;
  final bool showPopup;
  final VoidCallback onClose;

  @override
  State<PopupLogin> createState() => _PopupLoginState();
}

class _PopupLoginState extends State<PopupLogin> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      padding: EdgeInsets.all(30.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Column(
          children: [
            LoginView(
              onLoginSuccess: () {},
            ),
            SizedBox(
              height: 15,
            ),
            AuthButton(
              width: MediaQuery.of(context).size.width,
              onPressed: widget.onClose,
              text: "Kembali",
              borderRadius: BorderRadius.circular(10.0),
              bgColor: Colors.white,
              txtColor: const Color.fromARGB(255, 61, 143, 75),
              borderWidth: 2,
              borderColor: const Color.fromARGB(255, 61, 143, 75),
            ),
          ],
        ),
      ),
    );
  }
}
