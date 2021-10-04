import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hookup4u/Screens/SexualOrientation.dart';
import 'package:hookup4u/Screens/UserName.dart';
import 'package:hookup4u/util/color.dart';
import 'package:hookup4u/util/snackbar.dart';
import 'package:easy_localization/easy_localization.dart';

class Gender extends StatefulWidget {
  final Map<String, dynamic> userData;
  Gender(this.userData);

  @override
  _GenderState createState() => _GenderState();
}

class _GenderState extends State<Gender> {
  bool man = false;
  bool woman = false;
  bool other = false;
  bool select = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
      body: Stack(
        children: <Widget>[
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
          Padding(
            child: Text(
              "I am a".tr().toString(),
              style: TextStyle(fontSize: 34, color: Colors.white),
            ),
            padding: EdgeInsets.only(left: 84, top: 148),
          ),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 164),
                  child: InkWell(
                    onTap: (){
                      setState(() {
                        woman = false;
                        man = true;
                        other = false;
                      });
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * .065,
                      width: MediaQuery.of(context).size.width * .64,
                      child: Center(
                        child: Text("MAN".tr().toString(),
                          style: TextStyle(
                            fontSize: 18,
                            color: man ? goldBtnColorDark : Colors.white.withOpacity(0.7),
                            fontWeight: FontWeight.bold
                          )
                        )
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 6, bottom: 6),
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: 1,
                  color: goldBtnColorDark,
                ),
                InkWell(
                  onTap: (){
                    setState(() {
                      woman = true;
                      man = false;
                      other = false;
                    });
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * .065,
                    width: MediaQuery.of(context).size.width * .64,
                    child: Center(
                      child: Text("WOMAN".tr().toString(),
                        style: TextStyle(
                          fontSize: 18,
                          color: woman ? goldBtnColorDark : Colors.white.withOpacity(0.7),
                          fontWeight: FontWeight.bold
                        )
                      )
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 6, bottom: 6),
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: 1,
                  color: goldBtnColorDark,
                ),
                InkWell(
                  onTap: (){
                    setState(() {
                      woman = false;
                      man = false;
                      other = true;
                    });
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * .065,
                    width: MediaQuery.of(context).size.width * .64,
                    child: Center(
                      child: Text("OTHER".tr().toString(),
                        style: TextStyle(
                          fontSize: 18,
                          color: other ? goldBtnColorDark : Colors.white.withOpacity(0.7),
                          fontWeight: FontWeight.bold
                        )
                      )
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 44.0, left: 18),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: InkWell(
                      onTap: (){
                        setState(() {
                          select = !select;
                        });
                      },
                      child: Center(
                        child: ListTile(
                          leading: select ? Icon(Icons.check_box, color: Colors.white,)
                            : Icon(Icons.check_box_outline_blank, color: Colors.white,),
                          title: Text("Show my gender on my profile".tr().toString(),
                            style: TextStyle(
                              color: Colors.white
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                man || woman || other ? Padding(
                  padding: EdgeInsets.only(left: 30, right: 24, top: 28),
                  child: OutlineButton(
                    child: Container(
                      height: MediaQuery.of(context).size.height * .062,
                      width: MediaQuery.of(context).size.width * .64,
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
                      var userGender;
                      if (man) {
                        userGender = {
                          'userGender': "man",
                          'showOnProfile': select
                        };
                      } else if (woman) {
                        userGender = {
                          'userGender': "woman",
                          'showOnProfile': select
                        };
                      } else {
                        userGender = {
                          'userGender': "other",
                          'showOnProfile': select
                        };
                      }
                      widget.userData.addAll(userGender);
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => SexualOrientation(widget.userData)
                        )
                      );
                    },
                  ),
                ) : Padding(
                  padding: EdgeInsets.only(left: 30, right: 24, top: 28),
                  child: OutlineButton(
                    child: Container(
                      height: MediaQuery.of(context).size.height * .062,
                      width: MediaQuery.of(context).size.width * .64,
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
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
