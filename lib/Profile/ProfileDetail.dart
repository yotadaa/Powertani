import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:powertani/components/ImagePickerDisplay.dart';
import 'package:powertani/components/Text.dart';
import 'package:powertani/env.dart';
import 'package:powertani/file_function.dart';
import 'package:powertani/firebase_function.dart';

class ProfileDetail extends StatefulWidget {
  ProfileDetail({super.key, required this.user});

  Map<dynamic, dynamic> user;

  @override
  State<ProfileDetail> createState() => _ProfileDetailState();
}

class _ProfileDetailState extends State<ProfileDetail> {
  late TextEditingController usernameController = TextEditingController();
  late TextEditingController emailController = TextEditingController();

  bool isSubmitting = false;
  File? _imageFile;
  File? image;
  final picker = ImagePicker();
  String imgUrl = "";
  bool canEdit = false;

  Future<void> _pickImage() async {
    try {
      final _imageFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (_imageFile == null) return;
      final imageTemp = File(_imageFile.path);
      setState(() => this._imageFile = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future<void> submitForm() async {
    // Make sure the newUser is a copy of the original to avoid mutation issues
    Map<dynamic, dynamic> newUser = widget.user;

    // Set the displayName, fallback to user data if text is empty
    String displayName = usernameController.text.isNotEmpty
        ? usernameController.text
        : (widget.user['displayName'] ?? widget.user['name']);
    newUser['displayName'] = displayName;
    newUser['name'] = displayName;

    // Start submitting (disable UI or show loading state)
    setState(() {
      isSubmitting = true;
    });

    try {
      // Check if _imageFile is not null before updating with the image
      if (_imageFile != null) {
        // Pass the image file if it's selected
        // File? imageCompressed = await compressImage(_imageFile!);
        widget.user = await updateUser(newUser, _imageFile);
      } else {
        // If no image is selected, update without the image
        widget.user =
            await updateUser(newUser, null); // Pass null if there's no image
      }
    } catch (e) {
      // Error handling: print and/or show a user-friendly error
      print("[Outter] Error updating user data: $e");
      // Optionally show an alert dialog here
    } finally {
      // End submitting (reenable UI or hide loading state)
      setState(() {
        isSubmitting = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // Set default values if needed, for example:
    usernameController.text = widget.user['name'] ??
        widget.user['username'] ??
        widget.user['displayName'];
    emailController.text = widget.user['email'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.only(),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              // Profile Image and Name Section
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                width: MediaQuery.of(context).size.width,
                height: 190,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(60),
                    bottomRight: Radius.circular(60),
                  ),
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryGreenDark,
                      AppColors.primaryGreenLight
                    ],
                  ),
                ),
                child: const Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: const StdText(
                              text: "Profil",
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Profile Detail Section wrapped in Positioned
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 90),
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Stack(
                                  children: [
                                    Column(
                                      children: [
                                        CircleAvatar(
                                            radius: 50,
                                            backgroundColor: Colors.grey[
                                                200], // Optional, for fallback background color
                                            child: (_imageFile != null &&
                                                    widget.user != "")
                                                ? ImagePickerDisplay(
                                                    imageFile: _imageFile,
                                                    imgUrl: imgUrl,
                                                    size: 90,
                                                    borderRadius: 100,
                                                  )
                                                : (widget.user['profile_picture'] ==
                                                            null ||
                                                        widget.user[
                                                                'profile_picture'] ==
                                                            ""
                                                    ? Image.asset(
                                                        'assets/images/logo.png',
                                                        width: 90,
                                                        height: 90,
                                                        fit: BoxFit.cover,
                                                      )
                                                    : ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(100),
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl: widget.user[
                                                              'profile_picture']!,
                                                          width: 90,
                                                          height: 90,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ))
                                            // (widget.user[
                                            //                 'profile_picture'] !=
                                            //             null &&
                                            //         widget.user[
                                            //                 'profile_picture'] !=
                                            //             "")
                                            //     ? ((widget.user['profile_picture']!
                                            //                 .contains(
                                            //                     "https://") ||
                                            //             (widget.user[
                                            //                         'profile_picture']
                                            //                     .contains(
                                            //                         "http://") ||
                                            //                 (widget.user[
                                            //                         'profile_picture']
                                            //                     .contains(
                                            //                         "gs://")))
                                            //         ? CachedNetworkImage(
                                            //             imageUrl: widget.user[
                                            //                 'profile_picture']!,
                                            //             width: 80,
                                            //             height: 80,
                                            //             fit: BoxFit.cover,
                                            //           )
                                            //         : Image.asset(
                                            //             widget.user[
                                            //                 'profile_picture'],
                                            //             width: 80,
                                            //             height: 80,
                                            //             fit: BoxFit.cover,
                                            //           )))
                                            //     : (_imageFile != null
                                            //         ? ImagePickerDisplay(
                                            //             imageFile: _imageFile,
                                            //             imgUrl: imgUrl,
                                            //             size: 90,
                                            //             borderRadius: 100,
                                            //           )
                                            //         : Image.asset(
                                            //             'assets/images/logo.png',
                                            //             width: 90,
                                            //             height: 90,
                                            //             fit: BoxFit.cover,
                                            //           )),
                                            ),
                                      ],
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: Container(
                                        alignment: Alignment.center,
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(colors: [
                                              AppColors.primaryGreenDark,
                                              AppColors.primaryGreenLight
                                            ]),
                                            borderRadius:
                                                BorderRadius.circular(100)),
                                        child: Center(
                                          child: IconButton(
                                              color: Colors.white,
                                              onPressed: _pickImage,
                                              icon: Icon(Icons.edit)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                GestureDetector(
                                  onTap: () {
                                    print(widget.user);
                                  },
                                  child: StdText(
                                    text: widget.user['displayName'] ??
                                        widget.user['name'] ??
                                        "John Doe", // Display username or real name
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Username Field
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width -
                                        60, // Adjust width
                                    child: TextFormField(
                                      enabled: canEdit,
                                      controller: usernameController,
                                      decoration: InputDecoration(
                                        labelText: 'Username',
                                        // border: OutlineInputBorder(
                                        //     borderRadius: BorderRadius.circular(25)),
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Username cannot be empty';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(colors: [
                                      AppColors.primaryGreenDark,
                                      AppColors.primaryGreenLight
                                    ]),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Center(
                                  child: IconButton(
                                      iconSize: 15,
                                      color: Colors.white,
                                      onPressed: () {
                                        setState(() {
                                          canEdit = !canEdit;
                                        });
                                      },
                                      icon: Icon(Icons.edit)),
                                ),
                              ),
                            ],
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width -
                                  60, // Adjust width
                              child: TextFormField(
                                controller: emailController,
                                enabled: false, // Disable the input field
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  // border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Email cannot be empty';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),

                          SizedBox(
                            height: 20,
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 0.0),
                            child: Container(
                              padding: EdgeInsets.all(0),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: LinearGradient(
                                  colors: isSubmitting
                                      ? [
                                          AppColors.disabled,
                                          AppColors.disabled,
                                        ]
                                      : [
                                          AppColors.primaryGreenDark,
                                          AppColors.primaryGreenLight,
                                        ],
                                ),
                              ),
                              child: TextButton(
                                onPressed: isSubmitting
                                    ? null // Disable the button when submitting
                                    : () async {
                                        if (!isSubmitting) await submitForm();
                                      },
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  overlayColor: MaterialStateProperty.all(
                                    Colors.white.withOpacity(0.1),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const StdText(
                                      text: 'Save Changes',
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    const SizedBox(
                                        width:
                                            10), // Space between text and loading spinner
                                    if (isSubmitting)
                                      const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Back Button Positioned at top left
              Positioned(
                top: 0,
                left: 0,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
