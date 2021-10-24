import 'package:cloud_firestore/cloud_firestore.dart';
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
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Post> _posts = []; // stores fetched products
  bool isLoading = false; // track if products fetching
  bool hasMore = true; // flag for more products available or not
  int documentLimit = 10; // documents to be fetched per request
  DocumentSnapshot?
      lastDocument; // flag for last document from where next 10 records to be fetched
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.20;
      if (maxScroll - currentScroll <= delta) {
        getProducts();
      }
    });
    getProducts();
  }

  getProducts() async {
    if (!hasMore) {
      print('No More Products');
      return;
    }
    if (isLoading) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    QuerySnapshot querySnapshot;
    if (lastDocument == null) {
      querySnapshot = await _firestore
          .collection('posts')
          .orderBy('timestamp')
          .limit(documentLimit)
          .get();
    } else {
      querySnapshot = await _firestore
          .collection('posts')
          .orderBy('timestamp')
          .startAfterDocument(lastDocument!)
          .limit(documentLimit)
          .get();
      print(1);
    }
    if (querySnapshot.docs.length < documentLimit) {
      hasMore = false;
    }
    lastDocument = querySnapshot.docs[querySnapshot.docs.length - 1];
    _posts.addAll(querySnapshot.docs.map((doc) => Post.fromDoc(doc)).toList());
    setState(() {
      isLoading = false;
    });
  }

  // queryPosts() async {
  //   List<Post> posts = await PostService.query();
  //   if (!mounted) return;
  //   setState(() {
  //     _posts = posts;
  //   });
  // }

  Widget _buildDisplayPosts() {
    // Column
    List<PostView> postViews = [];
    // _posts.forEach((post) {
    //   postViews.add(PostView(currentUid: widget.currentUid, post: post));
    // });
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
                  return ListTile(
                    contentPadding: EdgeInsets.all(5),
                    title: Text(_posts[index].caption),
                    subtitle: Text(_posts[index].id),
                  );
                },
              ),
      ),
      isLoading
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
    // return ListView(
    //   children: postViews,
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('FutureBuilder Demo'),
        ),
        body: RefreshIndicator(
            onRefresh: () => getProducts(), child: _buildDisplayPosts()));
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
