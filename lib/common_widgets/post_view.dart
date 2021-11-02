import 'dart:async';
import 'package:animator/animator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagram_flutter02/common_widgets/custom_cached_image.dart';
import 'package:instagram_flutter02/controllers/post_view_controller.dart';
import 'package:instagram_flutter02/models/controller_datas/post_view_data.dart';
import 'package:instagram_flutter02/models/post.dart';
import 'package:instagram_flutter02/models/user_model.dart';
import 'package:instagram_flutter02/screens/profile_screen.dart';
import 'package:instagram_flutter02/services/api/post_service.dart';
import 'package:instagram_flutter02/utilities/constants.dart';
import 'package:instagram_flutter02/utilities/themes.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';

final postViewControllerProvider =
    StateNotifierProvider<PostViewController, PostViewData>((ref) {
  return PostViewController();
});

class PostView extends ConsumerWidget {
  String? currentUid;
  Post? post;
  UserModel? userModel;

  PostView({this.currentUid, this.post, this.userModel});

  // String loremIpsum =
  //     'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of clickType and scrambled it to make a clickType specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.';

  late PostViewController _postViewController;
  late PostViewData _postViewData;

  handleLikePost(clickType) async {
    _postViewController.handleLikePost(
        clickType: clickType, currentUid: currentUid, post: post);
    // bool _isLiked = widget.post?.likes[widget.currentUid] == true;
    // if (isPushingLike == false) {
    //   isPushingLike = true;
    //   if (_isLiked && clickType == 'single') {
    //     await PostService.unLikePost(widget.currentUid, widget.post);
    //     setState(() {
    //       _likeCount -= 1;
    //       _isLiked = false;
    //       // likes[widget.currentUid] = false;
    //     });
    //   } else if (!_isLiked) {
    //     await PostService.likePost(widget.currentUid, widget.post);
    //     setState(() {
    //       _likeCount += 1;
    //       _isLiked = true;
    //       if (clickType == "double") {
    //         showHeart = true;
    //       }
    //     });
    //     if (clickType == "double") {
    //       Timer(Duration(milliseconds: 500), () {
    //         setState(() {
    //           showHeart = false;
    //         });
    //       });
    //     }
    //   }
    //   isPushingLike = false;
    // }
  }

  readMoreLess() {
    _postViewController.readMoreLess();
    // setState(() {
    //   isReadMore = !isReadMore;
    // });
  }

  goToProfilePage(context, post) {
    _postViewController.goToProfilePage(context: context, uid: post.uid);

    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //       builder: (context) => ProfileScreen(uid: widget.post?.uid)),
    // );
  }

  Widget buildText() {
    final maxLines = _postViewData.isReadMore! ? null : 2;
    final overflow = _postViewData.isReadMore!
        ? TextOverflow.visible
        : TextOverflow.ellipsis;
    final iconType =
        _postViewData.isReadMore! ? Icons.expand_less : Icons.expand_more;
    return Row(
      children: <Widget>[
        Expanded(
            child: Text(
          post!.caption,
          maxLines: maxLines,
          overflow: overflow,
          style: TextStyle(fontSize: 16),
        )),
        GestureDetector(
          onTap: () => readMoreLess(),
          child: Icon(
            iconType,
            size: 35.0,
          ),
        ),
      ],
    );
    // );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _postViewController = ref.watch(postViewControllerProvider.notifier);
    _postViewData = ref.watch(postViewControllerProvider);

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
                customCachedImage(post!.photoUrl),
                _postViewData.showHeart!
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
                onTap: () => goToProfilePage(context, post),
                child: CircleAvatar(
                  backgroundColor: Colors.grey,
                  backgroundImage: CachedNetworkImageProvider(
                    userModel!.profileImageUrl,
                  ),
                ),
              ),
              title: GestureDetector(
                onTap: () => goToProfilePage(context, post),
                child: Row(
                  children: [
                    Text(
                      userModel!.name,
                      style: kFontSize18FontWeight600TextStyle,
                    ),
                  ],
                ),
              ),
              trailing: Text(
                DateFormat("yyyy/MM/dd")
                    .format(post!.timestamp.toDate())
                    .toString(),
                style: TextStyle(fontSize: 16.0, color: Colors.black),
              ),
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
                                _postViewData.isLiked!
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                size: 35.0,
                                color: Colors.pink,
                              ),
                            ),
                            Container(
                              child: Text(_postViewData.likeCount.toString()),
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
