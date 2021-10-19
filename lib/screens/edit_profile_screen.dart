import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final String text =
      '123456789123456789123456789123456789123456789123456789123456789123456789123456789123456789123456789123456789123456789123456789123456789123456789123456789';
  final int maxLines = 2;
  bool _isExpanded = false;

  @override
  // Widget build(BuildContext context) {
  //   return Container(child: Text('Edit Profile Screen!'));
  // }
  Widget build(BuildContext context) => GestureDetector(
        onTap: () {
          setState(() {
            _isExpanded = !_isExpanded;
            print(_isExpanded);
          });
        },
        child: Container(
          child: Container(
            padding: const EdgeInsets.only(top: 110),
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
              maxLines: _isExpanded ? null : maxLines,
            ),
          ),
        ),
      );
}
