import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hookup4u/util/color.dart';
import 'package:hookup4u/util/snackbar.dart';
import 'AllowLocation.dart';
import 'package:flutter_mapbox_autocomplete/flutter_mapbox_autocomplete.dart';
import 'package:easy_localization/easy_localization.dart';

String mapboxApi = "pk.eyJ1IjoicHVlcnRvcmljb21hdGNobWFrZXIiLCJhIjoiY2tzcTNlNGprMDhqNDJ2cG85azNtMnQ5diJ9.R0FD2S8ZOW1UuiwZ2ghHKg";

class SearchLocation extends StatefulWidget {
  final Map<String, dynamic> userData;
  SearchLocation(this.userData);

  @override
  _SearchLocationState createState() => _SearchLocationState();
}

class _SearchLocationState extends State<SearchLocation> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _city = TextEditingController();
  MapBoxPlace _mapBoxPlace;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: AnimatedOpacity(
        opacity: 1.0,
        duration: Duration(milliseconds: 50),
        child: Padding(
          padding: EdgeInsets.only(top: 10.0),
          child: FloatingActionButton(
            elevation: 10,
            child: IconButton(
              color: secondaryColor,
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            backgroundColor: Colors.white38,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: <Widget>[
                Padding(
                  child: Text(
                    "Select\nyour city".tr().toString(),
                    style: TextStyle(fontSize: 40),
                  ),
                  padding: EdgeInsets.only(left: 50, top: 120),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: TextField(
                        autofocus: false,
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: "Enter your city name".tr().toString(),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: primaryColor)
                          ),
                          helperText: "This is how it will appear in App.".tr().toString(),
                          helperStyle: TextStyle(color: secondaryColor, fontSize: 15),
                        ),
                        controller: _city,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MapBoxAutoCompleteWidget(
                              language: 'en',
                              closeOnSelect: true,
                              apiKey: mapboxApi,
                              limit: 10,
                              hint: 'Enter your city name'.tr().toString(),
                              onSelect: (place) {
                                setState(() {
                                  _mapBoxPlace = place;
                                  _city.text = _mapBoxPlace.placeName;
                                });
                              },
                            ),
                          )
                        ),
                      ),
                    ),
                  ],
                ),
                _city.text.length > 0 ?  Padding(
                  padding: EdgeInsets.only(bottom: 40.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: InkWell(
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(25),
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [
                              primaryColor.withOpacity(.5),
                              primaryColor.withOpacity(.8),
                              primaryColor,
                              primaryColor
                            ]
                          )
                        ),
                        height: MediaQuery.of(context).size.height * .065,
                        width: MediaQuery.of(context).size.width * .75,
                        child: Center(
                          child: Text(
                            "Continue".tr().toString(),
                            style: TextStyle(
                              fontSize: 15,
                              color: textColor,
                              fontWeight: FontWeight.bold
                            ),
                          )
                        )
                      ),
                      onTap: () async {
                        widget.userData.addAll({
                          'location': {
                            'latitude':
                                _mapBoxPlace.geometry.coordinates[1],
                            'longitude':
                                _mapBoxPlace.geometry.coordinates[0],
                            'address': "${_mapBoxPlace.placeName}"
                          },
                          'maximum_distance': 20,
                          'age_range': {
                            'min': "20",
                            'max': "50",
                          },
                        },
                      );
                      showWelcomeDialog(context);
                      setUserData(widget.userData);
                    },
                  ),
                  ),
                ):
                Padding(
                  padding: EdgeInsets.only(bottom: 40),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: InkWell(
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        height: MediaQuery.of(context).size.height * .065,
                        width: MediaQuery.of(context).size.width * .75,
                        child: Center(
                          child: Text(
                            "CONTINUE".tr().toString(),
                            style: TextStyle(
                              fontSize: 15,
                              color: secondaryColor,
                              fontWeight: FontWeight.bold
                            ),
                          )
                        )
                      ),
                      onTap: () {
                        CustomSnackbar.snackbar(
                          "Select a location !".tr().toString(),
                          _scaffoldKey);
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
