import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image/image.dart' as i;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hookup4u/models/UserModel.dart';
import 'package:hookup4u/util/color.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:easy_localization/easy_localization.dart';

var heightValues = {
  '< 4.92',
  '<= 4.92 and < 5.08',
  '<= 5.08 and < 5.24',
  '<= 5.24 and < 5.41',
  '<= 5.41 and < 5.57',
  '<= 5.57 and < 5.74',
  '<= 5.74 and < 5.90',
  '<= 5.90 and < 6.06',
  '<= 6.06 and < 6.23',
  '<= 6.23'
};

var ethnicityValues = {
  'Asian',
  'Black',
  'Hispanic/Latin',
  'Indian',
  'Middle Eastern',
  'Native American',
  'Pacific Islander',
  'White',
  'Other'
};

var languages = {
  'English',
  'Italian',
  'Spanish',
  'French',
  'Russian',
  'Danish',
  'Portuguese',
  'Dutch',
  'Chinese',
  'Japanese',
  'Korean',
  'Hindi',
  'Latin',
};

var smokingHabitValues = {
  'No',
  'Sometimes',
  'Yes'
};

var connectionValues = {
  'Long term relationship',
  'New friends',
  'Something casual'
};

var religionValues = {
  'Agnostic',
  'Atheist',
  'Christianity',
  'Judaism',
  'Catholicism',
  'Islam',
  'Hinduism',
  'Buddhism',
  'Sikh',
  'Other',
};

var drinkingValues = {
  'No',
  'Sometimes',
  'Yes'
};

var marryRels = {
  'I am a single',
  'I have married'
};

class EditProfile extends StatefulWidget {
  final UserModel currentUser;
  EditProfile(this.currentUser);

  @override
  EditProfileState createState() => EditProfileState();
}

class EditProfileState extends State<EditProfile> {
  final TextEditingController userNameCtrl = new TextEditingController();
  final TextEditingController aboutCtrl = new TextEditingController();
  final TextEditingController companyCtrl = new TextEditingController();
  final TextEditingController livingCtrl = new TextEditingController();
  final TextEditingController heightCtrl = new TextEditingController();
  final TextEditingController ethnicityCtrl = new TextEditingController();
  final TextEditingController incomeCtrl = new TextEditingController();
  final TextEditingController jobCtrl = new TextEditingController();
  final TextEditingController universityCtrl = new TextEditingController();

  bool visibleAge = false;
  bool visibleDistance = true;

  var showMe;
  Map editInfo = {};

  var marryRef = '';
  List<String> marryRefs = [];

  var heightVal = '';
  List<String> heights = [];

  var ethnicityVal = '';
  List<String> ethnicities = [];

  var speakVal = '';
  List<String> speaks = [];

  var smokingVal = '';
  List<String> smokingHabits = [];

  var connectionVal = '';
  List<String> connections = [];

  var religionVal = '';
  List<String> religions = [];

  var drinkingVal = '';
  List<String> drinkingHabits = [];

