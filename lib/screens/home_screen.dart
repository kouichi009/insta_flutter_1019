import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter02/screens/camera_screen.dart';
import 'package:instagram_flutter02/screens/edit_profile_screen.dart';
import 'package:instagram_flutter02/screens/news_api/test3.dart';
import 'package:instagram_flutter02/screens/profile_screen.dart';
import 'package:instagram_flutter02/screens/sign_up_screen.dart';
import 'package:instagram_flutter02/screens/test2.dart';
import 'package:instagram_flutter02/screens/timeline_screen.dart';
import 'package:instagram_flutter02/services/api/auth_service.dart';
import 'package:instagram_flutter02/utilities/constants.dart';

class HomeScreen extends StatefulWidget {
  // const HomeScreen({Key? key}) : super(key: key);
  final String? currentUid;

  HomeScreen({this.currentUid});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  PageController? pageController;
  int pageIndex = 0;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    configurePushNotifications();
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

  configurePushNotifications() {
    if (Platform.isIOS) getiOSPermission();

    _firebaseMessaging.getToken().then((token) {
      // print("Firebase Messaging Token: $token\n");
      usersRef
          .doc(widget.currentUid)
          .update({"androidNotificationToken": token});
    });

    // workaround for onLaunch: When the app is completely closed (not in the background) and opened directly from the push notification
    // _firebaseMessaging.getInitialMessage().then((RemoteMessage? message) {
    //   print('getInitialMessage data: ${message?.data}');
    //   // _serialiseAndNavigate(message);
    // });

    // // replacement for onResume: When the app is in the background and opened directly from the push notification.
    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? message) {
    //   print('onMessageOpenedApp data: ${message?.data}');
    //   // _serialiseAndNavigate(message);
    // });

    // onMessage: When the app is open and it receives a push notification
    FirebaseMessaging.onMessage.listen((RemoteMessage? message) {
      print("onMessage data: ${message?.data}");
      if (message == null) return;
      final String recipientId = message.data['recipient'];
      final String? body = message.notification?.body;

      if (recipientId == widget.currentUid) {
        // print("Notification shown!");
        SnackBar snackbar = SnackBar(
            content: Text(
          body!,
          overflow: TextOverflow.ellipsis,
        ));
        // _scaffoldKey.currentContext
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //   content: const Text('snack'),
        //   duration: const Duration(seconds: 1),
        //   action: SnackBarAction(
        //     label: 'ACTION',
        //     onPressed: () {},
        //   ),
        // ));
        print("snackBar: $body");
        _scaffoldKey.currentState?.showSnackBar(snackbar);
      }
    });
// *****************************************

    // _firebaseMessaging.configure(
    //   // onLaunch: (Map<String, dynamic> message) async {},
    //   // onResume: (Map<String, dynamic> message) async {},
    //   onMessage: (Map<String, dynamic> message) async {
    //     // print("on message: $message\n");
    //     final String recipientId = message['data']['recipient'];
    //     final String body = message['notification']['body'];
    //     if (recipientId == user.id) {
    //       // print("Notification shown!");
    //       SnackBar snackbar = SnackBar(
    //           content: Text(
    //         body,
    //         overflow: TextOverflow.ellipsis,
    //       ));
    //       _scaffoldKey.currentState.showSnackBar(snackbar);
    //     }
    //     // print("Notification NOT shown");
    //   },
    // );
  }

  getiOSPermission() {
    _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  Scaffold buildAuthScreen() {
    return Scaffold(
      key: _scaffoldKey,
      body: PageView(
        children: <Widget>[
          TimelineScreen(currentUid: widget.currentUid),
          CameraScreen(currentUid: widget.currentUid),
          ProfileScreen(currentUid: widget.currentUid),
          SignUpScreen(),
          Test3(),
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
            BottomNavigationBarItem(icon: Icon(Icons.email)),
          ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildAuthScreen();
  }
}
