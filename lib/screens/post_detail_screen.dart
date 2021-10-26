import 'package:flutter/material.dart';
import 'package:instagram_flutter02/common_widgets/post_view.dart';
import 'package:instagram_flutter02/models/post.dart';
import 'package:instagram_flutter02/models/user_model.dart';
import 'package:instagram_flutter02/services/api/post_service.dart';

class PostDetailScreen extends StatefulWidget {
  String? currentUid;
  Post? post;
  UserModel? userModel;

  PostDetailScreen({this.currentUid, this.post});

  @override
  _PostDetailScreenState createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  Post? _latestPost;
  UserModel? _latestUserModel;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    print('${widget.currentUid} ${widget.post} ${widget.userModel}');
    print('initS');
    getLatestPost();
  }

  getLatestPost() async {
    var b = widget.post;
    var c = widget.currentUid;
    Map latestObj = await PostService.getLatestPost(widget.post);
    _latestPost = latestObj['latestPost'];
    _latestUserModel = latestObj['latestUserModel'];
    setState(() {
      _isLoading = false;
    });
  }

  handleDeletePost(BuildContext parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text("Remove this post?"),
            children: <Widget>[
              SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context);
                    // deletePost();
                  },
                  child: Text(
                    'Delete',
                    style: TextStyle(color: Colors.red),
                  )),
              SimpleDialogOption(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel')),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('テストアプリ'),
          actions: <Widget>[
            IconButton(
              onPressed: () => handleDeletePost(context),
              icon: Icon(Icons.more_vert),
            ),
          ],
        ),
        body: !_isLoading
            ? ListView(
                children: <Widget>[
                  PostView(
                    currentUid: widget.currentUid,
                    userModel: _latestUserModel,
                    post: _latestPost,
                  ),
                ],
              )
            : Center(
                child: CircularProgressIndicator(),
              ));
  }
}
