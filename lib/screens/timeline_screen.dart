import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter02/common_widgets/app_header.dart';
import 'package:instagram_flutter02/common_widgets/post_view.dart';
import 'package:instagram_flutter02/models/post.dart';
import 'package:instagram_flutter02/models/user_model.dart';
import 'package:instagram_flutter02/screens/post_detail_screen.dart';
import 'package:instagram_flutter02/services/api/auth_service.dart';
import 'package:instagram_flutter02/services/api/post_service.dart';

class TimelineScreen extends StatefulWidget {
  String? currentUid;

  TimelineScreen({this.currentUid});

  @override
  _TimelineScreenState createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Post> _posts = []; // stores fetched products
  List<UserModel> _userModels = [];
  bool _isLoading = false; // track if products fetching
  bool _hasMore = true; // flag for more products available or not
  int documentLimit = 5; // documents to be fetched per request
  DocumentSnapshot?
      _lastDocument; // flag for last document from where next 10 records to be fetched
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.20;
      if (maxScroll - currentScroll <= delta) {
        getPosts();
      }
    });
    getPosts();
  }

  getPosts() async {
    if (!_hasMore) {
      return;
    }
    if (_isLoading) {
      return;
    }

    setState(() {
      _isLoading = true;
    });
    Map values =
        await PostService.queryTimeline(documentLimit, _lastDocument, _hasMore);

    List<Post> posts = values['posts'];
    List<UserModel> userModels = values['userModels'];
    _posts.addAll(posts);
    _userModels.addAll(userModels);
    _hasMore = values['hasMore'];
    _lastDocument = values['lastDocument'];

    setState(() {
      _isLoading = false;
    });
  }

  Widget _buildDisplayPosts() {
    List<PostView> postViews = [];
    return Column(children: [
      Expanded(
        child: _posts.length == 0
            ? Center(
                child: Text('No Data...'),
              )
            : ListView.builder(
                controller: _scrollController,
                itemCount: _posts.length,
                itemBuilder: (context, index) {
                  return new GestureDetector(
                    //You need to make my child interactive
                    onTap: () => goToPostDetail(context, index),
                    child: PostView(
                      currentUid: widget.currentUid,
                      userModel: _userModels[index],
                      post: _posts[index],
                    ),
                  );
                },
              ),
      ),
      _isLoading
          ? Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(5),
              color: Colors.yellowAccent,
              child: Text(
                'Loading',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : Container()
    ]);
  }

  goToPostDetail(context, index) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PostDetailScreen(
              currentUid: widget.currentUid, post: _posts[index]),
        ));
    if (result != null) {
      refresh();
    }
  }

  refresh() async {
    Map values = await PostService.queryTimeline(documentLimit, null, true);

    List<Post> posts = values['posts'];
    List<UserModel> userModels = values['userModels'];
    _posts = posts;
    _userModels = userModels;
    _hasMore = values['hasMore'];
    _lastDocument = values['lastDocument'];
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppHeader(
          isAppTitle: true,
        ),
        body: RefreshIndicator(
            onRefresh: () => refresh(), child: _buildDisplayPosts()));
  }
}
