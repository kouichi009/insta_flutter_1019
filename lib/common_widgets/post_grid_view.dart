import 'package:flutter/material.dart';
import 'package:instagram_flutter02/common_widgets/custom_cached_image.dart';
import 'package:instagram_flutter02/models/post.dart';

class PostGridView extends StatefulWidget {
  List<Post>? posts;

  PostGridView({this.posts});

  @override
  _PostGridViewState createState() => _PostGridViewState();
}

class _PostGridViewState extends State<PostGridView> {
  buildProfilePosts() {
    List<GridTile> gridTiles = [];

    widget.posts!.forEach((post) {
      gridTiles.add(GridTile(child: PostTile(post)));
    });
    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: 1.0,
      mainAxisSpacing: 1.5,
      crossAxisSpacing: 1.5,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: gridTiles,
    );
  }

  PostTile(post) {
    return GestureDetector(
      onTap: () => print('tap grid'),
      child: customCachedImage(post.photoUrl),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildProfilePosts();
  }
}
