import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String? id;
  final String? caption;
  final String? photoUrl;
  final String? uid;
  final Map<String, dynamic>? likes;
  final int? likeCount;
  final Timestamp? timestamp;
  final int? status;
  bool? isLiked;

  Post({
    this.id,
    this.caption,
    this.photoUrl,
    this.uid,
    this.likes,
    this.likeCount,
    this.timestamp,
    this.status,
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
      status: doc['status'],
    );
  }
}
