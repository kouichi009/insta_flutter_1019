import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter02/common_widgets/custom_cached_image.dart';
import 'package:instagram_flutter02/models/post.dart';
import 'package:instagram_flutter02/models/user_model.dart';
import 'package:instagram_flutter02/providers/post_view_provider.dart';
import 'package:instagram_flutter02/utilities/themes.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostView extends StatelessWidget {
  // const PostView({Key? key}) : super(key: key);

  final UserModel? userModel;
  final Post? post;

  PostView({this.userModel, this.post});

  handleLikePost({type, post, postViewProvider, currentUid}) async {
    print(currentUid);
    // final authUser = context.read<User?>();
    postViewProvider.handleLikePost(
        type: type, currentUid: currentUid, post: post);
  }

  readMoreLess() {}

  goToProfilePage() {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //       builder: (context) => ProfileScreen(uid: widget.post?.uid)),
    // );
  }

  Widget buildText(PostViewProvider postViewProvider) {
    final maxLines = postViewProvider.isReadMore ? null : 2;
    final overflow = postViewProvider.isReadMore
        ? TextOverflow.visible
        : TextOverflow.ellipsis;

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
            postViewProvider.isReadMore ? Icons.expand_less : Icons.expand_more,
            size: 35.0,
          ),
        ),
      ],
    );
    // );
  }

  @override
  Widget build(BuildContext context) {
    print(context);
    PostViewProvider postViewProvider = context.watch<PostViewProvider>();
    final authUser = context.watch<User?>();
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
            onDoubleTap: () => handleLikePost(
                type: 'double',
                post: post,
                postViewProvider: postViewProvider,
                currentUid: authUser?.uid),
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                // height: MediaQuery.of(context).size.width,
                customCachedImage(post!.photoUrl),
                // showHeart
                //     ? Animator(
                //         duration: Duration(milliseconds: 300),
                //         tween: Tween(begin: 0.8, end: 1.4),
                //         curve: Curves.elasticOut,
                //         cycles: 0,
                //         builder: (context, anim, child) => Transform.scale(
                //           scale: anim.controller.value,
                //           child: Icon(
                //             Icons.favorite,
                //             size: 80.0,
                //             color: Colors.red,
                //           ),
                //         ),
                //       )
                //     : Text(""),
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
                    userModel!.profileImageUrl,
                  ),
                ),
              ),
              title: GestureDetector(
                onTap: () => goToProfilePage(),
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
                          child: buildText(postViewProvider),
                        ),
                        Row(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () => handleLikePost(
                                  type: 'single',
                                  post: post,
                                  postViewProvider: postViewProvider,
                                  currentUid: authUser?.uid),
                              child: Icon(
                                postViewProvider.isLiked
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                size: 35.0,
                                color: Colors.pink,
                              ),
                            ),
                            Container(
                              child:
                                  Text(postViewProvider.likeCount.toString()),
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
