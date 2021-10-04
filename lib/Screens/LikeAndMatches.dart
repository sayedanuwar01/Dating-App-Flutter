import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hookup4u/Screens/MatchesScreen.dart';
import 'package:hookup4u/models/UserModel.dart';
import 'package:hookup4u/util/color.dart';
import 'package:easy_localization/easy_localization.dart';
import 'LikedByScreen.dart';

class LikeAndMatches extends StatefulWidget {
  final UserModel currentUser;
  final Map items;
  const LikeAndMatches(this.currentUser, this.items);

  @override
  _LikeAndMatchesState createState() => _LikeAndMatchesState();
}

class _LikeAndMatchesState extends State<LikeAndMatches> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        brightness: Brightness.dark,
      ),
      body: DefaultTabController(
        length: 2,
        initialIndex: 0,
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
                  icon: Text(
                    'Matches'.tr().toString(),
                    style: TextStyle(
                      color: goldBtnColorDark,
                      fontSize: 16.0,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
                Tab(
                  icon: Text(
                    'LikedBy'.tr().toString(),
                    style: TextStyle(
                      color: goldBtnColorDark,
                      fontSize: 16.0,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ]
            ),
          ),
          body: TabBarView(
            children: [
              Center(
                child: MatchesScreen(
                  widget.currentUser, widget.items
                )
              ),
              Center(
                child: LikedByScreen(
                  widget.currentUser, widget.items
                )
              ),
            ],
            physics: NeverScrollableScrollPhysics(),
          )
        ),
      ),
    );
  }
}
