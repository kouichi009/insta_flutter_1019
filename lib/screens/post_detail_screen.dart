import 'package:flutter/material.dart';
import 'package:instagram_flutter02/common_widgets/post_view.dart';
import 'package:instagram_flutter02/models/post.dart';

class PostDetailScreen extends StatefulWidget {
  String? currentUid;
  Post? post;

  PostDetailScreen({this.currentUid, this.post});

  @override
  _PostDetailScreenState createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('テストアプリ'),
      ),
      body: PostView(currentUid: widget.currentUid, post: widget.post),
    );
  }
}
