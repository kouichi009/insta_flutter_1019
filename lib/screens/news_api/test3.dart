import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter02/utilities/constants.dart';
import 'package:uuid/uuid.dart';

class Test3 extends StatefulWidget {
  const Test3({Key? key}) : super(key: key);

  @override
  _Test3State createState() => _Test3State();
}

class _Test3State extends State<Test3> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<DocumentSnapshot> posts = []; // stores fetched products
  bool isLoading = false; // track if products fetching
  bool hasMore = true; // flag for more products available or not
  int documentLimit = 10; // documents to be fetched per request
  DocumentSnapshot?
      lastDocument; // flag for last document from where next 10 records to be fetched
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // uploadFirestore();
    // return;
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
    posts.addAll(querySnapshot.docs);
    setState(() {
      isLoading = false;
    });
  }

  int count = 0;

  uploadFirestore() {
    for (var i = 0; i < 10; i++) {
      print(i);
      final downloadUrl =
          'https://firebasestorage.googleapis.com/v0/b/instagram-flutter-kadai.appspot.com/o/post_dcb7e750-d4db-4608-9c65-aaa223fc7716.jpg?alt=media&token=a356e1a3-2112-4fd7-8fff-d98b68c8ac68';
      String postId = Uuid().v4();

      postsRef.doc(postId).set({
        "id": postId,
        "uid": 'g32hXuaRCkbueZZUJVJj6NxtiAo2',
        "photoUrl": downloadUrl,
        "likeCount": 0,
        "timestamp": FieldValue.serverTimestamp(),
        "caption": '$i caption',
        "likes": {},
        'status': 1,
      });
    }
    print('ループから脱出');
    // count++;
    // if (count >= 3) return;
    // print('uploadFirestore@@@@ $count');
  }

  @override
  Widget build(BuildContext context) {
    // return Container(
    //   child: ElevatedButton(
    //     onPressed: () => {uploadFirestore()},
    //     child: Text('ボタンでfirestore'),
    //   ),
    // );
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Pagination with Firestore'),
      ),
      body: Column(children: [
        Expanded(
          child: posts.length == 0
              ? Center(
                  child: Text('No Data...'),
                )
              : ListView.builder(
                  controller: _scrollController,
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      contentPadding: EdgeInsets.all(5),
                      title: Text(posts[index]['caption']),
                      subtitle: Text(posts[index]['id']),
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
      ]),
    );
  }
}
