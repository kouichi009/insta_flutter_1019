import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String profileImageUrl;
  final String dateOfBirth;
  final String gender;
  final Timestamp timestamp;

  UserModel({
    required this.uid,
    required this.name,
    required this.profileImageUrl,
    required this.dateOfBirth,
    required this.gender,
    required this.timestamp,
  });

  factory UserModel.fromDoc(DocumentSnapshot doc) {
    return UserModel(
      uid: doc['uid'],
      name: doc['name'],
      profileImageUrl: doc['profileImageUrl'],
      dateOfBirth: doc['dateOfBirth'],
      gender: doc['gender'],
      timestamp: doc['timestamp'],
    );
  }
}
