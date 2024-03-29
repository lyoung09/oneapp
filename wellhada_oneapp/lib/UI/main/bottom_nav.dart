// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wellhada_oneapp/UI/main/bottom_detail/private_info.dart';
import 'package:wellhada_oneapp/UI/main/bottom_detail/usage_history.dart';

import 'package:wellhada_oneapp/listitem/userFile/userList.dart' as user;
import 'package:wellhada_oneapp/model/menu/drawer_detail/qr_34.dart';

import 'bottom_detail/favorite.dart';
import 'bottom_detail/home_screen.dart';

/////////////////////////////
/////////////////////////////
///////bottom tab 관리////////
/////////////////////////////
/////////////////////////////
///number없으면 0으로옴
//0 홈화면(지도,리스트),1(이용내역),2(즐겨찾기),3(내정보)

class BottomNav extends StatefulWidget {
  var number;
  var userId;

  BottomNav({this.number, this.userId});
  @override
  _BottomNavState createState() =>
      _BottomNavState(number: number, userId: userId);
}

class _BottomNavState extends State<BottomNav> {
  var appColor = '#ffffff';
  var menuColor = '#ffd428';
  var appFontColor = '#333333';
  var menuFontColor = '#333333';
  var number;
  var userId;

  int _selectedIndex = 0;
  _BottomNavState({this.number, this.userId});

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

  //tabbar에 따라 움직이는 screen list
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
