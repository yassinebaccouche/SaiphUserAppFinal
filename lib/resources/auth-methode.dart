import 'dart:typed_data';

import 'package:saiphappfinal/resources/storage_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Models/user.dart' as model;

class AuthMethodes {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot documentSnapshot =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(documentSnapshot);
  }

  Future<String> SignUPUser({
    required String email,
    required String password,
    required String pseudo,
    required String Profession,
    required String phoneNumber,
    required String pharmacy,
    required String Datedenaissance,
    required Uint8List file,
    required String Verified,
    required String FullScore,
    required String PuzzleScore,
    required String CodeClient,
  }) async {
    String res = "some error occurred";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          pseudo.isNotEmpty ||
          Profession.isNotEmpty ||
          phoneNumber.isNotEmpty ||
          pharmacy.isNotEmpty ||
          Datedenaissance.isNotEmpty ||
          file != null) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        String photoUrl = await StorageMethods()
            .uploadImageToStorage('profilePics', file, false);

        //add user to database
        model.User user = model.User(
          lastLogin: DateUtils.dateOnly(DateTime.now()).millisecondsSinceEpoch,
          pseudo: pseudo,
          uid: cred.user!.uid,
          email: email,
          followers: [],
          following: [],
          photoUrl: photoUrl,
          pharmacy: pharmacy,
          phoneNumber: phoneNumber,
          Profession: Profession,
          Datedenaissance: Datedenaissance,
          Verified: Verified,
          FullScore: FullScore,
          PuzzleScore: PuzzleScore,
          CodeClient: CodeClient,
        );
        await _firestore
            .collection('users')
            .doc(cred.user!.uid)
            .set(user.toJson());

        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> updateUser({
    required String pseudo,
    required String Profession,
    required String phoneNumber,
    required String pharmacy,
    required String Datedenaissance,
    required Uint8List photoUrl,
    required String Verified,
    required String CodeClient,
    String? newEmail, // New email parameter
    String? newPassword, // New password parameter
  }) async {
    try {
      User? currentUser = _auth.currentUser;

      if (currentUser != null) {
        // Check if the file is not null
        if (photoUrl == null) {
          return "File is null";
        }

        // If a new email is provided, update the email in authentication
        if (newEmail != null && newEmail.isNotEmpty) {
          await currentUser.verifyBeforeUpdateEmail(newEmail);
        }

        // If a new password is provided, update the password
        if (newPassword != null && newPassword.isNotEmpty) {
          await currentUser.updatePassword(newPassword);
        }

        // Create a map with updated user data (excluding email and password)
        Map<String, dynamic> updatedUserData = {
          'lastLogin': DateUtils.dateOnly(DateTime.now()).millisecondsSinceEpoch,
          'pseudo': pseudo,
          'Profession': Profession,
          'phoneNumber': phoneNumber,
          'pharmacy': pharmacy,
          'Datedenaissance': Datedenaissance,
          'Verified': Verified,
          'CodeClient': CodeClient,
          'email': newEmail,
        };

        // Update the user's data in Firestore
        await _firestore
            .collection('users')
            .doc(currentUser.uid)
            .update(updatedUserData);

        return "success";
      } else {
        return "User not logged in";
      }
    } catch (err) {
      print("Error during user update: $err");
      return "Some error occurred";
    }
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        return "Please enter all the fields";
      }

      // Logging in user with email and password
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Retrieve user data from Firestore
      DocumentSnapshot userSnapshot = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      // Check if the account is deactivated
      if (userSnapshot.exists && userSnapshot['isDeactivated'] == true) {
        // If the account is deactivated, sign out the user and return an error message
        await _auth.signOut();
        return "Your account is deactivated. Please contact support for assistance.";
      } else {
        // If the account is not deactivated, return success
        return "success";
      }
    } catch (err) {
      print("Error during login: $err");
      return "An error occurred while logging in";
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<String> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return "Password reset email sent successfully";
    } catch (error) {
      print("Error sending reset password email: $error");
      return "Failed to send password reset email";
    }
  }

  Future<String> deactivateAccount() async {
    try {
      User? currentUser = _auth.currentUser;

      if (currentUser != null) {
        // Mark the user as deactivated in Firestore
        await _firestore.collection('users').doc(currentUser.uid).update({
          'isDeactivated': true,
        });

        // Sign out the user
        await _auth.signOut();

        return "Account deactivated successfully";
      } else {
        return "User not logged in";
      }
    } catch (err) {
      print("Error during account deactivation: $err");
      return "Failed to deactivate account";
    }
  }

  Future<String> updateLastLoginAndScore({
    required String score,
  }) async {
    try {
      User? currentUser = _auth.currentUser;

      if (currentUser != null) {

        // Create a map with updated user data (excluding email and password)
        Map<String, dynamic> updatedUserData = {
          'lastLogin': DateUtils.dateOnly(DateTime.now()).millisecondsSinceEpoch,
          'FullScore': score,

        };

        // Update the user's data in Firestore
        await _firestore
            .collection('users')
            .doc(currentUser.uid)
            .update(updatedUserData);

        return "success";
      } else {
        return "User not logged in";
      }
    } catch (err) {
      print("Error during user update: $err");
      return "Some error occurred";
    }
  }

}
