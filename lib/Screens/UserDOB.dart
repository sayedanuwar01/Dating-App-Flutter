import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hookup4u/Screens/Gender.dart';
import 'package:hookup4u/util/color.dart';
import 'package:easy_localization/easy_localization.dart';

class UserDOB extends StatefulWidget {
  final Map<String, dynamic> userData;
  UserDOB(this.userData);

  @override
  _UserDOBState createState() => _UserDOBState();
}

class _UserDOBState extends State<UserDOB> {
  DateTime selectedDate;
  TextEditingController dobCtrl = new TextEditingController();

  var dateStr = '';

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
              filter: ImageFilter.blur(sigmaX: 64, sigmaY: 64),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200.withOpacity(0.06),
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
                  child: Center(
                    child: Text(
                      "My birthday is".tr().toString(),
                      style: TextStyle(fontSize: 34, color: Colors.white.withOpacity(0.95)),
                    ),
                  ),
                  padding: EdgeInsets.only(top: 164),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 32, right: 32, top: 124),
                  child: Container(
                    child: ListTile(
                      title: CupertinoTextField(
                        readOnly: true,
                        keyboardType: TextInputType.phone,
                        prefix: IconButton(
                          icon: (Icon(
                            Icons.calendar_today,
                            color: primaryColor,
                          )),
                          onPressed: () {},
                        ),
                        onTap: () => showCupertinoModalPopup(
                          context: context,
                          builder: (BuildContext context) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Spacer(),
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 32),
                                  child: Column(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(top: 12),
                                        height: MediaQuery.of(context).size.height * .25,
                                        child: CupertinoDatePicker(
                                          initialDateTime: DateTime(2000, 10, 12),
                                          onDateTimeChanged: (DateTime newDate) {
                                            setState(() {
                                              dateStr = newDate.day.toString() +
                                                  '/' + newDate.month.toString() +
                                                  '/' + newDate.year.toString();
                                              selectedDate = newDate;
                                            });
                                          },
                                          maximumYear: 2002,
                                          minimumYear: 1800,
                                          maximumDate: DateTime(2002, 03, 12),
                                          mode: CupertinoDatePickerMode.date,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: (){
                                          Navigator.pop(context);
                                          setState(() {
                                            dobCtrl.text = dateStr;
                                          });
                                        },
                                        child: Container(
                                          height: 42,
                                          margin: EdgeInsets.only(bottom: 12, top: 6, left: 12, right: 12),
                                          child: Center(
                                            child: Text(
                                              'Done',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white
                                              ),
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(12)),
                                            color: goldBtnColorDark
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(12)),
                                    color: Colors.white
                                  ),
                                ),
                                Spacer()
                              ],
                            );
                          }
                        ),
                        placeholder: "DD/MM/YYYY",
                        controller: dobCtrl,
                      ),
                      subtitle: Padding(
                        padding: EdgeInsets.only(top: 12.0),
                        child: Text(" Your age will be public".tr().toString(), style: TextStyle(color: Colors.grey),),
                      ),
                    )
                  )
                ),
                SizedBox(
                  height: 32,
                ),
                dobCtrl.text.length > 0 ? Padding(
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
                      widget.userData.addAll({
                        'user_DOB': "$selectedDate",
                        'age': ((DateTime.now().difference(selectedDate).inDays) / 365.2425).truncate(),
                      }
                      );
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => Gender(widget.userData)
                        )
                      );
                    },
                  ),
                )
                : Padding(
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
