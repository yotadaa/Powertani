import 'package:flutter/material.dart';
import 'package:powertani/Auth/authentication.dart';
import 'package:powertani/Home/main.dart';
import 'package:powertani/Profile/main.dart';
import 'package:powertani/components/PopUp.dart';
import 'package:powertani/components/Text.dart';
import 'package:powertani/env.dart';

class CustomContainer extends StatefulWidget {
  final String? username;
  final Map<String, dynamic> user;

  CustomContainer({Key? key, this.username = '', required this.user})
      : super(key: key);

  @override
  _CustomContainerState createState() => _CustomContainerState();
}

class _CustomContainerState extends State<CustomContainer> {
  final double navigationHeight = 80;
  late PageController _pageController;
  int _currentIndex = 0;

  final List<Widget> _pages = [];
  bool showPopup = false;
  Widget popupChild = SizedBox.shrink();

  void popupLogoutConfirmation(BuildContext context) {
    setState(() {
      showPopup = true;
      popupChild = Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: StdText(
                    text: "Konfirmasi Logout",
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          showPopup = false;
                        });
                      },
                      child:
                          StdText(fontWeight: FontWeight.w500, text: "Kembali"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              8), // Adjust the radius here
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Authentication.signOut(context: context);
                      },
                      child:
                          StdText(fontWeight: FontWeight.w500, text: "Logout"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              8), // Adjust the radius here
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    // Future.delayed(Duration.zero, () {
    //   popupLogoutConfirmation(context);
    // });
    _pageController = PageController();

    _pages.addAll([
      HomePage(
          user: widget.user,
          activatePopUp: activatePopUp,
          deactivatePopUp: deactivatePopUp),
      const Center(child: Text("Schedule Page")),
      ProfilePage(
        user: widget.user,
        showPopup: showPopup,
        activatePopUp: activatePopUp,
        deactivatePopUp: deactivatePopUp,
        popupLogoutConfirmation: () {
          popupLogoutConfirmation(context);
        },
      ),
    ]);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNavigationItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  void activatePopUp() {
    setState(() {
      showPopup = true;
    });
  }

  void deactivatePopUp() {
    setState(() {
      showPopup = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            physics:
                const NeverScrollableScrollPhysics(), // Disable swipe gestures if you want manual navigation only
            children: _pages,
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              height: navigationHeight,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: NavigationBar(
                currentIndex: _currentIndex,
                menuItems: [
                  {'key': 0, 'icon': const Icon(Icons.home), 'text': 'Beranda'},
                  {
                    'key': 1,
                    'icon': const Icon(Icons.notification_add_outlined),
                    'text': 'Schedule',
                  },
                  {
                    'key': 2,
                    'icon': const Icon(Icons.account_circle_outlined),
                    'text': 'Profil',
                  },
                ],
                onItemSelected: _onNavigationItemTapped,
              ),
            ),
          ),
          // Positioned(
          //   top: 0,
          //   left: 0,
          //   child: StdText(text: "tes for positioned"),
          // ),
          PopUp(
            show: showPopup,
            child: Center(child: popupChild),
          )
        ],
      ),
    );
  }
}

class NavigationBar extends StatelessWidget {
  final int currentIndex;
  final List<Map<String, dynamic>> menuItems;
  final Function(int) onItemSelected;

  const NavigationBar({
    Key? key,
    required this.currentIndex,
    required this.menuItems,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: menuItems.map((menuItem) {
          return NavIcon(
            icon: menuItem['icon'],
            text: menuItem['text'],
            isSelected: menuItem['key'] == currentIndex,
            onPressed: () => onItemSelected(menuItem['key']),
          );
        }).toList(),
      ),
    );
  }
}

class NavIcon extends StatelessWidget {
  const NavIcon({
    Key? key,
    required this.icon,
    this.size = 30,
    this.text = '',
    required this.isSelected,
    required this.onPressed,
  }) : super(key: key);

  final Widget icon;
  final double size;
  final String text;
  final bool isSelected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(0),
          decoration: BoxDecoration(
            gradient: isSelected
                ? LinearGradient(
                    colors: [
                      AppColors.primaryGreenLight.withOpacity(0.8),
                      AppColors.primaryGreenDark.withOpacity(0.8)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null, // If not selected, no gradient
            borderRadius: BorderRadius.circular(
                50), // Add border radius for a rounded button if needed
          ),
          child: IconButton(
            onPressed: onPressed,
            icon: icon,
            color: isSelected
                ? Colors.white
                : Colors
                    .grey, // Icon color (white for selected, grey for not selected)
          ),
        ),
        Text(
          text,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 12,
            color: isSelected ? AppColors.primaryGreenDark : Colors.grey,
          ),
        ),
      ],
    );
  }
}
