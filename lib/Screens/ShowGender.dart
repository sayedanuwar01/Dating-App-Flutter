import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hookup4u/Screens/AboutMeScreen.dart';
import 'package:hookup4u/util/color.dart';
import 'package:hookup4u/util/snackbar.dart';
import 'package:easy_localization/easy_localization.dart';

class ShowGender extends StatefulWidget {
  final Map<String, dynamic> userData;
  ShowGender(this.userData);

  @override
  _ShowGenderState createState() => _ShowGenderState();
}

class _ShowGenderState extends State<ShowGender> {
  bool man = false;
  bool woman = false;
  bool everyOne = false;
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
                ),
              ),
            ),
          ),
          Container(
            child: Text(
              "Show me".tr().toString(),
              style: TextStyle(fontSize: 34, color: Colors.white),
            ),
            alignment: Alignment.topCenter,
            padding: EdgeInsets.only(top: 132),
          ),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 88),
                  child: InkWell(
                    onTap: (){
                      setState(() {
                        woman = false;
                        man = true;
                        everyOne = false;
                      });
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * .064,
                      width: MediaQuery.of(context).size.width * .64,
                      child: Center(
                        child: Text("MEN".tr().toString(),
                          style: TextStyle(
                            fontSize: 18,
                            color: man ? goldBtnColorDark : secondaryColor,
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
                      everyOne = false;
                    });
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * .064,
                    width: MediaQuery.of(context).size.width * .64,
                    child: Center(
                      child: Text("WOMEN".tr().toString(),
                        style: TextStyle(
                          fontSize: 18,
                          color: woman ? goldBtnColorDark : secondaryColor,
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
                      everyOne = true;
                    });
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * .064,
                    width: MediaQuery.of(context).size.width * .64,
                    child: Center(
                      child: Text("EVERYONE".tr().toString(),
                        style: TextStyle(
                          fontSize: 20,
                          color: everyOne ? goldBtnColorDark : secondaryColor,
                          fontWeight: FontWeight.bold
                        )
                      )
                    ),
                  ),
                ),
                man || woman || everyOne ? Padding(
                  padding: EdgeInsets.only(left: 30, right: 24, top: 112),
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
                      if (man) {
                        widget.userData.addAll({'showGender': "man"});
                      } else if (woman) {
                        widget.userData.addAll({'showGender': "woman"});
                      } else {
                        widget.userData.addAll({'showGender': "everyone"});
                      }

                      print(widget.userData);
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => AboutMeScreen(widget.userData)
                        )
                      );
                    },
                  ),
                )
                : Padding(
                  padding: EdgeInsets.only(left: 30, right: 24, top: 112),
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
