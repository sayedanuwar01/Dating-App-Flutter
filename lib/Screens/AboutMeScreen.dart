import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hookup4u/util/color.dart';
import 'package:easy_localization/easy_localization.dart';

import 'Profile/UploadProfileImage.dart';

class AboutMeScreen extends StatefulWidget {
  final Map<String, dynamic> userData;
  AboutMeScreen(this.userData);

  @override
  _AboutMeScreenState createState() => _AboutMeScreenState();
}

class _AboutMeScreenState extends State<AboutMeScreen> {
  final TextEditingController aboutCtrl = new TextEditingController();
  String aboutMe = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  child: Text(
                    "About Me".tr().toString(),
                    style: TextStyle(fontSize: 34, color: Colors.white),
                  ),
                  padding: EdgeInsets.only(top: 134),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 112, left: 22, right: 22),
                  child: ListTile(
                    title: Container(
                      margin: EdgeInsets.only(bottom: 6),
                      child: Text(
                        "About Me",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                          color: goldBtnColorLight
                        ),
                      ).tr(),
                    ),
                    subtitle: CupertinoTextField(
                      controller: aboutCtrl,
                      maxLines: 10,
                      minLines: 3,
                      placeholder: "About you".tr().toString(),
                      padding: EdgeInsets.all(10),
                      onChanged: (text) {
                        aboutMe = text;
                      },
                      cursorColor: Colors.white,
                      style: TextStyle(
                        color: goldBtnColorDark
                      ),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(width: 1, color: Colors.grey.withOpacity(0.85)),
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                      ),
                    ),
                  ),
                ),
                aboutMe.length > 0 ? Padding(
                  padding: EdgeInsets.only(left: 30, right: 24, top: 164),
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
                        'editInfo': {
                          'about': "$aboutMe",
                          'height': '',
                          'userGender': widget.userData['userGender'],
                          'showOnProfile': widget.userData['showOnProfile'],
                          'company': "",
                          'job_title': "",
                          'university': "",
                          'living_in': "",
                          'Ethnicity': "",
                          'IncomeAnnual': "",
                        }
                      });
                      widget.userData.remove('showOnProfile');
                      widget.userData.remove('userGender');

                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => UploadProfileImage(widget.userData)
                        )
                      );
                    },
                  ),
                )
                : Padding(
                  padding: EdgeInsets.only(left: 30, right: 24, top: 164),
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
                    onPressed: () {},
                  ),
                )
              ],
            ),
          ),
        ]
      ),
    );
  }
}
