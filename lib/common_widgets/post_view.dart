import 'dart:async';
import 'package:animator/animator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:instagram_flutter02/common_widgets/custom_cached_image.dart';
import 'package:instagram_flutter02/models/post.dart';
import 'package:instagram_flutter02/models/user_model.dart';
import 'package:instagram_flutter02/utilities/constants.dart';

class PostView extends StatefulWidget {
  String? currentUid;
  Post? post;

  PostView({this.currentUid, this.post});

  @override
  _PostViewState createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  bool isLiked = false;
  int likeCount = 0;
  Map likes = {};
  bool showHeart = false;

  handleLikePost() {
    bool _isLiked = widget.post!.likes[widget.currentUid] == true;

    if (_isLiked) {
      // WriteBatch batch = FirebaseFirestore.instance.batch();
      // batch.update(postsRef.doc(widget.currentUid),
      postsRef.doc(widget.post!.id).update({
        'likes.${widget.currentUid}': false,
        'likeCount': widget.post!.likeCount - 1
      });
      setState(() {
        likeCount -= 1;
        isLiked = false;
        likes[widget.currentUid] = false;
      });
    } else if (!_isLiked) {
      postsRef.doc(widget.post!.id).update({
        'likes.${widget.currentUid}': true,
        'likeCount': widget.post!.likeCount + 1
      });
      setState(() {
        likeCount += 1;
        isLiked = true;
        likes[widget.currentUid] = true;
        showHeart = true;
      });
      Timer(Duration(milliseconds: 500), () {
        setState(() {
          showHeart = false;
        });
      });
    }
  }

  buildPostHeader() {
    return FutureBuilder(
      future: usersRef.doc(widget.post!.uid).get(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Text('loading');
        }
        UserModel user = UserModel.fromDoc(snapshot.data);
        // bool isPostOwner = currentUserId == ownerId;
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(user.profileImageUrl),
            backgroundColor: Colors.grey,
          ),
          title: GestureDetector(
            onTap: () => null,
            child: Text(
              user.name,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // subtitle: Text('subtitle'),
          trailing: Container(
            child: Text('投稿日時'),
          ),
        );
      },
    );
  }

  buildPostImage() {
    return GestureDetector(
      onDoubleTap: handleLikePost,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          customCachedImage(
            widget.post!.photoUrl,
          ),
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
    );
  }

  buildPostFooter() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: 40.0, left: 20.0)),
            Flexible(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Container(
                    padding: new EdgeInsets.all(5.0),
                    child: new Text(
                      widget.post!.caption,
                      softWrap: true,
                      style: new TextStyle(fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: handleLikePost,
                        child: Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          size: 35.0,
                          color: Colors.pink,
                        ),
                      ),
                      Container(
                        child: Text(likeCount.toString()),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // GestureDetector(
            //   onTap: () => showComments(
            //     context,
            //     postId: postId,
            //     ownerId: ownerId,
            //     mediaUrl: mediaUrl,
            //   ),
            //   child: Icon(
            //     Icons.chat,
            //     size: 28.0,
            //     color: Colors.blue[900],
            //   ),
            // ),
          ],
        ),
        // Row(
        //   children: <Widget>[
        //     Container(
        //       margin: EdgeInsets.only(left: 20.0),
        //       child: Text(
        //         "25 likes",
        //         style: TextStyle(
        //           color: Colors.black,
        //           fontWeight: FontWeight.bold,
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
        // Row(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: <Widget>[
        //     Container(
        //       margin: EdgeInsets.only(left: 20.0),
        //       child: Text(
        //         "kouichi ",
        //         style: TextStyle(
        //           color: Colors.black,
        //           fontWeight: FontWeight.bold,
        //         ),
        //       ),
        //     ),
        //     Expanded(child: Text('description'))
        //   ],
        // ),
      ],
    );
  }

  int getLikeCount(likes) {
    // if no likes, return 0
    if (likes == null) {
      return 0;
    }
    int count = 0;
    // if the key is explicitly set to true, add a like
    likes.values.forEach((val) {
      if (val == true) {
        count += 1;
      }
    });
    return count;
  }

  @override
  Widget build(BuildContext context) {
    isLiked = (widget.post!.likes[widget.currentUid] == true);
    // likeCount = widget.post!.likeCount;
    likes = widget.post!.likes;
    likeCount = getLikeCount(widget.post!.likes);

    return Column(
      children: <Widget>[
        buildPostImage(),
        buildPostHeader(),
        buildPostFooter(),
      ],
    );
  }
}
