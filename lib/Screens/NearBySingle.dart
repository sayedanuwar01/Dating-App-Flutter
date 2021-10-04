import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:hookup4u/Screens/UserInfoScreen.dart';
import 'package:hookup4u/Screens/TabBarScreen.dart';
import 'package:hookup4u/models/UserModel.dart';
import 'package:hookup4u/util/color.dart';
import 'package:easy_localization/easy_localization.dart';

import 'Calling/DialCall.dart';
import 'Chat/Matches.dart';
import 'Chat/ChatPage.dart';

class NearBySingle extends StatefulWidget {
  final UserModel currentUser;
  final Map items;
  NearBySingle(this.currentUser, this.items);
  @override
  _NearBySingleState createState() => _NearBySingleState();
}

class _NearBySingleState extends State<NearBySingle> {
  final db = Firestore.instance;
  CollectionReference usersRef = Firestore.instance.collection('Users');

  List<UserModel> users = [];
  List likedList = [];
  List likedByList = [];

  @override
  void initState() {
    super.initState();
    getNearByUsers();
  }

  query() {
    if (widget.currentUser.showGender == 'everyone') {
      return usersRef.where('age', isGreaterThanOrEqualTo: int.parse(widget.currentUser.ageRange['min']),)
        .where('editInfo.married', isEqualTo: 'I am a single')
        .where('age', isLessThanOrEqualTo: int.parse(widget.currentUser.ageRange['max']))
        .orderBy('age', descending: false
      );
    } else {
      return usersRef.where('editInfo.userGender', isEqualTo: widget.currentUser.showGender)
        .where('editInfo.married', isEqualTo: 'I am a single')
        .where('age', isGreaterThanOrEqualTo: int.parse(widget.currentUser.ageRange['min']),)
        .where('age', isLessThanOrEqualTo: int.parse(widget.currentUser.ageRange['max']))
        .orderBy('age', descending: false
      );
    }
  }

  Future getNearByUsers() async {
    query().snapshots().listen((data) async {
      if (data.documents.length > 0) {
        users.clear();
        for (var doc in data.documents) {
          UserModel userModel = UserModel.fromDocument(doc);
          var distance = calculateDistance(
            widget.currentUser.coordinates['latitude'],
            widget.currentUser.coordinates['longitude'],
            userModel.coordinates['latitude'],
            userModel.coordinates['longitude']
          );
          userModel.distanceBW = distance.round();
          if (matches.any((value) => value.id == userModel.id,)) {}
          else {
            if (distance <= widget.currentUser.maxDistance && userModel.id != widget.currentUser.id && !userModel.isBlocked) {
              users.add(userModel);
            }
          }
        }
        if (mounted) setState(() {});
      }
    });

    usersRef.document(widget.currentUser.id)
      .collection("LikedBy").snapshots()
      .listen((data) async {
        likedByList.clear();
        likedByList.addAll(data.documents.map((f) => f['LikedBy']));
        setState(() {});
      }
    );

    usersRef.document(widget.currentUser.id)
      .collection("CheckedUser").snapshots()
      .listen((data) async {
        likedList.clear();
        likedList.addAll(data.documents.map((f) => f['LikedUser']));
        setState(() {});
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    double cellSize = (MediaQuery.of(context).size.width - 16)  / 2;
    return Scaffold(
      backgroundColor: primaryColor.withOpacity(0.88),
      body: users.length == 0 ? Align(
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
              "There are no any Singles yet".tr().toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                decoration: TextDecoration.none,
                fontSize: 18
              ),
            )
          ],
        ),
      ) :
      Padding(
        padding: EdgeInsets.symmetric(vertical: 4),
        child: GridView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) => SinglesUI(
            index,
            cellSize,
            users.elementAt(index),
            () async {
              await showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return UserInfoScreen(
                    users.elementAt(index),
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
      )
    );
  }
}

String convertToTitleCase(String text) {
  if (text == null) {
    return null;
  }
  if (text.length <= 1) {
    return text.toUpperCase();
  }
  final List<String> words = text.split(' ');
  final capitalizedWords = words.map((word) {
    if (word.trim().isNotEmpty) {
      final String firstLetter = word.trim().substring(0, 1).toUpperCase();
      final String remainingLetters = word.trim().substring(1);

      return '$firstLetter$remainingLetters';
    }
    return '';
  });
  return capitalizedWords.join(' ');
}

class SinglesUI extends StatelessWidget {
  final int singleIndex;
  final double cellSize;
  final UserModel userModel;
  final Function callback;

  const SinglesUI(
    this.singleIndex,
    this.cellSize,
    this.userModel,
    this.callback,
  );

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        callback();
      },
      child: Container(
          width: cellSize, height: cellSize,
          margin: EdgeInsets.all(4),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  userModel.imageUrl.elementAt(0),
                  width: cellSize,
                  fit: BoxFit.cover,
                ),
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Spacer(),
                      Container(
                        width: 56, height: 28,
                        child: Row(
                          children: [
                            SizedBox(width: 4,),
                            Icon(Icons.image_outlined, size: 22, color: Colors.white,),
                            SizedBox(width: 10,),
                            Text(
                              '${userModel.imageUrl.length}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white
                              ),
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(topRight: Radius.circular(12)),
                          color: Colors.black45,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Row(
                    children: [
                      Flexible(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 6),
                          child: Text(
                            '${convertToTitleCase(userModel.name)}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4,)
                ],
              ),
            ],
          ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(14)),
          color: Colors.white,
        ),
      ),
    );
  }
}

