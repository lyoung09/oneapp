import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:wellhada_oneapp/UI/main/bottom_detail/private_info.dart';
import 'package:wellhada_oneapp/UI/main/main_scene.dart';
import 'package:wellhada_oneapp/UI/mapUI/map.dart';
import 'package:wellhada_oneapp/model/menu/drawer_detail/qr_34.dart';

class BottomNav extends StatefulWidget {
  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  var appColor = '#ffffff';
  var menuColor = '#ffd428';
  var appFontColor = '#333333';
  var menuFontColor = '#333333';

  int _selectedIndex = 0;

  List<Widget> _widgetOptions = <Widget>[
    MainScreen(),
    QR_34(1),
    PriavateInfo(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "home"),
          BottomNavigationBarItem(icon: Icon(Icons.ac_unit), label: "dk"),
          BottomNavigationBarItem(
              icon: Icon(Icons.star_purple500_sharp), label: "plus"),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
