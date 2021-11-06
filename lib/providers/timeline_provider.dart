import 'package:flutter/material.dart';
import 'package:instagram_flutter02/models/post.dart';
import 'package:instagram_flutter02/models/user_model.dart';
import 'package:instagram_flutter02/services/api/post_service.dart';

class TimelineProvider with ChangeNotifier {
  dynamic? _lastDocument = null;

  // dynamic get lastDocument => _lastDocument;

  int _documentLimit = 5;
  bool _hasMore = true;
  List<Post> _posts = [];
  List<UserModel> _userModels = [];

  bool get hasMore => _hasMore;
  List<Post> get posts => _posts;
  List<UserModel> get userModels => _userModels;

  void init() async {
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
    print('getQueryTimeline()@@@@@@@@@@@@@@@@@@');
    Map<String, dynamic> values = await PostService.queryTimeline(
        _documentLimit, _lastDocument, _hasMore);
    _lastDocument = values['lastDocument'];
    _posts = [..._posts, ...values['posts']];
    _userModels = [..._userModels, ...values['userModels']];
    _hasMore = values['hasMore'];
    // 'userModels': userModels,
    // 'hasMore': hasMore,
    // 'lastDocument': lastDocument,
    notifyListeners();
  }

  // List<StoreItem> get items => _items;

  // void remove(StoreItem item) {
  //   _items.remove(item);
  //   notifyListeners();
  // }

  // void add(StoreItem item) {
  //   _items.add(item);
  //   notifyListeners();
  // }

  // num get totalPrice {
  //   return _items.fold(0, (previousValue, storeItem) {
  //     return previousValue + storeItem.price;
  //   });
  // }
}
