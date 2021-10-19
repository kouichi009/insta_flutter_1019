import 'package:flutter/material.dart';
import 'package:instagram_flutter02/common_widgets/custom_cached_image.dart';

class PostGridView extends StatefulWidget {
  const PostGridView({Key? key}) : super(key: key);

  @override
  _PostGridViewState createState() => _PostGridViewState();
}

class _PostGridViewState extends State<PostGridView> {
  buildProfilePosts() {
    List<GridTile> gridTiles = [];
    List<String> lists = [
      'a',
      'b',
      'c',
      'a',
      'b',
      'c',
      'a',
      'b',
      'c',
      'a',
      'b',
      'c',
      'a',
      'b',
      'c'
    ];
    lists.forEach((post) {
      gridTiles.add(GridTile(child: PostTile(post)));
    });
    return GridView.count(
      crossAxisCount: 3,
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
      onTap: () => null,
      child: customCachedImage(
          'https://i.guim.co.uk/img/media/26392d05302e02f7bf4eb143bb84c8097d09144b/446_167_3683_2210/master/3683.jpg?width=1200&height=1200&quality=85&auto=format&fit=crop&s=49ed3252c0b2ffb49cf8b508892e452d'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildProfilePosts();
  }
}
