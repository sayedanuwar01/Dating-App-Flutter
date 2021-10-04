import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hookup4u/models/UserModel.dart';
import 'package:hookup4u/util/color.dart';
import 'package:easy_localization/easy_localization.dart';

import 'NearBySingle.dart';
import 'TabBarScreen.dart';
import 'UserInfoScreen.dart';


class MatchesScreen extends StatefulWidget {
  final UserModel currentUser;
  final Map items;
  const MatchesScreen(this.currentUser, this.items);

  @override
  _MatchesScreenState createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  CollectionReference usersRef = Firestore.instance.collection('Users');
  final db = Firestore.instance;
  List<UserModel> matchedUsers = [];

  @override
  void initState() {
    super.initState();
    _getLikeBys();
  }

  _getLikeBys() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return db.collection('/Users/${user.uid}/Matches')
      .orderBy('timestamp', descending: true)
      .snapshots()
      .listen((onData) async {
        if (onData.documents.length > 0) {
          matchedUsers.clear();
          onData.documents.forEach((f) async {
            await usersRef.document('${f.data['Matches']}').get().then((DocumentSnapshot doc) {
              if (doc.exists) {
                UserModel userModel = UserModel.fromDocument(doc);
                userModel.distanceBW = calculateDistance(
                  widget.currentUser.coordinates['latitude'],
                  widget.currentUser.coordinates['longitude'],
                  userModel.coordinates['latitude'],
                  userModel.coordinates['longitude']).round();
                matchedUsers.add(userModel);
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
    double cellSize = (MediaQuery.of(context).size.width - 16)  / 2;
    return Scaffold(
      backgroundColor: Colors.white,
      body: matchedUsers.length == 0 ? Align(
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
              "There are no any matches yet".tr().toString(),
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
      Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Image.asset(
                    'asset/images/s10.png',
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.fitWidth,
                  ),
                ),
                ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200.withOpacity(0.06),
                        // color: Colors.black.withOpacity(0.4),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: GridView.builder(
              itemCount: matchedUsers.length,
              itemBuilder: (context, index) => SinglesUI(
                index,
                cellSize,
                matchedUsers.elementAt(index),
                () async {
                  await showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return UserInfoScreen(
                        matchedUsers.elementAt(index),
                        widget.currentUser,
                      );
                    }
                  );
                }
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
            ),
          ),
        ],
      )
    );
  }
}
