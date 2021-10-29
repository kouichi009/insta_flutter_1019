import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_flutter02/common_widgets/app_header.dart';
import 'package:instagram_flutter02/common_widgets/progress.dart';
import 'package:instagram_flutter02/common_widgets/select_image_dialog.dart';
import 'package:instagram_flutter02/screens/launch_screen.dart';
import 'package:instagram_flutter02/services/api/post_service.dart';
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
  String postId = Uuid().v4();
  bool isUploading = false;

  Scaffold buildUploadForm() {
    return Scaffold(
      appBar: AppHeader(
        isAppTitle: false,
        titleText: '投稿ページ',
      ),
      body: ListView(
        children: <Widget>[
          isUploading ? linearProgress() : Text(""),
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
              onPressed: isUploading ? null : () => upload(),
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
        ],
      ),
    );
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

  handleImage(type) async {
    print("handleimage888 $type");
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

  upload() async {
    setState(() {
      isUploading = true;
    });
    final downloadUrl = await uploadImage(this.file);
    print(widget.currentUid);
    await PostService.uploadPost(
        postId, widget.currentUid, downloadUrl, captionController.text);
    setState(() {
      isUploading = false;
    });
    print('upload2@@@@@');

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LaunchScreen()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildUploadForm();
  }
}
