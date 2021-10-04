import 'dart:io';
import 'dart:ui';
import 'package:apple_sign_in/apple_sign_in.dart' as appleSignInBtn;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hookup4u/Screens/TabBarScreen.dart';
import 'package:hookup4u/Screens/Welcome.dart';
import 'package:hookup4u/Screens/auth/Otp.dart';
import 'package:hookup4u/models/CustomWebView.dart';
import 'package:hookup4u/util/color.dart';
import 'package:hookup4u/util/variables.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';

class Login extends StatelessWidget {
  static const your_client_id = '283501649855464'; //Facebook app ID
  static const your_redirect_url = 'https://puerto-dating-6982d.firebaseapp.com/__/auth/handler';
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
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
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.12),
                  ),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  SizedBox(height: 100,),
                  Image.asset(
                    'asset/hookup4u-Logo-BP.png',
                    width: 220,
                    fit: BoxFit.fitWidth,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 48, bottom: 16),
                    child: Material(
                      elevation: 2.0,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      child: Padding(
                        padding: EdgeInsets.all(6.0),
                        child: InkWell(
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(25),
                              gradient: LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [
                                  fbBtnColor.withOpacity(.95),
                                  fbBtnColor.withOpacity(.85),
                                  fbBtnColor.withOpacity(.85),
                                  fbBtnColor.withOpacity(.95),
                                ]
                              )
                            ),
                            height: MediaQuery.of(context).size.height * .065,
                            width: MediaQuery.of(context).size.width * .8,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset('asset/Icon/ic_fb.png', width: 28,),
                                SizedBox(width: 12,),
                                Text(
                                  "LOG IN WITH FACEBOOK".tr().toString(),
                                  style: TextStyle(
                                    color: textColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            )
                          ),
                          onTap: () async {
                            showDialog(
                              context: context,
                              builder: (context) => Container(
                                height: 30,
                                width: 30,
                                child: Center(
                                  child: CupertinoActivityIndicator(
                                    key: UniqueKey(),
                                    radius: 20,
                                    animating: true,
                                  )
                                )
                              )
                            );
                            await handleFacebookLogin(context).then((user) {
                              navigationCheck(user, context);
                            }).then((_) {
                              Navigator.pop(context);
                            }).catchError((e) {
                              Navigator.pop(context);
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  /*Platform.isIOS ? Padding(
                    padding: EdgeInsets.only(
                      top: 6, bottom: 16.0, left: 30, right: 30
                    ),
                    child: appleSignInBtn.AppleSignInButton(
                      cornerRadius: 50,
                      style: appleSignInBtn.ButtonStyle.whiteOutline,
                      type: appleSignInBtn.ButtonType.defaultButton,
                      onPressed: () async {
                        final FirebaseUser currentUser = await handleAppleLogin().catchError((onError) {
                          SnackBar snackBar = SnackBar(content: Text(onError));
                          _scaffoldKey.currentState.showSnackBar(snackBar);
                        });
                        if (currentUser != null) {
                          navigationCheck(currentUser, context);
                        }
                      },
                    ),
                  ) : Container(),*/
                  Padding(
                    padding: EdgeInsets.only(top: 6),
                    child: OutlineButton(
                      child: Container(
                        height: MediaQuery.of(context).size.height * .068,
                        width: MediaQuery.of(context).size.width * .74,
                        child: Center(
                          child: Text(
                            "LOG IN WITH PHONE NUMBER".tr().toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                            ),
                            textAlign: TextAlign.center,
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
                      onPressed: () {
                        bool updateNumber = false;
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => OTP(updateNumber)
                          )
                        );
                      },
                    ),
                  ),
                  Spacer(),
                  Text(
                    "Trouble logging in?".tr().toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.normal
                    ),
                  ),
                  SizedBox(height: 12,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        child: Text(
                          "Privacy Policy".tr().toString(),
                          style: TextStyle(color: Colors.blue),
                        ),
                        onTap: () => _launchURL(
                          "https://www.deligence.com/apps/hookup4u/Privacy-Policy.html"), //TODO: add privacy policy
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10, right: 10),
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.blue
                        ),
                      ),
                      GestureDetector(
                        child: Text(
                          "Terms & Conditions".tr().toString(),
                          style: TextStyle(color: Colors.blue),
                        ),
                        onTap: () => _launchURL(
                          "https://www.deligence.com/apps/hookup4u/Terms-Service.html"), //TODO: add Terms and conditions
                      ),
                    ],
                  ),
                  Container(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: Firestore.instance.collection('Language').snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            // child: Text('Lanuage not Found'),
                          );
                        }
                        return Column(
                          children: snapshot.data.documents.map((document) {
                            if (document['spanish'] == true && document['english'] == true) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FlatButton(
                                    child: Text(
                                      'Inglesa',
                                      style: TextStyle(
                                        color: languageIndex == 0 ? goldBtnColorLight : goldBtnColorDark
                                      ),
                                    ),
                                    onPressed: () {
                                      languageIndex = 0;
                                      EasyLocalization.of(context).locale = Locale('en', 'US');
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Login(),
                                        )
                                      );
                                    },
                                  ),
                                  FlatButton(
                                    child: Text(
                                      'Española',
                                      style: TextStyle(
                                        color: languageIndex == 1 ? goldBtnColorLight : goldBtnColorDark
                                      ),
                                    ),
                                    onPressed: () {
                                      languageIndex = 1;
                                      EasyLocalization.of(context).locale = Locale('es', 'ES');
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Login(),
                                        )
                                      );
                                    },
                                  ),
                                ],
                              );
                            } else {
                              return Text('');
                            }
                          }).toList(),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      onWillPop: () {
        return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Exit'.tr().toString()),
              content: Text('Do you want to exit the app?'.tr().toString()),
              actions: <Widget>[
                FlatButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('No'.tr().toString()),
                ),
                FlatButton(
                  onPressed: () => SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
                  child: Text('Yes'.tr().toString()),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<FirebaseUser> handleFacebookLogin(context) async {
    FirebaseUser user;
    String result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CustomWebView(
          selectedUrl: 'https://www.facebook.com/dialog/oauth?client_id=$your_client_id&redirect_uri=$your_redirect_url&response_type=token&scope=email,public_profile,',
        ),
        maintainState: true
      ),
    );
    if (result != null) {
      try {
        final facebookAuthCred = FacebookAuthProvider.getCredential(accessToken: result);
        user = (await FirebaseAuth.instance.signInWithCredential(facebookAuthCred)).user;
      } catch (e) {
        print('Error $e');
      }
    }
    return user;
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future navigationCheck(FirebaseUser currentUser, context) async {
    await Firestore.instance.collection('Users')
      .where('userId', isEqualTo: currentUser.uid)
      .getDocuments()
      .then((QuerySnapshot snapshot) async {
        if (snapshot.documents.length > 0) {
          if (snapshot.documents[0].data['location'] != null) {
            Navigator.push(context,
              CupertinoPageRoute(builder: (context) => TabBarScreen(null, null))
            );
          } else {
            Navigator.push(
              context, CupertinoPageRoute(builder: (context) => Welcome())
            );
          }
        } else {
          await _setDataUser(currentUser);
          Navigator.push(
            context, CupertinoPageRoute(builder: (context) => Welcome())
          );
        }
      }
    );
  }

  Future<FirebaseUser> handleAppleLogin() async {
    FirebaseUser user;
    if (await appleSignInBtn.AppleSignIn.isAvailable()) {
      try {
        final appleSignInBtn.AuthorizationResult result = await appleSignInBtn.AppleSignIn.performRequests([
          appleSignInBtn.AppleIdRequest(requestedScopes: [appleSignInBtn.Scope.email, appleSignInBtn.Scope.fullName])
        ]).catchError((onError) {
          print("inside $onError");
        });
        switch (result.status) {
          case appleSignInBtn.AuthorizationStatus.authorized:
            try {
              final appleSignInBtn.AppleIdCredential appleIdCredential = result.credential;
              OAuthProvider oAuthProvider = new OAuthProvider(providerId: "apple.com");
              final AuthCredential credential = oAuthProvider.getCredential(
                idToken: String.fromCharCodes(appleIdCredential.identityToken),
                accessToken: String.fromCharCodes(appleIdCredential.authorizationCode),
              );
              user = (await _auth.signInWithCredential(credential)).user;
            } catch (error) {
              print("Error $error");
            }
            break;
          case appleSignInBtn.AuthorizationStatus.error:
            _scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text('An error occured. Please Try again.'),
              duration: Duration(seconds: 8),
            ));
            break;
          case appleSignInBtn.AuthorizationStatus.cancelled:
            print('User cancelled');
            break;
        }
      } catch (error) {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('$error.'),
          duration: Duration(seconds: 8),
        ));
        print("error with apple sign in");
      }
    } else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Apple SignIn is not available for your device'),
        duration: Duration(seconds: 8),
      ));
    }
    return user;
  }
}

class WaveClipper1 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.height - 50);

    var firstEndPoint = Offset(size.width * 0.6, size.height - 29 - 50);
    var firstControlPoint = Offset(size.width * .25, size.height - 60 - 50);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, size.height - 60);
    var secondControlPoint = Offset(size.width * 0.84, size.height - 50);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class WaveClipper3 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.height - 50);

    var firstEndPoint = Offset(size.width * 0.6, size.height - 15 - 50);
    var firstControlPoint = Offset(size.width * .25, size.height - 60 - 50);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, size.height - 40);
    var secondControlPoint = Offset(size.width * 0.84, size.height - 30);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class WaveClipper2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.height - 50);

    var firstEndPoint = Offset(size.width * .7, size.height - 40);
    var firstControlPoint = Offset(size.width * .25, size.height);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, size.height - 45);
    var secondControlPoint = Offset(size.width * 0.84, size.height - 50);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

Future _setDataUser(FirebaseUser user) async {
  await Firestore.instance.collection("Users").document(user.uid).setData(
    {
      'userId': user.uid,
      'UserName': user.displayName ?? '',
      'phoneNumber': user.phoneNumber,
      'timestamp': FieldValue.serverTimestamp()
    },
    merge: true,
  );
}
