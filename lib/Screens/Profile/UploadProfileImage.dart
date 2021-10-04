import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hookup4u/util/color.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hookup4u/util/snackbar.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as imagePack;

import '../AllowLocation.dart';

var defaultImageUrl = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSxUC64VZctJ0un9UBnbUKtj-blhw02PeDEQIMOqovc215LWYKu&s';

class UploadProfileImage extends StatefulWidget {
  final Map<String, dynamic> userData;
  UploadProfileImage(this.userData);
  @override
  _UploadProfileImageState createState() => _UploadProfileImageState();
}

class _UploadProfileImageState extends State<UploadProfileImage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var profileImageUrl = '';

  @override
  void initState() {
    super.initState();
    setUserId();
  }

  setUserId() async {
    await getUserId();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double sizeOfPhoto = MediaQuery.of(context).size.width * 0.64;
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: AnimatedOpacity(
        opacity: 1.0,
        duration: Duration(milliseconds: 50),
        child: Padding(
          padding: EdgeInsets.only(top: 16.0),
          child: FloatingActionButton(
            elevation: 2,
            child: IconButton(
              color: Colors.white,
              icon: Padding(
                padding: EdgeInsets.only(left: 6.0),
                child: Icon(Icons.arrow_back_ios, size: 28,),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            backgroundColor: goldBtnColorDark,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Image.asset(
              'asset/images/s9.png',
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fitWidth,
            ),
          ),
          ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 64, sigmaY: 64),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200.withOpacity(0.06),
                  // color: Colors.black.withOpacity(0.4),
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  child: Center(
                    child: Text(
                      "Upload profile picture".tr().toString(),
                      style: TextStyle(fontSize: 28, color: Colors.white.withOpacity(0.95)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  padding: EdgeInsets.only(top: 148),
                ),
                SizedBox(height: 64,),
                InkWell(
                  onTap: (){
                    selectSourceImage(context);
                  },
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18,),
                      child: profileImageUrl.isNotEmpty ? Container(
                        width: sizeOfPhoto,
                        height: sizeOfPhoto,
                        child: Image.network(
                          profileImageUrl,
                          width: sizeOfPhoto,
                          height: sizeOfPhoto,
                          fit: BoxFit.cover,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(18)),
                          color: Colors.white
                        ),
                      ):
                      Center(
                        child: Container(
                          width: sizeOfPhoto,
                          height: sizeOfPhoto,
                          child: Center(
                            child: Icon(Icons.add_circle_sharp, size: 46, color: goldBtnColorDark,),
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(24)),
                            color: Colors.white
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                profileImageUrl.isNotEmpty ? Padding(
                  padding: EdgeInsets.only(left: 30, right: 24, top: 124),
                  child: OutlineButton(
                    child: Container(
                      height: MediaQuery.of(context).size.height * .062,
                      width: MediaQuery.of(context).size.width * .74,
                      child: Center(
                        child: Text(
                          "CONTINUE".tr().toString(),
                          style: TextStyle(
                            fontSize: 15,
                            color: goldBtnColorDark,
                            fontWeight: FontWeight.bold
                          ),
                        )
                      ),
                      color: Colors.transparent,
                    ),
                    borderSide: BorderSide(
                      width: 2,
                      style: BorderStyle.solid,
                      color: goldBtnColorDark
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)
                    ),
                    onPressed: () {
                      gotoLocationPage();
                    },
                  ),
                ):
                Padding(
                  padding: EdgeInsets.only(left: 30, right: 24, top: 124),
                  child: OutlineButton(
                    child: Container(
                      height: MediaQuery.of(context).size.height * .062,
                      width: MediaQuery.of(context).size.width * .74,
                      child: Center(
                        child: Text(
                          "CONTINUE".tr().toString(),
                          style: TextStyle(
                            fontSize: 15,
                            color: secondaryColor,
                            fontWeight: FontWeight.bold
                          ),
                        )
                      ),
                      color: Colors.transparent,
                    ),
                    borderSide: BorderSide(
                      width: 2,
                      style: BorderStyle.solid,
                      color: secondaryColor
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)
                    ),
                    onPressed: () {},
                  ),
                )
              ],
            ),
          ),
        ]
      ),
    );
  }

  Future getUserId() async {
    await FirebaseAuth.instance.currentUser().then((FirebaseUser user) async {
      widget.userData.addAll({'userId': user.uid});
    });
  }

  Future selectSourceImage(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Container(
            padding: EdgeInsets.only(top: 12, bottom: 32),
            child: Text(
              "Select pictures".tr().toString(),
              style: TextStyle(
                fontSize: 22
              ),
            ),
          ),
          content: Text(
            "Select source".tr().toString(),
            style: TextStyle(
              fontSize: 18
            ),
          ),
          insetAnimationCurve: Curves.decelerate,
          actions: <Widget>[ Container(
            color: goldBtnColorDark,
            child: Padding(
              padding: EdgeInsets.all(12.0),
              child: GestureDetector(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.photo_camera,
                      size: 28,
                    ),
                    Text(
                      " Camera".tr().toString(),
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        decoration: TextDecoration.none
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (context) {
                      getImageResource(
                        ImageSource.camera,
                        context,
                      );
                      return Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      );
                    }
                  );
                },
              ),
            ),
          ),
          Container(
            color: goldBtnColorDark,
            child: Padding(
              padding: EdgeInsets.all(12.0),
              child: GestureDetector(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.photo_library,
                      size: 28,
                    ),
                    Text(
                      " Gallery".tr().toString(),
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        decoration: TextDecoration.none
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      getImageResource(
                        ImageSource.gallery,
                        context,
                      );
                      return Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      );
                    }
                  );
                },
                ),
              ),
            ),
          ]
        );
      }
    );
  }

  Future getImageResource(ImageSource imageSource, context) async {
    try {
      var image = await ImagePicker.pickImage(source: imageSource);
      if (image != null) {
        File croppedFile = await ImageCropper.cropImage(
          sourcePath: image.path,
          cropStyle: CropStyle.circle,
          aspectRatioPresets: [CropAspectRatioPreset.square],
          androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Crop',
            toolbarColor: primaryColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true
          ),
          iosUiSettings: IOSUiSettings(
            minimumAspectRatio: 1.0,
          )
        );
        if (croppedFile != null) {
          await uploadProfileImage(await compressImage(croppedFile));
        }
      }
      Navigator.pop(context);
    } catch (e) {
      Navigator.pop(context);
    }
  }

  Future uploadProfileImage(File image) async {
    StorageReference storageReference = FirebaseStorage.instance.ref()
      .child('users/${widget.userData['userId']}/${image.hashCode}.jpg');

    StorageUploadTask uploadTask = storageReference.putFile(image);
    if (await uploadTask.onComplete != null) {
      storageReference.getDownloadURL().then((fileURL) async {
        try {
          profileImageUrl = fileURL;
          Map<String, dynamic> profileImage = {
            "Pictures": FieldValue.arrayUnion([
              profileImageUrl,
            ])
          };
          widget.userData.addAll(profileImage);
          CustomSnackbar.snackbar(
            "Profile Image uploaded successfully".tr().toString(),
            _scaffoldKey
          );
          setState(() {});
        } catch (err) {
          print("Error: $err");
        }
      });
    }
  }

  Future compressImage(File image) async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    imagePack.Image imageFile = imagePack.decodeImage(image.readAsBytesSync());
    final compressedImageFile = File('$path.jpg')
      ..writeAsBytesSync(imagePack.encodeJpg(imageFile, quality: 80));
    return compressedImageFile;
  }

  gotoLocationPage(){
    Navigator.push(context, CupertinoPageRoute(
        builder: (context) => AllowLocation(widget.userData)
      )
    );
  }
}
