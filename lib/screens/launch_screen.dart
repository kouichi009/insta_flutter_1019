import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter02/screens/home_screen.dart';
import 'package:instagram_flutter02/screens/login_screen.dart';
import 'package:instagram_flutter02/services/api/auth_service.dart';

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({Key? key}) : super(key: key);

  @override
  _LaunchScreenState createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  authCheckNextPage() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, streamSnapshot) {
        // Authentication Connection Error
        // if (streamSnapshot.hasError) {
        //   return ErrorSplash(
        //       text: "Something went wrong. Please try again later.");
        // }

        // Authentication Connection Successful -> Internet Connection Check
        if (streamSnapshot.connectionState == ConnectionState.active) {
          User? currentUser = streamSnapshot.data as User?;
          // FirebaseAuth.instance.signOut();

          // No User
          if (currentUser != null) {
            return HomeScreen(currentUid: currentUser.uid);
          }

          // // Unverified User
          // else if (!FirebaseAuth.instance.currentUser.emailVerified) {
          //   timer = Timer.periodic(Duration(seconds: 3), (timer) async {
          //     checkEmailVerified();
          //   });
          //   return EmailVerification(
          //       emailAddress: FirebaseAuth.instance.currentUser.email);
          // }

        }

        // UnAuthUser
        return LoginScreen();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return authCheckNextPage();
  }
}
