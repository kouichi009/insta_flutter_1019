import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_flutter02/models/post.dart';
import 'package:instagram_flutter02/models/user_model.dart';

class TimelineData {
  final List<Post>? posts;
  final List<UserModel>? userModels;
  final DocumentSnapshot? lastDocument;
  final int? documentLimit;
  final bool? hasMore;

  TimelineData(
      {this.posts,
      this.userModels,
      this.lastDocument,
      this.documentLimit,
      this.hasMore});

  TimelineData.inital()
      : posts = [],
        userModels = [],
        lastDocument = null,
        documentLimit = 2,
        hasMore = true;

  TimelineData copyWith(
      {List<Post>? posts,
      List<UserModel>? userModels,
      DocumentSnapshot? lastDocument,
      int? documentLimit,
      bool? hasMore}) {
    return TimelineData(
        posts: posts ?? this.posts,
        userModels: userModels ?? this.userModels,
        lastDocument: lastDocument ?? this.lastDocument,
        documentLimit: documentLimit ?? this.documentLimit);
  }
}
