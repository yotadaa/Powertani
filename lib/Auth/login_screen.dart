import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:powertani/Auth/authentication.dart';
import 'package:powertani/components/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String errorMessage = '';

  Future<void> signIn() async {
    try {
      // Authenticate user with email and password
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      User? user = userCredential.user;

      if (user != null) {
        // Reference to the user's Firestore document
        DocumentReference userDoc =
            FirebaseFirestore.instance.collection('users').doc(user.uid);

        // Check if user data exists in Firestore
        DocumentSnapshot docSnapshot = await userDoc.get();

        if (!docSnapshot.exists) {
          // If user data doesn't exist, create it
          await userDoc.set({
            'username': user.displayName ?? user.email?.split('@')[0],
            'email': user.email,
            'createdAt': Timestamp.now(),
          });
        }

        // Navigate to AuthWrapper once Firestore operations are complete
        if (mounted)
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => AuthWrapper()),
          );
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = ErrorMessages.getErrorMessage(e.code);
        });
      }
    }
  }

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
      key: _formKey,
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
          SizedBox(
            height: 30,
          ),
          Text(errorMessage),
          AuthButton(
            width: MediaQuery.of(context).size.width,
            onPressed: signIn,
            text: "Login",
            borderRadius: BorderRadius.circular(10.0),
          ),
        ],
      ),
    );
  }
}
