import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hookup4u/Screens/UserDOB.dart';
import 'package:hookup4u/Screens/UserName.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hookup4u/util/constants.dart';

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
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
                filter: ImageFilter.blur(sigmaX: 32, sigmaY: 32),
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
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 110,
                          ),
                          Text(
                            appName,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 26,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.normal
                            ),
                          ),
                          SizedBox(
                            height: 38,
                          ),
                          ListTile(
                            contentPadding: EdgeInsets.only(left: 8, right: 8, top: 12, bottom: 8),
                            title: Text(
                              "Welcome to $appName.\nPlease follow these House Rules.".tr().toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                          ListTile(
                            contentPadding: EdgeInsets.all(8),
                            title: Text(
                              "Be yourself.".tr().toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            subtitle: Text(
                              "Make sure your photos, age, and bio are true to who you are.".tr().toString(),
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          ListTile(
                            contentPadding: EdgeInsets.all(8),
                            title: Text(
                              "Play it cool.".tr().toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            subtitle: Text(
                              "Respect other and treat them as you would like to be treated".tr().toString(),
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          ListTile(
                            contentPadding: EdgeInsets.all(8),
                            title: Text(
                              "Stay safe.".tr().toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            subtitle: Text(
                              "Don't be too quick to give out personal information.".tr().toString(),
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          ListTile(
                            contentPadding: EdgeInsets.all(8),
                            title: Text(
                              "Be proactive.".tr().toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            subtitle: Text(
                              "Always report bad behavior.".tr().toString(),
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                    child: OutlineButton(
                      child: Container(
                        height: MediaQuery.of(context).size.height * .064,
                        width: MediaQuery.of(context).size.width * .74,
                        child: Center(
                          child: Text(
                            "GOT IT".tr().toString(),
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                            ),
                          )
                        ),
                        color: Colors.transparent,
                      ),
                      borderSide: BorderSide(
                        width: 2,
                        style: BorderStyle.solid,
                        color: Colors.white
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)
                      ),
                      onPressed: () async {
                        await FirebaseAuth.instance.currentUser().then((_user) {
                          if (_user.displayName != null) {
                            if (_user.displayName.length > 0) {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => UserDOB(
                                    {'UserName': _user.displayName}
                                  )
                                )
                              );
                            }else {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => UserName()
                                )
                              );
                            }
                          }else {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => UserName()
                              )
                            );
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
