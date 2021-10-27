import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_flutter02/common_widgets/header.dart';
import 'package:instagram_flutter02/common_widgets/progress.dart';
import 'package:instagram_flutter02/models/user_model.dart';
import 'package:instagram_flutter02/services/api/auth_service.dart';
import 'package:instagram_flutter02/utilities/constants.dart';

class EditProfileScreen extends StatefulWidget {
  String? currentUid;
  EditProfileScreen({this.currentUid});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController nameController = TextEditingController();
  int _radioSelected = 1;
  String _radioVal = '';
  File? file;
  String? profileImageUrl;
  dynamic dateOfBirth = {'year': '', "month": '', 'day': ''};
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (!mounted) return;
    getUser();
  }

  getUser() async {
    setState(() {
      isLoading = true;
    });
    final userModel = await getUserFromDB();
    nameController.text = userModel.name;
    profileImageUrl = userModel.profileImageUrl;
    dateOfBirth = {
      'year': userModel.dateOfBirth['year'],
      "month": userModel.dateOfBirth['month'],
      'day': userModel.dateOfBirth['day']
    };
    if (userModel.gender == FEMALE) {
      _radioSelected = 2;
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<UserModel> getUserFromDB() async {
    UserModel userModel = await AuthService.getUser(widget.currentUid!);
    return userModel;
  }

  buildProfileHeader() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                radius: 50.0,
                backgroundColor: Colors.grey,
                backgroundImage: getBackgroundImage(),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top: 2.0),
                      child: FlatButton(
                        onPressed: () => selectImage(),
                        child: Container(
                          width: 250.0,
                          height: 35.0,
                          child: Text(
                            '写真変更',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            border: Border.all(
                              color: Colors.grey,
                            ),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
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

  getBackgroundImage() {
    if (file != null) {
      return FileImage(file!);
    } else if (profileImageUrl != null) {
      return CachedNetworkImageProvider(profileImageUrl!);
    }

    // backgroundImage: FileImage(file!),
    //               backgroundImage: CachedNetworkImageProvider(
    //                   widget.userModel!.profileImageUrl),
    // return
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

  // upload() async {
  //   final downloadUrl = await uploadImage(this.file);
  //   print(widget.currentUid);

  //   postsRef.doc(postId).set({
  //     "id": postId,
  //     "uid": widget.currentUid,
  //     "photoUrl": downloadUrl,
  //     "likeCount": 0,
  //     "timestamp": timestamp,
  //     "caption": captionController.text,
  //     "likes": {},
  //   });
  // }

  Future<String> uploadImage(imageFile) async {
    final Reference storageRef = FirebaseStorage.instance.ref();
    final storedImage = await storageRef
        .child("post_${widget.currentUid}.jpg")
        .putFile(imageFile);
    final String downloadUrl = await storedImage.ref.getDownloadURL();
    return downloadUrl;
  }

  updateProfile() async {
    setState(() {
      isLoading = true;
    });
    String? downloadUrl = profileImageUrl;
    if (file != null) {
      downloadUrl = await uploadImage(file);
    }
    String gender = _radioSelected == 1 ? MALE : FEMALE;
    await usersRef.doc(widget.currentUid).update({
      'dateOfBirth': dateOfBirth,
      'gender': gender,
      'name': nameController.text,
      'profileImageUrl': downloadUrl,
    });
    setState(() {
      isLoading = false;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, titleText: "Profile"),
      body: isLoading
          ? circularProgress()
          : ListView(
              children: <Widget>[
                buildProfileHeader(),
                // Padding(
                //   padding: EdgeInsets.only(top: 10.0),
                // ),

                Container(
                  padding: const EdgeInsets.all(20.0),
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      hintText: "名前を入れてください。",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    print("Container clicked");
                    var datePicked = await DatePicker.showSimpleDatePicker(
                      context,
                      initialDate: DateTime(1994),
                      firstDate: DateTime(1960),
                      lastDate: DateTime(2020),
                      dateFormat: "dd-MMMM-yyyy",
                      locale: DateTimePickerLocale.jp,
                      looping: true,
                    );
                    dateOfBirth['year'] = datePicked!.year.toString();
                    dateOfBirth['month'] = datePicked.month.toString();
                    dateOfBirth['day'] = datePicked.day.toString();

                    setState(() {});
                  },
                  child: Container(
                    padding: const EdgeInsets.all(20.0),
                    height: 100.0,
                    // width: MediaQuery.of(context).size.width * 0.8,
                    child: Center(
                        child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                      ),
                      child: Container(
                          child: Center(
                        child: Text(
                            '${dateOfBirth['year']}年${dateOfBirth['month']}月${dateOfBirth['day']}日'),
                      )),
                    )),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('男'),
                    Radio(
                      value: 1,
                      groupValue: _radioSelected,
                      activeColor: Colors.blue,
                      onChanged: (value) {
                        setState(() {
                          _radioSelected = 1;
                          _radioVal = MALE;
                        });
                      },
                    ),
                    Text('女'),
                    Radio(
                      value: 2,
                      groupValue: _radioSelected,
                      activeColor: Colors.pink,
                      onChanged: (value) {
                        setState(() {
                          _radioSelected = 2;
                          _radioVal = FEMALE;
                        });
                      },
                    )
                  ],
                ),
                Container(
                  padding: EdgeInsets.only(top: 20.0),
                  child: FlatButton(
                    onPressed: () => updateProfile(),
                    child: Container(
                      width: 280.0,
                      height: 40.0,
                      child: Text(
                        '更新ボタン',
                        style: TextStyle(
                          color: true ? Colors.black : Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: true ? Colors.blue : Colors.blue,
                        border: Border.all(
                          color: true ? Colors.grey : Colors.blue,
                        ),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                )
                // buildpostType(),
                // _buildGridPosts(),
                // RefreshIndicator(
                //     onRefresh: () => queryPosts(), child: _buildDisplayPosts())
                // PostGridView(posts: []),
              ],
            ),
    );
  }
}
