import 'package:flutter/material.dart';
import 'package:instagram_flutter02/services/api/post_service.dart';
import 'package:instagram_flutter02/view_models/post_view_model.dart';
import 'package:instagram_flutter02/view_models/user_model_view_model.dart';

class UserModelListViewModel extends ChangeNotifier {
  List<UserModelViewModel>? userModels;

  // Future<void> queryUsers({documentLimit, lastDocument, hasMore}) async {
  //   // _lastDocument = lastDocument;
  //   final values = await PostService.queryTimeline(
  //       documentLimit, lastDocument, hasMore);
  //   print(values);
  //   lastDocument = values['lastDocument'];
  //   posts = [...posts!, ...values['posts']];
  //   _userModels = [..._userModels, ...values['userModels']];
  //   _hasMore = values['hasMore'];
  //   // 'userModels': userModels,
  //   // 'hasMore': hasMore,
  //   // 'lastDocument': lastDocument,
  //   print('getQueryTimeline()@@@@@@@@@@@@@@@@@@: ${_posts.length}');
  //   for (var i = 0; i < _posts.length; i++) {
  //     bool? isLiked = _posts[i].isLiked;
  //     Map? likes = _posts[i].likes;
  //     String? id = _posts[i].id;
  //     bool? isReadMore = _posts[i].isReadMore;
  //     print('${i}番目: $isLiked, $likes, $id, $isReadMore');
  //     // if (post.id == widget.posts![i].id) {
  //     //   widget.posts!.removeAt(i);
  //     // }
  //   }
  //   notifyListeners();
  // }

  // queryUserPosts(uid) async {
  //   List<Post> posts = await PostService.queryUserPosts(uid);
  //   _posts = posts;
  //   _postType = MYPOSTS;
  //   notifyListeners();
  // }

  // queryLikedPosts(uid) async {
  //   List<Post> posts = await PostService.queryLikedPosts(uid);
  //   _posts = posts;
  //   _postType = FAV;
  //   notifyListeners();
  // }
}
