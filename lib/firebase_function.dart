import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:powertani/file_function.dart';

Future<String?> _uploadFileToFirebase(
    String folderName, String name, File file) async {
  try {
    String fileName = "$folderName/$name";
    Reference storageReference = FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = storageReference.putFile(file);

    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  } catch (e) {
    print("Error uploading image: $e");
    return null;
  }
}

Future<Map<dynamic, dynamic>> updateUser(
    Map<dynamic, dynamic> user, File? imageFile) async {
  try {
    // Get the currently authenticated user (whether it's via email/password or Google)
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      print("No user is logged in.");
      return {}; // No user is logged in, handle this case
    }

    CollectionReference collection =
        FirebaseFirestore.instance.collection('users');

    // Fetch the user document by either UID or email
    var querySnapshot =
        await collection.where('email', isEqualTo: currentUser.email).get();

    if (querySnapshot.docs.isNotEmpty) {
      var existingDocument = querySnapshot.docs.first;
      String profilePicture = existingDocument["profile_picture"];

      // Only process the image if it's not null
      if (imageFile != null) {
        int fileName = DateTime.now().millisecondsSinceEpoch;
        final fileExtension = imageFile.path.split('.').last;

        // Check if the profile picture needs to be updated
        if (existingDocument['profile_picture'] != "") {
          // Delete the existing profile picture from Firebase Storage
          await deleteFileFromFirebaseWithUrl(
              existingDocument['profile_picture']);
        }

        // Upload the new profile picture to Firebase Storage
        profilePicture = (await _uploadFileToFirebase(
                "users", "$fileName.$fileExtension", imageFile)) ??
            existingDocument[""];
      }

      // Update Firestore with the new user data
      await collection.doc(existingDocument.id).update({
        'displayName': user['displayName'] ?? user['name'],
        'name': user['name'] ?? user['displayName'],
        'email': currentUser.email, // Ensure the email is up-to-date
        'profile_picture': profilePicture.isNotEmpty
            ? profilePicture
            : existingDocument['profile_picture'],
      });

      print("User data updated successfully");

      return {
        'displayName': user['displayName'] ?? user['name'],
        'name': user['name'] ?? user['displayName'],
        'email': currentUser.email, // Ensure the email is up-to-date
        'profile_picture':
            profilePicture ?? existingDocument['profile_picture'],
      };
    } else {
      print("User not found in Firestore.");
      return {};
    }
  } catch (e) {
    print("Error updating user data: $e");
    return {};
  }
}

Future<void> deleteFileFromFirebaseWithUrl(String url) async {
  try {
    if (url.isNotEmpty) {
      Reference storageReference = FirebaseStorage.instance.refFromURL(url);
      await storageReference.delete();
      print("Old file deleted from Firebase Storage.");
    }
  } catch (e) {
    print("Failed to delete old file: $e");
  }
}
