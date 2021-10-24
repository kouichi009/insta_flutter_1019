import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:instagram_flutter02/models/post.dart';
import 'package:instagram_flutter02/models/user_model.dart';
import 'package:instagram_flutter02/screens/home_screen.dart';
import 'package:instagram_flutter02/utilities/constants.dart';
// import 'package:firebase_auth/firebase_auth.dart' hide UserCredential;

class PostService {
  // static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // static final FirebaseMessaging _messaging = FirebaseMessaging();

  static Future<dynamic /*List<Post>, String*/ > queryTimeline(
      documentLimit, lastDocument, hasMore) async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    List<Post> posts = [];
    List<UserModel> userModels = [];
    QuerySnapshot querySnapshot;
    if (lastDocument == null) {
      querySnapshot = await _firestore
          .collection('posts')
          .orderBy('timestamp')
          .limit(documentLimit)
          .get();
    } else {
      querySnapshot = await _firestore
          .collection('posts')
          .orderBy('timestamp')
          .startAfterDocument(lastDocument!)
          .limit(documentLimit)
          .get();
      print(1);
    }
    if (querySnapshot.docs.length < documentLimit) {
      hasMore = false;
    }
    lastDocument = querySnapshot.docs[querySnapshot.docs.length - 1];
    await Future.wait(querySnapshot.docs.map((doc) async {
      Post post = Post.fromDoc(doc);
      print('aaaaaaaaaaaaggggggg $doc');
      String postUid = doc['uid'];
      print('postUid: $postUid');
      DocumentSnapshot documentSnapshot = await usersRef.doc(postUid).get();
      UserModel userModel = UserModel.fromDoc(documentSnapshot);
      posts.add(post);
      userModels.add(userModel);
    }));
    // _posts.addAll(querySnapshot.docs.map((doc) => Post.fromDoc(doc)).toList());
    ////////////////////////////////////////////////////////////
    print('finish');
    return {
      'posts': posts,
      'userModels': userModels,
      'hasMore': hasMore,
      'lastDocument': lastDocument,
    };
  }

  static Future<List<Post>> queryMyPosts(currentUid) async {
    QuerySnapshot snapshot = await postsRef
        .where("uid", isEqualTo: currentUid)
        .orderBy("timestamp", descending: true)
        .get();

    List<Post> posts = snapshot.docs.map((doc) => Post.fromDoc(doc)).toList();
    return posts;
  }

  static Future<List<Post>> queryLikedPosts(currentUid) async {
    List<Post> posts = [];
    QuerySnapshot snapshot = await usersRef
        .doc(currentUid)
        .collection('likedPosts')
        .where("isLiked", isEqualTo: true)
        .orderBy("timestamp", descending: true)
        .get();
    print('snap@@@@@@@: $snapshot ${snapshot.size} ${snapshot.docs}');
    await Future.wait(snapshot.docs.map((doc) async {
      print('aaaaaaaaaaaaggggggg $doc');
      String postId = doc['postId'];
      print('postID: $postId');
      DocumentSnapshot documentSnapshot = await postsRef.doc(postId).get();
      Post post = Post.fromDoc(documentSnapshot);
      posts.add(post);
    }));
    print('finish');
    return posts;
  }

  // static Future<void> signUpUser(
  //     BuildContext context, String name, String email, String password) async {
  //   try {
  //     UserCredential userCredential = await FirebaseAuth.instance
  //         .createUserWithEmailAndPassword(email: email, password: password);
  //     User? signedInUser = userCredential.user;
  //     String uid = signedInUser!.uid;

  //     _firestore.collection('/users').doc(uid).set({
  //       'name': name,
  //       'email': email,
  //       'profileImageUrl':
  //           'https://applimura.com/wp-content/uploads/2019/08/twittericon13.jpg',
  //       'timestamp': timestamp,
  //       'gender': 'man',
  //       'dateOfBirth': '1988年9月8日',
  //       'uid': uid
  //     });
  //     // Navigator.pop(context);
  //     print('auth success22 $uid');
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'weak-password') {
  //       print('The password provided is too weak.');
  //     } else if (e.code == 'email-already-in-use') {
  //       print('The account already exists for that email.');
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  // static Future<void> loginUser(String email, String password) async {
  //   try {
  //     print('login user@@@@@@@ $email $password');
  //     await _auth.signInWithEmailAndPassword(
  //         email: '2@gmail.com', password: '123456');
  //     print("login success@@@@@@@");
  //   } on PlatformException catch (err) {
  //     throw (err);
  //   }
  // }
}
