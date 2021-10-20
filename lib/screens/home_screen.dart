import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter02/screens/camera_screen.dart';
import 'package:instagram_flutter02/screens/edit_profile_screen.dart';
import 'package:instagram_flutter02/screens/profile_screen.dart';
import 'package:instagram_flutter02/screens/sign_up_screen.dart';
import 'package:instagram_flutter02/screens/timeline_screen.dart';

class HomeScreen extends StatefulWidget {
  // const HomeScreen({Key? key}) : super(key: key);
  final String? currentUid;

  HomeScreen({this.currentUid});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController? pageController;
  int pageIndex = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    pageController!.dispose();
    super.dispose();
  }

  onPageChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  onTap(int pageIndex) {
    pageController!.animateToPage(
      pageIndex,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Scaffold buildAuthScreen() {
    return Scaffold(
      key: null,
      body: PageView(
        children: <Widget>[
          TimelineScreen(),
          CameraScreen(currentUid: widget.currentUid),
          ProfileScreen(),
          SignUpScreen(),
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: CupertinoTabBar(
          currentIndex: pageIndex,
          onTap: onTap,
          activeColor: Theme.of(context).primaryColor,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.whatshot)),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.photo_camera,
                size: 35.0,
              ),
            ),
            BottomNavigationBarItem(icon: Icon(Icons.account_circle)),
            BottomNavigationBarItem(icon: Icon(Icons.email)),
          ]),
    );
    // return RaisedButton(
    //   child: Text('Logout'),
    //   onPressed: logout,
    // );
  }

  // Scaffold buildUnAuthScreen() {
  //   return Scaffold(
  //     body: Container(
  //       decoration: BoxDecoration(
  //         gradient: LinearGradient(
  //           begin: Alignment.topRight,
  //           end: Alignment.bottomLeft,
  //           colors: [
  //             Theme.of(context).accentColor,
  //             Theme.of(context).primaryColor,
  //           ],
  //         ),
  //       ),
  //       alignment: Alignment.center,
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         children: <Widget>[
  //           Text(
  //             'FlutterShare',
  //             style: TextStyle(
  //               fontFamily: "Signatra",
  //               fontSize: 90.0,
  //               color: Colors.white,
  //             ),
  //           ),
  //           GestureDetector(
  //             onTap: login,
  //             child: Container(
  //               width: 260.0,
  //               height: 60.0,
  //               decoration: BoxDecoration(
  //                 image: DecorationImage(
  //                   image: AssetImage(
  //                     'assets/images/google_signin_button.png',
  //                   ),
  //                   fit: BoxFit.cover,
  //                 ),
  //               ),
  //             ),
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return buildAuthScreen();
  }
}
