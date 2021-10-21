import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String id;
  final String caption;
  final String photoUrl;
  final String uid;
  final dynamic likes;
  final int likeCount;
  final Timestamp timestamp;

  Post({
    required this.id,
    required this.caption,
    required this.photoUrl,
    required this.uid,
    required this.likes,
    required this.likeCount,
    required this.timestamp,
  });

  factory Post.fromDoc(DocumentSnapshot doc) {
    return Post(
      id: doc['id'],
      caption: doc['caption'],
      photoUrl: doc['photoUrl'],
      uid: doc['uid'],
      likes: doc['likes'],
      likeCount: doc['likeCount'],
      timestamp: doc['timestamp'],
    );
  }
}
