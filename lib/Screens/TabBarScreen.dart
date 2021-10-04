import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hookup4u/Screens/Profile/Profile.dart';
import 'package:hookup4u/Screens/SplashScreen.dart';
import 'package:hookup4u/Screens/LikedByScreen.dart';
import 'package:hookup4u/Screens/BlockUser.dart';
import 'package:hookup4u/Screens/Notifications.dart';
import 'package:hookup4u/models/UserModel.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'Calling/Incoming.dart';
import 'Chat/MessagesScreen.dart';
import 'LikeAndMatches.dart';
import 'NearByScreen.dart';
import 'package:hookup4u/util/color.dart';
import 'package:easy_localization/easy_localization.dart';

import 'NearBySearchs.dart';

List<UserModel> matches = [];
List<UserModel> newMatches = [];

class TabBarScreen extends StatefulWidget {
  final bool isPaymentSuccess;
  final String plan;
  TabBarScreen(this.plan, this.isPaymentSuccess);

  @override
  TabBarScreenState createState() => TabBarScreenState();
}

class TabBarScreenState extends State<TabBarScreen> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  CollectionReference usersRef = Firestore.instance.collection('Users');
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  UserModel currentUser;

  List<PurchaseDetails> purchases = [];
  InAppPurchaseConnection _iap = InAppPurchaseConnection.instance;
  bool isPurchased = false;

  Map items = {};

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    if (widget.isPaymentSuccess != null && widget.isPaymentSuccess) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await Alert(
          context: context,
          type: AlertType.success,
          title: "Confirmation".tr().toString(),
          desc: "You have successfully subscribed to our".tr(args: ['${widget.plan}']).toString(),
          buttons: [
            DialogButton(
              child: Text(
                "Ok".tr().toString(),
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
              width: 120,
            )
          ],
        ).show();
      });
    }
    _getAccessItems();
    _getCurrentUser();
    _getMatches();
    _getPastPurchases();
  }

  _getAccessItems() async {
    Firestore.instance.collection("Item_access").snapshots().listen((doc) {
      if (doc.documents.length > 0) {
        items = doc.documents[0].data;
      }
      if (mounted) setState(() {});
    });
  }

  _getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return usersRef.document("${user.uid}").snapshots().listen((data) async {
      currentUser = UserModel.fromDocument(data);
      if (mounted) setState(() {});
      configurePushNotification(currentUser);
      return currentUser;
    });
  }

  _getMatches() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return Firestore.instance.collection('/Users/${user.uid}/Matches')
      .orderBy('timestamp', descending: true).snapshots()
      .listen((onData) {
        matches.clear();
        newMatches.clear();
        if (onData.documents.length > 0) {
          onData.documents.forEach((f) async {
            await usersRef.document(f.data['Matches']).get().then((DocumentSnapshot doc) {
              if (doc.exists) {
                UserModel tempUser = UserModel.fromDocument(doc);
                tempUser.distanceBW = calculateDistance(
                  currentUser.coordinates['latitude'],
                  currentUser.coordinates['longitude'],
                  tempUser.coordinates['latitude'],
                  tempUser.coordinates['longitude']
                ).round();

                matches.add(tempUser);
                newMatches.add(tempUser);
                if (mounted) setState(() {});
              }
            });
          });
        }
      }
    );
  }

  Future<void> _getPastPurchases() async {
    QueryPurchaseDetailsResponse response = await _iap.queryPastPurchases();
    for (PurchaseDetails purchase in response.pastPurchases) {
      await _iap.completePurchase(purchase);
    }
    setState(() {
      purchases = response.pastPurchases;
    });
    if (response.pastPurchases.length > 0) {
      purchases.forEach((purchase) async {
        await _verifyPurchase(purchase.productID);
      });
    }
  }

  PurchaseDetails _hasPurchased(String productId) {
    return purchases.firstWhere((purchase) => purchase.productID == productId,
      orElse: () => null
    );
  }

  Future<void> _verifyPurchase(String id) async {
    PurchaseDetails purchase = _hasPurchased(id);
    if (purchase != null && purchase.status == PurchaseStatus.purchased) {
      if (Platform.isIOS) {
        await _iap.completePurchase(purchase);
        isPurchased = true;
      }
      isPurchased = true;
    } else {
      isPurchased = false;
    }
  }

  configurePushNotification(UserModel user) async {
    await _firebaseMessaging.requestNotificationPermissions(
      IosNotificationSettings(
        alert: true, sound: true, provisional: false, badge: true
      )
    );

    _firebaseMessaging.getToken().then((token) {
      usersRef.document(user.id).updateData({
        'pushToken': token,
      });
    });

    _firebaseMessaging.configure(
      onLaunch: (Map<String, dynamic> message) async {
        if (Platform.isIOS && message['type'] == 'Call') {
          Map callInfo = {};
          callInfo['channel_id'] = message['channel_id'];
          callInfo['senderName'] = message['senderName'];
          callInfo['senderPicture'] = message['senderPicture'];
          bool isCalling = await _checkCallState(message['channel_id']);
          if (isCalling) {
            await Navigator.push(context,
              MaterialPageRoute(builder: (context) => Incoming(message))
            );
          }
        } else if (Platform.isAndroid && message['data']['type'] == 'Call') {
          bool isCalling = await _checkCallState(message['data']['channel_id']);
          if (isCalling) {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Incoming(message['data'])
              )
            );
          }else {
            print("Timeout");
          }
        }
      },
      onMessage: (Map<String, dynamic> message) async {
        if (Platform.isIOS && message['type'] == 'Call') {
          Map callInfo = {};
          callInfo['channel_id'] = message['channel_id'];
          callInfo['senderName'] = message['senderName'];
          callInfo['senderPicture'] = message['senderPicture'];
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Incoming(callInfo))
          );
        }else if (Platform.isAndroid && message['data']['type'] == 'Call') {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Incoming(message['data'])
            )
          );
        } else
          print("object");
      },
      onResume: (Map<String, dynamic> message) async {
        if (Platform.isIOS && message['type'] == 'Call') {
          Map callInfo = {};
          callInfo['channel_id'] = message['channel_id'];
          callInfo['senderName'] = message['senderName'];
          callInfo['senderPicture'] = message['senderPicture'];
          bool isCalling = await _checkCallState(message['channel_id']);
          if (isCalling) {
            await Navigator.push(context,
              MaterialPageRoute(builder: (context) => Incoming(message))
            );
          }
        } else if (Platform.isAndroid && message['data']['type'] == 'Call') {
          bool isCalling = await _checkCallState(message['data']['channel_id']);
          if (isCalling) {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Incoming(message['data'])
              )
            );
          } else {
            print("Timeout");
          }
        }
      },
    );
  }

  _checkCallState(channelId) async {
    bool isCalling = await Firestore.instance.collection("calls")
      .document(channelId)
      .get().then((value) {
        return value.data["calling"] ?? false;
      }
    );
    return isCalling;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
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
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          brightness: Brightness.dark,
        ),
        body: currentUser == null ? Center(child: SplashScreen()) : currentUser.isBlocked ?
          BlockUser() : DefaultTabController(
            length: 5,
            initialIndex: 1,
            child: Scaffold(
              appBar: AppBar(
                elevation: 0,
                backgroundColor: primaryColor,
                automaticallyImplyLeading: false,
                title: TabBar(
                  labelColor: goldBtnColorDark,
                  indicatorColor: goldBtnColorDark,
                  unselectedLabelColor: secondaryColor,
                  isScrollable: false,
                  indicatorSize: TabBarIndicatorSize.label,
                  tabs: [
                    Tab(
                      icon: Icon(
                        Icons.assignment_ind_rounded,
                      ),
                    ),
                    Tab(
                      icon: Icon(
                        Icons.near_me,
                      ),
                    ),
                    Tab(
                      icon: Icon(
                        Icons.notifications,
                      ),
                    ),
                    Tab(
                      icon: Icon(
                        Icons.message,
                      ),
                    ),
                    Tab(
                      icon: Icon(
                        Icons.person,
                        size: 30,
                      ),
                    ),
                  ]
                ),
              ),
              body: TabBarView(
                children: [
                  Center(
                    child: LikeAndMatches(
                      currentUser, items
                    )
                  ),
                  Center(
                    child: NearBySearches(
                      currentUser, items
                    )
                  ),
                  Center(
                    child: Notifications(currentUser)
                  ),
                  Center(
                    child: MessagesScreen(
                      currentUser, matches, newMatches
                    )
                  ),
                  Center(
                    child: Profile(
                      currentUser, isPurchased, purchases, items
                    )
                  ),
                ],
                physics: NeverScrollableScrollPhysics(),
              )
          ),
        ),
      ),
    );
  }
}

double calculateDistance(lat1, lon1, lat2, lon2) {
  var p = 0.017453292519943295;
  var c = cos;
  var a = 0.5 - c((lat2 - lat1) * p) / 2 + c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
  return 12742 * asin(sqrt(a));
}
