import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:powertani/Initial/main.dart';
import 'package:powertani/components/CustomContainer.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;

          if (user == null) {
            // If not logged in, show StartingPage
            return StartingPage();
          } else {
            String loginMethod = user.providerData.isNotEmpty
                ? user.providerData[0].providerId == 'google.com'
                    ? 'Google'
                    : 'Email'
                : 'Email';
            // If logged in, retrieve additional user data from Firestore
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .get(),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.done) {
                  if (userSnapshot.hasData && userSnapshot.data!.exists) {
                    // Get the user data as a map
                    var userData =
                        userSnapshot.data!.data() as Map<String, dynamic>;
                    String? username = userData['username'] ?? user.displayName;

                    // Pass the username to HomePage
                    return CustomContainer(username: username, user: userData);
                  } else {
                    // return Center(child: Text("User data not found"));
                    return const AuthWrapper();
                  }
                } else {
                  // Show loading spinner while waiting for Firestore data
                  return Center(child: CircularProgressIndicator());
                }
              },
            );
          }
        } else {
          // Show loading spinner while waiting for auth state
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

Future<void> signOut(BuildContext context) async {
  try {
    // Get the current user
    final User? user = FirebaseAuth.instance.currentUser;

    // Check if the user is signed in with Google
    if (user != null) {
      for (var provider in user.providerData) {
        if (provider.providerId == 'google.com') {
          // Sign out from Google if the provider is Google
          await GoogleSignIn().signOut();
          break;
        }
      }
    }

    // Sign out from Firebase (covers all providers, including email)
    await FirebaseAuth.instance.signOut();

    // Optionally navigate the user back to a login or starting screen
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => StartingPage()),
    );

    print('User signed out successfully');
  } catch (e) {
    print('Error signing out: $e');
  }
}

class Authentication {
  static SnackBar customSnackBar({required String content}) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
  }

  static Future<void> signOut({required BuildContext context}) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      if (!kIsWeb) {
        await googleSignIn.signOut();
      }
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        Authentication.customSnackBar(
          content: 'Error signing out. Try again.',
        ),
      );
    }
  }

  static Future<User?> signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    if (kIsWeb) {
      GoogleAuthProvider authProvider = GoogleAuthProvider();

      try {
        final UserCredential userCredential =
            await auth.signInWithPopup(authProvider);

        user = userCredential.user;

        // Print the profile picture URL
        print('Profile Picture URL: ${user?.photoURL}');
      } catch (e) {
        print(e);
      }
    } else {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        try {
          final UserCredential userCredential =
              await auth.signInWithCredential(credential);

          Map<String, dynamic> _user = {
            'id': userCredential.user!.uid,
            'username': userCredential.user!.displayName,
            'email': userCredential.user!.email,
            'photoUrl': userCredential.user!.photoURL,
          };

          user = userCredential.user!;

          // Print the profile picture URL
          print('Profile Picture URL: ${user?.photoURL}');
        } on FirebaseAuthException catch (e) {
          if (e.code == 'account-exists-with-different-credential') {
            ScaffoldMessenger.of(context).showSnackBar(
              Authentication.customSnackBar(
                content:
                    'The account already exists with a different credential.',
              ),
            );
          } else if (e.code == 'invalid-credential') {
            ScaffoldMessenger.of(context).showSnackBar(
              Authentication.customSnackBar(
                content:
                    'Error occurred while accessing credentials. Try again.',
              ),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            Authentication.customSnackBar(
              content: 'Error occurred using Google Sign-In. Try again.',
            ),
          );
        }
      }
    }
    return user;
  }
}
