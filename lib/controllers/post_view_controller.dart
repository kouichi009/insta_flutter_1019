import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagram_flutter02/models/controller_datas/post_view_data.dart';
import 'package:instagram_flutter02/models/post.dart';
import 'package:instagram_flutter02/screens/profile_screen.dart';
import 'package:instagram_flutter02/services/api/post_service.dart';

class PostViewController extends StateNotifier<Post> {
  PostViewController([Post? state]) : super(state ?? Post.inital()) {
    // getMovies();
  }

  Future<void> handleLikePost(
      {String? clickType, String? currentUid, Post? post}) async {
    try {
      // if (state.isPushingLike == false) {
      // state = state.copyWith(isPushingLike: true);
      // if (state.isLiked! && clickType == 'single') {
      //   await PostService.unLikePost(currentUid, post);
      //   state = state.copyWith(likeCount: state.likeCount! - 1, isLiked: false);
      // } else if (!state.isLiked!) {
      //   await PostService.likePost(currentUid, post);
      //   state = state.copyWith(likeCount: state.likeCount! + 1, isLiked: true);
      //   if (clickType == 'double') {
      //     // state = state.copyWith(showHeart: true);
      //     Timer(Duration(milliseconds: 500), () {
      //       // state = state.copyWith(showHeart: false);
      //     });
      //   }
      // }
      // state = state.copyWith(isPushingLike: false);
      // }
    } catch (e) {
      print(e);
    }
  }

  readMoreLess() {
    print(state.isReadMore);
    state = state.copyWith(isReadMore: !state.isReadMore!);
    print(state.isLiked);
    print(state.isReadMore);

    // setState(() {
    //   isReadMore = !isReadMore;
    // });
  }

  goToProfilePage({BuildContext? context, String? uid}) {
    Navigator.push(
      context!,
      MaterialPageRoute(builder: (context) => ProfileScreen(uid: uid)),
    );
  }
}
