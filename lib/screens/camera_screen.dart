import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_flutter02/utilities/constants.dart';
import 'package:instagram_flutter02/utilities/themes.dart';
import 'package:uuid/uuid.dart';

import 'home_screen.dart';

class CameraScreen extends StatefulWidget {
  String? currentUid;

  CameraScreen({this.currentUid});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  TextEditingController captionController = TextEditingController();

  File? file;
  bool isUploading = false;
  String postId = Uuid().v4();

  Scaffold buildUploadForm() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white70,
        title: Text(
          "Caption Post",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: ListView(
        children: <Widget>[
          // isUploading ? Text("13") : Text(""),
          GestureDetector(
            onTap: () {
              print("Container clicked");
              selectImage();
            },
            child: Container(
              padding: const EdgeInsets.all(5.0),
              height: 220.0,
              // width: MediaQuery.of(context).size.width * 0.8,
              child: Center(
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: (file == null)
                      ? (Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                          ),
                          child: Container(
                              child: Center(
                            child: const Text("Containerの枠線"),
                          )),
                        ))
                      : Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.yellow),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: FileImage(file!),
                              ),
                            ),
                          ),
                        ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
          ),

          Container(
            padding: const EdgeInsets.all(5.0),
            child: TextField(
              maxLines: null,
              controller: captionController,
              decoration: InputDecoration(
                hintText: "ここに本文を入力してください。",
                border: OutlineInputBorder(),
              ),
            ),
          ),

          SizedBox(height: 20.0),
          Container(
            padding: const EdgeInsets.all(35.0),
            height: 130.0,
            child: FlatButton(
              onPressed: () => upload(),
              // print('push login button@@@@@'),
              color: Colors.orange,
              padding: const EdgeInsets.all(10.0),
              child: Text(
                '投稿',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ),
          // ButtonTheme(
          //   width: 50.0,
          //   height: 100.0,
          //   child: RaisedButton(
          //     onPressed: () {},
          //     child: Text("test"),
          //   ),
          // ),
        ],
      ),
    );
  }

  handleImage(type) async {
    print("handleimage $type");
    Navigator.pop(context);
    ImageSource imageSource;
    if (type == 'camera') {
      imageSource = ImageSource.camera;
    } else {
      imageSource = ImageSource.gallery;
    }

    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? file = await _picker.pickImage(source: imageSource);
    if (file == null) return;
    final imageTemporary = File(file.path);
    setState(() {
      this.file = imageTemporary;
    });
  }

  Future<String> uploadImage(imageFile) async {
    final Reference storageRef = FirebaseStorage.instance.ref();
    final storedImage =
        await storageRef.child("post_$postId.jpg").putFile(imageFile);
    final String downloadUrl = await storedImage.ref.getDownloadURL();
    return downloadUrl;
  }

  selectImage() {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text("Create Post"),
          children: <Widget>[
            SimpleDialogOption(
                child: Text("Photo with Camera"),
                onPressed: () => handleImage('camera')),
            SimpleDialogOption(
                child: Text("Image from Gallery"),
                onPressed: () => handleImage('gallery')),
            SimpleDialogOption(
              child: Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            )
          ],
        );
      },
    );
  }

  upload() async {
    final downloadUrl = await uploadImage(this.file);
    print(widget.currentUid);

    postsRef.doc(postId).set({
      "id": postId,
      "uid": widget.currentUid,
      "photoUrl": downloadUrl,
      "likeCount": 0,
      "timestamp": timestamp,
      "caption": captionController.text,
      "likes": {},
    });
  }

  @override
  Widget build(BuildContext context) {
    return buildUploadForm();
  }
}
