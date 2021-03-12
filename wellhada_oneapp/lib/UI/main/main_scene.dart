import 'package:flutter/material.dart';
import 'package:wellhada_oneapp/UI/mapUI/map.dart';

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
          Row(
            children: <Widget>[
              Container(
                height: size.height * 0.1,
                width: size.width * 0.5,
                child: Text("1"),
              ),
            ],
          ),
          Expanded(child: GoogleMapUI()),
        ],
      ),
    );
  }
}
