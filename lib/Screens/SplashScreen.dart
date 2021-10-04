import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Image.asset(
          'asset/images/ic_splash.jpeg',
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }
}
