import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:powertani/Notification/NotificationService.dart';
import 'package:powertani/components/ProfileContainer.dart';
import 'package:powertani/env.dart';
import 'package:shimmer/shimmer.dart';

class HeaderApp extends StatefulWidget {
  final Map<String, dynamic> user;
  HeaderApp({Key? key, required this.user}) : super(key: key);

  @override
  State<HeaderApp> createState() => _HeaderAppState();
}

class _HeaderAppState extends State<HeaderApp> {
  final double profileSize = 50;
  bool notificationState = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(25),
      // height: 250,
      alignment: AlignmentDirectional.topStart,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryGreenDark.withOpacity(1),
            AppColors.primaryGreenLight.withOpacity(1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ), // Add rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // Shadow color
            spreadRadius: 1,
            blurRadius: 8,
            offset: Offset(0, -2), // Changes the shadow position
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment:
                CrossAxisAlignment.center, // Align icon and text vertically
            children: [
              CircleAvatar(
                radius: 25, // Adjust the size of the profile picture
                backgroundColor:
                    Colors.grey[200], // Placeholder background color
                child: Profilecontainer(
                    profilePicture: widget.user['profile_picture']),
              ),
              const SizedBox(width: 8), // Space between icon and text
              Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Align text to the start
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Hai, ",
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    (widget.user['displayName']?.split(' ').first ??
                            widget.user['name']?.split(' ').first) ??
                        "username",
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const Spacer(), // Pushes the bell icon to the right
              Stack(
                children: [
                  IconButton(
                    icon: Icon(Icons.notifications, color: Colors.white),
                    onPressed: () async {
                      await NotificationService().showNotification(
                        id: 1,
                        title: "Test Notification",
                        body: "This is a test notification.",
                      );
                      setState(() {
                        notificationState = !notificationState;
                      });
                    },
                  ), // Show badge if there are notifications
                  Positioned(
                    right: 12,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4), // Badge padding
                      decoration: BoxDecoration(
                        color: notificationState
                            ? Colors.red
                            : Colors.grey, // Badge color
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 12,
                        minHeight: 16, // Minimum size for the badge
                      ),
                      child: Text(
                        '', // Notification count
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10, // Font size for the badge text
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
