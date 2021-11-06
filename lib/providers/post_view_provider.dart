import 'dart:async';

import 'package:flutter/material.dart';
import 'package:instagram_flutter02/models/post.dart';
import 'package:instagram_flutter02/models/user_model.dart';
import 'package:instagram_flutter02/services/api/post_service.dart';

class PostViewProvider with ChangeNotifier {
  bool _isLiked = false;
  int _likeCount = 0;
  Map _likes = {};
  bool _showHeart = false;
  bool _isPushingLike = false;
  bool _isReadMore = false;
  String _loremIpsum =
      'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.';

  bool get isLiked => _isLiked;
  int get likeCount => _likeCount;
  bool get isReadMore => _isReadMore;

  void handleLikePost({type, currentUid, post}) async {
    // bool _isLiked = widget.post?.likes[widget.currentUid] == true;
    // if (isPushingLike == false) {
    //   isPushingLike = true;
    if (_isLiked && type == 'single') {
      await PostService.unLikePost(currentUid, post);
      _likeCount -= 1;
      _isLiked = false;
      // setState(() {
      //   _likeCount -= 1;
      //   _isLiked = false;
      //   // likes[widget.currentUid] = false;
      // });
      notifyListeners();
    } else if (!_isLiked) {
      await PostService.likePost(currentUid, post);
      // setState(() {
      _likeCount += 1;
      _isLiked = true;
      //   if (type == "double") {
      //     showHeart = true;
      //   }
      // });
      notifyListeners();
      if (type == "double") {
        Timer(Duration(milliseconds: 500), () {
          // setState(() {
          //   showHeart = false;
          // });
        });
      }
      // notifyListeners();
    }
    // isPushingLike = false;
    // }
  }

  void readMoreLess() {
    // setState(() {
    //   isReadMore = !isReadMore;
    // });
  }
}
