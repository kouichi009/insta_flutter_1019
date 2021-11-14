import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter02/models/post.dart';
import 'package:instagram_flutter02/models/user_model.dart';

class UserModelViewModel {
  final UserModel? userModel;

  UserModelViewModel({this.userModel});

  String? get uid {
    return userModel?.uid;
  }

  String? get name {
    return userModel?.name;
  }

  String? get profileImageUrl {
    return userModel?.profileImageUrl;
  }

  Map<String, dynamic>? get dateOfBirth {
    return userModel?.dateOfBirth;
  }

  String? get gender {
    return userModel?.gender;
  }

  Timestamp? get timestamp {
    return userModel?.timestamp;
  }

  String? get androidNotificationToken {
    return userModel?.androidNotificationToken;
  }

  int? get status {
    return userModel?.status;
  }
}
