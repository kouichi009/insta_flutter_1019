import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String name;
  final String profileImageUrl;
  final String email;
  final String bio;
  final String token;
  final bool isBanned;
  final String role;
  final bool isVerified;
  final String website;
  final Timestamp timeCreated;

  UserModel({
    required this.id,
    required this.name,
    required this.profileImageUrl,
    required this.email,
    required this.bio,
    required this.token,
    required this.isBanned,
    required this.isVerified,
    required this.website,
    required this.role,
    required this.timeCreated,
  });

  factory UserModel.fromDoc(DocumentSnapshot doc) {
    return UserModel(
      id: 'doc.documentID',
      name: doc['name'],
      profileImageUrl: doc['profileImageUrl'],
      email: doc['email'],
      bio: doc['bio'] ?? '',
      token: doc['token'] ?? '',
      isVerified: doc['isVerified'] ?? false,
      isBanned: doc['isBanned'],
      website: doc['website'] ?? '',
      role: doc['role'] ?? 'user',
      timeCreated: doc['timeCreated'],
    );
  }
}
