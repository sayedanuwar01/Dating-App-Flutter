import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hookup4u/util/color.dart';

class LargeImage extends StatelessWidget {
  final largeImage;
  LargeImage(this.largeImage);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 0,
        brightness: Brightness.dark,
        automaticallyImplyLeading: false,
        backgroundColor: primaryColor
      ),
      backgroundColor: Colors.white,
      body: Container(
        color: Colors.white,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                CachedNetworkImage(
                  fit: BoxFit.contain,
                  placeholder: (context, url) => Center(
                    child: CupertinoActivityIndicator(
                      radius: 20,
                    ),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  height: MediaQuery.of(context).size.height * .75,
                  width: MediaQuery.of(context).size.width,
                  imageUrl: largeImage ?? '',
                ),
                SizedBox(
                  height: 20,
                ),
                FloatingActionButton(
                  backgroundColor: goldBtnColorDark,
                  child: Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context)),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        )
      )
    );
  }
}
