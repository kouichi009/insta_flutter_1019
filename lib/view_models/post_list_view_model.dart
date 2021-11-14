import 'package:flutter/material.dart';
import 'package:instagram_flutter02/models/post.dart';
import 'package:instagram_flutter02/services/api/post_service.dart';
import 'package:instagram_flutter02/view_models/post_view_model.dart';
import 'package:instagram_flutter02/view_models/user_model_view_model.dart';

class PostListViewModel extends ChangeNotifier {
  List<PostViewModel>? posts;
  List<UserModelViewModel>? userModels;

  Future<void> queryTimeline({documentLimit, lastDocument, hasMore}) async {
    // _lastDocument = lastDocument;
    final values =
        await PostService.queryTimeline(documentLimit, lastDocument, hasMore);
    print(values);
    lastDocument = values['lastDocument'];
    posts = [...posts!, ...values['posts']];
    userModels = [...userModels!, ...values['userModels']];
    hasMore = values['hasMore'];
    print('getQueryTimeline()@@@@@@@@@@@@@@@@@@: ${posts?.length}');
    // for (var i = 0; i < _posts.length; i++) {
    //   bool? isLiked = _posts[i].isLiked;
    //   Map? likes = _posts[i].likes;
    //   String? id = _posts[i].id;
    //   bool? isReadMore = _posts[i].isReadMore;
    //   print('${i}番目: $isLiked, $likes, $id, $isReadMore');
    //   // if (post.id == widget.posts![i].id) {
    //   //   widget.posts!.removeAt(i);
    //   // }
    // }
    notifyListeners();
  }

  queryUserPosts(uid) async {
    List<Post>? _posts = await PostService.queryUserPosts(uid);
    posts = _posts;
    // _postType = MYPOSTS;
    notifyListeners();
  }

  queryLikedPosts(uid) async {
    List<Post> posts = await PostService.queryLikedPosts(uid);
    posts = posts;
    // _postType = FAV;
    notifyListeners();
  }
}
