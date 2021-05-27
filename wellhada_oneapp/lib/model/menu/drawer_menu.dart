import 'dart:async';
import 'dart:convert';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:wellhada_oneapp/UI/main/bottom_detail/home_screen.dart';
import 'package:wellhada_oneapp/UI/privateInfo_detail/login.dart';
import 'package:wellhada_oneapp/model/menu/drawer_detail/account_user_info.dart';

import 'drawer_detail/qr_34.dart';

class DRAWER_MENU extends StatefulWidget {
  DRAWER_MENU();
  @override
  _DRAWER_MENUState createState() => _DRAWER_MENUState();
}

class _DRAWER_MENUState extends State<DRAWER_MENU> {
  List menuItems = null;

  _DRAWER_MENUState();
  SharedPreferences prefs;

  var userScSeq;
  var accessToken = "";
  var userChk = '01';
  var userName;
  var userGrade;
  var _colorText = Hexcolor('#242A37');
  var AppFontColor;

  // Future<Null> getFileData() async {
  //   final menuList = await initData.getMainList("assets/data/initinfo.json");

  //   prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     menuItems = menuList.SCREEN_LIST;
  //     userChk = prefs.getString("userChk");
  //     userName = prefs.getString("userName");

  //     print("userChk" + userChk);
  //     if (userChk == "00") {
  //       accessToken = prefs.getString("accessToken");
  //     }
  //   });

  //   final userInfo = await loginData.getUserInfo(accessToken);
  //   setState(() {
  //     userName = userInfo.USER_NAME;
  //     userGrade = userInfo.USER_GRADE;
  //   });
  // }

  _linkUrl(String url) async {
    await launch(url, forceWebView: false, forceSafariVC: false);
  }

  _linkInApp(String url) async {
    await launch(url,
        forceWebView: true, forceSafariVC: true, enableJavaScript: true);
  }

