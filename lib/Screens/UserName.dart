import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hookup4u/Screens/UserDOB.dart';
import 'package:hookup4u/util/color.dart';
import 'package:easy_localization/easy_localization.dart';

class UserName extends StatefulWidget {
  @override
  _UserNameState createState() => _UserNameState();
}

class _UserNameState extends State<UserName> {
  Map<String, dynamic> userData = {};
  String userName = '';

  @override
  void initState() {
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: AnimatedOpacity(
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
                child: Icon(Icons.arrow_back_ios, size: 28,),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                child: Text(
                  "My first\nname is".tr().toString(),
                  style: TextStyle(fontSize: 34, color: Colors.white.withOpacity(0.95)),
                ),
                padding: EdgeInsets.only(left: 84, top: 148),
              ),
              Padding(
                padding: EdgeInsets.only(left: 50, right: 50, top: 96),
                child: Container(
                  child: TextFormField(
                    style: TextStyle(fontSize: 23, color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Enter your first name".tr().toString(),
                      hintStyle: TextStyle(
                        color: secondaryColor,
                        fontSize: 18
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)
                      ),
                      disabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)
                      ),
                      helperText: "This is how it will appear in App.".tr().toString(),
                      helperStyle: TextStyle(
                        color: secondaryColor,
                        fontSize: 15
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        userName = value;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 32,
              ),
              userName.isNotEmpty ? Padding(
                padding: EdgeInsets.only(left: 30, right: 24, top: 128),
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
                    userData.addAll({'UserName': "$userName"});
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => UserDOB(userData)
                      )
                    );
                  },
                ),
              ) :
              Padding(
                padding: EdgeInsets.only(left: 30, right: 24, top: 128),
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
              ),
            ],
          ),
        ),
        ]
      ),
    );
  }
}
