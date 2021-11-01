import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter02/common_widgets/app_header.dart';
import 'package:instagram_flutter02/common_widgets/post_grid_view.dart';
import 'package:instagram_flutter02/common_widgets/post_view.dart';
import 'package:instagram_flutter02/models/post.dart';
import 'package:instagram_flutter02/models/user_model.dart';
import 'package:instagram_flutter02/screens/edit_profile_screen.dart';
import 'package:instagram_flutter02/screens/home_screen.dart';
import 'package:instagram_flutter02/screens/news_api/news_screen.dart';
import 'package:instagram_flutter02/services/api/post_service.dart';
import 'package:instagram_flutter02/utilities/constants.dart';
import 'package:instagram_flutter02/utilities/themes.dart';

class ProfileScreen extends StatefulWidget {
  String? uid;
  ProfileScreen({this.uid});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String postType = '';
  List<Post> _posts = [];
  String currentUid = '';

  @override
  void initState() {
    super.initState();
    queryUserPosts();
  }

  queryUserPosts() async {
    currentUid = FirebaseAuth.instance.currentUser!.uid;
    List<Post> posts = await PostService.queryUserPosts(widget.uid);
    if (!mounted) return;
    setState(() {
      _posts = posts;
      postType = MYPOSTS;
    });
  }

  queryLikedPosts() async {
    List<Post> posts = await PostService.queryLikedPosts(widget.uid);
    if (!mounted) return;
    setState(() {
      postType = FAV;
      _posts = posts;
    });
  }

  buildProfileHeader() {
    return FutureBuilder(
        future: usersRef.doc(widget.uid).get(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            // return circularProgress();
            return Text('abc');
          }
          UserModel userModel = UserModel.fromDoc(snapshot.data);
          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 50.0,
                      backgroundColor: Colors.grey,
                      backgroundImage:
                          CachedNetworkImageProvider(userModel.profileImageUrl),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text(userModel.name),
                              Text(
                                  '${userModel.dateOfBirth['year']}年${userModel.dateOfBirth['month']}月${userModel.dateOfBirth['day']}日'),
                              // buildCountColumn("posts", postCount),
                              // buildCountColumn("followers", followerCount),
                              // buildCountColumn("following", followingCount),
                            ],
                          ),
                          if (widget.uid == currentUid)
                            Container(
                              padding: EdgeInsets.only(top: 2.0),
                              child: FlatButton(
                                onPressed: () => goToEditProfile(userModel),
                                child: Container(
                                  width: 250.0,
                                  height: 35.0,
                                  child: Text(
                                    'プロフィール編集',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    border: Border.all(
                                      color: Colors.grey,
                                    ),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  buildpostType() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(
          onPressed: () => queryUserPosts(),
          icon: Icon(Icons.account_circle),
          color: postType == MYPOSTS
              ? Theme.of(context).primaryColor
              : Colors.grey,
        ),
        IconButton(
          onPressed: () => queryLikedPosts(),
          icon: Icon(Icons.favorite),
          color: postType == FAV ? Theme.of(context).primaryColor : Colors.grey,
        ),
      ],
    );
  }

  goToEditProfile(userModel) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditProfileScreen(currentUid: currentUid)));
    setState(() {});
  }

  Widget _buildGridPosts() {
    return PostGridView(currentUid: currentUid, posts: _posts);
  }

  goToNewsApiPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => NewsScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(
          isAppTitle: false,
          titleText: 'マイページ',
          actionWidget: IconButton(
              icon: Icon(Icons.check_circle_outline, color: Colors.black),
              onPressed: () => goToNewsApiPage())),
      body: ListView(
        children: <Widget>[
          buildProfileHeader(),
          Divider(),
          buildpostType(),
          _buildGridPosts(),
          // RefreshIndicator(
          //     onRefresh: () => queryPosts(), child: _buildDisplayPosts())
          // PostGridView(posts: []),
        ],
      ),
    );
  }
}