  _launchCaller(String tel) async {
    var url = "tel:${tel}";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    super.initState();

    //getFileData();

    if (AppFontColor == "#FFFFFF") {
      setState(() {
        AppFontColor = "#000000";
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  moveLogin() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => new LOGIN()));
  }

  moveHome() {
    Navigator.of(context).pushReplacement(
        (PageRouteBuilder(pageBuilder: (_, __, ___) => HomeScreen())));
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
      padding: EdgeInsets.zero,
      children: <Widget>[
        Container(
          color: Hexcolor('#ffd428'),
          child: Column(
            children: <Widget>[
              Container(),
              Expanded(
                child: Container(
                  height: 30.0,
                  alignment: Alignment.center,
                  child: Text(
                    '#story',
                    style: TextStyle(
                        fontFamily: 'Godo',
                        fontWeight: FontWeight.w900,
                        fontSize: 30.0,
                        color: Hexcolor('#333333')),
                  ),
                ),
              ),
              Container(
                height: 50.0,
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      userChk == '00'
                          ? InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) {
                                      return new Account_user_info();
                                    },
                                    fullscreenDialog: true));
                              },
                              child: Container(
                                width: size.width / 2,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 5.0),
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        "${userName} ",
                                        style: TextStyle(
                                          color: _colorText,
                                          fontSize: 16.0,
                                          fontFamily: "Godo",
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        "님 안녕하세요.",
                                        style: TextStyle(
                                          color: _colorText,
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

                                // Navigator.of(context)
                                //     .push(MaterialPageRoute(
                                //         builder: (BuildContext context) {
                                //           return new LOGIN();
                                //         },
                                //         fullscreenDialog: true));
                              },
                              child: Container(
                                width: size.width / 2,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 5.0),
                                  child: Text(
                                    "로그인 해주세요.",
                                    style: TextStyle(
                                      color: _colorText,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                      Icon(
                        Icons.person,
                        color: _colorText,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          decoration: BoxDecoration(
            color: Colors.white,
          ),
        ),

        // ListView.builder(
        //     scrollDirection: Axis.vertical,
        //     shrinkWrap: true,
        //     itemCount: menuItems == null ? 0 : menuItems.length,
        //     itemBuilder: (BuildContext context, int index) {
        //       return '${menuItems[index].SC_SEQ}' != "34"
        //           ? ListTile(
        //               leading: SvgPicture.network(
        //                   "https://wellhada.com" +
        //                       "${menuItems[index].SC_ICON}",
        //                   height: 25.0,
        //                   width: 25.0,
        //                   color: Hexcolor('#333333')),
        //               title: Text(
        //                 '${menuItems[index].SC_NAME}',
        //                 style: TextStyle(
        //                   fontFamily: 'Godo',
        //                   fontSize: 17.0,
        //                   color: Hexcolor('#000000'),
        //                 ),
        //               ),
        //               onTap: () {},
        //             )
        //           : '${userGrade}' == "A"
        //               ? ListTile(
        //                   leading: SvgPicture.network(
        //                       "https://wellhada.com" +
        //                           "${menuItems[index].SC_ICON}",
        //                       height: 25.0,
        //                       width: 25.0,
        //                       color: Hexcolor('${AppFontColor}')),
        //                   title: Text(
        //                     '${menuItems[index].SC_NAME}',
        //                     style: TextStyle(
        //                       fontFamily: 'Godo',
        //                       fontSize: 17.0,
        //                       color:
        //                           Hexcolor('${menuItems[index].SC_COLOR}'),
        //                     ),
        //                   ),
        //                   onTap: () {
        //                     setState(() {
        //                       userScSeq = '${menuItems[index].SC_U_SEQ}';
        //                     });

        //                     Navigator.of(context).push(
        //                       MaterialPageRoute(
        //                           builder: (BuildContext context) {
        //                             return new QR_34(0); //QR 스캔
        //                           },
        //                           fullscreenDialog: true),
        //                     );
        //                   },
        //                 )
        //               : Container();
        //     }),
        ListTile(
          leading: SvgPicture.network(
              "https://wellhada.com" + "/images/icon_image/house-door-fill.svg",
              height: 25.0,
              width: 25.0,
              color: Hexcolor('#333333')),
          title: Text(
            '홈',
            style: TextStyle(
              fontFamily: 'Godo',
              fontSize: 17.0,
              color: Hexcolor('#000000'),
            ),
          ),
          onTap: () {
            moveHome();
          },
        ),
        ListTile(
          leading: SvgPicture.network(
              "https://wellhada.com" + "/images/icon_image/archive.svg",
              height: 25.0,
              width: 25.0,
              color: Hexcolor('#333333')),
          title: Text(
            '메뉴',
            style: TextStyle(
              fontFamily: 'Godo',
              fontSize: 17.0,
              color: Hexcolor('#000000'),
            ),
          ),
          onTap: () {
            moveMenu();
          },
        ),
        ListTile(
          leading: SvgPicture.network(
              "https://wellhada.com" + "/images/icon_image/grid-3x3-gap.svg",
              height: 25.0,
              width: 25.0,
              color: Hexcolor('#333333')),
          title: Text(
            'qr코드',
            style: TextStyle(
              fontFamily: 'Godo',
              fontSize: 17.0,
              color: Hexcolor('#000000'),
            ),
          ),
          onTap: () {
            moveQr();
          },
        ),
        ListTile(
          leading: SvgPicture.network(
              "https://wellhada.com" + "/images/icon_image/bullseye.svg",
              height: 25.0,
              width: 25.0,
              color: Hexcolor('#333333')),
          title: Text(
            '스탬프',
            style: TextStyle(
              fontFamily: 'Godo',
              fontSize: 17.0,
              color: Hexcolor('#000000'),
            ),
          ),
          onTap: () {
            moveStamp();
          },
        ),
      ],
    );
  }
}