  @override
  void initState() {
    super.initState();

    heights.clear();
    for(var i=0; i<heightValues.length; i++){
      heights.add(heightValues.elementAt(i));
    }

    ethnicities.clear();
    for(var i=0; i<ethnicityValues.length; i++){
      ethnicities.add(ethnicityValues.elementAt(i));
    }

    speaks.clear();
    for(var i=0; i<languages.length; i++){
      speaks.add(languages.elementAt(i));
    }

    smokingHabits.clear();
    for(var i=0; i<smokingHabitValues.length; i++){
      smokingHabits.add(smokingHabitValues.elementAt(i));
    }

    connections.clear();
    for(var i=0; i<connectionValues.length; i++){
      connections.add(connectionValues.elementAt(i));
    }

    religions.clear();
    for(var i=0; i<religionValues.length; i++){
      religions.add(religionValues.elementAt(i));
    }

    drinkingHabits.clear();
    for(var i=0; i<drinkingValues.length; i++){
      drinkingHabits.add(drinkingValues.elementAt(i));
    }

    marryRefs.clear();
    for(var i=0; i<marryRels.length; i++){
      marryRefs.add(marryRels.elementAt(i));
    }

    heightVal = '';
    if(widget.currentUser.editInfo.containsKey('height')){
      heightVal = widget.currentUser.editInfo['height'];
    }

    ethnicityVal = '';
    if(widget.currentUser.editInfo.containsKey('Ethnicity')){
      ethnicityVal = widget.currentUser.editInfo['Ethnicity'];
    }

    incomeCtrl.text = '';
    if(widget.currentUser.editInfo.containsKey('IncomeAnnual')){
      incomeCtrl.text = widget.currentUser.editInfo['IncomeAnnual'];
    }

    livingCtrl.text = '';
    if(widget.currentUser.editInfo.containsKey('living_in')){
      livingCtrl.text = widget.currentUser.editInfo['living_in'];
    }

    jobCtrl.text = '';
    if(widget.currentUser.editInfo.containsKey('job_title')){
      jobCtrl.text = widget.currentUser.editInfo['job_title'];
    }

    companyCtrl.text = '';
    if(widget.currentUser.editInfo.containsKey('company')){
      companyCtrl.text = widget.currentUser.editInfo['company'];
    }

    universityCtrl.text = '';
    if(widget.currentUser.editInfo.containsKey('university')){
      universityCtrl.text = widget.currentUser.editInfo['university'];
    }

    speakVal = '';
    if(widget.currentUser.editInfo.containsKey('speaks')){
      speakVal = widget.currentUser.editInfo['speaks'];
    }

    smokingVal = '';
    if(widget.currentUser.editInfo.containsKey('smokingHabit')){
      smokingVal = widget.currentUser.editInfo['smokingHabit'];
    }

    connectionVal = '';
    if(widget.currentUser.editInfo.containsKey('connections')){
      connectionVal = widget.currentUser.editInfo['connections'];
    }

    religionVal = '';
    if(widget.currentUser.editInfo.containsKey('religions')){
      religionVal = widget.currentUser.editInfo['religions'];
    }

    drinkingVal = '';
    if(widget.currentUser.editInfo.containsKey('drinkingHabit')){
      drinkingVal = widget.currentUser.editInfo['drinkingHabit'];
    }

    marryRef = '';
    if(widget.currentUser.editInfo.containsKey('married')){
      marryRef = widget.currentUser.editInfo['married'];
    }

    userNameCtrl.text = widget.currentUser.name;
    aboutCtrl.text = widget.currentUser.editInfo['about'];

    setState(() {
      showMe = widget.currentUser.editInfo['userGender'];
      visibleAge = widget.currentUser.editInfo['showMyAge'] ?? false;
      visibleDistance = widget.currentUser.editInfo['DistanceVisible'] ?? true;
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    updateData();
  }

  Future updateData() async {
    if(userNameCtrl.text != ''){
      Firestore.instance.collection("Users")
        .document(widget.currentUser.id)
        .setData({
          'UserName': userNameCtrl.text,
          'age': widget.currentUser.age,
        }, merge: true
      );
    }

    if (editInfo.length > 0) {
      Firestore.instance.collection("Users")
        .document(widget.currentUser.id)
        .setData({
        'editInfo': editInfo,
        }, merge: true
      );
    }
  }

  Future source(BuildContext context, currentUser, bool isProfilePicture) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(
            isProfilePicture ? "Update profile picture".tr().toString() : "Add pictures".tr().toString()
          ),
          content: Text(
            "Select source".tr().toString(),
          ),
          insetAnimationCurve: Curves.decelerate,
          actions: currentUser.imageUrl.length < 9 ? <Widget>[ Container(
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
                      getImage(
                        ImageSource.camera,
                        context,
                        currentUser,
                        isProfilePicture
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
                      getImage(
                        ImageSource.gallery,
                        context,
                        currentUser,
                        isProfilePicture
                      );
                      return Center(
                        child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ));
                    }
                  );
                },
              ),
            ),
          ),
        ]: [
        Padding(
          padding: EdgeInsets.all(25.0),
          child: Center(
            child: Column(
              children: <Widget>[
                Icon(Icons.error),
                Text(
                  "Can't uplaod more than 9 pictures".tr().toString(),
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    decoration: TextDecoration.none
                  ),
                ),
              ],
            )
          ),)]
        );
      }
    );
  }

  Future getImage(
      ImageSource imageSource, context, currentUser, isProfilePicture) async {
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
          await uploadFile(
            await compressImage(croppedFile), currentUser, isProfilePicture);
        }
      }
      Navigator.pop(context);
    } catch (e) {
      Navigator.pop(context);
    }
  }

  Future uploadFile(File image, UserModel currentUser, isProfilePicture) async {
    StorageReference storageReference = FirebaseStorage.instance.ref()
      .child('users/${currentUser.id}/${image.hashCode}.jpg');
    StorageUploadTask uploadTask = storageReference.putFile(image);
    if (uploadTask.isInProgress == true) {}
    if (await uploadTask.onComplete != null) {
      storageReference.getDownloadURL().then((fileURL) async {
        Map<String, dynamic> updateObject = {
          "Pictures": FieldValue.arrayUnion([
            fileURL,
          ])
        };
        try {
          if (isProfilePicture) {
            currentUser.imageUrl.insert(0, fileURL);
            await Firestore.instance
              .collection("Users")
              .document(currentUser.id)
              .setData({"Pictures": currentUser.imageUrl}, merge: true);
          } else {
            await Firestore.instance
              .collection("Users")
              .document(currentUser.id)
              .setData(updateObject, merge: true);
            widget.currentUser.imageUrl.add(fileURL);
          }
          if (mounted) setState(() {});
        } catch (err) {
          print("Error: $err");
        }
      });
    }
  }

  Future compressImage(File image) async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    i.Image imageFile = i.decodeImage(image.readAsBytesSync());
    final compressedImageFile = File('$path.jpg')
      ..writeAsBytesSync(i.encodeJpg(imageFile, quality: 80));
    return compressedImageFile;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: primaryColor.withOpacity(0.88),
        appBar: AppBar(
          elevation: 0,
          title: Text(
            "Edit Profile".tr().toString(),
            style: TextStyle(color: goldBtnColorDark),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: goldBtnColorDark,
            onPressed: () {
              if(userNameCtrl.text == ''){

              }else{
                Navigator.pop(context);
              }
            }
          ),
          backgroundColor: primaryColor),
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 16,
                ),
                Container(
                  color: mainBlackColor.withOpacity(0.64),
                  width: MediaQuery.of(context).size.width,
                  height: 48,
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 18),
                    child: Text(
                      "My Medias".tr().toString(),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.withOpacity(0.8)
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height * .65,
                  width: MediaQuery.of(context).size.width,
                  child: GridView.count(
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    childAspectRatio: MediaQuery.of(context).size.aspectRatio * 1.5,
                    crossAxisSpacing: 4,
                    padding: EdgeInsets.all(10),
                    children: List.generate(9, (index) {
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Stack(
                            children: <Widget>[
                              widget.currentUser.imageUrl.length > index ? ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                  height: MediaQuery.of(context).size.height * .2,
                                  fit: BoxFit.cover,
                                  imageUrl: widget.currentUser.imageUrl[index] ?? '',
                                  placeholder: (context, url) => Center(
                                    child: CupertinoActivityIndicator(
                                      radius: 10,
                                    ),
                                  ),
                                  errorWidget: (context, url, error) => Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(
                                          Icons.error,
                                          color: Colors.black,
                                          size: 24,
                                        ),
                                        Text(
                                          "Enable to load".tr().toString(),
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ):
                              Container(),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Padding(
                                  padding: EdgeInsets.only(right: 4, bottom: 4),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: widget.currentUser.imageUrl.length > index ? Colors.white
                                        : primaryColor,
                                    ),
                                    child: widget.currentUser.imageUrl.length > index ? InkWell(
                                      child: Icon(
                                        Icons.cancel,
                                        color: primaryColor,
                                        size: 24,
                                      ),
                                      onTap: () async {
                                        if (widget.currentUser.imageUrl.length > 1) {
                                          _deletePicture(index);
                                        }else {
                                          source(
                                            context,
                                            widget.currentUser,
                                            true
                                          );
                                        }
                                      },
                                    ) :
                                    InkWell(
                                      child: Icon(
                                        Icons.add_circle_outline,
                                        size: 24,
                                        color: Colors.white,
                                      ),
                                      onTap: () => source(
                                        context,
                                        widget.currentUser,
                                        false
                                      ),
                                    )
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    })
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                InkWell(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(22),
                      color: goldBtnColorDark,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black54,
                          offset: Offset(0.0, 1.0), //(x,y)
                          blurRadius: 0.2,
                        ),
                      ],
                    ),
                    height: 44,
                    width: 340,
                    child: Center(
                      child: Text(
                        "Add media".tr().toString(),
                        style: TextStyle(
                          fontSize: 15,
                          color: textColor,
                          fontWeight: FontWeight.bold
                        ),
                      )
                    )
                  ),
                  onTap: () async {
                    await source(context, widget.currentUser, false);
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  color: mainBlackColor.withOpacity(0.64),
                  width: MediaQuery.of(context).size.width,
                  height: 48,
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 18),
                    child: Text(
                      "User Information".tr().toString(),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.withOpacity(0.8)
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                ListBody(
                  mainAxis: Axis.vertical,
                  children: <Widget>[
                    ListTile(
                      title: Container(
                        margin: EdgeInsets.only(bottom: 6, left: 4, right: 4),
                        child: Text(
                          "User Name".tr().toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 17,
                            color: Colors.white
                          ),
                        ),
                      ),
                      subtitle: CupertinoTextField(
                        controller: userNameCtrl,
                        cursorColor: Colors.white,
                        style: TextStyle(
                          color: goldBtnColorDark
                        ),
                        placeholder: "Enter your username".tr().toString(),
                        placeholderStyle: TextStyle(
                          color: Colors.grey
                        ),
                        padding: EdgeInsets.all(10),
                        onChanged: (text) {
                          userNameCtrl.text = text;
                        },
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      width: MediaQuery.of(context).size.width,
                      height: 0.88,
                      color: goldBtnColorDark.withOpacity(0.75),
                    ),
                    SizedBox(height: 12,),
                    ListTile(
                      title: Container(
                        margin: EdgeInsets.only(left: 4, right: 4),
                        child: Text(
                          "About Me",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 17,
                              color: Colors.white
                          ),
                        ).tr(),
                      ),
                      subtitle: CupertinoTextField(
                        controller: aboutCtrl,
                        maxLines: 10,
                        minLines: 3,
                        placeholder: "About you".tr().toString(),
                        placeholderStyle: TextStyle(
                            color: Colors.grey
                        ),
                        padding: EdgeInsets.all(10),
                        onChanged: (text) {
                          editInfo.addAll({'about': text});
                        },
                        cursorColor: Colors.white,
                        style: TextStyle(
                            color: goldBtnColorDark
                        ),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      width: MediaQuery.of(context).size.width,
                      height: 0.88,
                      color: goldBtnColorDark.withOpacity(0.75),
                    ),
                    SizedBox(height: 10,),
                    Container(
                      margin: EdgeInsets.only(left: 4, right: 4),
                      child: ListTile(
                        title: Text(
                          "Gender".tr().toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 17,
                              color: Colors.white
                          ),
                        ),
                        subtitle: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: DropdownButton(
                            iconEnabledColor: goldBtnColorDark,
                            iconDisabledColor: goldBtnColorDark,
                            isExpanded: true,
                            items: [
                              DropdownMenuItem(
                                child: Text("Man".tr().toString(), style: TextStyle(color: goldBtnColorDark),),
                                value: "man",
                              ),
                              DropdownMenuItem(
                                  child: Text("Woman".tr().toString(), style: TextStyle(color: goldBtnColorDark),),
                                  value: "woman"
                              ),
                              DropdownMenuItem(
                                  child: Text("Other".tr().toString(), style: TextStyle(color: goldBtnColorDark),),
                                  value: "other"
                              ),
                            ],
                            onChanged: (val) {
                              editInfo.addAll({'userGender': val});
                              setState(() {
                                showMe = val;
                              });
                            },
                            value: showMe,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    ListTile(
                      title: Container(
                        margin: EdgeInsets.only(bottom: 2, left: 4, right: 4),
                        child: Text(
                          "Living in".tr().toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 17,
                              color: Colors.white
                          ),
                        ),
                      ),
                      subtitle: CupertinoTextField(
                        controller: livingCtrl,
                        cursorColor: Colors.white,
                        style: TextStyle(
                            color: goldBtnColorDark
                        ),
                        placeholder: "Add city".tr().toString(),
                        placeholderStyle: TextStyle(
                            color: Colors.grey
                        ),
                        padding: EdgeInsets.all(10),
                        onChanged: (text) {
                          editInfo.addAll({'living_in': text});
                        },
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      width: MediaQuery.of(context).size.width,
                      height: 0.88,
                      color: goldBtnColorDark.withOpacity(0.75),
                    ),
                    SizedBox(height: 4,),
                    ListTile(
                      title: InkWell(
                        onTap: (){
                          onClickHeight(context, "Ethnicity".tr().toString(), ethnicities, (value){
                            setState(() {
                              ethnicityVal = value;
                              editInfo.addAll({'Ethnicity': ethnicityVal});
                            });
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 4, right: 4, top: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Ethnicity".tr().toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 17,
                                        color: Colors.white
                                    ),
                                  ),
                                  Spacer(),
                                  Container(
                                    child: Text(
                                      "What is your Ethnicity?".tr().toString(),
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 8, top: 10, bottom: 8),
                                child: Text(
                                  ethnicityVal == '' ? "Add Ethnicity".tr().toString() : ethnicityVal,
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: ethnicityVal == '' ? Colors.grey : goldBtnColorDark
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      width: MediaQuery.of(context).size.width,
                      height: 0.88,
                      color: goldBtnColorDark.withOpacity(0.75),
                    ),
                    SizedBox(height: 16,),
                    ListTile(
                      title: InkWell(
                        onTap: (){
                          onClickHeight(context, 'Speak Languages', speaks, (value){
                            setState(() {
                              speakVal = value;
                              editInfo.addAll({'speaks': speakVal});
                            });
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 4, right: 4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Speaks".tr().toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 17,
                                        color: Colors.white
                                    ),
                                  ),
                                  Spacer(),
                                  Container(
                                    child: Text(
                                      "What languages do you speak?".tr().toString(),
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 8, top: 10, bottom: 8),
                                child: Text(
                                  speakVal == '' ? "Add speaks".tr().toString() : speakVal,
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: speakVal == '' ? Colors.grey : goldBtnColorDark
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 4,),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      color: mainBlackColor.withOpacity(0.64),
                      width: MediaQuery.of(context).size.width,
                      height: 48,
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 18),
                        child: Text(
                          "Basic Information".tr().toString(),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.withOpacity(0.8)
                          ),
                        ),
                      ),
                    ),
                    ListTile(
                      title: InkWell(
                        onTap: (){
                          onClickHeight(context, 'Height (ft)', heights, (value){
                            setState(() {
                              heightVal = value;
                              editInfo.addAll({'height': heightVal});
                            });
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 4, right: 4, top: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Height".tr().toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 17,
                                      color: Colors.white
                                    ),
                                  ),
                                  Spacer(),
                                  Container(
                                    child: Text(
                                      "How tall are you?".tr().toString(),
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 8, top: 10, bottom: 8),
                                child: Text(
                                  heightVal == '' ? "Add Height".tr().toString() : heightVal,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: heightVal == '' ? Colors.grey : goldBtnColorDark
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      width: MediaQuery.of(context).size.width,
                      height: 0.88,
                      color: goldBtnColorDark.withOpacity(0.75),
                    ),
                    SizedBox(height: 8,),
                    ListTile(
                      title: InkWell(
                        onTap: (){
                          onClickHeight(context, 'Smoking Habits', smokingHabits, (value){
                            setState(() {
                              smokingVal = value;
                              editInfo.addAll({'smokingHabit': smokingVal});
                            });
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 4, right: 4, top: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Smoking Habits".tr().toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 17,
                                        color: Colors.white
                                    ),
                                  ),
                                  Spacer(),
                                  Container(
                                    child: Text(
                                      "Do you smoke?".tr().toString(),
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 8, top: 10, bottom: 8),
                                child: Text(
                                  smokingVal == '' ? "Add Smoking Habit".tr().toString() : smokingVal,
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: smokingVal == '' ? Colors.grey : goldBtnColorDark
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      width: MediaQuery.of(context).size.width,
                      height: 0.88,
                      color: goldBtnColorDark.withOpacity(0.75),
                    ),
                    SizedBox(height: 8,),
                    ListTile(
                      title: InkWell(
                        onTap: (){
                          onClickHeight(context, 'Drinking Habit', drinkingHabits, (value){
                            setState(() {
                              drinkingVal = value;
                              editInfo.addAll({'drinkingHabit': drinkingVal});
                            });
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 4, right: 4, top: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Drinking Habit".tr().toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 17,
                                        color: Colors.white
                                    ),
                                  ),
                                  Spacer(),
                                  Container(
                                    child: Text(
                                      "Do you drink?".tr().toString(),
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 8, top: 10, bottom: 8),
                                child: Text(
                                  drinkingVal == '' ? "Add Drinking Habit".tr().toString() : drinkingVal,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: drinkingVal == '' ? Colors.grey : goldBtnColorDark
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      width: MediaQuery.of(context).size.width,
                      height: 0.88,
                      color: goldBtnColorDark.withOpacity(0.75),
                    ),
                    SizedBox(height: 8,),
                    ListTile(
                      title: InkWell(
                        onTap: (){
                          onClickHeight(context, 'RelationShip', marryRefs, (value){
                            setState(() {
                              marryRef = value;
                              editInfo.addAll({'married': marryRef});
                            });
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 4, right: 4, top: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "RelationShip".tr().toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 17,
                                      color: Colors.white
                                    ),
                                  ),
                                  Spacer(),
                                  Container(
                                    child: Text(
                                      "Are you married?".tr().toString(),
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 8, top: 10, bottom: 8),
                                child: Text(
                                  marryRef == '' ? "Add relationship".tr().toString() : marryRef,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: marryRef == '' ? Colors.grey : goldBtnColorDark
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      width: MediaQuery.of(context).size.width,
                      height: 0.88,
                      color: goldBtnColorDark.withOpacity(0.75),
                    ),
                    SizedBox(height: 8,),
                    ListTile(
                      title: InkWell(
                        onTap: (){
                          onClickHeight(context, 'Connections', connections, (value){
                            setState(() {
                              connectionVal = value;
                              editInfo.addAll({'connections': connectionVal});
                            });
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 4, right: 4, top: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Connections".tr().toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 17,
                                      color: Colors.white
                                    ),
                                  ),
                                  Spacer(),
                                  Container(
                                    child: Text(
                                      "What are you open to".tr().toString(),
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 8, top: 10, bottom: 8),
                                child: Text(
                                  connectionVal == '' ? "Add Connection".tr().toString() : connectionVal,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: connectionVal == '' ? Colors.grey : goldBtnColorDark
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      width: MediaQuery.of(context).size.width,
                      height: 0.88,
                      color: goldBtnColorDark.withOpacity(0.75),
                    ),
                    SizedBox(height: 8,),
                    ListTile(
                      title: InkWell(
                        onTap: (){
                          onClickHeight(context, 'Religion', religions, (value){
                            setState(() {
                              religionVal = value;
                              editInfo.addAll({'religions': religionVal});
                            });
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 4, right: 4, top: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Religion".tr().toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 17,
                                      color: Colors.white
                                    ),
                                  ),
                                  Spacer(),
                                  Container(
                                    child: Text(
                                      "What is your religion?".tr().toString(),
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 8, top: 10, bottom: 8),
                                child: Text(
                                  religionVal == '' ? "Add Religion".tr().toString() : religionVal,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: religionVal == '' ? Colors.grey : goldBtnColorDark
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 8,),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 18),
                      color: mainBlackColor.withOpacity(0.64),
                      width: MediaQuery.of(context).size.width,
                      height: 48,
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 18),
                        child: Text(
                          "Occupation".tr().toString(),
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.withOpacity(0.8)
                          ),
                        ),
                      ),
                    ),
                    ListTile(
                      title: Container(
                        margin: EdgeInsets.only(bottom: 6, left: 4, right: 4),
                        child: Row(
                          children: [
                            Text(
                              "Income".tr().toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 17,
                                  color: Colors.white
                              ),
                            ),
                            Spacer(),
                            Container(
                              child: Text(
                                "What is your annual income?".tr().toString(),
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      subtitle: CupertinoTextField(
                        controller: incomeCtrl,
                        cursorColor: Colors.white,
                        style: TextStyle(
                            color: goldBtnColorDark
                        ),
                        placeholder: "What is your annual income?".tr().toString(),
                        placeholderStyle: TextStyle(
                            color: Colors.grey
                        ),
                        padding: EdgeInsets.all(10),
                        onChanged: (text) {
                          editInfo.addAll({'IncomeAnnual': text});
                        },
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      width: MediaQuery.of(context).size.width,
                      height: 0.88,
                      color: goldBtnColorDark.withOpacity(0.75),
                    ),
                    SizedBox(height: 16,),
                    ListTile(
                      title: Container(
                        margin: EdgeInsets.only(bottom: 6, left: 4, right: 4),
                        child: Text(
                          "Job title".tr().toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 17,
                            color: Colors.white
                          ),
                        ),
                      ),
                      subtitle: CupertinoTextField(
                        controller: jobCtrl,
                        cursorColor: Colors.white,
                        style: TextStyle(
                          color: goldBtnColorDark
                        ),
                        placeholder: "Add job title".tr().toString(),
                        placeholderStyle: TextStyle(
                          color: Colors.grey
                        ),
                        padding: EdgeInsets.all(10),
                        onChanged: (text) {
                          editInfo.addAll({'job_title': text});
                        },
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      width: MediaQuery.of(context).size.width,
                      height: 0.88,
                      color: goldBtnColorDark.withOpacity(0.75),
                    ),
                    SizedBox(height: 16,),
                    ListTile(
                      title: Container(
                        margin: EdgeInsets.only(bottom: 6, left: 4, right: 4),
                        child: Text(
                          "Company".tr().toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 17,
                            color: Colors.white
                          ),
                        ),
                      ),
                      subtitle: CupertinoTextField(
                        controller: companyCtrl,
                        cursorColor: Colors.white,
                        style: TextStyle(
                          color: goldBtnColorDark
                        ),
                        placeholder: "Add company".tr().toString(),
                        placeholderStyle: TextStyle(
                          color: Colors.grey
                        ),
                        padding: EdgeInsets.all(10),
                        onChanged: (text) {
                          editInfo.addAll({'company': text});
                        },
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                        ),
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      width: MediaQuery.of(context).size.width,
                      height: 0.88,
                      color: goldBtnColorDark.withOpacity(0.75),
                    ),
                    SizedBox(height: 16,),
                    ListTile(
                      title: Container(
                        margin: EdgeInsets.only(bottom: 6, left: 4, right: 4),
                        child: Text(
                          "Education".tr().toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 17,
                            color: Colors.white
                          ),
                        ),
                      ),
                      subtitle: CupertinoTextField(
                        controller: universityCtrl,
                        cursorColor: Colors.white,
                        style: TextStyle(
                          color: goldBtnColorDark
                        ),
                        placeholder: "Add university".tr().toString(),
                        placeholderStyle: TextStyle(
                          color: Colors.grey
                        ),
                        padding: EdgeInsets.all(10),
                        onChanged: (text) {
                          editInfo.addAll({'university': text});
                        },
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  color: mainBlackColor.withOpacity(0.64),
                  width: MediaQuery.of(context).size.width,
                  height: 48,
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 18),
                    child: Text(
                      "Others".tr().toString(),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.withOpacity(0.8)
                      ),
                    ),
                  ),
                ),
                ListTile(
                  title: Container(
                    margin: EdgeInsets.only(bottom: 6),
                    child: Text(
                      "Control your profile".tr().toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Colors.white
                      ),
                    ),
                  ),
                  subtitle: Container(
                    margin: EdgeInsets.only(top: 6),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("Don't Show My Age".tr().toString(), style: TextStyle(color: goldBtnColorDark),),
                            ),
                            Switch(
                              activeColor: goldBtnColorDark,
                              value: visibleAge,
                              onChanged: (value) {
                                editInfo.addAll({'showMyAge': value});
                                setState(() {
                                  visibleAge = value;
                                });
                              }
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("Make My Distance Visible".tr().toString(), style: TextStyle(color: goldBtnColorDark)),
                            ),
                            Switch(
                              activeColor: goldBtnColorDark,
                              value: visibleDistance,
                              onChanged: (value) {
                                editInfo.addAll({'DistanceVisible': value});
                                setState(() {
                                  visibleDistance = value;
                                });
                              }
                            )
                          ],
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(width: 1, color: Colors.grey.withOpacity(0.85)),
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                    ),
                  ),
                ),
                SizedBox(
                  height: 100,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _deletePicture(index) async {
    if (widget.currentUser.imageUrl[index] != null) {
      try {
        StorageReference _ref = await FirebaseStorage.instance
          .getReferenceFromUrl(widget.currentUser.imageUrl[index]);
        await _ref.delete();
      } catch (e) {
        print(e);
      }
    }
    setState(() {
      widget.currentUser.imageUrl.removeAt(index);
    });
    var temp = [];
    temp.add(widget.currentUser.imageUrl);
    await Firestore.instance
      .collection("Users")
      .document("${widget.currentUser.id}")
      .setData({"Pictures": temp[0]}, merge: true);
  }

  onClickHeight(BuildContext context, var title, List<String> values, Function function) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Spacer(),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 32),
                padding: EdgeInsets.only(top: 16, bottom: 16, left: 12, right: 12),
                child: Column(
                  children: [
                    Container(
                      child: Text(
                        title,
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 18,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: values.length,
                      itemBuilder: (BuildContext context, index) {
                        return Column(
                          children: [
                            GestureDetector(
                              onTap: (){
                                Navigator.pop(context);
                                function(values.elementAt(index));
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.symmetric(horizontal: 6, vertical: 10),
                                child: Text(
                                  values.elementAt(index),
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 16,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: 1,
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.symmetric(horizontal: 6),
                              color: Colors.grey.withOpacity(0.7),
                            ),
                          ],
                        );
                      },
                    ),
                    SizedBox(height: 8,)
                  ],
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(12))
                ),
              ),
              Spacer(),
            ],
          ),
        );
      }
    );
  }
}
