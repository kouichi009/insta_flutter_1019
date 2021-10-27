import 'package:flutter/material.dart';
import 'package:instagram_flutter02/common_widgets/custom_cached_image.dart';
import 'package:instagram_flutter02/models/post.dart';
import 'package:instagram_flutter02/screens/post_detail_screen.dart';

class PostGridView extends StatefulWidget {
  List<Post>? posts;
  String? currentUid;

  PostGridView({this.currentUid, this.posts});

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

  goToDetailPost(post) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            PostDetailScreen(currentUid: widget.currentUid, post: post),
      ),
    );
    print(result);
    print('aaa: ${widget.posts!.length}');
    if (result != null) {
      for (var i = 0; i < widget.posts!.length; i++) {
        print(i);
        if (post.id == widget.posts![i].id) {
          widget.posts!.removeAt(i);
        }
      }
      print('ループから脱出 ${post.id}: ${widget.posts!.length}');
      setState(() {});
    }
  }

  PostTile(post) {
    return GestureDetector(
      onTap: () => goToDetailPost(post),
      child: customCachedImage(post.photoUrl),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildProfilePosts();
  }
}
