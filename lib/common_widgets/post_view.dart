import 'dart:async';
import 'package:animator/animator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:instagram_flutter02/common_widgets/custom_cached_image.dart';
import 'package:instagram_flutter02/models/post.dart';
import 'package:instagram_flutter02/models/user_model.dart';
import 'package:instagram_flutter02/screens/profile_screen.dart';
import 'package:instagram_flutter02/services/api/post_service.dart';
import 'package:instagram_flutter02/utilities/constants.dart';
import 'package:instagram_flutter02/utilities/themes.dart';
import 'package:ionicons/ionicons.dart';

class PostView extends StatefulWidget {
  String? currentUid;
  Post? post;
  UserModel? userModel;

  PostView({this.currentUid, this.post, this.userModel});

  @override
  _PostViewState createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  bool _isLiked = false;
  int _likeCount = 0;
  Map likes = {};
  bool showHeart = false;
  bool isPushingLike = false;
  bool isReadMore = false;
  String loremIpsum =
      'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.';

  @override
  void initState() {
    super.initState();
    _likeCount = widget.post!.likeCount;
    _isLiked = widget.post?.likes[widget.currentUid] == true;
  }

  handleLikePost(type) async {
    // bool _isLiked = widget.post?.likes[widget.currentUid] == true;
    if (isPushingLike == false) {
      isPushingLike = true;
      if (_isLiked && type == 'single') {
        await PostService.unLikePost(widget.currentUid, widget.post);
        setState(() {
          _likeCount -= 1;
          _isLiked = false;
          // likes[widget.currentUid] = false;
        });
      } else if (!_isLiked) {
        await PostService.likePost(widget.currentUid, widget.post);
        setState(() {
          _likeCount += 1;
          _isLiked = true;
          if (type == "double") {
            showHeart = true;
          }
        });
        if (type == "double") {
          Timer(Duration(milliseconds: 500), () {
            setState(() {
              showHeart = false;
            });
          });
        }

        print('like finish@');
      }
      isPushingLike = false;
    }
  }

  readMoreLess() {
    setState(() {
      isReadMore = !isReadMore;
    });
  }

  goToProfilePage() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ProfileScreen(uid: widget.post?.uid)),
    );
  }

  Widget buildText() {
    final maxLines = isReadMore ? null : 2;
    final overflow = isReadMore ? TextOverflow.visible : TextOverflow.ellipsis;

    return Row(
      children: <Widget>[
        Expanded(
            child: Text(
          widget.post!.caption,
          maxLines: maxLines,
          overflow: overflow,
          style: TextStyle(fontSize: 16),
        )),
        GestureDetector(
          onTap: () => readMoreLess(),
          child: Icon(
            isReadMore ? Icons.expand_less : Icons.expand_more,
            size: 35.0,
          ),
        ),
      ],
    );
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 50.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        // mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          // Padding(
          //     padding: EdgeInsets.only(
          //   bottom: 100.0,
          // )),
          GestureDetector(
            onDoubleTap: () => handleLikePost('double'),
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                // height: MediaQuery.of(context).size.width,
                customCachedImage(widget.post!.photoUrl),
                showHeart
                    ? Animator(
                        duration: Duration(milliseconds: 300),
                        tween: Tween(begin: 0.8, end: 1.4),
                        curve: Curves.elasticOut,
                        cycles: 0,
                        builder: (context, anim, child) => Transform.scale(
                          scale: anim.controller.value,
                          child: Icon(
                            Icons.favorite,
                            size: 80.0,
                            color: Colors.red,
                          ),
                        ),
                      )
                    : Text(""),
              ],
            ),
          ),
          Container(
            child: ListTile(
              leading: GestureDetector(
                onTap: () => goToProfilePage(),
                child: CircleAvatar(
                  backgroundColor: Colors.grey,
                  backgroundImage: CachedNetworkImageProvider(
                    widget.userModel!.profileImageUrl,
                  ),
                ),
              ),
              title: GestureDetector(
                onTap: () => goToProfilePage(),
                child: Row(
                  children: [
                    Text(
                      widget.userModel!.name,
                      style: kFontSize18FontWeight600TextStyle,
                    ),
                  ],
                ),
              ),
              trailing: Text('投稿日時'),
            ),
          ),

          Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(
                    top: 40.0,
                    left: 20.0,
                  )),
                  Flexible(
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(5.0),
                          child: buildText(),
                        ),
                        Row(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () => handleLikePost('single'),
                              child: Icon(
                                _isLiked
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                size: 35.0,
                                color: Colors.pink,
                              ),
                            ),
                            Container(
                              child: Text(_likeCount.toString()),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
