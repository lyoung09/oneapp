import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:wellhada_oneapp/UI/main/bottom_detail/private_info.dart';
import 'package:wellhada_oneapp/UI/main/bottom_detail/usage_history.dart';
import 'package:wellhada_oneapp/UI/main/home_screen.dart';
import 'package:wellhada_oneapp/UI/usageHistory_detail/review.dart';

import 'package:wellhada_oneapp/model/menu/drawer_detail/qr_34.dart';

import 'bottom_detail/favorite.dart';

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
    HomeScreen(),
    UsageHistory(),
    Favorite(),
    PriavateInfo(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
            // sets the background color of the `BottomNavigationBar`
            canvasColor: Colors.amberAccent,
            // sets the active color of the `BottomNavigationBar` if `Brightness` is light
            primaryColor: Colors.amberAccent,
            textTheme: Theme.of(context)
                .textTheme
                .copyWith(caption: new TextStyle(color: Colors.black))),
        child: BottomNavigationBar(
          backgroundColor: Colors.amberAccent,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.white,
          currentIndex: _selectedIndex,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          items: [
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  "assets/svg/home.svg",
                  fit: BoxFit.fill,
                  width: 20,
                  height: 20,
                ),
                label: "홈"),
            BottomNavigationBarItem(icon: Icon(Icons.map), label: "이용내역"),
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  "assets/svg/star.svg",
                  fit: BoxFit.fill,
                  width: 20,
                  height: 20,
                ),
                label: "즐겨찾기"),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/svg/user.svg",
                fit: BoxFit.fill,
                width: 20,
                height: 20,
              ),
              label: '내 정보',
            )
          ],
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }
}
