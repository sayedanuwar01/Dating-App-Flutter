import 'dart:ui';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hookup4u/Screens/TabBarScreen.dart';
import 'package:hookup4u/Screens/auth/OtpVerification.dart';
import 'package:hookup4u/util/color.dart';
import 'package:hookup4u/util/snackbar.dart';
import 'Login.dart';
import 'package:easy_localization/easy_localization.dart';

class OTP extends StatefulWidget {
  final bool updateNumber;
  OTP(this.updateNumber);

  @override
  _OTPState createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool cont = false;
  String _smsVerificationCode;
  String countryCode = '+1';
  TextEditingController phoneNumController = new TextEditingController();
  Login _login = new Login();

  @override
  void dispose() {
    super.dispose();
    cont = false;
  }

  Future _verifyPhoneNumber(String phoneNumber) async {
    phoneNumber = countryCode + phoneNumber.toString();
    final FirebaseAuth _auth = FirebaseAuth.instance;
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: Duration(seconds: 30),
      verificationCompleted: (authCredential) => _verificationComplete(
        authCredential,
        context
      ),
      verificationFailed: (authException) => _verificationFailed(
        authException,
        context
      ),
      codeAutoRetrievalTimeout: (verificationId) => _codeAutoRetrievalTimeout(
        verificationId
      ),
      codeSent: (verificationId, [code]) => _smsCodeSent(verificationId, [code])
    );
  }

  Future updatePhoneNumber() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    await Firestore.instance.collection("Users")
      .document(user.uid)
      .setData(
        {'phoneNumber': user.phoneNumber},
        merge: true
      ).then((_) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.SUCCES,
          animType: AnimType.BOTTOMSLIDE,
          title: 'SUCCESS',
          desc: "Phone Number\nChanged\nSuccessfully".tr().toString(),
          btnOkOnPress: () {
            Navigator.pop(context);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => TabBarScreen(null, null))
            );
          },
        )..show();
      }
    );
  }

  _verificationComplete(
    AuthCredential authCredential, BuildContext context) async {
      if (widget.updateNumber) {
        FirebaseUser user = await FirebaseAuth.instance.currentUser();
        user.updatePhoneNumberCredential(authCredential)
          .then((_) => updatePhoneNumber())
          .catchError((e) {
            CustomSnackbar.snackbar("$e", _scaffoldKey);
          }
        );
      } else {
        FirebaseAuth.instance.signInWithCredential(authCredential)
          .then((authResult) async {
            AwesomeDialog(
              context: context,
              dialogType: DialogType.SUCCES,
              animType: AnimType.BOTTOMSLIDE,
              title: 'SUCCESS',
              desc: "Verified\n Successfully".tr().toString(),
              btnOkOnPress: () async {
                await Firestore.instance.collection('Users')
                  .where('userId', isEqualTo: authResult.user.uid)
                  .getDocuments()
                  .then((QuerySnapshot snapshot) async {
                    await setDataUser(authResult.user);
                    Navigator.pop(context);
                    await _login.navigationCheck(authResult.user, context);
                  }
                );
              },
            )..show();
        }
      );
    }
  }

  _smsCodeSent(String verificationId, List<int> code) async {
    _smsVerificationCode = verificationId;
    AwesomeDialog(
      context: context,
      dialogType: DialogType.SUCCES,
      animType: AnimType.BOTTOMSLIDE,
      title: 'SUCCESS',
      desc: "OTP\nSent".tr().toString(),
      btnOkOnPress: () async {
        Navigator.pop(context);
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => OtpVerification(
              countryCode + phoneNumController.text,
              _smsVerificationCode,
              widget.updateNumber
            )
          )
        );
      },
    )..show();
  }

  _verificationFailed(AuthException authException, BuildContext context) {
    CustomSnackbar.snackbar('Enter valid phone number.',
      _scaffoldKey
    );
  }

  _codeAutoRetrievalTimeout(String verificationId) {
    _smsVerificationCode = verificationId;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Image.asset(
              'asset/images/s10.png',
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fitWidth,
            ),
          ),
          ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 64,),
                  ListTile(
                    title: Text(
                      "Verify Your Number".tr().toString(),
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 27,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                      ),
                    ),
                    subtitle: Padding(
                      padding: EdgeInsets.only(left: 12, top: 12),
                      child: Text(
                        "Please enter Your mobile Number to\n receive a verification code. Message and data\n rates may apply".tr().toString(),
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 15, 
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withOpacity(0.8)
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 50, horizontal: 8),
                    child: ListTile(
                      leading: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                          color: Colors.white
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: CountryCodePicker(
                            onChanged: (value) {
                              countryCode = value.dialCode;
                            },
                            initialSelection: 'PR',
                            favorite: [countryCode, 'PR'],
                            showCountryOnly: false,
                            showOnlyCountryWhenClosed: false,
                            alignLeft: false,
                          ),
                        ),
                      ),
                      title: Container(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: TextFormField(
                            keyboardType: TextInputType.phone,
                            style: TextStyle(fontSize: 16),
                            cursorColor: primaryColor,
                            controller: phoneNumController,
                            onChanged: (value) {
                              setState(() {
                                if(value.isEmpty){
                                  cont = false;
                                }else{
                                  cont = true;
                                }
                              });
                            },
                            decoration: InputDecoration(
                              hintText: "Enter your number".tr().toString(),
                              hintStyle: TextStyle(fontSize: 16),
                              focusColor: Colors.white,
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)
                              ),
                            ),
                          ),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                          color: Colors.white
                        ),
                      )
                    )
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: OutlineButton(
                      child: Container(
                        height: MediaQuery.of(context).size.height * .068,
                        width: MediaQuery.of(context).size.width * .74,
                        child: Center(
                          child: Text(
                            "CONTINUE".tr().toString(),
                            style: TextStyle(
                              color: cont ? Colors.white : Colors.grey,
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
                        color: cont ? Colors.white : Colors.grey,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)
                      ),
                      onPressed: () async {
                        if(cont){
                          showDialog(
                            builder: (context) {
                              Future.delayed(Duration(seconds: 1), () {
                                Navigator.pop(context);
                              });
                              return Center(
                                child: CupertinoActivityIndicator(
                                  radius: 20,
                                )
                              );
                            },
                            barrierDismissible: false,
                            context: context,
                          );
                          await _verifyPhoneNumber(phoneNumController.text);
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future setDataUser(FirebaseUser user) async {
  await Firestore.instance.collection("Users").document(user.uid).setData({
      'userId': user.uid,
      'phoneNumber': user.phoneNumber,
      'timestamp': FieldValue.serverTimestamp(),
    },
    merge: true
  );
}
