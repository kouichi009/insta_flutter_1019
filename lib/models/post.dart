import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String id;
  final String name;
  final String mediaUrl;
  final String ownerId;
  final dynamic likes;
  // final String token;
  // final bool isBanned;
  // final String role;
  // final bool isVerified;
  // final String website;
  // final Timestamp timeCreated;

  Post({
    required this.id,
    required this.name,
    required this.mediaUrl,
    required this.ownerId,
    required this.likes,
    // required this.bio,
    // required this.token,
    // required this.isBanned,
    // required this.isVerified,
    // required this.website,
    // required this.role,
    // required this.timeCreated,
  });

  factory Post.fromDoc(DocumentSnapshot doc) {
    return Post(
      id: 'doc.documentID',
      name: doc['name'],
      mediaUrl: doc['mediaUrl'],
      ownerId: doc['ownerId'],
      likes: doc['likes'],

      // email: doc['email'],
      // bio: doc['bio'] ?? '',
      // token: doc['token'] ?? '',
      // isVerified: doc['isVerified'] ?? false,
      // isBanned: doc['isBanned'],
      // website: doc['website'] ?? '',
      // role: doc['role'] ?? 'user',
      // timeCreated: doc['timeCreated'],
    );
  }
}
