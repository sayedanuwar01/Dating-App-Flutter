import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hookup4u/Screens/UserInfoScreen.dart';
import 'package:hookup4u/Screens/TabBarScreen.dart';
import 'package:hookup4u/models/UserModel.dart';
import 'package:hookup4u/util/color.dart';
import 'package:easy_localization/easy_localization.dart';

class LikedByScreen extends StatefulWidget {
  final UserModel currentUser;
  final Map items;
  LikedByScreen(this.currentUser, this.items);
  @override
  _LikedByScreenState createState() => _LikedByScreenState();
}

class _LikedByScreenState extends State<LikedByScreen> {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  CollectionReference usersRef = Firestore.instance.collection('Users');
  final db = Firestore.instance;
  List<UserModel> likedBys = [];

  @override
  void initState() {
    super.initState();
    _getLikeBys();
  }

  _getLikeBys() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return db.collection('/Users/${user.uid}/LikedBy')
      .orderBy('timestamp', descending: true)
      .snapshots()
      .listen((onData) async {
        if (onData.documents.length > 0) {
          likedBys.clear();
          onData.documents.forEach((f) async {
            await usersRef.document('${f.data['LikedBy']}').get().then((DocumentSnapshot doc) {
              if (doc.exists) {
                UserModel userModel = UserModel.fromDocument(doc);
                userModel.distanceBW = calculateDistance(
                  widget.currentUser.coordinates['latitude'],
                  widget.currentUser.coordinates['longitude'],
                  userModel.coordinates['latitude'],
                  userModel.coordinates['longitude']).round();
                likedBys.add(userModel);
                if (mounted) setState(() {});
              }
            });
          });
        }
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Container(
        height: MediaQuery.of(context).size.height * .81,
        width: MediaQuery.of(context).size.width,
        child: likedBys.length == 0 ? Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: secondaryColor,
                  radius: 40,
                ),
              ),
              Text(
                "There are no any visitors yet".tr().toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: secondaryColor,
                  decoration: TextDecoration.none,
                  fontSize: 18
                ),
              )
            ],
          ),
        ) :
        Container(
          child: ListView.builder(
            itemCount: likedBys.length + 1,
            itemBuilder: (context, index) {
              return index < likedBys.length ? likedBys.elementAt(index).likeByCelUI(
                context: context,
                onClickCell: (userId) async {
                  await showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return UserInfoScreen(
                        likedBys.elementAt(index),
                        widget.currentUser,
                      );
                    }
                  );
                }
              ) :
              Container(height: 16,);
            },
          ),
        ),
        decoration: BoxDecoration(
          color: CupertinoColors.systemGrey5,
        ),
      ),
    );
  }
}
