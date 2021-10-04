import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hookup4u/Screens/ShowGender.dart';
import 'package:hookup4u/util/color.dart';
import 'package:hookup4u/util/snackbar.dart';
import 'package:easy_localization/easy_localization.dart';

class SexualOrientation extends StatefulWidget {
  final Map<String, dynamic> userData;
  SexualOrientation(this.userData);

  @override
  _SexualOrientationState createState() => _SexualOrientationState();
}

class _SexualOrientationState extends State<SexualOrientation> {
  List<Map<String, dynamic>> orientationList = [
    {'name': 'Straight'.tr().toString(), 'ontap': false},
    {'name': 'Gay'.tr().toString(), 'ontap': false},
    {'name': 'Asexual'.tr().toString(), 'ontap': false},
    {'name': 'Lesbian'.tr().toString(), 'ontap': false},
    {'name': 'Bisexual'.tr().toString(), 'ontap': false},
    {'name': 'Demisexual'.tr().toString(), 'ontap': false},
  ];
  List selected = [];
  bool select = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: primaryColor,
      floatingActionButton: AnimatedOpacity(
        opacity: 1.0,
        duration: Duration(milliseconds: 50),
        child: Padding(
          padding: EdgeInsets.only(top: 10.0),
          child: FloatingActionButton(
            elevation: 10,
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
              dispose();
              Navigator.pop(context);
            },
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Stack(
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  child: Text(
                    "My sexual\norientation is".tr().toString(),
                    style: TextStyle(fontSize: 34, color: Colors.white),
                  ),
                  padding: EdgeInsets.only(left: 84, top: 96),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 70, vertical: 22),
                  child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: orientationList.length,
                    itemBuilder: (BuildContext context, index) {
                      return Padding(
                        padding: EdgeInsets.all(4.0),
                        child: InkWell(
                          onTap: (){
                            setState(() {
                              if (selected.length < 3) {
                                orientationList[index]["ontap"] =
                                !orientationList[index]["ontap"];
                                if (orientationList[index]["ontap"]) {
                                  selected.add(orientationList[index]["name"]);
                                  print(orientationList[index]["name"]);
                                  print(selected);
                                } else {
                                  selected.remove(orientationList[index]["name"]);
                                  print(selected);
                                }
                              } else {
                                if (orientationList[index]["ontap"]) {
                                  orientationList[index]["ontap"] =
                                  !orientationList[index]["ontap"];
                                  selected.remove(orientationList[index]["name"]);
                                } else {
                                  CustomSnackbar.snackbar("select upto 3".tr().toString(),
                                      _scaffoldKey
                                  );
                                }
                              }
                            });
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height * .055,
                            width: MediaQuery.of(context).size.width * .65,
                            child: Column(
                              children: [
                                Center(
                                  child: Text("${orientationList[index]["name"]}",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: orientationList[index]["ontap"] ? goldBtnColorDark
                                          : secondaryColor,
                                      fontWeight: FontWeight.bold
                                    )
                                  )
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 12, ),
                                  width: MediaQuery.of(context).size.width * 0.5,
                                  height: orientationList.length-1 == index ? 0 : 1,
                                  color: goldBtnColorDark,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 14),
                      child: InkWell(
                        onTap: (){
                          setState(() {
                            select = !select;
                          });
                        },
                        child: ListTile(
                          leading: select ? Icon(Icons.check_box, color: Colors.white,)
                              : Icon(Icons.check_box_outline_blank, color: Colors.white,),
                          title: Text("Show my orientation on my profile".tr().toString(),
                            style: TextStyle(
                                color: Colors.white
                            ),
                          ),
                        ),
                      ),
                    ),
                    selected.length > 0 ? Padding(
                      padding: EdgeInsets.only(left: 30, right: 24, top: 28),
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
                          widget.userData.addAll({
                            "sexualOrientation": {
                              'orientation': selected,
                              'showOnProfile': select
                            },
                          });
                          print(widget.userData);
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => ShowGender(widget.userData)
                              )
                          );
                        },
                      ),
                    )
                    : Padding(
                      padding: EdgeInsets.only(left: 30, right: 24, top: 28),
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
                        onPressed: () {
                          CustomSnackbar.snackbar("Please select one".tr().toString(), _scaffoldKey);
                        },
                      ),
                    ),
                    Container(height: 24,)
                  ],
                ),
              ],
            ),
          ),
          ]
        ),
      ),
    );
  }
}
