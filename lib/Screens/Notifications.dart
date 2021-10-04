import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hookup4u/Screens/UserInfoScreen.dart';
import 'package:hookup4u/models/UserModel.dart';
import 'package:hookup4u/util/color.dart';
import 'package:easy_localization/easy_localization.dart';

import 'TabBarScreen.dart';

class Notifications extends StatefulWidget {
  final UserModel currentUser;
  Notifications(this.currentUser);

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final db = Firestore.instance;
  CollectionReference matchRef;

  @override
  void initState() {
    matchRef = db.collection("Users")
      .document(widget.currentUser.id)
      .collection('Matches');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Notifications'.tr().toString(),
          style: TextStyle(
            color: goldBtnColorDark,
            fontSize: 18.0,
            letterSpacing: 1.0,
          ),
        ),
        elevation: 0,
      ),
      backgroundColor: primaryColor,
      body: Container(
        color: Colors.white,
        child: ClipRRect(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              StreamBuilder<QuerySnapshot>(
                stream: matchRef.orderBy('timestamp', descending: true).snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData)
                    return Center(
                      child: Text(
                        "No Notification".tr().toString(),
                        style: TextStyle(color: secondaryColor, fontSize: 16),
                      )
                    );
                  else if (snapshot.data.documents.length == 0) {
                    return Center(
                      child: Text(
                        "No Notification".tr().toString(),
                        style: TextStyle(color: secondaryColor, fontSize: 16),
                      )
                    );
                  }
                  return Expanded(
                    child: ListView(
                      children: snapshot.data.documents.map((doc) => Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: !doc.data['isRead'] ? primaryColor.withOpacity(.15)
                              : secondaryColor.withOpacity(.15)
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.all(5),
                            leading: CircleAvatar(
                              radius: 25,
                              backgroundColor: secondaryColor,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(25,),
                                child: CachedNetworkImage(
                                  imageUrl: doc.data['pictureUrl'] ?? "",
                                  fit: BoxFit.cover,
                                  useOldImageOnUrlChange: true,
                                  placeholder: (context, url) => CupertinoActivityIndicator(
                                    radius: 20,
                                  ),
                                  errorWidget: (context, url, error) => Icon(
                                    Icons.error,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            title: Text("you are matched with").tr(args: ["${doc.data['userName'] ?? '__'}"]),
                            subtitle: Text("${(doc.data['timestamp'].toDate())}"),
                            trailing: Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  !doc.data['isRead'] ? Container(
                                    width: 40.0,
                                    height: 20.0,
                                    decoration: BoxDecoration(
                                      color: primaryColor,
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'NEW',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                                  : Text(""),
                                ],
                              ),
                            ),
                            onTap: () async {
                              print(doc.data["Matches"]);
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return Center(
                                    child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ));
                                }
                              );
                              DocumentSnapshot userdoc = await db.collection("Users")
                                .document(doc.data["Matches"]).get();
                              if (userdoc.exists) {
                                Navigator.pop(context);
                                UserModel tempUser = UserModel.fromDocument(userdoc);
                                tempUser.distanceBW = calculateDistance(
                                  widget.currentUser.coordinates['latitude'],
                                  widget.currentUser.coordinates['longitude'],
                                  tempUser.coordinates['latitude'],
                                  tempUser.coordinates['longitude']).round();

                                await showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) {
                                    if (!doc.data["isRead"]) {
                                      db.collection("/Users/${widget.currentUser.id}/Matches")
                                        .document('${doc.data["Matches"]}')
                                        .updateData({'isRead': true});
                                    }
                                    return UserInfoScreen(
                                      tempUser,
                                      widget.currentUser,
                                    );
                                  }
                                );
                              }
                            },
                          )
                        ),
                      )
                      ).toList(),
                    ),
                  );
                }
              )
            ],
          ),
        ),
      )
    );
  }
}
