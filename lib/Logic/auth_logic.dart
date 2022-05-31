import 'dart:async';
import 'dart:core';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_chat_types/flutter_chat_types.dart';
// import 'package:flutter_chat_types/flutter_chat_types.dart';
// import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:real_chat/Logic/storage.dart';
import 'package:real_chat/utils/models.dart'as model;

class AuthLogics {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  // get user details
  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot documentSnapshot =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(documentSnapshot);
  }

  //Sign up Users
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = "Some error Occurred";
    try {
      if (email.isNotEmpty ||
              password.isNotEmpty ||
              username.isNotEmpty ||
              bio.isNotEmpty ||
              file != null
          // file != null
          ) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        print(cred.user!.uid);

        String photoUrl = await StorageMethods()
            .uploadImageToStorage('ProfilePic', file, false);

        await _firestore.collection('users').doc(cred.user!.uid).set({
          'username': username,
          'uid': cred.user!.uid,
          'photoUrl': photoUrl,
          " email": email,
          "  bio": bio,
          " followers": [],
          " following": [],
        });

        res = 'Success';
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'Invalid Email') {
        res = 'Email is Formatted';
      } else if (error.code == 'Weak Password') {
        res = 'Your password Is Should Be Atleast 6 Characters';
      }
    } catch (error) {
      res = error.toString();
    }
    return res;
  }

  //Check users Email Logging And Passwords
  //source of Authentication
  // file Logic
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error occurred";

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "Success";
      } else {
        res = "All fields Are Required";
      }
    } catch (error) {
      res = error.toString();
    }
    return res;
  }
}
