import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:hookup4u/Screens/UserInfoScreen.dart';
import 'package:hookup4u/Screens/Payment/PaymentDetails.dart';
import 'package:hookup4u/Screens/Profile/EditProfile.dart';
import 'package:hookup4u/Screens/Profile/Settings.dart';
import 'package:hookup4u/models/UserModel.dart';
import 'package:hookup4u/util/color.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import '../Payment/Subscription.dart';
import 'package:easy_localization/easy_localization.dart';

final List adds = [
  {
    'icon': Icons.whatshot,
    'color': goldBtnColorDark,
    'title': "Get matches faster".tr().toString(),
    'subtitle': "Boost your profile once a month".tr().toString(),
  },
  {
    'icon': Icons.favorite,
    'color': goldBtnColorDark,
    'title': "more likes".tr().toString(),
    'subtitle': "Get free rewindes".tr().toString(),
  },
  {
    'icon': Icons.star_half,
    'color': goldBtnColorDark,
    'title': "Increase your chances".tr().toString(),
    'subtitle': "Get unlimited free likes".tr().toString(),
  },
  {
    'icon': Icons.location_on,
    'color': goldBtnColorDark,
    'title': "Swipe around the world".tr().toString(),
    'subtitle': "Passport to anywhere with hookup4u".tr().toString(),
  },
  {
    'icon': Icons.vpn_key,
    'color': goldBtnColorDark,
    'title': "Control your profile".tr().toString(),
    'subtitle': "highly secured".tr().toString(),
  }
];

