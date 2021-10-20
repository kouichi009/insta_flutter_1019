import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:instagram_flutter02/screens/home_screen.dart';
// import 'package:firebase_auth/firebase_auth.dart' hide UserCredential;

class PostService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // static final FirebaseMessaging _messaging = FirebaseMessaging();

  static Future<void> signUpUser(
      BuildContext context, String name, String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      User? signedInUser = userCredential.user;
      String uid = signedInUser!.uid;

      _firestore.collection('/users').doc(uid).set({
        'name': name,
        'email': email,
        'profileImageUrl':
            'https://applimura.com/wp-content/uploads/2019/08/twittericon13.jpg',
        'timestamp': timestamp,
        'gender': 'man',
        'dateOfBirth': '1988年9月8日',
        'uid': uid
      });
      // Navigator.pop(context);
      print('auth success22 $uid');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  static Future<void> loginUser(String email, String password) async {
    try {
      print('login user@@@@@@@ $email $password');
      await _auth.signInWithEmailAndPassword(
          email: '2@gmail.com', password: '123456');
      print("login success@@@@@@@");
    } on PlatformException catch (err) {
      throw (err);
    }
  }
}
