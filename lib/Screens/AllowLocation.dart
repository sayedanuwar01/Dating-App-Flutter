import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hookup4u/util/color.dart';
import 'package:easy_localization/easy_localization.dart';
import 'TabBarScreen.dart';
import 'UpdateLocation.dart';

class AllowLocation extends StatelessWidget {
  final Map<String, dynamic> userData;
  AllowLocation(this.userData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            AnimatedOpacity(
              opacity: 1.0,
              duration: Duration(milliseconds: 50),
              child: Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: FloatingActionButton(
                  elevation: 2,
                  child: IconButton(
                    color: Colors.white,
                    icon: Padding(
                      padding: EdgeInsets.only(left: 6.0),
                      child: Icon(Icons.arrow_back_ios, size: 28, ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  backgroundColor: goldBtnColorDark,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
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
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Stack(children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 96),
                      child: Center(
                        child: CircleAvatar(
                          backgroundColor: secondaryColor.withOpacity(.3),
                          radius: 110,
                          child: Icon(
                            Icons.location_on,
                            color: goldBtnColorLight,
                            size: 84,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 0),
                      child: RichText(
                        text: TextSpan(
                          text: "Enable location".tr().toString(),
                          style: TextStyle(color: Colors.white, fontSize: 34),
                          children: [
                            TextSpan(
                              text: "\n\nYou'll need to provide a \nlocation\nin order to search users around you.".tr().toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Colors.white54,
                                textBaseline: TextBaseline.alphabetic,
                                fontSize: 18
                              )
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      )
                    ),
                    Padding(
                      padding: EdgeInsets.all(50.0),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 40.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: InkWell(
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(25),
                          color: goldBtnColorDark,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0.0, 1.0), //(x,y)
                              blurRadius: 3,
                            ),
                          ]
                        ),
                        height: MediaQuery.of(context).size.height * .062,
                        width: MediaQuery.of(context).size.width * .75,
                        child: Center(
                          child: Text(
                            "ALLOW LOCATION".tr().toString(),
                            style: TextStyle(
                              fontSize: 15,
                              color: textColor,
                              fontWeight: FontWeight.bold
                            ),
                          )
                        )
                      ),
                      onTap: () async {
                        var currentLocation = await getLocationCoordinates();
                        if (currentLocation != null) {
                          userData.addAll(
                            {
                              'location': {
                                'latitude': currentLocation['latitude'],
                                'longitude': currentLocation['longitude'],
                                'address': currentLocation['PlaceName'],
                              },
                              'maximum_distance': 10000,
                              'age_range': {
                                'min': "20",
                                'max': "50",
                              },
                            },
                          );
                          showWelcomeDialog(context);
                          setUserData(userData);
                        }
                      },
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ]
      ),
    );
  }
}

Future setUserData(Map<String, dynamic> userData) async {
  await FirebaseAuth.instance.currentUser().then((FirebaseUser user) async {
    await Firestore.instance
      .collection("Users")
      .document(user.uid)
      .setData(userData, merge: true);
  });
}

Future showWelcomeDialog(context) async {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (_) {
      Future.delayed(Duration(seconds: 3), () {
        Navigator.pop(context);
        Navigator.push(context,
          CupertinoPageRoute(builder: (context) => TabBarScreen(null, null)));
      });
      return Center(
        child: Container(
          width: 150.0,
          height: 100.0,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(20)),
          child: Column(
            children: <Widget>[
              Image.asset(
                "asset/auth/verified.jpg",
                height: 60,
                color: primaryColor,
                colorBlendMode: BlendMode.color,
              ),
              Text(
                "You'r in".tr().toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  decoration: TextDecoration.none,
                  color: Colors.black,
                  fontSize: 20
                ),
              )
            ],
          )
        )
      );
    }
  );
}
