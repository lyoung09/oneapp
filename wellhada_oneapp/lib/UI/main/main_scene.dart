import 'package:flutter/material.dart';
import 'package:wellhada_oneapp/UI/banner/top_banner.dart';
import 'package:wellhada_oneapp/UI/mapUI/map.dart';
import 'package:wellhada_oneapp/UI/mapUI/map1.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var appColor = '#ffffff';
  var menuColor = '#ffd428';
  var appFontColor = '#333333';
  var menuFontColor = '#333333';
  var userChk = "01";

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Center(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 20.0, bottom: 10.0),
          ),
          Container(
            height: size.height * 0.15,
            width: size.width,
            child: TopBanner(),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 10.0),
          ),
          Expanded(child: Google1MapUI()),
        ],
      ),
    );
  }
}
