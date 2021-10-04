import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hookup4u/models/UserModel.dart';
import 'package:hookup4u/util/color.dart';
import 'package:easy_localization/easy_localization.dart';
import 'LikedByScreen.dart';
import 'NearByScreen.dart';
import 'NearBySingle.dart';


class NearBySearches extends StatefulWidget {
  final UserModel currentUser;
  final Map items;
  const NearBySearches(this.currentUser, this.items);

  @override
  _NearBySearchesState createState() => _NearBySearchesState();
}

class _NearBySearchesState extends State<NearBySearches> {
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
                    'Nearby You'.tr().toString(),
                    style: TextStyle(
                      color: goldBtnColorDark,
                      fontSize: 16.0,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
                Tab(
                  icon: Text(
                    'Singles NearBy'.tr().toString(),
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
                child: NearByScreen(
                  widget.currentUser, widget.items
                )
              ),
              Center(
                child: NearBySingle(
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
