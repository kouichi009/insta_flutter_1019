import 'dart:async';
import 'package:animator/animator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:instagram_flutter02/common_widgets/custom_cached_image.dart';
import 'package:instagram_flutter02/models/post.dart';
import 'package:instagram_flutter02/models/user_model.dart';
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
  bool isLiked = false;
  int likeCount = 0;
  Map likes = {};
  bool showHeart = false;

  // handleLikePost() {
  //   bool _isLiked = widget.post!.likes[widget.currentUid] == true;
  //   WriteBatch batch = FirebaseFirestore.instance.batch();

  //   if (_isLiked) {
  //     // batch.update(postsRef.doc(widget.post!.id)}{
  //     //   'likes.${widget.currentUid}': false,
  //     //   'likeCount': widget.post!.likeCount - 1
  //     // });
  //     batch.update(postsRef.doc(widget.post!.id), {
  //       'likes.${widget.currentUid}': false,
  //       // 'likeCount': widget.post!.likeCount - 1
  //     });

  //     batch.set(
  //         usersRef
  //             .doc(widget.post!.uid)
  //             .collection('likedPosts')
  //             .doc(widget.post!.id),
  //         {
  //           'postId': widget.post!.id,
  //           'isLiked': false,
  //           'timestamp': timestamp,
  //           'uid': widget.post!.uid
  //         });

  //     // postsRef.doc(widget.post!.id).update({
  //     //   'likes.${widget.currentUid}': false,
  //     //   'likeCount': widget.post!.likeCount - 1
  //     // });
  //     setState(() {
  //       likeCount -= 1;
  //       isLiked = false;
  //       likes[widget.currentUid] = false;
  //     });
  //   } else if (!_isLiked) {
  //     batch.update(postsRef.doc(widget.post!.id), {
  //       'likes.${widget.currentUid}': true,
  //       // 'likeCount': widget.post!.likeCount + 1
  //     });
  //     // postsRef.doc(widget.post!.id).update({
  //     //   'likes.${widget.currentUid}': true,
  //     //   // 'likeCount': widget.post!.likeCount + 1
  //     // });

  //     batch.set(
  //         usersRef
  //             .doc(widget.post!.uid)
  //             .collection('likedPosts')
  //             .doc(widget.post!.id),
  //         {
  //           'postId': widget.post!.id,
  //           'isLiked': true,
  //           'timestamp': timestamp,
  //           'uid': widget.post!.uid
  //         });

  //     setState(() {
  //       likeCount += 1;
  //       isLiked = true;
  //       likes[widget.currentUid] = true;
  //       showHeart = true;
  //     });
  //     Timer(Duration(milliseconds: 500), () {
  //       setState(() {
  //         showHeart = false;
  //       });
  //     });
  //   }
  //   batch.commit();
  // }

  // buildPostHeader() {
  //   return FutureBuilder(
  //     future: usersRef.doc(widget.post!.uid).get(),
  //     builder: (BuildContext context, AsyncSnapshot snapshot) {
  //       if (!snapshot.hasData) {
  //         return Text('loading');
  //       }
  //       UserModel user = UserModel.fromDoc(snapshot.data);
  //       // bool isPostOwner = currentUserId == ownerId;
  //       return ListTile(
  //         leading: CircleAvatar(
  //           backgroundImage: CachedNetworkImageProvider(user.profileImageUrl),
  //           backgroundColor: Colors.grey,
  //         ),
  //         title: GestureDetector(
  //           onTap: () => null,
  //           child: Text(
  //             user.name,
  //             style: TextStyle(
  //               color: Colors.black,
  //               fontWeight: FontWeight.bold,
  //             ),
  //           ),
  //         ),
  //         // subtitle: Text('subtitle'),
  //         trailing: Container(
  //           child: Text('投稿日時'),
  //         ),
  //       );
  //     },
  //   );
  // }

  // buildPostImage() {
  //   return GestureDetector(
  //     onDoubleTap: handleLikePost,
  //     child: Stack(
  //       alignment: Alignment.center,
  //       children: <Widget>[
  //         customCachedImage(
  //           widget.post!.photoUrl,
  //         ),
  //         showHeart
  //             ? Animator(
  //                 duration: Duration(milliseconds: 300),
  //                 tween: Tween(begin: 0.8, end: 1.4),
  //                 curve: Curves.elasticOut,
  //                 cycles: 0,
  //                 builder: (context, anim, child) => Transform.scale(
  //                   scale: anim.controller.value,
  //                   child: Icon(
  //                     Icons.favorite,
  //                     size: 80.0,
  //                     color: Colors.red,
  //                   ),
  //                 ),
  //               )
  //             : Text(""),
  //       ],
  //     ),
  //   );
  // }

  // buildPostFooter() {
  //   return Column(
  //     children: <Widget>[
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.start,
  //         children: <Widget>[
  //           Padding(padding: EdgeInsets.only(top: 40.0, left: 20.0)),
  //           Flexible(
  //             child: new Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: <Widget>[
  //                 new Container(
  //                   padding: new EdgeInsets.all(5.0),
  //                   child: new Text(
  //                     widget.post!.caption,
  //                     softWrap: true,
  //                     style: new TextStyle(fontWeight: FontWeight.bold),
  //                     maxLines: 2,
  //                     overflow: TextOverflow.ellipsis,
  //                   ),
  //                 ),
  //                 Row(
  //                   children: <Widget>[
  //                     GestureDetector(
  //                       onTap: handleLikePost,
  //                       child: Icon(
  //                         isLiked ? Icons.favorite : Icons.favorite_border,
  //                         size: 35.0,
  //                         color: Colors.pink,
  //                       ),
  //                     ),
  //                     Container(
  //                       child: Text(likeCount.toString()),
  //                     ),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ),

  //           // GestureDetector(
  //           //   onTap: () => showComments(
  //           //     context,
  //           //     postId: postId,
  //           //     ownerId: ownerId,
  //           //     mediaUrl: mediaUrl,
  //           //   ),
  //           //   child: Icon(
  //           //     Icons.chat,
  //           //     size: 28.0,
  //           //     color: Colors.blue[900],
  //           //   ),
  //           // ),
  //         ],
  //       ),
  //       // Row(
  //       //   children: <Widget>[
  //       //     Container(
  //       //       margin: EdgeInsets.only(left: 20.0),
  //       //       child: Text(
  //       //         "25 likes",
  //       //         style: TextStyle(
  //       //           color: Colors.black,
  //       //           fontWeight: FontWeight.bold,
  //       //         ),
  //       //       ),
  //       //     ),
  //       //   ],
  //       // ),
  //       // Row(
  //       //   crossAxisAlignment: CrossAxisAlignment.start,
  //       //   children: <Widget>[
  //       //     Container(
  //       //       margin: EdgeInsets.only(left: 20.0),
  //       //       child: Text(
  //       //         "kouichi ",
  //       //         style: TextStyle(
  //       //           color: Colors.black,
  //       //           fontWeight: FontWeight.bold,
  //       //         ),
  //       //       ),
  //       //     ),
  //       //     Expanded(child: Text('description'))
  //       //   ],
  //       // ),
  //     ],
  //   );
  // }

  // int getLikeCount(likes) {
  //   // if no likes, return 0
  //   if (likes == null) {
  //     return 0;
  //   }
  //   int count = 0;
  //   // if the key is explicitly set to true, add a like
  //   likes.values.forEach((val) {
  //     if (val == true) {
  //       count += 1;
  //     }
  //   });
  //   return count;
  // }

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
            onDoubleTap: null,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Container(
                    height: MediaQuery.of(context).size.width,
                    child: CachedNetworkImage(
                        fadeInDuration: Duration(milliseconds: 500),
                        imageUrl: widget.post!.photoUrl))
                // _heartAnim ? HeartAnime(100.0) : SizedBox.shrink(),
              ],
            ),
          ),
          Container(
            child: ListTile(
              leading: GestureDetector(
                onTap: () => null,
                child: CircleAvatar(
                  backgroundColor: Colors.grey,
                  backgroundImage: CachedNetworkImageProvider(
                    widget.userModel!.profileImageUrl,
                  ),
                ),
              ),
              title: GestureDetector(
                onTap: () => null,
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
          // Container(
          //   padding: EdgeInsets.symmetric(horizontal: 10),
          //   child: ListTile(
          //     leading: Text(
          //       widget.post!.caption,
          //       // softWrap: true,
          //       // style: new TextStyle(fontWeight: FontWeight.bold),
          //       maxLines: 2,
          //       overflow: TextOverflow.ellipsis,
          //       textAlign: TextAlign.left,
          //     ),
          //     // title: GestureDetector(
          //     //   onTap: () => null,
          //     //   child: Row(
          //     //     children: [
          //     //       Text(
          //     //         widget.userModel!.name,
          //     //         style: kFontSize18FontWeight600TextStyle,
          //     //       ),
          //     //     ],
          //     //   ),
          //     // ),
          //     // trailing: Text('投稿日時'),
          //   ),
          // ),
          // Container(

          //   // padding: EdgeInsets.all(5.0),
          //   child: Text(
          //     widget.post!.caption,
          //     // softWrap: true,
          //     // style: new TextStyle(fontWeight: FontWeight.bold),
          //     maxLines: 2,
          //     overflow: TextOverflow.ellipsis,
          //     textAlign: TextAlign.left,
          //   ),
          // ),
          // Container(
          //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: <Widget>[
          //       Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: <Widget>[
          //           Row(
          //             children: [
          //               IconButton(
          //                 icon: isLiked
          //                     ? Icon(
          //                         Ionicons.heart_sharp,
          //                         size: 36,
          //                         color: Colors.red,
          //                       )
          //                     : Icon(Ionicons.heart_outline, size: 36),
          //                 iconSize: 30.0,
          //                 onPressed:
          //                     null /*widget.postStatus == PostStatus.feedPost
          //                     ? isLiked
          //                     : () {}*/
          //                 ,
          //               ),
          //               Padding(
          //                 padding: const EdgeInsets.symmetric(horizontal: 12.0),
          //                 child: Text(
          //                   '1 Likes',
          //                   style: TextStyle(
          //                     fontSize: 16.0,
          //                     fontWeight: FontWeight.bold,
          //                   ),
          //                 ),
          //               ),
          //               // IconButton(
          //               //   icon: Icon(Ionicons.chatbubble_ellipses_outline),
          //               //   iconSize: 28.0,
          //               //   onPressed: () => Navigator.push(
          //               //     context,
          //               //     MaterialPageRoute(
          //               //       builder: (_) => CommentsScreen(
          //               //         postStatus: widget.postStatus,
          //               //         post: post,
          //               //         likeCount: _likeCount,
          //               //         author: widget.author,
          //               //       ),
          //               //     ),
          //               //   ),
          //               // ),
          //             ],
          //           ),
          //           // TODO: Favorire Post
          //           // IconButton(
          //           //   icon: _isLiked
          //           //       ? FaIcon(
          //           //           FontAwesomeIcons.solidHeart,
          //           //           color: Colors.red,
          //           //         )
          //           //       : FaIcon(FontAwesomeIcons.heart),
          //           //   iconSize: 30.0,
          //           //   onPressed: _likePost,
          //           // ),
          //         ],
          //       ),

          //       // SizedBox(height: 4.0),
          //       // Row(
          //       //   children: <Widget>[
          //       //     Container(
          //       //       margin: const EdgeInsets.only(
          //       //         left: 12.0,
          //       //         right: 6.0,
          //       //       ),
          //       //       child: GestureDetector(
          //       //         onTap: () => _goToUserProfile(context, post),
          //       //         child: Row(
          //       //           children: [
          //       //             Text(
          //       //               widget.author.name,
          //       //               style: TextStyle(
          //       //                   fontSize: 16.0, fontWeight: FontWeight.bold),
          //       //             ),
          //       //             UserBadges(
          //       //                 user: widget.author,
          //       //                 size: 15,
          //       //                 secondSizedBox: false)
          //       //           ],
          //       //         ),
          //       //       ),
          //       //     ),
          //       //     Expanded(
          //       //         child: Text(
          //       //       post.caption,
          //       //       style: TextStyle(fontSize: 16.0),
          //       //       overflow: TextOverflow.ellipsis,
          //       //     )),
          //       //   ],
          //       // ),
          //       // Padding(
          //       //   padding:
          //       //       const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          //       //   child: Text(
          //       //     timeago.format(post.timestamp.toDate()),
          //       //     style: TextStyle(
          //       //       color: Colors.grey,
          //       //       fontSize: 12.0,
          //       //     ),
          //       //   ),
          //       // ),
          //       // SizedBox(height: 12.0),
          //     ],
          //   ),
          // ),
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
                              onTap: null,
                              child: Icon(
                                isLiked
                                    ? Icons.favorite
                                    : Icons.favorite_border,
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
          ),
        ],
      ),
    );
  }
}
