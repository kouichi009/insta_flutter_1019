import 'package:flutter/material.dart';
import 'package:instagram_flutter02/models/post.dart';
import 'package:instagram_flutter02/models/user_model.dart';
import 'package:instagram_flutter02/services/api/post_service.dart';

class TimelineProvider with ChangeNotifier {
  dynamic? _lastDocument = null;

  // dynamic get lastDocument => _lastDocument;

  int _documentLimit = 2;
  bool _hasMore = true;
  List<Post> _posts = [];
  List<UserModel> _userModels = [];

  bool get hasMore => _hasMore;
  List<Post> get posts => _posts;
  List<UserModel> get userModels => _userModels;

  void init() {
    getQueryTimeline();
    // Map<String, dynamic> values = await PostService.queryTimeline(
    //     _documentLimit, _lastDocument, _hasMore);
    // _lastDocument = values['lastDocument'];
    // _posts = [..._posts, ...values['posts']];
    // _userModels = [..._userModels, ...values['userModels']];
    // _hasMore = values['hasMore'];
    // // 'userModels': userModels,
    // // 'hasMore': hasMore,
    // // 'lastDocument': lastDocument,
    // notifyListeners();
  }

  void getQueryTimeline() async {
    // _lastDocument = lastDocument;
    final values = await PostService.queryTimeline(
        _documentLimit, _lastDocument, _hasMore);
    print(values);
    _lastDocument = values['lastDocument'];
    _posts = [..._posts, ...values['posts']];
    _userModels = [..._userModels, ...values['userModels']];
    _hasMore = values['hasMore'];
    // 'userModels': userModels,
    // 'hasMore': hasMore,
    // 'lastDocument': lastDocument,
    print('getQueryTimeline()@@@@@@@@@@@@@@@@@@: ${_posts.length}');
    for (var i = 0; i < _posts.length; i++) {
      bool? isLiked = _posts[i].isLiked;
      Map? likes = _posts[i].likes;
      String? id = _posts[i].id;
      bool? isReadMore = _posts[i].isReadMore;
      print('${i}番目: $isLiked, $likes, $id, $isReadMore');
      // if (post.id == widget.posts![i].id) {
      //   widget.posts!.removeAt(i);
      // }
    }
    notifyListeners();
  }

  updatePost(
      {int? index,
      bool? isReadMore,
      Map<String, dynamic>? likes,
      int? likeCount}) {
    print(posts.length);
    print(posts[index!]);
    print(posts[index].isReadMore);
    if (isReadMore != null) posts[index].isReadMore = isReadMore;
    if (likes != null) posts[index].likes = likes;
    if (likeCount != null) posts[index].likeCount = likeCount;
    print(posts[index].isReadMore);
  }

  deletePost({int? index}) {
    print(posts.length);
    posts.removeAt(index!);
    print(posts.length);
  }
}
