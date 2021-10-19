import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
// import 'package:firebase_auth/firebase_auth.dart' hide UserCredential;

class AuthService {
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

      _firestore.collection('/users').doc(signedInUser.uid).set({
        'name': name,
        'email': email,
        'profileImageUrl': '',
        'isVerified': false,
        'role': 'user',
        'timeCreated': Timestamp.now(),
      });
      Navigator.pop(context);
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

  // static Future<void> signUp(
  //     BuildContext context, String email, String password) async {
  //   try {
  //     userCredential userCredential = await _auth.createUserWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );
  //     FirebaseUser signedInUser = userCredential.user;
  //   } on PlatformException catch (err) {
  //     throw (err);
  //   }
  // }

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

  // static Future<void> removeToken() async {
  //   final currentUser = await _auth.currentUser();
  //   await usersRef
  //       .document(currentUser.uid)
  //       .setData({'token': ''}, merge: true);
  // }

  // static Future<void> updateToken() async {
  //   final currentUser = await _auth.currentUser();
  //   final token = await _messaging.getToken();
  //   final userDoc = await usersRef.document(currentUser.uid).get();
  //   if (userDoc.exists) {
  //     User user = User.fromDoc(userDoc);
  //     if (token != user.token) {
  //       usersRef
  //           .document(currentUser.uid)
  //           .setData({'token': token}, merge: true);
  //     }
  //   }
  // }

  // static Future<void> updateTokenWithUser(User user) async {
  //   final token = await _messaging.getToken();
  //   if (token != user.token) {
  //     await usersRef.document(user.id).updateData({'token': token});
  //   }
  // }

  // static Future<void> logout() async {
  //   await removeToken();
  //   Future.wait([
  //     _auth.signOut(),
  //   ]);
  // }
}
