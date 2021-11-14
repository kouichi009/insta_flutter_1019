import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter02/models/post.dart';

class PostViewModel {
  final Post? post;

  PostViewModel({this.post});

  String? get id {
    return post?.id;
  }

  String? get caption {
    return post?.caption;
  }

  String? get photoUrl {
    return post?.photoUrl;
  }

  String? get uid {
    return post?.uid;
  }

  Timestamp? get timestamp {
    return post?.timestamp;
  }

  int? get status {
    return post?.status;
  }

  Map<String, dynamic>? get likes {
    return post?.likes;
  }

  int? get likeCount {
    return post?.likeCount;
  }

  bool? get isLiked {
    return post?.isLiked;
  }

  bool? get isReadMore {
    return post?.isReadMore;
  }
}
