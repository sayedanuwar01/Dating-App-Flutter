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

class NearByScreen extends StatefulWidget {
  final UserModel currentUser;
  final Map items;
  NearByScreen(this.currentUser, this.items);
  @override
  _NearByScreenState createState() => _NearByScreenState();
}

class _NearByScreenState extends State<NearByScreen> {
  final db = Firestore.instance;
  CollectionReference usersRef = Firestore.instance.collection('Users');

  List<UserModel> users = [];
  List likedList = [];
  List likedByList = [];
  List starList = [];

  @override
  void initState() {
    super.initState();
    getNearByUsers();
  }

  query() {
    if (widget.currentUser.showGender == 'everyone') {
      return usersRef.where('age', isGreaterThanOrEqualTo: int.parse(widget.currentUser.ageRange['min']),)
        .where('age', isLessThanOrEqualTo: int.parse(widget.currentUser.ageRange['max']))
        .orderBy('age', descending: false
      );
    } else {
      return usersRef.where('editInfo.userGender', isEqualTo: widget.currentUser.showGender)
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

    usersRef.document(widget.currentUser.id)
      .collection("StaredUser").snapshots()
      .listen((data) async {
        starList.clear();
        starList.addAll(data.documents.map((f) => f['StaredUser']));
        setState(() {});
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor.withOpacity(0.88),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * .8,
        child: users.length == 0 ? Align(
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
                "There's no one new around you.".tr().toString(),
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
        ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () async {
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
              },
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width,
                        child: Swiper(
                          key: UniqueKey(),
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: users.elementAt(index).imageUrl.length,
                          itemBuilder: (BuildContext context, int index2) {
                            return CachedNetworkImage(
                              imageUrl: users.elementAt(index).imageUrl[index2],
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.width,
                              fit: BoxFit.cover,
                              useOldImageOnUrlChange: true,
                              placeholder: (context, url) => CupertinoActivityIndicator(
                                radius: 20,
                              ),
                              errorWidget: (context, url, error) => Icon(
                                  Icons.error
                              ),
                            );
                          },
                          pagination: SwiperPagination(
                              alignment: Alignment.bottomCenter,
                              builder: DotSwiperPaginationBuilder(
                                  activeSize: 13,
                                  color: secondaryColor,
                                  activeColor: Colors.red
                              )
                          ),
                          control: SwiperControl(
                            color: primaryColor,
                            disableColor:
                            secondaryColor,
                          ),
                          loop: false,
                          customLayoutOption: CustomLayoutOption(
                            startIndex: 0,
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width,
                        child: Column(
                          children: [
                            Spacer(),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 52,
                              margin: EdgeInsets.symmetric(horizontal: 12),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.image_outlined,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                  SizedBox(width: 6,),
                                  Text(
                                    '${users.elementAt(index).imageUrl.length}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.88,
                    padding: EdgeInsets.only(top: 14, bottom: 14, ),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      convertToTitleCase('${users.elementAt(index).name}'),
                      style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 4, left: 14, bottom: 6),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'asset/Icon/ic_account.svg',
                          width: 28,
                          height: 28,
                          color: goldBtnColorDark,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.82,
                          padding: EdgeInsets.only(left: 12),
                          child: Text(
                            "About Me".tr().toString(),
                            style: TextStyle(color: goldBtnColorDark, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.82,
                    padding: EdgeInsets.only(left: 10, bottom: 8),
                    child: Text(
                      '${users.elementAt(index).editInfo['about']}',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 28, vertical: 6),
                    height: 1,
                    color: Colors.grey.withOpacity(0.4),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 6, left: 14, bottom: 6),
                    child: Row(
                      children: [
                        Icon(Icons.location_pin, size: 28, color: goldBtnColorDark,),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.82,
                          padding: EdgeInsets.only(left: 12),
                          child: Text(
                            "Location".tr().toString(),
                            style: TextStyle(color: goldBtnColorDark, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.82,
                    padding: EdgeInsets.only(left: 10, bottom: 8),
                    child: Text(
                      '${users.elementAt(index).address}',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 28, vertical: 6),
                    height: 1,
                    color: Colors.grey.withOpacity(0.4),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: (){
                            if(likedList.contains(users[index].id)){
                              disLikeUser(index);
                            }
                            /*
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => ChatPage(
                                sender: widget.currentUser,
                                second: users.elementAt(index),
                                chatId: chatId(users.elementAt(index), widget.currentUser),
                                )
                              )
                            );*/
                          },
                          child: Container(
                            width: 46, height: 46,
                            child: Icon(
                              Icons.close,
                              color: likedList.contains(users[index].id) ? Colors.blue : goldBtnColorDark,
                              size: 24,
                            ),
                            decoration: BoxDecoration(
                              color: mainBlackColor,
                              borderRadius: BorderRadius.all(Radius.circular(23)),
                              border: Border.all(width: 1, color: goldBtnColorDark)
                            ),
                          ),
                        ),
                        SizedBox(width: 16,),
                        InkWell(
                          onTap: (){
                            if(starList.contains(users[index].id)){
                              unStarUser(index);
                            }else{
                              starUser(index);
                            }
                          },
                          child: Container(
                            width: 46, height: 46,
                            child: Icon(
                              Icons.star,
                              color: starList.contains(users[index].id) ? goldBtnColorDark : Colors.grey,
                              size: 26,
                            ),
                            decoration: BoxDecoration(
                              color: mainBlackColor,
                              borderRadius: BorderRadius.all(Radius.circular(23)),
                              border: Border.all(width: 1, color: goldBtnColorDark)
                            ),
                          ),
                        ),
                        SizedBox(width: 16,),
                        InkWell(
                          onTap: () async {
                            if(!likedList.contains(users[index].id)){
                              likeUser(index);
                            }
                          },
                          child: Container(
                            width: 46, height: 46,
                            child: Icon(
                              likedList.contains(users[index].id) ? Icons.favorite : Icons.favorite_outline_sharp,
                              color: likedList.contains(users[index].id) ? Colors.red : Colors.blue,
                              size: 22,
                            ),
                            decoration: BoxDecoration(
                              color: mainBlackColor,
                              borderRadius: BorderRadius.all(Radius.circular(23)),
                              border: Border.all(width: 1, color: goldBtnColorDark)
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8,)
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> onJoin(callType, String callReceiverId, UserModel receiverUser) async {
    var chatsId = chatId(receiverUser, widget.currentUser),
    chatRef = db.collection("chats").document(chatsId).collection('messages');

    await handleCameraAndMic(callType);
    await chatRef.add({
      'type': 'Call',
      'text': callType,
      'sender_id': widget.currentUser.id,
      'receiver_id': callReceiverId,
      'isRead': false,
      'image_url': "",
      'time': FieldValue.serverTimestamp(),
    });

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DialCall(
          channelName: chatId(receiverUser, widget.currentUser),
          receiver: receiverUser,
          callType: callType
        ),
      ),
    );
  }

  starUser(int index) async {
    await usersRef.document(widget.currentUser.id)
      .collection("StaredUser")
      .document(users[index].id)
      .setData({
        'StaredUser': users[index].id,
        'timestamp': DateTime.now(),
      },
    );

    usersRef.document(users[index].id)
      .collection("Stars")
      .document(users[index].id)
      .setData({
        'Stars': FieldValue.increment(1),
      }
    );

    setState(() {});
  }

  unStarUser(int index) async {
    await usersRef.document(widget.currentUser.id)
      .collection("StaredUser")
      .document(users[index].id)
      .setData({
        'UnStaredUser': users[index].id,
        'timestamp': DateTime.now(),
      },
    );

    usersRef.document(users[index].id)
      .collection("Stars")
      .document(users[index].id)
      .get().then((DocumentSnapshot doc) {
        int star = doc['Stars'] as int;
        if(star > 0){
          usersRef.document(users[index].id)
            .collection("Stars")
            .document(users[index].id)
            .updateData({
              'Stars' : star-1
            }
          );
        }
      }
    );

    setState(() {});
  }

  Future<void> disLikeUser(int index) async {
    await usersRef.document(widget.currentUser.id)
      .collection("CheckedUser")
      .document(users[index].id)
      .setData({
        'DislikedUser': users[index].id,
        'timestamp': DateTime.now(),
      },
    );

    await usersRef.document(users[index].id)
      .collection("LikedBy")
      .document(widget.currentUser.id)
      .delete();

    setState(() {});
  }

  Future<void> likeUser(int index) async {
    if (likedByList.contains(users[index].id)) {
      showDialog(
        context: context,
        builder: (ctx) {
          Future.delayed(Duration(milliseconds: 1500), () {
              Navigator.pop(ctx);
            }
          );
          return Padding(
            padding: EdgeInsets.only(top: 80),
            child: Align(
              alignment: Alignment.topCenter,
              child: Card(
                child: Container(
                  height: 100,
                  width: 300,
                  child: Center(
                    child: Text(
                      "It's a match\n With ",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 30,
                        decoration: TextDecoration.none
                      ),
                    ).tr(args: ['${users[index].name}']),
                  ),
                ),
              ),
            ),
          );
        }
      );

      await usersRef.document(widget.currentUser.id)
        .collection("Matches")
        .document(users[index].id)
        .setData({
          'Matches': users[index].id,
          'isRead': false,
          'userName': users[index].name,
          'pictureUrl': users[index].imageUrl[0],
          'timestamp': FieldValue.serverTimestamp()
        },
      );

      await usersRef.document(users[index].id)
        .collection("Matches")
        .document(widget.currentUser.id)
        .setData({
          'Matches': widget.currentUser.id,
          'userName': widget.currentUser.name,
          'pictureUrl': widget.currentUser.imageUrl[0],
          'isRead': false,
          'timestamp': FieldValue.serverTimestamp()
        },
      );

      await usersRef.document(widget.currentUser.id)
        .collection("CheckedUser")
        .document(users[index].id)
        .delete();
      await usersRef.document(users[index].id)
        .collection("CheckedUser")
        .document(widget.currentUser.id)
        .delete();
      await usersRef.document(widget.currentUser.id)
        .collection("LikedBy")
        .document(users[index].id)
        .delete();
      await usersRef.document(users[index].id)
        .collection("LikedBy")
        .document(widget.currentUser.id)
        .delete();

      setState(() {});
    }
    else{
      await usersRef.document(widget.currentUser.id)
        .collection("CheckedUser")
        .document(users[index].id)
        .setData({
          'LikedUser': users[index].id,
          'timestamp': FieldValue.serverTimestamp(),
        },
      );
      await usersRef.document(users[index].id)
        .collection("LikedBy")
        .document(widget.currentUser.id)
        .setData({
          'LikedBy': widget.currentUser.id,
          'timestamp': FieldValue.serverTimestamp()
        },
      );
    }
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

