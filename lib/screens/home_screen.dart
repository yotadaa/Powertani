import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:powertani/Auth/authentication.dart';
import 'package:powertani/Auth/loginContainer.dart';
import 'package:powertani/components/auth.dart';
import 'package:powertani/components/components.dart';
import 'package:powertani/env.dart';
import 'package:powertani/src/components/register.component.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:ui';

class HomeScreen extends StatefulWidget {
  // Changed to StatefulWidget
  const HomeScreen({super.key});
  static String id = 'home_screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  // Added State class
  bool _showPopup = false;
  double popupHeight = 0;
  bool _keyboardVisible = false;

  bool _isSigningIn = false;
  late Animation<double> animation;
  late AnimationController animationController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 3));
    animation = Tween<double>(begin: 0, end: -300).animate(animationController)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    if (mounted) {
      setState(() {
        _isSigningIn = true;
      });
    }

    try {
      // Initiate Google sign-in
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser != null) {
        // Obtain the Google authentication details
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        // Create a new credential using the token from Google Sign-In
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Sign in with Firebase using the credential
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
        User? user = userCredential.user;

        if (user != null) {
          // Check if the user already exists in Firestore
          final userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();
          if (!userDoc.exists) {
            // Create a new user document in Firestore
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .set({
              'name': user.displayName,
              'email': user.email,
              'profile_picture': user.photoURL,
              'created_at': Timestamp.now(),
              // Add any other user data you want to store
            });
          }

          const AuthWrapper();

          // Navigate to the HomeScreen
          // await Navigator.of(context).pushReplacement(
          //   MaterialPageRoute(builder: (context) {
          //     return AuthWrapper();
          //   }),
          // );
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        print('Account exists with different credential');
      } else if (e.code == 'invalid-credential') {
        print('Invalid credential');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSigningIn = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            child: Padding(
              padding: EdgeInsets.only(bottom: 30),
              // Moved SafeArea to wrap the main content
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const TopScreenImage(screenImageName: 'home.png'),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 2,
                    // padding: const EdgeInsets.only(
                    // right: 15.0, left: 15, bottom: 15),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          right: 15.0, left: 15, bottom: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(0),
                            child: Image.asset(
                              'assets/images/PowerTani.png', // Make sure this path is correct
                              height: 100,
                              width: 300,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const Text(
                            'Silahkan login atau daftar untuk melanjutkan',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 15,
                            ),
                          ),
                          AuthButton(
                            // Assuming AuthButton is a custom widget you have
                            bgColor: [
                              AppColors.primaryGreenDark,
                              AppColors.primaryGreenLight
                            ],
                            borderColor: AppColors.primaryGreenDark,
                            text: "Masuk",
                            onPressed: () {
                              setState(() {
                                _showPopup = true;
                                popupHeight = 400;
                              });
                            },
                          ),
                          AuthButton(
                            text: "Daftar",
                            bgColor: Colors.white,
                            txtColor: const Color.fromARGB(255, 61, 143, 75),
                            borderWidth: 2,
                            borderColor: AppColors.primaryGreenDark,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        // RegisterPasswordComponent(
                                        //     title: 'Register')),
                                        RegisterComponent(
                                          title: 'Daftar',
                                        )),
                              );
                              // Handle Daftar button press (e.g., navigate to registration screen)
                            },
                          ),
                          const Text(
                            'Sign up using',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () async {
                                  if (mounted) await signInWithGoogle(context);
                                },
                                icon: CircleAvatar(
                                  radius: 18,
                                  backgroundColor: Colors.transparent,
                                  child: Image.asset(
                                      'assets/images/icons/google.png'), // Make sure this path is correct
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            height: _showPopup ? MediaQuery.of(context).size.height : 0,
            child: GestureDetector(
              onTap: () => {
                setState(() {
                  _showPopup = false;
                  print("Keyboad should be closed by now");
                  FocusManager.instance.primaryFocus?.unfocus();
                }),
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: const Color.fromARGB(96, 0, 0, 0),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 300), // Animation duration
            curve: Curves.easeInOut, // Animation curve (optional)
            top: _showPopup
                ? MediaQuery.of(context).size.height -
                    popupHeight -
                    MediaQuery.of(context).viewInsets.bottom
                : MediaQuery.of(context).size.height,
            left: 0,
            right: 0,
            child: PopupLogin(
              height: popupHeight,
              showPopup: _showPopup,
              context: context,
              onClose: () {
                setState(() {
                  _showPopup = false;
                  // _focusNode.unfocus();
                  FocusManager.instance.primaryFocus?.unfocus();
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
