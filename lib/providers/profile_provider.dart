import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter02/models/post.dart';
import 'package:instagram_flutter02/models/user_model.dart';
import 'package:instagram_flutter02/services/api/post_service.dart';
import 'package:instagram_flutter02/utilities/constants.dart';
import 'package:provider/provider.dart';

class ProfileProvider extends ChangeNotifier {
  List<Post>? _posts;
  String? _postType;
  List<Post>? get posts => _posts;
  String? get postType => _postType;

  void init(context) async {}

  queryUserPosts(uid) async {
    List<Post> posts = await PostService.queryUserPosts(uid);
    _posts = posts;
    _postType = MYPOSTS;
    notifyListeners();
  }

  queryLikedPosts(uid) async {
    List<Post> posts = await PostService.queryLikedPosts(uid);
    _posts = posts;
    _postType = FAV;
    notifyListeners();
  }

  updatePost({int? index, Map<String, dynamic>? likes, int? likeCount}) {
    if (_posts == null) return;
    print(_posts);
    print(_posts?.length);
    print(_posts?[index!]);
    print(_posts?[index!].isReadMore);
    if (likes != null) posts![index!].likes = likes;
    if (likeCount != null) posts![index!].likeCount = likeCount;
  }

  deletePost({int? index}) {
    print(_posts?.length);
    _posts?.removeAt(index!);
    print(_posts?.length);
    notifyListeners();
  }
}
