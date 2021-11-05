import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String? id;
  final String? caption;
  final String? photoUrl;
  final String? uid;
  final Map? likes;
  final int? likeCount;
  final Timestamp? timestamp;
  final int? status;
  bool? isLiked;
  bool? isReadMore;
  bool? isShowHeart;

  Post(
      {this.id,
      this.caption,
      this.photoUrl,
      this.uid,
      this.likes,
      this.likeCount,
      this.timestamp,
      this.status,
      this.isLiked,
      this.isReadMore,
      this.isShowHeart});

  Post.inital()
      : id = '',
        caption = '',
        photoUrl = '',
        uid = '',
        likes = {},
        likeCount = 0,
        timestamp = null,
        status = 1,
        isLiked = false,
        isReadMore = false,
        isShowHeart = false;

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

  Post copyWith(
      {String? id,
      String? caption,
      String? photoUrl,
      String? uid,
      Map? likes,
      int? likeCount,
      Timestamp? timestamp,
      int? status,
      bool? isLiked,
      bool? isReadMore,
      bool? isShowHeart}) {
    return Post(
      id: id ?? this.id,
      caption: caption ?? this.caption,
      photoUrl: photoUrl ?? this.photoUrl,
      uid: uid ?? this.uid,
      likes: likes ?? this.likes,
      likeCount: likeCount ?? this.likeCount,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
      isLiked: isLiked ?? this.isLiked,
      isReadMore: isReadMore ?? this.isReadMore,
      isShowHeart: isShowHeart ?? this.isShowHeart,
    );
  }

  Post copyPostWith({Post? post}) {
    return Post(
      id: post?.id ?? this.id,
      caption: post?.caption ?? this.caption,
      photoUrl: post?.photoUrl ?? this.photoUrl,
      uid: post?.uid ?? this.uid,
      likes: post?.likes ?? this.likes,
      likeCount: post?.likeCount ?? this.likeCount,
      timestamp: post?.timestamp ?? this.timestamp,
      status: post?.status ?? this.status,
      isLiked: post?.isLiked ?? this.isLiked,
      isReadMore: post?.isReadMore ?? this.isReadMore,
      isShowHeart: post?.isShowHeart ?? this.isShowHeart,
    );
  }
}
