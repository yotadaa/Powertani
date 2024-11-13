import 'package:flutter/material.dart';
import 'package:powertani/components/auth.dart';

class LoginView extends StatefulWidget {
  final VoidCallback onLoginSuccess; // Callback for successful login

  const LoginView({
    Key? key,
    required this.onLoginSuccess,
  }) : super(key: key);

  // ... your existing code ...
  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late FocusNode _focusNode1;
  late FocusNode _focusNode2;

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _focusNode1 = FocusNode();
    _focusNode2 = FocusNode();

    _focusNode1.addListener(() {
      print("Email field focus changed: ${_focusNode1.hasFocus}");
    });
  }

  @override
  void dispose() {
    _focusNode1.dispose();
    _focusNode2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          AuthTextField(
            controller: emailController,
            hintText: "Email",
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Email harus diisi";
              }
              return null;
            },
          ),
          AuthTextField(
            icon: Icons.lock,
            controller: passwordController,
            hintText: "Password",
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Password harus diisi";
              }
              return null;
            },
            obscureText: true,
          ),
          AuthButton(
            width: MediaQuery.of(context).size.width,
            onPressed: widget.onLoginSuccess,
            text: "Login",
            borderRadius: BorderRadius.circular(10.0),
          ),
        ],
      ),
    );
  }
}
