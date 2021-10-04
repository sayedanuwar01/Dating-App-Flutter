import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserModel {

  final String id;
  final String name;
  final String gender;
  final String showGender;
  final int age;
  final String phoneNumber;
  final bool isBlocked;
  final Map coordinates;
  final List sexualOrientation;
  final Map ageRange;
  final Map editInfo;
  var distanceBW;
  var university;

  String address;
  int maxDistance;
  Timestamp lastMsg;
  List imageUrl = [];

  UserModel({
    @required this.id,
    @required this.age,
    @required this.address,
    @required this.name,
    @required this.imageUrl,
    this.isBlocked,
    this.coordinates,
    this.phoneNumber,
    this.lastMsg,
    this.gender,
    this.showGender,
    this.ageRange,
    this.maxDistance,
    this.editInfo,
    this.distanceBW,
    this.sexualOrientation,
    this.university
  });

  factory UserModel.fromDocument(DocumentSnapshot doc) {
    return UserModel(
      id: doc['userId'],
      age: ((DateTime.now().difference(DateTime.parse(doc["user_DOB"])).inDays) / 365.2425).truncate(),
      address: doc['location']['address'],
      isBlocked: doc['isBlocked'] != null ? doc['isBlocked'] : false,
      coordinates: doc['location'],
      name: doc['UserName'],
      imageUrl: doc['Pictures'] != null ? List.generate(doc['Pictures'].length, (index) {
        return doc['Pictures'][index];
      }) : [],
      phoneNumber: doc['phoneNumber'],
      gender: doc['editInfo']['userGender'] ?? null,
      showGender: doc['showGender'] != null ? doc['showGender'] : 'everyone',
      ageRange: doc['age_range'],
      maxDistance: doc['maximum_distance'],
      editInfo: doc['editInfo'],
      sexualOrientation: doc['sexualOrientation']['orientation'] ?? "",
      university: doc['editInfo']['university'],
    );
  }

  Widget likeByCelUI({
    BuildContext context,
    Function onClickCell
  }){
    return InkWell(
      onTap: (){
        onClickCell(id);
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 132,
        color: Colors.white,
        margin: EdgeInsets.only(bottom: 1.2),
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 4, vertical: 12),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(39,),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl[0],
                    fit: BoxFit.fitWidth,
                    width: 78,
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
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 10, right: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87.withOpacity(0.8)
                        ),
                      ),
                      Spacer(),
                      Text(
                        address,
                        style: TextStyle(
                          color: Colors.black54,
                        ),
                        textAlign: TextAlign.start,
                        maxLines: 3,
                      ),
                      Spacer(),
                      Text(
                        'Age: $age',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                          fontWeight: FontWeight.bold
                        ),
                        textAlign: TextAlign.start,
                        maxLines: 1,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
