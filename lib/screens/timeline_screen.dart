import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter02/models/user_model.dart';
import 'package:instagram_flutter02/screens/home_screen.dart';

class TimelineScreen extends StatefulWidget {
  const TimelineScreen({Key? key}) : super(key: key);

  @override
  _TimelineScreenState createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  bool showHeart = false;
  final String mediaUrl =
      'https://i.guim.co.uk/img/media/26392d05302e02f7bf4eb143bb84c8097d09144b/446_167_3683_2210/master/3683.jpg?width=1200&height=1200&quality=85&auto=format&fit=crop&s=49ed3252c0b2ffb49cf8b508892e452d';
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        buildPostImage(),
        buildPostHeader(),
        buildPostFooter()
      ],
    );
  }

  buildPostHeader() {
    return FutureBuilder(
      future: usersRef.doc('Rfhmu5OaCBPROJ0wLNoHb3K3OiE2').get(),
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
      onDoubleTap: null,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          CachedNetworkImage(
            imageUrl: mediaUrl,
          ),
          // showHeart
          //     ? Animator(
          //         duration: Duration(milliseconds: 300),
          //         tween: Tween(begin: 0.8, end: 1.4),
          //         curve: Curves.elasticOut,
          //         cycles: 0,
          //         builder: (anim) => Transform.scale(
          //           scale: anim.value,
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
                      "titletitletitletitletitletitletitletitletitletitletitletitletitletitletitletitletitletitletitletitletitletitletitletitletitle",
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
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          size: 35.0,
                          color: Colors.pink,
                        ),
                      ),
                      Container(
                        child: Text('12'),
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
}
