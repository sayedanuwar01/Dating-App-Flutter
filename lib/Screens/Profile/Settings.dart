import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:hookup4u/Screens/UpdateLocation.dart';
import 'package:hookup4u/Screens/auth/Login.dart';
import 'package:hookup4u/models/UserModel.dart';
import 'package:hookup4u/util/color.dart';
import 'package:share/share.dart';
import '../TabBarScreen.dart';
import 'UpdateNumber.dart';

import 'package:easy_localization/easy_localization.dart';

class Settings extends StatefulWidget {
  final UserModel currentUser;
  final bool isPurchased;
  final Map items;
  Settings(this.currentUser, this.isPurchased, this.items);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Map<String, dynamic> changeValues = {};

  RangeValues ageRange;
  var _showMe;
  int distance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  @override
  void dispose() {
    super.dispose();

    if (changeValues.length > 0) {
      updateData();
    }
  }

  Future updateData() async {
    Firestore.instance
      .collection("Users")
      .document(widget.currentUser.id)
      .setData(changeValues, merge: true);
  }

  int freeR;
  int paidR;

  @override
  void initState() {
    super.initState();
    freeR = widget.items['free_radius'] != null
      ? int.parse(widget.items['free_radius'])
      : 40000;
    paidR = widget.items['paid_radius'] != null
      ? int.parse(widget.items['paid_radius'])
      : 40000;

    setState(() {
      if (!widget.isPurchased && widget.currentUser.maxDistance > freeR) {
        widget.currentUser.maxDistance = freeR.round();
        changeValues.addAll({'maximum_distance': freeR.round()});
      } else if (widget.isPurchased &&
          widget.currentUser.maxDistance >= paidR) {
        widget.currentUser.maxDistance = paidR.round();
        changeValues.addAll({'maximum_distance': paidR.round()});
      }
      _showMe = widget.currentUser.showGender;
      distance = widget.currentUser.maxDistance.round();
      ageRange = RangeValues(double.parse(widget.currentUser.ageRange['min']),
          (double.parse(widget.currentUser.ageRange['max'])));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor.withOpacity(0.88),
      appBar: AppBar(
        title: Text(
          "Settings".tr().toString(),
          style: TextStyle(color: goldBtnColorDark),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: goldBtnColorDark,
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
        backgroundColor: primaryColor
      ),
      body: Container(
        decoration: BoxDecoration(
          color: primaryColor.withAlpha(0)
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50), topRight: Radius.circular(50)),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 18, left: 16, right: 12),
                  child: Text(
                    "Account settings".tr().toString(),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: goldBtnColorDark),
                  ),
                ),
                ListTile(
                  title: Container(
                    child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: InkWell(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Phone Number".tr().toString(), style: TextStyle(color: goldBtnColorLight, fontSize: 14),),
                          Padding(
                            padding: EdgeInsets.only(
                              left: 20,
                            ),
                            child: Text(
                              widget.currentUser.phoneNumber != null ? "${widget.currentUser.phoneNumber}"
                                : "Verify Now".tr().toString(),
                              style: TextStyle(color: Colors.white.withOpacity(0.8)),
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white.withOpacity(0.8),
                            size: 15,
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(builder: (context) => UpdateNumber(widget.currentUser)));
                      },
                    ),
                  )),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 26, ),
                  width: MediaQuery.of(context).size.width,
                  height: 1,
                  color: goldBtnColorDark.withOpacity(0.6),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16.0, right: 10, top: 22),
                  child: Text(
                    "Discovery settings".tr().toString(),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: goldBtnColorDark),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Container(
                    child: ExpansionTile(
                      key: UniqueKey(),
                      leading: Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: Text(
                          "Current location : ".tr().toString(),
                          style: TextStyle(
                            fontSize: 14,
                            color: goldBtnColorLight
                          ),
                        ),
                      ),
                      title: Text(
                        widget.currentUser.address,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.location_on,
                                color: Colors.white.withOpacity(0.8),
                                size: 25,
                              ),
                              InkWell(
                                child: Text(
                                  '${"Change location".tr().toString()}  ',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onTap: () async {
                                  var address = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              UpdateLocation()));
                                  print(address);
                                  if (address != null) {
                                    _updateAddress(address);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 32, bottom: 2
                  ),
                  child: Text(
                    "Change your location to see members in other city".tr().toString(),
                    style: TextStyle(color: goldBtnColorDark, fontSize: 12),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 26, right: 26, top: 8),
                  width: MediaQuery.of(context).size.width,
                  height: 1,
                  color: goldBtnColorDark.withOpacity(0.6),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16.0, right: 10, top: 20),
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Show me".tr().toString(),
                          style: TextStyle(
                            fontSize: 18,
                            color: goldBtnColorDark,
                            fontWeight: FontWeight.w500
                          ),
                        ),
                        ListTile(
                          title: DropdownButton(
                            iconEnabledColor: goldBtnColorDark,
                            iconDisabledColor: goldBtnColorDark,
                            isExpanded: true,
                            underline: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 1,
                              color: goldBtnColorDark.withOpacity(0.6),
                            ),
                            items: [
                              DropdownMenuItem(
                                child: Text("Man".tr().toString(), style: TextStyle(fontSize: 14, color: goldBtnColorDark),),
                                value: "man",
                              ),
                              DropdownMenuItem(
                                child: Text("Woman".tr().toString(), style: TextStyle(fontSize: 14, color: goldBtnColorDark),),
                                value: "woman"
                              ),
                              DropdownMenuItem(
                                child: Text("Everyone".tr().toString(), style: TextStyle(fontSize: 14, color: goldBtnColorDark),),
                                value: "everyone"
                              ),
                            ],
                            onChanged: (val) {
                              changeValues.addAll({
                                'showGender': val,
                              });
                              setState(() {
                                _showMe = val;
                              });
                            },
                            value: _showMe,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding:  EdgeInsets.only(top: 8),
                  child: Container(
                    child: ListTile(
                      title: Text(
                        "Maximum distance".tr().toString(),
                        style: TextStyle(
                          fontSize: 18,
                          color: goldBtnColorDark,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                      trailing: Text(
                        "${distance * 0.62} Miles.",
                        style: TextStyle(fontSize: 16, color: goldBtnColorDark),
                      ),
                      subtitle: Slider(
                        value: distance.toDouble(),
                        inactiveColor: secondaryColor,
                        min: 1.0,
                        max: widget.isPurchased ? paidR.toDouble() : freeR.toDouble(),
                        activeColor: goldBtnColorDark.withOpacity(0.7),
                        onChanged: (val) {
                          changeValues.addAll({'maximum_distance': val.round()});
                          setState(() {
                            distance = val.round();
                          });
                        }
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 26, right: 26, ),
                  width: MediaQuery.of(context).size.width,
                  height: 1,
                  color: goldBtnColorDark.withOpacity(0.6),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 18),
                  child: Container(
                    child: ListTile(
                      title: Text(
                        "Age range".tr().toString(),
                        style: TextStyle(
                          fontSize: 18,
                          color: goldBtnColorDark,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                      trailing: Text(
                        "${ageRange.start.round()}-${ageRange.end.round()}",
                        style: TextStyle(fontSize: 16, color: goldBtnColorDark),
                      ),
                      subtitle: RangeSlider(
                        inactiveColor: secondaryColor,
                        values: ageRange,
                        min: 18.0,
                        max: 100.0,
                        divisions: 25,
                        activeColor: goldBtnColorDark.withOpacity(0.7),
                        labels: RangeLabels('${ageRange.start.round()}',
                          '${ageRange.end.round()}'),
                        onChanged: (val) {
                          changeValues.addAll({
                            'age_range': {
                              'min': '${val.start.truncate()}',
                              'max': '${val.end.truncate()}'
                            }
                          });
                          setState(() {
                            ageRange = val;
                          });
                        }
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 26, right: 26, ),
                  width: MediaQuery.of(context).size.width,
                  height: 1,
                  color: goldBtnColorDark.withOpacity(0.6),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: ListTile(
                    title: Text(
                      "Change Language".tr().toString(),
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: goldBtnColorDark),
                    ),
                  ),
                ),
                Container(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance.collection('Language').snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: Text('Lanuage not Found'),);
                      }
                      return Column(
                        children: snapshot.data.documents.map((document) {
                          if (document['spanish'] == true &&
                              document['english'] == true) {
                            return ListTile(
                              subtitle: Container(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 12.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          FlatButton(
                                            child: Text(
                                              "English".tr().toString(),
                                              style: TextStyle(
                                                color: goldBtnColorDark
                                              ),
                                            ),
                                            onPressed: () async {
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text(
                                                      "Change Language".tr().toString()
                                                    ),
                                                    content: Text(
                                                      'Do you want to change the language to English?'.tr().toString()
                                                    ),
                                                    actions: <Widget>[
                                                      FlatButton(
                                                        onPressed: () => Navigator.of(context).pop(false),
                                                        child: Text(
                                                          'No'.tr().toString()
                                                        ),
                                                      ),
                                                      FlatButton(
                                                        onPressed: () {
                                                          EasyLocalization.of(context).locale = Locale('en', 'US');
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(builder: (context) => TabBarScreen(null, false)));
                                                        },
                                                        child: Text(
                                                          'Yes'.tr().toString()
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                          FlatButton(
                                            child: Text(
                                              "Spanish".tr().toString(),
                                              style: TextStyle(
                                                color: goldBtnColorDark
                                              ),
                                            ),
                                            onPressed: () async {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text(
                                                      "Change Language".tr().toString()
                                                    ),
                                                    content: Text(
                                                      'Do you want to change the language to Spanish?'.tr().toString()
                                                    ),
                                                    actions: <Widget>[
                                                      FlatButton(
                                                        onPressed: () => Navigator.of(context).pop(false),
                                                        child: Text('No'.tr().toString()),
                                                      ),
                                                      FlatButton(
                                                        onPressed: () {
                                                          EasyLocalization.of(context).locale = Locale('es', 'ES');
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(builder: (context) => TabBarScreen(null, false))
                                                          );
                                                        },
                                                        child: Text('Yes'.tr().toString()),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return Text('');
                          }
                        }).toList(),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(12.0),
                  child: InkWell(
                    child: Card(

                      child: Padding(
                        padding: EdgeInsets.all(14.0),
                        child: Center(
                          child: Text(
                            "Invite your friends".tr().toString(),
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: 15,
                              fontWeight: FontWeight.w500
                            ),
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                      Share.share(
                        'https://puerutorico.page.link/rniX', //Replace with your dynamic link and msg for invite users
                        subject: 'PerutoRico Luxy'.tr().toString()
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(12.0),
                  child: InkWell(
                    child: Card(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(14.0),
                          child: Text(
                            "Logout".tr().toString(),
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ),
                    onTap: () async {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Logout'.tr().toString()),
                            content: Text('Do you want to logout your account?'
                                .tr()
                                .toString()),
                            actions: <Widget>[
                              FlatButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: Text('No'.tr().toString()),
                              ),
                              FlatButton(
                                onPressed: () async {
                                  await _auth.signOut().whenComplete(() {
                                    _firebaseMessaging.deleteInstanceID();
                                    Navigator.pushReplacement(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (context) => Login()),
                                    );
                                  });
                                },
                                child: Text('Yes'.tr().toString()),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(12.0),
                  child: InkWell(
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(14.0),
                        child: Center(
                          child: Text(
                            "Delete Account".tr().toString(),
                            style: TextStyle(
                                color: primaryColor,
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ),
                    onTap: () async {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Delete Account'.tr().toString()),
                            content: Text('Do you want to delete your account?'
                                .tr()
                                .toString()),
                            actions: <Widget>[
                              FlatButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: Text('No'.tr().toString()),
                              ),
                              FlatButton(
                                onPressed: () async {
                                  final user = await _auth
                                      .currentUser()
                                      .then((FirebaseUser user) {
                                    return user;
                                  });
                                  await _deleteUser(user).then((_) async {
                                    await _auth.signOut().whenComplete(() {
                                      Navigator.pushReplacement(
                                        context,
                                        CupertinoPageRoute(
                                            builder: (context) => Login()),
                                      );
                                    });
                                  });
                                },
                                child: Text('Yes'.tr().toString()),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Center(
                    child: Container(
                      height: 120,
                      width: 120,
                      child: Image.asset(
                        "asset/hookup4u-Logo-BP.png",
                        width: 80,
                        fit: BoxFit.fitWidth,
                      )
                    ),
                  )
                ),
                SizedBox(
                  height: 56,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _updateAddress(Map _address) {
    showCupertinoModalPopup(
        context: context,
        builder: (ctx) {
          return Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * .4,
            child: Column(
              children: <Widget>[
                Material(
                  child: ListTile(
                    title: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'New address:'.tr().toString(),
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.none),
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.cancel,
                        color: Colors.black26,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    subtitle: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          _address['PlaceName'] ?? '',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                              decoration: TextDecoration.none),
                        ),
                      ),
                    ),
                  ),
                ),
                RaisedButton(
                  color: Colors.white,
                  child: Text(
                    "Confirm".tr().toString(),
                    style: TextStyle(color: primaryColor),
                  ),
                  onPressed: () async {
                    Navigator.pop(context);
                    await Firestore.instance
                        .collection("Users")
                        .document('${widget.currentUser.id}')
                        .updateData({
                          'location': {
                            'latitude': _address['latitude'],
                            'longitude': _address['longitude'],
                            'address': _address['PlaceName']
                          },
                        })
                        .whenComplete(() => showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (_) {
                              Future.delayed(Duration(seconds: 3), () {
                                setState(() {
                                  widget.currentUser.address =
                                      _address['PlaceName'];
                                });

                                Navigator.pop(context);
                              });
                              return Center(
                                  child: Container(
                                      width: 160.0,
                                      height: 120.0,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.rectangle,
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Column(
                                        children: <Widget>[
                                          Image.asset(
                                            "asset/auth/verified.jpg",
                                            height: 60,
                                            color: primaryColor,
                                            colorBlendMode: BlendMode.color,
                                          ),
                                          Text(
                                            "location\nchanged".tr().toString(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                decoration: TextDecoration.none,
                                                color: Colors.black,
                                                fontSize: 20),
                                          )
                                        ],
                                      )));
                            }))
                        .catchError((e) {
                          print(e);
                        });
                  },
                )
              ],
            ),
          );
        });
  }

  Future _deleteUser(FirebaseUser user) async {
    await Firestore.instance.collection("Users").document(user.uid).delete();
  }
}
