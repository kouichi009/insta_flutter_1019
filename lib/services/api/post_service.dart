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

  static Future<void> likePost(String? currentUid, Post? post) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    DocumentSnapshot doc = await postsRef.doc(post?.id).get();
    int likeCount = doc['likeCount'];
    batch.update(postsRef.doc(post?.id), {
      'likeCount': likeCount + 1,
      'likes.${currentUid}': true,
    });

    batch.set(usersRef.doc(currentUid).collection('likedPosts').doc(post?.id), {
      'postId': post?.id,
      'isLiked': true,
      'timestamp': timestamp,
      'uid': post?.uid
    });

    await batch.commit();
  }

  static Future<void> unLikePost(String? currentUid, Post? post) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    DocumentSnapshot doc = await postsRef.doc(post?.id).get();
    int likeCount = doc['likeCount'];
    batch.update(postsRef.doc(post?.id), {
      'likeCount': likeCount - 1,
      'likes.${currentUid}': false,
    });

    batch.update(
        usersRef.doc(currentUid).collection('likedPosts').doc(post?.id), {
      'isLiked': false,
      'timestamp': timestamp,
    });

    await batch.commit();
  }

  static Future<Map> getLatestPost(post) async {
    List futureDocs = await Future.wait([
      postsRef.doc(post.id).get(),
      usersRef.doc(post.uid).get(),
    ]);

    final latestPostDoc = futureDocs[0];
    final latestUserModelDoc = futureDocs[1];

    Post latestPost = Post.fromDoc(latestPostDoc);
    UserModel latestUserModel = UserModel.fromDoc(latestUserModelDoc);

    return {'latestPost': latestPost, 'latestUserModel': latestUserModel};
  }
}
