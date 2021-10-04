import 'package:flutter/material.dart';
import 'package:hookup4u/Screens/Chat/RecentChats.dart';
import 'package:hookup4u/models/UserModel.dart';
import 'package:hookup4u/util/color.dart';
import 'Matches.dart';
import 'package:easy_localization/easy_localization.dart';

class MessagesScreen extends StatefulWidget {
  final UserModel currentUser;
  final List<UserModel> matches;
  final List<UserModel> newMatches;
  MessagesScreen(this.currentUser, this.matches, this.newMatches);

  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 500), () {
      if (widget.matches.length > 0 && widget.matches[0].lastMsg != null) {
        widget.matches.sort((a, b) {
          if (a.lastMsg != null && b.lastMsg != null) {
            var aDate = a.lastMsg; //before -> var aDate = a.expiry;
            var bBate = b.lastMsg; //before -> var bBate = b.expiry;
            return bBate?.compareTo(aDate); //to get the order other way just switch `adate & bdate`
          }
          return 1;
        });
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        automaticallyImplyLeading: false,
        title: Text(
          'Messages'.tr().toString(),
          style: TextStyle(
            color: goldBtnColorDark,
            fontSize: 18.0,
            letterSpacing: 1.0,
          ),
        ),
        brightness: Brightness.dark,
        elevation: 0.0,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: ClipRRect(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Matches(
                  widget.currentUser,
                  widget.newMatches
                ),
                Divider(),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'Recent messages'.tr().toString(),
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
                RecentChats(
                  widget.currentUser,
                  widget.matches
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
