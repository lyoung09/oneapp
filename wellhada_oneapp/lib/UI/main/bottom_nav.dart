import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wellhada_oneapp/UI/main/bottom_detail/private_info.dart';
import 'package:wellhada_oneapp/UI/main/bottom_detail/usage_history.dart';

import 'package:wellhada_oneapp/UI/usageHistory_detail/review.dart';
import 'package:wellhada_oneapp/listitem/user/user.dart' as user;
import 'package:wellhada_oneapp/model/menu/drawer_detail/qr_34.dart';

import 'bottom_detail/favorite.dart';
import 'bottom_detail/home_screen.dart';

class BottomNav extends StatefulWidget {
  var number;

  BottomNav({this.number});
  @override
  _BottomNavState createState() => _BottomNavState(number: number);
}

class _BottomNavState extends State<BottomNav> {
  var appColor = '#ffffff';
  var menuColor = '#ffd428';
  var appFontColor = '#333333';
  var menuFontColor = '#333333';
  var number;
  int _selectedIndex = 0;
  _BottomNavState({this.number});

  @override
  initState() {
    super.initState();
    check();
  }

  check() {
    if (number != null) {
      _selectedIndex = number;
    }
  }

  List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    UsageHistory(),
    Favorite(),
    PriavateInfo(),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {},
      child: Scaffold(
        body: _widgetOptions.elementAt(_selectedIndex),
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
              // sets the background color of the `BottomNavigationBar`
              canvasColor: Colors.amberAccent,
              // sets the active color of the `BottomNavigationBar` if `Brightness` is light
              primaryColor: Colors.amberAccent,
              textTheme: Theme.of(context).textTheme.copyWith(
                  caption: new TextStyle(
                      color: Colors.grey[350], fontFamily: 'nanumB'))),
          child: BottomNavigationBar(
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.grey[350],
            currentIndex: _selectedIndex,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            items: [
              BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    "assets/svg/home1.svg",
                    fit: BoxFit.fill,
                    width: 20,
                    height: 20,
                  ),
                  label: "홈"),
              BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    "assets/svg/uselist.svg",
                    fit: BoxFit.fill,
                    width: 20,
                    height: 20,
                  ),
                  label: "이용내역"),
              BottomNavigationBarItem(
                  icon: Image.asset(
                    'assets/img/favorite.png',
                    fit: BoxFit.fill,
                    width: 20,
                    height: 20,
                  ),
                  label: "즐겨찾기"),
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/img/information.png',
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
      ),
    );
  }
}
