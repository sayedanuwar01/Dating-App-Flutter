import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:hookup4u/Screens/Chat/Matches.dart';
import 'package:hookup4u/Screens/NearByScreen.dart';
import 'package:hookup4u/Screens/Profile/EditProfile.dart';
import 'package:hookup4u/Screens/ReportUser.dart';
import 'package:hookup4u/Screens/TabBarScreen.dart';
import 'package:hookup4u/models/UserModel.dart';
import 'package:hookup4u/util/color.dart';
import 'package:easy_localization/easy_localization.dart';

import 'Calling/DialCall.dart';
import 'Chat/ChatPage.dart';
import 'Chat/LargeImage.dart';

class UserInfoScreen extends StatefulWidget {
  final UserModel user;
  final UserModel currentUser;
  UserInfoScreen(this.user, this.currentUser, );
  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  final db = Firestore.instance;
  CollectionReference usersRef = Firestore.instance.collection('Users');
  CollectionReference chatReference;
  bool isMatched;

  List likedList = [];
  List likedByList = [];

  @override
  void initState() {
    super.initState();

    isMatched = false;
    if (matches.any((value) => value.id == widget.user.id,)) {
      isMatched = true;
    }
    addLikedListener();
  }

  addLikedListener() async {
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
    bool isMe = widget.user.id == widget.currentUser.id;

    bool visibleOccupation = false;
    if(widget.user.editInfo.containsKey('university') && widget.user.editInfo['university'] != ''){
      visibleOccupation = true;
    }else if(widget.user.editInfo.containsKey('job_title') && widget.user.editInfo['job_title'] != ''){
      visibleOccupation = true;
    }else if(widget.user.editInfo.containsKey('IncomeAnnual') && widget.user.editInfo['IncomeAnnual'] != ''){
      visibleOccupation = true;
    }else if(widget.user.editInfo.containsKey('connections') && widget.user.editInfo['connections'] != ''){
      visibleOccupation = true;
    }
    bool visibleBasicInfo = false;
    if(widget.user.editInfo.containsKey('height') && widget.user.editInfo['height'] != ''){
      visibleBasicInfo = true;
    }else if(widget.user.editInfo.containsKey('smokingHabit') && widget.user.editInfo['smokingHabit'] != ''){
      visibleBasicInfo = true;
    }else if(widget.user.editInfo.containsKey('drinkingHabit') && widget.user.editInfo['drinkingHabit'] != ''){
      visibleBasicInfo = true;
    }else if(widget.user.editInfo.containsKey('religions') && widget.user.editInfo['religions'] != ''){
      visibleBasicInfo = true;
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        color: primaryColor.withOpacity(0.94),
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width,
                    child: Swiper(
                      key: UniqueKey(),
                      physics: ScrollPhysics(),
                      itemCount: widget.user.imageUrl.length,
                      itemBuilder: (BuildContext context, int index2) {
                        return widget.user.imageUrl.length != null ? Hero(
                          tag: "abc",
                          child: InkWell(
                            onTap: (){
                              Navigator.of(context).push(
                                CupertinoPageRoute(
                                  builder: (context) => LargeImage(
                                    widget.user.imageUrl[index2],
                                  ),
                                ),
                              );
                            },
                            child: CachedNetworkImage(
                              imageUrl: widget.user.imageUrl[index2] ?? '',
                              width: MediaQuery.of(context).size.width,
                              fit: BoxFit.cover,
                              useOldImageOnUrlChange: true,
                              placeholder: (context, url) =>
                                  CupertinoActivityIndicator(
                                    radius: 20,
                                  ),
                              errorWidget: (context, url, error) => Icon(Icons.error, color: goldBtnColorDark,),
                            ),
                          ),
                        ) : Container();
                      },
                      pagination: new SwiperPagination(
                          alignment: Alignment.bottomCenter,
                          builder: DotSwiperPaginationBuilder(
                              activeSize: 13,
                              color: goldBtnColorLight,
                              activeColor: Colors.red
                          )
                      ),
                      control: new SwiperControl(
                        color: primaryColor,
                        disableColor: secondaryColor,
                      ),
                      loop: false,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 8,),
                        ListTile(
                          title: Text(
                            "${convertToTitleCase(widget.user.name)}, ${widget.user.editInfo['showMyAge'] != null ? !widget.user.editInfo['showMyAge'] ? widget.user.age : "" : widget.user.age}",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.97),
                              fontSize: 22,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          subtitle: Padding(
                            padding: EdgeInsets.only(top: 12, left: 4),
                            child: Text(
                              "${widget.user.editInfo['DistanceVisible'] != null ? widget.user.editInfo['DistanceVisible'] ? 'Less than ${widget.user.distanceBW * 0.62} Miles away' : 'Distance not visible' : 'Less than ${widget.user.distanceBW * 0.62} Miles away'}",
                              style: TextStyle(
                                color: goldBtnColorDark,
                                fontSize: 15
                              ),
                            ),
                          ),
                          trailing: FloatingActionButton(
                            backgroundColor: goldBtnColorLight,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.arrow_downward,
                              color: primaryColor.withOpacity(0.8),
                              size: 32,
                            )
                          ),
                        ),
                        SizedBox(height: 4,),
                        ListTile(
                          dense: true,
                          leading: SvgPicture.asset(
                            'asset/Icon/ic_account.svg',
                            width: 28,
                            height: 28,
                            color: goldBtnColorDark,
                          ),
                          title: Text(
                            "About Me".tr().toString(),
                            style: TextStyle(
                              color: goldBtnColorDark,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Text(
                              '${widget.user.editInfo['about']}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                          height: 1,
                          color: Colors.grey.withOpacity(0.4),
                        ),
                        ListTile(
                          dense: true,
                          leading: Icon(
                            Icons.location_searching_outlined,
                            color: goldBtnColorDark,
                            size: 26,
                          ),
                          title: Text(
                            "Location".tr().toString(),
                            style: TextStyle(
                              color: goldBtnColorDark,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Text(
                              "${widget.user.address}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                          height: 1,
                          color: Colors.grey.withOpacity(0.4),
                        ),
                        widget.user.editInfo.containsKey('userGender') ? widget.user.editInfo['userGender'] != '' ? Column(
                          children: [
                            ListTile(
                              dense: true,
                              leading: Icon(Icons.wc, color: goldBtnColorDark,
                                  size: 27),
                              title: Row(
                                children: [
                                  Text(
                                    "Gender".tr().toString(),
                                    style: TextStyle(
                                      color: goldBtnColorDark,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    "${convertToTitleCase(widget.user.editInfo['userGender'])}",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15
                                    ),
                                  ),
                                  SizedBox(width: 18,),
                                ],
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                              height: 1,
                              color: Colors.grey.withOpacity(0.4),
                            ),
                          ],
                        ) : Container() : Container(),
                        widget.user.editInfo.containsKey('married') ? widget.user.editInfo['married'] != '' ? Column(
                          children: [
                            ListTile(
                              dense: true,
                              leading: Icon(Icons.people_outlined, color: goldBtnColorDark,
                                  size: 27),
                              title: Row(
                                children: [
                                  Text(
                                    "RelationShip".tr().toString(),
                                    style: TextStyle(
                                      color: goldBtnColorDark,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    "${widget.user.editInfo['married']}",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15
                                    ),
                                  ),
                                  SizedBox(width: 18,),
                                ],
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                              height: 1,
                              color: Colors.grey.withOpacity(0.4),
                            ),
                          ],
                        ) : Container() : Container(),
                        widget.user.editInfo.containsKey('Ethnicity') ? widget.user.editInfo['Ethnicity'] != '' ? Column(
                          children: [
                            ListTile(
                              dense: true,
                              leading: Icon(Icons.people_alt_outlined, color: goldBtnColorDark,
                                  size: 26),
                              title: Row(
                                children: [
                                  Text(
                                    "Ethnicity".tr().toString(),
                                    style: TextStyle(
                                      color: goldBtnColorDark,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    "${widget.user.editInfo['Ethnicity']}",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15
                                    ),
                                  ),
                                  SizedBox(width: 18,),
                                ],
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                              height: 1,
                              color: Colors.grey.withOpacity(0.4),
                            ),
                          ],
                        ) : Container() : Container(),
                        widget.user.editInfo.containsKey('speaks') ? widget.user.editInfo['speaks'] != '' ? Column(
                          children: [
                            ListTile(
                              dense: true,
                              leading: Icon(Icons.language, color: goldBtnColorDark,
                                  size: 26),
                              title: Row(
                                children: [
                                  Text(
                                    "Speaks".tr().toString(),
                                    style: TextStyle(
                                      color: goldBtnColorDark,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    "${widget.user.editInfo['speaks']}",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15
                                    ),
                                  ),
                                  SizedBox(width: 18,),
                                ],
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                              height: 1,
                              color: Colors.grey.withOpacity(0.4),
                            ),
                          ],
                        ) : Container() : Container(),
                        visibleOccupation ? Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
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
                        ) : Container(),
                        widget.user.editInfo.containsKey('university') ? widget.user.editInfo['university'] != '' ? Column(
                          children: [
                            ListTile(
                              dense: true,
                              leading: Icon(Icons.menu_book, color: goldBtnColorDark,
                                size: 26,),
                              title: Text(
                                "Education".tr().toString(),
                                style: TextStyle(
                                  color: goldBtnColorDark,
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: Padding(
                                padding: EdgeInsets.only(top: 8),
                                child: Text(
                                  "${widget.user.editInfo['university']}",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                              height: 1,
                              color: Colors.grey.withOpacity(0.4),
                            ),
                          ],
                        ) : Container() : Container(),
                        widget.user.editInfo.containsKey('job_title') ? widget.user.editInfo['job_title'] != '' ? Column(
                          children: [
                            ListTile(
                              dense: true,
                              leading: Icon(Icons.home_work_outlined, color: goldBtnColorDark,
                                size: 26,),
                              title: Text(
                                "Job title".tr().toString(),
                                style: TextStyle(
                                  color: goldBtnColorDark,
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: Padding(
                                padding: EdgeInsets.only(top: 8),
                                child: Text(
                                  "${widget.user.editInfo['job_title']}",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                              height: 1,
                              color: Colors.grey.withOpacity(0.4),
                            ),
                          ],
                        ) : Container() : Container(),
                        widget.user.editInfo.containsKey('IncomeAnnual') ? widget.user.editInfo['IncomeAnnual'] != '' ? Column(
                          children: [
                            ListTile(
                              dense: true,
                              leading: Icon(Icons.money, color: goldBtnColorDark,
                                size: 26,),
                              title: Text(
                                "Annual Income".tr().toString(),
                                style: TextStyle(
                                  color: goldBtnColorDark,
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: Padding(
                                padding: EdgeInsets.only(top: 8),
                                child: Text(
                                  "${widget.user.editInfo['IncomeAnnual']}",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                              height: 1,
                              color: Colors.grey.withOpacity(0.4),
                            ),
                          ],
                        ) : Container() : Container(),
                        widget.user.editInfo.containsKey('connections') ? widget.user.editInfo['connections'] != '' ? Column(
                          children: [
                            ListTile(
                              dense: true,
                              leading: Icon(Icons.account_tree_outlined, color: goldBtnColorDark,
                                size: 26,),
                              title: Text(
                                "Connections".tr().toString(),
                                style: TextStyle(
                                  color: goldBtnColorDark,
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: Padding(
                                padding: EdgeInsets.only(top: 8),
                                child: Text(
                                  "${widget.user.editInfo['connections']}",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                              height: 1,
                              color: Colors.grey.withOpacity(0.4),
                            ),
                          ],
                        ) : Container() : Container(),
                        visibleBasicInfo ? Container(
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
                        ) : Container(),
                        widget.user.editInfo.containsKey('height') ? widget.user.editInfo['height'] != '' ? Column(
                          children: [
                            ListTile(
                              dense: true,
                              leading: Icon(Icons.accessibility_rounded, color: goldBtnColorDark,
                                  size: 26),
                              title: Row(
                                children: [
                                  Text(
                                    "Height".tr().toString(),
                                    style: TextStyle(
                                      color: goldBtnColorDark,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    "${widget.user.editInfo['height']}",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15
                                    ),
                                  ),
                                  SizedBox(width: 18,),
                                ],
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                              height: 1,
                              color: Colors.grey.withOpacity(0.4),
                            ),
                          ],
                        ) : Container() : Container(),
                        widget.user.editInfo.containsKey('smokingHabit') ? widget.user.editInfo['smokingHabit'] != '' ? Column(
                          children: [
                            ListTile(
                              dense: true,
                              leading: Icon(Icons.smoking_rooms, color: goldBtnColorDark,
                                  size: 26),
                              title: Row(
                                children: [
                                  Text(
                                    "Smoking Habits".tr().toString(),
                                    style: TextStyle(
                                      color: goldBtnColorDark,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    "${widget.user.editInfo['smokingHabit']}",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15
                                    ),
                                  ),
                                  SizedBox(width: 18,),
                                ],
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                              height: 1,
                              color: Colors.grey.withOpacity(0.4),
                            ),
                          ],
                        ) : Container() : Container(),
                        widget.user.editInfo.containsKey('drinkingHabit') ? widget.user.editInfo['drinkingHabit'] != '' ? Column(
                          children: [
                            ListTile(
                              dense: true,
                              leading: Icon(Icons.wine_bar, color: goldBtnColorDark,
                                  size: 26),
                              title: Row(
                                children: [
                                  Text(
                                    "Drinking Habit".tr().toString(),
                                    style: TextStyle(
                                      color: goldBtnColorDark,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    "${widget.user.editInfo['drinkingHabit']}",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15
                                    ),
                                  ),
                                  SizedBox(width: 18,),
                                ],
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                              height: 1,
                              color: Colors.grey.withOpacity(0.4),
                            ),
                          ],
                        ) : Container() : Container(),
                        widget.user.editInfo.containsKey('religions') ? widget.user.editInfo['religions'] != '' ? Column(
                          children: [
                            ListTile(
                              dense: true,
                              leading: Icon(Icons.home, color: goldBtnColorDark,
                                  size: 26),
                              title: Row(
                                children: [
                                  Text(
                                    "Religion".tr().toString(),
                                    style: TextStyle(
                                      color: goldBtnColorDark,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    "${widget.user.editInfo['religions']}",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15
                                    ),
                                  ),
                                  SizedBox(width: 18,),
                                ],
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                              height: 1,
                              color: Colors.grey.withOpacity(0.4),
                            ),
                          ],
                        ) : Container() : Container(),
                        Divider(),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 18,
                  ),
                  !isMe ? InkWell(
                    onTap: () => showDialog(
                      barrierDismissible: true,
                      context: context,
                      builder: (context) => ReportUser(
                        currentUser: widget.currentUser,
                        secondUser: widget.user,
                      )
                    ),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: Text(
                          "REPORT ${widget.user.name}".toUpperCase(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: secondaryColor
                          ),
                        ),
                      )
                    ),
                  ) : Container(),
                  SizedBox(
                    height: 48,
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: isMe ? Padding(
                padding: EdgeInsets.all(18.0),
                child: Align(
                    alignment: Alignment.bottomRight,
                    child: InkWell(
                      onTap: (){
                        Navigator.pushReplacement(
                            context,
                            CupertinoPageRoute(builder: (context) => EditProfile(widget.user))
                        );
                      },
                      child: Container(
                        width: 96, height: 44,
                        child: Center(
                          child: Text(
                            'Edit',
                            style: TextStyle(
                                fontSize: 22,
                                color: Colors.brown
                            ),
                          ),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          color: goldBtnColorLight,
                        ),
                      ),
                    )
                ),
              ) :
              Padding(
                padding: EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    Spacer(),
                    Row(
                      children: [
                        Spacer(),
                        isMatched ? InkWell(
                          onTap: (){
                            onJoin(context, "AudioCall", widget.user.id);
                          },
                          child: Container(
                            width: 52, height: 52,
                            child: Icon(
                              Icons.call_outlined,
                              color: Colors.green,
                              size: 26,
                            ),
                            decoration: BoxDecoration(
                                color: mainBlackColor,
                                borderRadius: BorderRadius.all(Radius.circular(26)),
                                border: Border.all(width: 1, color: goldBtnColorDark)
                            ),
                          ),
                        ) : Container(),
                        SizedBox(width: 22,),
                        !isMatched ? InkWell(
                          onTap: () async {
                            if(likedList.contains(widget.user.id)){
                              disLikeUser();
                            }else{
                              likeUser();
                            }
                          },
                          child: Container(
                            width: 52, height: 52,
                            child: Icon(
                              likedList.contains(widget.user.id) ? Icons.favorite : Icons.favorite_outline_sharp,
                              color: likedList.contains(widget.user.id) ? Colors.red : Colors.lightBlueAccent,
                              size: 22,
                            ),
                            decoration: BoxDecoration(
                                color: mainBlackColor,
                                borderRadius: BorderRadius.all(Radius.circular(26)),
                                border: Border.all(width: 1, color: goldBtnColorDark)
                            ),
                          ),
                        ) : Container(),
                        isMatched ? InkWell(
                          onTap: (){
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => ChatPage(
                                      sender: widget.currentUser,
                                      second: widget.user,
                                      chatId: chatId(widget.user, widget.currentUser),
                                    )
                                )
                            );
                          },
                          child: Container(
                            width: 52, height: 52,
                            child: Icon(
                              Icons.message_rounded,
                              color: goldBtnColorDark,
                              size: 26,
                            ),
                            decoration: BoxDecoration(
                                color: mainBlackColor,
                                borderRadius: BorderRadius.all(Radius.circular(26)),
                                border: Border.all(width: 1, color: goldBtnColorDark)
                            ),
                          ),
                        ) : Container(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> disLikeUser() async {
    await usersRef.document(widget.currentUser.id)
      .collection("CheckedUser")
      .document(widget.user.id)
      .setData({
        'DislikedUser': widget.user.id,
        'timestamp': DateTime.now(),
      },
    );

    await usersRef.document(widget.user.id)
      .collection("LikedBy")
      .document(widget.currentUser.id)
      .delete();
    setState(() {});
  }

  Future<void> likeUser() async {
    if (likedByList.contains(widget.user.id)) {
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
                    ).tr(args: ['${widget.user.name}']),
                  ),
                ),
              ),
            ),
          );
        }
      );

      await usersRef.document(widget.currentUser.id)
        .collection("Matches")
        .document(widget.user.id)
        .setData({
          'Matches': widget.user.id,
          'isRead': false,
          'userName': widget.user.name,
          'pictureUrl': widget.user.imageUrl[0],
          'timestamp': FieldValue.serverTimestamp()
        },
      );

      await usersRef.document(widget.user.id)
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
        .document(widget.user.id)
        .delete();
      await usersRef.document(widget.user.id)
        .collection("CheckedUser")
        .document(widget.currentUser.id)
        .delete();
      await usersRef.document(widget.currentUser.id)
        .collection("LikedBy")
        .document(widget.user.id)
        .delete();
      await usersRef.document(widget.user.id)
        .collection("LikedBy")
        .document(widget.currentUser.id)
        .delete();

      setState(() {});
    }
    else{
      await usersRef.document(widget.currentUser.id)
        .collection("CheckedUser")
        .document(widget.user.id)
        .setData({
          'LikedUser': widget.user.id,
          'timestamp': FieldValue.serverTimestamp(),
        },
      );
      await usersRef.document(widget.user.id)
        .collection("LikedBy")
        .document(widget.currentUser.id)
        .setData({
          'LikedBy': widget.currentUser.id,
          'timestamp': FieldValue.serverTimestamp()
        },
      );
    }
  }

  Future<void> onJoin(BuildContext context, callType, String callReceiverId) async {
    var chatsId = chatId(widget.user, widget.currentUser),
        chatReference = db.collection("chats").document(chatsId).collection('messages');

    await handleCameraAndMic(callType);
    await chatReference.add({
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
          channelName: chatId(widget.user, widget.currentUser),
          receiver: widget.user,
          callType: callType
        ),
      ),
    );
  }
}