class Profile extends StatefulWidget {
  final UserModel currentUser;
  final bool isPurchased;
  final Map items;
  final List<PurchaseDetails> purchases;
  Profile(this.currentUser, this.isPurchased, this.purchases, this.items);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final EditProfileState _editProfileState = EditProfileState();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Hero(
                tag: "abc",
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    radius: 80,
                    backgroundColor: secondaryColor,
                    child: Material(
                      color: Colors.white,
                      child: Stack(
                        children: <Widget>[
                          InkWell(
                            onTap: () => showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return UserInfoScreen(widget.currentUser,
                                  widget.currentUser,
                                );
                                }
                              ),
                            child: Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(64,),
                                child: CachedNetworkImage(
                                  height: 128,
                                  width: 128,
                                  fit: BoxFit.fill,
                                  imageUrl: widget.currentUser.imageUrl.length > 0
                                    ? widget.currentUser.imageUrl[0] ?? ''
                                    : '',
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
                                        size: 22,
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
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24)
                              ),
                              color: primaryColor,
                              child: IconButton(
                                alignment: Alignment.center,
                                icon: Icon(
                                  Icons.photo_camera,
                                  size: 22,
                                  color: goldBtnColorLight,
                                ),
                                onPressed: () {
                                  _editProfileState.source(
                                    context, widget.currentUser, true
                                  );
                                }
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Text(
                widget.currentUser.name != null && widget.currentUser.age != null
                  ? "${widget.currentUser.name}, ${widget.currentUser.age}"
                  : "",
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                  fontSize: 30
                ),
              ),
              Text(
                widget.currentUser.address,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.w400,
                  fontSize: 17
                ),
              ),
              Text(
                widget.currentUser.editInfo['university'] != null
                  ? "${widget.currentUser.editInfo['university']}"
                  : "",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.w400,
                  fontSize: 20
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * .45,
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 60),
                      child: Align(
                        alignment: Alignment.center,
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: 70,
                              width: 70,
                              child: FloatingActionButton(
                                heroTag: UniqueKey(),
                                splashColor: secondaryColor,
                                backgroundColor: primaryColor,
                                child: Icon(
                                  Icons.add_a_photo,
                                  color: goldBtnColorLight,
                                  size: 32,
                                ),
                                onPressed: () {
                                  _editProfileState.source(
                                    context, widget.currentUser, false
                                  );
                                }
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Add media".tr().toString(),
                                style: TextStyle(color: goldBtnColorDark),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 30, top: 30),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          children: <Widget>[
                            FloatingActionButton(
                              splashColor: secondaryColor,
                              heroTag: UniqueKey(),
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.settings,
                                color: goldBtnColorLight,
                                size: 28,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    maintainState: true,
                                    builder: (context) => Settings(
                                      widget.currentUser,
                                      widget.isPurchased,
                                      widget.items
                                    )
                                  )
                                );
                              }
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Settings".tr().toString(),
                                style: TextStyle(
                                  color: goldBtnColorDark
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 30, top: 30),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Column(
                          children: <Widget>[
                            FloatingActionButton(
                              heroTag: UniqueKey(),
                              splashColor: secondaryColor,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.edit,
                                color: goldBtnColorLight,
                                size: 28,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) => EditProfile(widget.currentUser)
                                  )
                                );
                              }
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Edit Info".tr().toString(),
                                style: TextStyle(color: goldBtnColorDark),
                              ),
                            ),
                          ],
                        ),
                      )
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 210),
                      child: Container(
                        height: 120,
                        child: CustomPaint(
                          painter: CurvePainter(),
                          size: Size.infinite,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18.0),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)
                          ),
                          height: 100,
                          width: MediaQuery.of(context).size.width * .85,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Swiper(
                              key: UniqueKey(),
                              curve: Curves.linear,
                              autoplay: true,
                              physics: ScrollPhysics(),
                              itemBuilder: (BuildContext context, int index2) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(
                                          adds[index2]["icon"],
                                          color: adds[index2]["color"],
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          adds[index2]["title"],
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      adds[index2]["subtitle"],
                                      textAlign: TextAlign.center,
                                    ),
                                  ]
                                );
                              },
                              itemCount: adds.length,
                              pagination: SwiperPagination(
                                alignment: Alignment.bottomCenter,
                                builder: DotSwiperPaginationBuilder(
                                  activeSize: 10,
                                  color: secondaryColor,
                                  activeColor: primaryColor
                                )
                              ),
                              control: SwiperControl(
                                size: 20,
                                color: primaryColor,
                                disableColor: secondaryColor,
                              ),
                              loop: false,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: InkWell(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(25),
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          goldBtnColorDark.withOpacity(.5),
                          goldBtnColorDark.withOpacity(.8),
                          goldBtnColorDark,
                          goldBtnColorDark
                        ]
                      )
                    ),
                    height: MediaQuery.of(context).size.height * .065,
                    width: MediaQuery.of(context).size.width * .75,
                    child: Center(
                      child: Text(
                        widget.isPurchased && widget.purchases != null
                          ? "Check Payment Details".tr().toString()
                          : "Subscribe Plan".tr().toString(),
                        style: TextStyle(
                          fontSize: 15,
                          color: textColor,
                          fontWeight: FontWeight.bold
                        ),
                      )
                    )
                  ),
                  onTap: () async {
                    if (widget.isPurchased && widget.purchases != null) {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => PaymentDetails(widget.purchases)
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => Subscription(
                            widget.currentUser, null, widget.items
                          )
                        ),
                      );
                    }
                  },
                ),
              ),
            ]
          ),
        ),
      ),
    );
  }
}

class CurvePainter extends CustomPainter {
  void paint(Canvas canvas, Size size) {
    var paint = Paint();

    paint.color = secondaryColor.withOpacity(.4);
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 1.5;

    var startPoint = Offset(0, -size.height / 2);
    var controlPoint1 = Offset(size.width / 4, size.height / 3);
    var controlPoint2 = Offset(3 * size.width / 4, size.height / 3);
    var endPoint = Offset(size.width, -size.height / 2);

    var path = Path();
    path.moveTo(startPoint.dx, startPoint.dy);
    path.cubicTo(controlPoint1.dx, controlPoint1.dy, controlPoint2.dx,
        controlPoint2.dy, endPoint.dx, endPoint.dy);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
