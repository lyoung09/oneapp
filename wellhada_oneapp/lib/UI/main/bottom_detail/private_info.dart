import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:wellhada_oneapp/UI/login/login.dart';
import 'package:wellhada_oneapp/UI/main/home_detail/main_screen.dart';
import 'package:wellhada_oneapp/UI/main/home_detail/map_scene.dart';

import 'package:wellhada_oneapp/model/menu/drawer_detail/qr_34.dart';

import '../home_screen.dart';

class PriavateInfo extends StatefulWidget {
  @override
  _PriavateInfoState createState() => _PriavateInfoState();
}

class _PriavateInfoState extends State<PriavateInfo> {
  var appColor = '#ffffff';
  var menuColor = '#ffd428';
  var appFontColor = '#333333';
  var menuFontColor = '#333333';
  var userChk = "01";

  moveLogin() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => new LOGIN()));
  }

  moveHome() {
    Navigator.of(context).pushReplacement(
        (PageRouteBuilder(pageBuilder: (_, __, ___) => HomeScreen())));
  }

  moveMap() {
    Navigator.of(context).pushReplacement(
        (PageRouteBuilder(pageBuilder: (_, __, ___) => MapScreen())));
  }

  moveQr() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => new QR_34(1)));
  }

  moveMenu() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => new QR_34(1)));
  }

  moveStamp() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => new QR_34(1)));
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return ListView(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(bottom: 50.0),
        ),
        Container(
          height: 50.0,
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                userChk == "00"
                    ? InkWell(
                        onTap: () {
                          // Navigator.of(context).push(MaterialPageRoute(
                          //     builder: (BuildContext context) {
                          //       return new Account_user_info();
                          //     },
                          //     fullscreenDialog: true));
                        },
                        child: Container(
                          width: size.width / 2,
                          child: Padding(
                            padding: EdgeInsets.only(left: 5.0),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  "TT ",
                                  style: TextStyle(
                                    // color: _colorText,
                                    fontSize: 16.0,
                                    fontFamily: "Godo",
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  "님 안녕하세요.",
                                  style: TextStyle(
                                    //color: _colorText,
                                    fontSize: 14.0,
                                    fontFamily: "Godo",
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : InkWell(
                        onTap: () {
                          moveLogin();
                        },
                        child: Container(
                          width: size.width / 2,
                          child: Padding(
                            padding: EdgeInsets.only(left: 5.0),
                            child: Text(
                              "로그인 해주세요.",
                              style: TextStyle(
                                  // color: _colorText,
                                  ),
                            ),
                          ),
                        ),
                      ),
                Icon(
                  Icons.person,
                  //color: _colorText,
                ),
              ],
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(top: 40.0, bottom: 10.0),
        ),
        // ListTile(
        //   leading: SvgPicture.network(
        //       "https://wellhada.com" + "/images/icon_image/house-door-fill.svg",
        //       height: 25.0,
        //       width: 25.0,
        //       color: Hexcolor('#333333')),
        //   title: Text(
        //     '홈',
        //     style: TextStyle(
        //       fontFamily: 'Godo',
        //       fontSize: 17.0,
        //       color: Hexcolor('#000000'),
        //     ),
        //   ),
        //   onTap: () {
        //     moveHome();
        //   },
        // ),
      ],
    );
  }
}
