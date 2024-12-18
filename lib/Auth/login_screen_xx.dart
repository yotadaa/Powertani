// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../home_screen.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback onViewSwitchText;
  final VoidCallback onViewSwitchHome;

  const LoginScreen(
      {Key? key,
      required this.onViewSwitchText,
      required this.onViewSwitchHome})
      : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Image.asset(
              "assets/images/logo1.png",
              height: size.height * 0.30,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: TextField(
                key: const Key("signInEmail"),
                controller: emailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Correo electrónico',
                ),
                style: TextStyle(height: 0.5)),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: TextField(
                key: const Key("signInPassword"),
                controller: passwordController,
                obscureText: true,
                obscuringCharacter: "*",
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Clave',
                ),
                style: TextStyle(height: 0.5)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton(
                    child: const Text("Iniciar Sesión",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                        fixedSize: const Size(0,
                            60)), //El ancho de deja en 0 porque el "expanded" lo define.
                    onPressed: () async {},
                  ),
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                // ignore: prefer_const_constructors
                icon: Icon(
                  Icons.home,
                ),
                onPressed: widget.onViewSwitchHome,
              ),
              TextButton(
                key: const Key("toSignUpButton"),
                child: Text(
                  "¿No tienes cuenta? Registrate!",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                onPressed: widget.onViewSwitchText,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                // ignore: prefer_const_constructors
                icon: FaIcon(
                  FontAwesomeIcons.google,
                  color: Colors.red,
                ),
                onPressed: () => {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance
          .authStateChanges(), // Memantau perubahan status login
      builder: (context, snapshot) {
        // Jika ada data user, arahkan ke HomeScreen, jika tidak, arahkan ke LoginScreen
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;
          if (user == null) {
            return HomeScreen(); // Jika belum login, arahkan ke halaman login
          } else {
            return HomeScreen(); // Jika sudah login, arahkan ke halaman home
          }
        } else {
          return Center(
              child:
                  CircularProgressIndicator()); // Tampilkan loading jika masih memuat
        }
      },
    );
  }
}
