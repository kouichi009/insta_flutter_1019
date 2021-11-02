import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_flutter02/models/post.dart';
import 'package:instagram_flutter02/models/user_model.dart';

class PostViewData {
  final bool? isLiked;
  final int? likeCount;
  final bool? showHeart;
  final bool? isPushingLike;
  final bool? isReadMore;

  PostViewData(
      {this.isLiked,
      this.likeCount,
      this.showHeart,
      this.isPushingLike,
      this.isReadMore});

  PostViewData.inital()
      : isLiked = false,
        likeCount = 0,
        showHeart = false,
        isPushingLike = false,
        isReadMore = false;

  PostViewData copyWith(
      {bool? isLiked,
      int? likeCount,
      bool? showHeart,
      bool? isPushingLike,
      bool? isReadMore}) {
    return PostViewData(
      isLiked: isLiked ?? this.isLiked,
      likeCount: likeCount ?? this.likeCount,
      showHeart: showHeart ?? this.showHeart,
      isPushingLike: isPushingLike ?? this.isPushingLike,
      isReadMore: isReadMore ?? this.isReadMore,
    );
  }
}
