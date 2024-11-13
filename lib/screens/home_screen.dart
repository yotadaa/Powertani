import 'package:flutter/material.dart';
import 'package:powertani/Auth/login_screen.dart';
import 'package:powertani/components/auth.dart';
import 'package:powertani/components/components.dart';
import 'package:powertani/src/components/register.component.dart';
import 'package:powertani/src/components/register_password.component.dart';

class PopupLogin extends StatefulWidget {
  const PopupLogin({
    Key? key,
    this.height = 300,
    required this.showPopup,
    required this.onClose,
    required BuildContext context,
  }) : super(key: key);

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

class HomeScreen extends StatefulWidget {
  // Changed to StatefulWidget
  const HomeScreen({super.key});
  static String id = 'home_screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Added State class
  bool _showPopup = false;
  double popupHeight = 400;
  bool _keyboardVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            child: SafeArea(
              // Moved SafeArea to wrap the main content
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const TopScreenImage(screenImageName: 'home.png'),
                    // ClipRRect(
                    //   borderRadius: BorderRadius.circular(0),
                    //   child: Image.asset(
                    //     'assets/images/home.png', // Make sure this path is correct
                    //     fit: BoxFit.cover,
                    //   ),
                    // ),
                    Expanded(
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
                              text: "Masuk",
                              onPressed: () {
                                setState(() {
                                  _showPopup = true;
                                });
                              },
                            ),
                            AuthButton(
                              text: "Daftar",
                              bgColor: Colors.white,
                              txtColor: const Color.fromARGB(255, 61, 143, 75),
                              borderWidth: 2,
                              borderColor:
                                  const Color.fromARGB(255, 61, 143, 75),
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
                                  onPressed: () {
                                    // Handle Google login
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
