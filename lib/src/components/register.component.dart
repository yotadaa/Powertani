import 'package:flutter/material.dart';
import 'package:powertani/Auth/authentication.dart';
import 'package:powertani/Auth/login_screen.dart';
import 'package:powertani/components/auth.dart';
import 'package:powertani/screens/home_screen.dart';
import 'package:powertani/src/shared/widgets/verticalSpacing.widget.dart';
import 'package:powertani/src/shared/widgets/wave.widget.dart';
import 'package:wave/config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterComponent extends StatefulWidget {
  const RegisterComponent({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<RegisterComponent> createState() => _RegisterComponentState();
}

class _RegisterComponentState extends State<RegisterComponent> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String errorMessage = '';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController countryFlagController =
      TextEditingController(text: 'US');

  String selectValue = 'US';
  Config animationConfig = CustomConfig(
    gradients: [
      [
        const Color.fromARGB(255, 61, 143, 75),
        const Color.fromARGB(255, 120, 179, 130)
      ],
      [
        const Color.fromARGB(255, 115, 218, 31),
        const Color.fromARGB(255, 121, 143, 61)
      ],
      [
        const Color.fromARGB(255, 22, 125, 185),
        const Color.fromARGB(255, 139, 198, 247)
      ],
      [
        const Color.fromARGB(255, 61, 143, 75),
        const Color.fromARGB(255, 177, 216, 184)
      ]
    ],
    durations: [35000, 19440, 10800, 6000],
    heightPercentages: [0.20, 0.23, 0.25, 0.30],
    gradientBegin: Alignment.bottomLeft,
    gradientEnd: Alignment.topRight,
  );

  Future<void> signUp() async {
    if (passwordController.text.trim() !=
        confirmPasswordController.text.trim()) {
      setState(() {
        errorMessage = "Mohon masukkan password yang sama";
      });
      return;
    }

    try {
      // Check if email is already registered with another provider
      List<String> methods = await FirebaseAuth.instance
          .fetchSignInMethodsForEmail(emailController.text.trim());

      if (methods.isNotEmpty) {
        // If there are existing methods, it means the email is already in use
        setState(() {
          errorMessage = "Email sudah terdaftar dengan metode lain";
        });
        return;
      }

      // Register a new user with email and password
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final User? user = userCredential.user;

      // Save additional user data in Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': usernameController.text,
        'email': emailController.text,
        'createdAt': Timestamp.now(),
        'profil_picture': '',
      });

      // Navigate to the AuthWrapper screen after successful sign-up
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => AuthWrapper()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = ErrorMessages.getErrorMessage(e.code);
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            waveBackInfo(),
            form(),
            verticalSpacing(10),
            verticalSpacing(10),
            verticalSpacing(10),
            sendCodeButton(),
            verticalSpacing(10),
            BackButton(),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }

  Widget waveBackInfo() {
    return Stack(
      children: [
        waveAnimation(
          backgroundColor: Colors.purpleAccent,
          height: 200,
          context: context,
          config: animationConfig,
        ),
      ],
    );
  }

  Widget backButton() {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Row(
        children: [horizontalSpacing(30), const Icon(Icons.arrow_back_ios_new)],
      ),
    );
  }

  Widget fillInformationBelow() {
    return Column(
      children: [
        Row(
          children: const [
            SizedBox(
              width: 20,
            ),
            Text(
              'Daftar',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget form() {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            fillInformationBelow(),
            verticalSpacing(15),
            usernameInput(),
            verticalSpacing(15),
            emailInput(),
            verticalSpacing(15),
            passwordInput(),
            verticalSpacing(15),
            confirmPasswordInput(),
            verticalSpacing(15),
            Text(errorMessage),
          ],
        ),
      ),
    );
  }

  Widget usernameInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: AuthTextField(
        hintText: "Nama",
        controller: usernameController,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Username harus diisi!";
          }
          return null;
        },
      ),
    );
  }

  Widget emailInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: AuthTextField(
        icon: Icons.email,
        hintText: "Email",
        controller: emailController,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Email harus diisi!";
          }
          return null;
        },
      ),
    );
  }

  Widget passwordInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: AuthTextField(
        icon: Icons.lock,
        obscureText: true,
        hintText: "Password",
        controller: passwordController,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Password harus diisi";
          }
          return null;
        },
      ),
    );
  }

  Widget confirmPasswordInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: AuthTextField(
        icon: Icons.lock,
        obscureText: true,
        hintText: "Konfirmasi Password",
        controller: confirmPasswordController,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Password harus diisi";
          }
          return null;
        },
      ),
    );
  }

  Widget sendCodeButton() {
    return GestureDetector(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: AuthButton(
              width: MediaQuery.of(context).size.width,
              borderRadius: BorderRadius.circular(5),
              onPressed: signUp,
              text: "Daftar"),
        ),
        onTap: () => {});
  }

  Widget BackButton() {
    return GestureDetector(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: AuthButton(
            width: MediaQuery.of(context).size.width,
            onPressed: () => {
                  Navigator.pop(context),
                },
            bgColor: Colors.white,
            txtColor: const Color.fromARGB(255, 61, 143, 75),
            borderWidth: 2,
            borderRadius: BorderRadius.circular(5),
            borderColor: const Color.fromARGB(255, 61, 143, 75),
            text: "Kembali"),
      ),
      onTap: () {},
    );
  }
}
