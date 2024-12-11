import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:powertani/Auth/authentication.dart';
import 'package:powertani/Profile/ProfileDetail.dart';
import 'package:powertani/components/CustomContainer.dart';
import 'package:powertani/components/ProfileContainer.dart';
import 'package:powertani/components/Text.dart';
import 'package:powertani/components/auth.dart';
import 'package:powertani/env.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({
    super.key,
    required this.user,
    this.activatePopUp,
    this.deactivatePopUp,
    this.showPopup = false,
    required this.popupLogoutConfirmation,
  });
  bool showPopup;
  final VoidCallback? popupLogoutConfirmation;
  final VoidCallback? activatePopUp;
  final VoidCallback? deactivatePopUp;

  Map<dynamic, dynamic> user;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    AuthWrapper();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.user);
    return Container(
      // padding: EdgeInsets.symmetric(horizontal: 30),
      child: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryGreenDark,
                  AppColors.primaryGreenLight
                ],
              ),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                StdText(
                  text: "Profil",
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 21,
                ),
              ],
            ),
          ),
          Positioned(
            child: Padding(
              padding: const EdgeInsets.only(top: 100),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    ItemContainer(
                      height: 70,
                      image: widget.user['profile_picture'],
                      marginTop: 20,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          StdText(
                            // text: widget.user['profie_picture'],
                            // text: widget.user['profile_picture'],
                            text: widget.user['name'] ??
                                widget.user['displayName'] ??
                                'User',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow
                                .ellipsis, // Truncate the text with "..."
                            maxLines: 1, // Limit to a single line
                          ),
                          const SizedBox(height: 1),
                          StdText(
                            text: widget.user['email'],
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                            overflow: TextOverflow
                                .ellipsis, // Truncate the email if it's too long
                            maxLines: 1, // Limit to a single line
                          ),
                        ],
                      ),
                      onArrowClick: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfileDetail(
                                    user: widget.user,
                                  )),
                        );
                      },
                      onBodyClick: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfileDetail(
                                    user: widget.user,
                                  )),
                        );
                      },
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    ItemContainer(
                      withIcon: true, // Example image for menu
                      marginVertical: 5,
                      child: StdText(
                        text: 'Help Center',
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                      ),
                      onBodyClick: () {
                        print("Body Clicked!");
                      },
                      onArrowClick: () {
                        print("Arrow Clicked!");
                      },
                    ),
                    ItemContainer(
                      withIcon: true,
                      marginVertical: 5,
                      icon: Icons.notifications,
                      child: StdText(
                        text: 'Notification Settings',
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                      ),
                      onBodyClick: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Center(
                                child: StdText(text: 'Notification Settings')),
                          ),
                        );
                      },
                      onArrowClick: () {
                        print("Notification Arrow Clicked!");
                      },
                    ),
                    ItemContainer(
                      withIcon: true,
                      marginVertical: 5,
                      icon: Icons.description,
                      child: StdText(
                        text: 'Terms & Conditions',
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                      ),
                      onBodyClick: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Center(
                                child: StdText(text: 'Terms & Conditions')),
                          ),
                        );
                      },
                      onArrowClick: () {
                        print("Terms Arrow Clicked!");
                      },
                    ),
                    ItemContainer(
                      withIcon: true,
                      icon: Icons.lock,
                      marginVertical: 5,
                      child: StdText(
                        text: 'Privacy Policy',
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                      ),
                      onBodyClick: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                Center(child: StdText(text: 'Privacy Policy')),
                          ),
                        );
                      },
                      onArrowClick: () {
                        print("Privacy Arrow Clicked!");
                      },
                    ),
                    ItemContainer(
                        navigating: false,
                        withIcon: true,
                        marginVertical: 5,
                        icon: Icons.exit_to_app_outlined,
                        colors: [
                          Colors.red,
                          const Color.fromARGB(255, 233, 99, 89)
                        ],
                        child: StdText(
                          text: 'Logout',
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                        ),
                        onBodyClick: () => {
                              widget.showPopup
                                  ? widget.deactivatePopUp
                                  : widget.activatePopUp,
                              widget.popupLogoutConfirmation!(),
                            }),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ItemContainer extends StatelessWidget {
  final Widget child;
  final String? image;
  final double marginBottom, marginTop, marginVertical;
  final IconData? icon;
  final bool withIcon;
  final bool navigating;
  final List<Color> colors;
  final VoidCallback? onBodyClick;
  final VoidCallback? onArrowClick;
  final double height;

  ItemContainer({
    Key? key,
    this.image,
    this.child = const SizedBox.shrink(),
    this.marginTop = 0,
    this.marginBottom = 0,
    this.marginVertical = 0,
    this.withIcon = false,
    this.navigating = true,
    this.icon, // Icon parameter is now optional
    this.colors = const [
      AppColors.primaryGreenDark,
      AppColors.primaryGreenLight
    ],
    this.onArrowClick,
    this.onBodyClick,
    this.height = 60,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: marginVertical != 0 ? marginVertical : marginTop,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          height: height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
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
          child: GestureDetector(
            onTap: onBodyClick,
            child: Row(
              children: [
                // Display either an Image or Icon depending on the withIcon flag
                if (withIcon)
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: LinearGradient(
                        colors: colors.length > 1
                            ? colors
                            : [colors.first, colors.first],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Icon(
                      icon == null ? Icons.help : icon,
                      color: Colors.white,
                      size: 25,
                    ),
                  )
                else
                  CircleAvatar(
                    radius: 25, // Adjust the size of the profile picture
                    backgroundColor:
                        Colors.grey[200], // Placeholder background color
                    child: ClipOval(
                      child: Profilecontainer(profilePicture: image),
                    ),
                  ),
                const SizedBox(width: 10),
                // Username and Email Text
                Expanded(child: child),
                // Icon Button for navigation (if required)
                navigating
                    ? IconButton(
                        icon: const Icon(Icons.arrow_forward_ios,
                            size: 16, color: Colors.grey),
                        onPressed: onArrowClick,
                      )
                    : SizedBox.shrink(),
              ],
            ),
          ),
        ),
        SizedBox(
          height: marginVertical != 0 ? marginVertical : marginBottom,
        )
      ],
    );
  }
}
