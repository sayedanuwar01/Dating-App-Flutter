import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hookup4u/models/UserModel.dart';
import 'package:hookup4u/util/color.dart';
import 'package:easy_localization/easy_localization.dart';

import 'CallPage.dart';

class DialCall extends StatefulWidget {
  final String channelName;
  final UserModel receiver;
  final String callType;
  const DialCall({@required this.channelName, this.receiver, this.callType});

  @override
  _DialCallState createState() => _DialCallState();
}

class _DialCallState extends State<DialCall> {
  bool isPickup = false;
  CollectionReference callRef = Firestore.instance.collection("calls");
  @override
  void initState() {
    _addCallingData();
    super.initState();
  }

  _addCallingData() async {
    await callRef.document(widget.channelName).delete();
    await callRef.document(widget.channelName).setData({
      'callType': widget.callType,
      'calling': true,
      'response': "Awaiting",
      'channel_id': widget.channelName,
      'last_call': FieldValue.serverTimestamp()
    });
  }

  @override
  void dispose() async {
    super.dispose();
    isPickup = true;
    await callRef.document(widget.channelName)
      .setData({'calling': false}, merge: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: callingBackground,
      body: Center(
        child: StreamBuilder<QuerySnapshot>(
          stream: callRef.where("channel_id", isEqualTo: "${widget.channelName}").snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            Future.delayed(Duration(seconds: 30), () async {
              if (!isPickup) {
                await callRef.document(widget.channelName)
                  .updateData({'response': 'Not-answer'});
              }
            });
            if (!snapshot.hasData) {
              return Container();
            } else
              try {
                switch (snapshot.data.documents[0]['response']) {
                  case "Awaiting": {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: 10,),
                          CircleAvatar(
                            backgroundColor: Colors.grey,
                            radius: 60,
                            child: Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(60,),
                                child: CachedNetworkImage(
                                  imageUrl: widget.receiver.imageUrl[0] ?? '',
                                  useOldImageOnUrlChange: true,
                                  placeholder: (context, url) => CupertinoActivityIndicator(
                                    radius: 15,
                                  ),
                                  errorWidget: (context, url, error) => Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        Icons.error,
                                        color: Colors.black,
                                        size: 30,
                                      ),
                                      Text(
                                        "Enable to load".tr().toString(),
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Text("Calling to",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                            ),
                            textAlign: TextAlign.center,
                          ).tr(args: ['\n${widget.receiver.name}']),
                          SizedBox(height: 4,),
                          FloatingActionButton(
                            heroTag: UniqueKey(),
                            backgroundColor: Colors.red,
                            child: Icon(
                              Icons.call_end,
                              color: Colors.white,
                            ),
                            onPressed: () async {
                              await callRef
                                .document(widget.channelName)
                                .setData({'response': "Call_Cancelled"},
                                merge: true
                              );
                            }
                          ),
                        ],
                      );
                    }
                    break;
                  case "Pickup": {
                    isPickup = true;
                    return CallPage(
                      channelName: widget.channelName,
                      role: ClientRole.Broadcaster,
                      callType: widget.callType);
                    }
                    break;
                  case "Decline": {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: 10,),
                        Text("is Busy",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                          ),
                          textAlign: TextAlign.center,
                        ).tr(args: ["${widget.receiver.name} \n"]),
                        SizedBox(height: 4,),
                        FloatingActionButton(
                          heroTag: UniqueKey(),
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.green,
                            size: 26,
                          ),
                          onPressed: () async {
                            Navigator.pop(context);
                          }
                        ),
                      ],);
                    }
                    break;
                  case "Not-answer": {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: 10,),
                        Text("is Not-answering",
                          style: TextStyle(
                            fontSize: 28,
                            color: Colors.white
                          ),
                          textAlign: TextAlign.center,
                        ).tr(args: ["${widget.receiver.name} \n"]),
                        SizedBox(height: 4,),
                        FloatingActionButton(
                          heroTag: UniqueKey(),
                          backgroundColor: Colors.red,
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          onPressed: () async {
                            Navigator.pop(context);
                          }
                        )
                      ],);
                    }
                    break;
                  //call end
                  default:
                    {
                      Future.delayed(Duration(milliseconds: 500), () {
                        Navigator.pop(context);
                      });
                      return Container(
                        child: Text("Call Ended...".tr().toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 22
                          )
                        ),
                      );
                    }
                    break;
                }
              }
              //  else if (!snapshot.data.documents[0]['calling']) {
              //   Navigator.pop(context);
              // }
              catch (e) {
                return Container();
              }
            }
          )
      ),
    );
  }
}
