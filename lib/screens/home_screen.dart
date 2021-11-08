import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter02/providers/bottom_navigation_bar_provider.dart';
import 'package:instagram_flutter02/screens/camera_screen.dart';
import 'package:instagram_flutter02/screens/edit_profile_screen.dart';
import 'package:instagram_flutter02/screens/login_screen.dart';
import 'package:instagram_flutter02/screens/news_api/news_screen.dart';

import 'package:instagram_flutter02/screens/profile_screen.dart';
import 'package:instagram_flutter02/screens/sign_up_screen.dart';
import 'package:instagram_flutter02/screens/timeline_screen.dart';
import 'package:instagram_flutter02/services/api/auth_service.dart';
import 'package:instagram_flutter02/utilities/constants.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  // const HomeScreen({Key? key}) : super(key: key);

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  var currentTab = [
    TimelineScreen(),
    CameraScreen(),
    ProfileScreen(),
    SignUpScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final bottomNavigationBar = context.watch<BottomNavigationBarProvider>();

    // final bottomNavigationBar =
    //     Provider.of<BottomNavigationBarProvider>(context);
    return Scaffold(
      body: currentTab[bottomNavigationBar.currentIndex],
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: bottomNavigationBar.currentIndex,
        onTap: (index) {
          bottomNavigationBar.currentIndex = index;
        },
        activeColor: Theme.of(context).primaryColor,
        // type: BottomNavigationBarType.fixed,
        // selectedItemColor: Colors.blue,
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
        ],
      ),
    );
    // return Container();
  }
}
