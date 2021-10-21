import 'package:flutter/material.dart';
import 'package:instagram_flutter02/common_widgets/post_view.dart';
import 'package:instagram_flutter02/models/post.dart';
import 'package:instagram_flutter02/services/api/post_service.dart';

class TimelineScreen extends StatefulWidget {
  String? currentUid;

  TimelineScreen({this.currentUid});

  @override
  _TimelineScreenState createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  List<Post> _posts = [];

  @override
  void initState() {
    super.initState();
    queryPosts();
  }

  queryPosts() async {
    List<Post> posts = await PostService.query();
    if (!mounted) return;
    setState(() {
      _posts = posts;
    });
  }

  method1() async {
    List<Post> posts = await PostService.query();
    print(
        'method1@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ $posts ${posts.length}');

    posts.forEach((post) {
      print('${post.id} ${post.caption}');
    });
    // posts.map((post) {
    //   print('888 ${post.id} ${post.caption}');
    // });
    print('Loopから脱出 1');

    // posts.map(
    //     (post) => print('123 postId: ${post.id} caption: ${post.caption}'));

    List<String> mixFruit = ['apple', 'banana', 'grape', 'orange'];

    mixFruit.forEach((fruit) {
      print(fruit);
    });
    print('Loopから脱出 2');
  }

  Widget _buildDisplayPosts() {
    // Column
    List<PostView> postViews = [];
    _posts.forEach((post) {
      // postViews.add(PostView(
      //   postStatus: PostStatus.feedPost,
      //   currentUserId: widget.currentUserId,
      //   post: post,
      //   author: _profileUser,
      // ));
      postViews.add(PostView(currentUid: widget.currentUid, post: post));
    });
    // return Text('654123');
    return ListView(
      children: postViews,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('FutureBuilder Demo'),
        ),
        body: RefreshIndicator(
            onRefresh: () => queryPosts(), child: _buildDisplayPosts()));
    // body: FutureBuilder(
    //   future: PostService.query(),
    //   builder: (BuildContext context, AsyncSnapshot snapshot) {
    //     // 通信中はスピナーを表示
    //     if (snapshot.connectionState != ConnectionState.done) {
    //       // return CircularProgressIndicator();
    //     }

    //     // エラー発生時はエラーメッセージを表示
    //     if (snapshot.hasError) {
    //       return Text(snapshot.error.toString());
    //     }

    //     // データがnullでないかチェック
    //     if (snapshot.hasData) {
    //       // snapshot.data.forEach((fruit) {
    //       //   print(fruit);
    //       // });
    //       // snapshot.data.map((e) => {print('e');}
    //       // snapshot.docs.map((doc) => Post.fromDoc(snapshot.data));
    //       print('snapData: ${snapshot.data}');
    //       return ListView(
    //         // physics: AlwaysScrollableScrollPhysics(),
    //         children: <Widget>[
    //           _buildDisplayPosts(),
    //         ],
    //       );
    //     } else {
    //       return Text("データが存在しません");
    //     }
    //   },
    // ),
    // );
  }
}
