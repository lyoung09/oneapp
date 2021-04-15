import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  var uriUserProfile;
  var userId, userName, appId, limitYn, userChk;
  String userProfile;
  @override
  void initState() {
    super.initState();

    userCheck();
  }

  void userCheck() async {
    try {
      final User user = await UserApi.instance.me();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        uriUserProfile = user.kakaoAccount.profile.profileImageUrl;
        userId = prefs.getString("userId");
        userName = prefs.getString("userName");
        appId = prefs.getString("appId");
        limitYn = prefs.getString("limitYn");
        userChk = prefs.getString("userChk");
        userProfile = uriUserProfile.toString();
      });
    } catch (e) {
      userChk = "00";
      print(e);
    }
  }

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

  logOutTalk() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      var code = await UserApi.instance.logout();

      setState(() {
        userId = prefs.setString("userId", null);
        userName = prefs.setString("userName", null);
        limitYn = prefs.setString("limitYn", null);
        userChk = prefs.setString("userChk", "01");
      });

      print(code.toString());
    } catch (e) {
      print(e);
    }
  }

  unlinkTalk() async {
    try {
      var code = await UserApi.instance.unlink();
      print(code.toString());
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return ListView(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(bottom: 10.0),
        ),
        Container(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: userChk == "00"
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: <Widget>[
                          uriUserProfile == null
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 35),
                                        child: Container(
                                          child: Text(
                                            "P",
                                            style: TextStyle(
                                              // color: _colorText,
                                              fontSize: 22.0,
                                              fontFamily: "Godo",
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Container(
                                        decoration: new BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: new Border.all(
                                            color: Colors.black,
                                            width: 0.5,
                                          ),
                                        ),
                                        child: CircleAvatar(
                                          radius: 35,
                                          child: Icon(Icons.person),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 35),
                                        child: Container(
                                          child: Text(
                                            "P",
                                            style: TextStyle(
                                              // color: _colorText,
                                              fontSize: 22.0,
                                              fontFamily: "Godo",
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Container(
                                        decoration: new BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: new Border.all(
                                            color: Colors.black,
                                            width: 0.5,
                                          ),
                                        ),
                                        child: CircleAvatar(
                                          radius: 35,
                                          backgroundImage:
                                              NetworkImage(userProfile),
                                          backgroundColor: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 20.0),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: InkWell(
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
                                  padding: EdgeInsets.only(top: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(top: 10),
                                      ),
                                      Text(
                                        userName,
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
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 40, bottom: 20.0),
                      ),
                      FlatButton(
                        child: Text("포인트"),
                        onPressed: logOutTalk,
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 10.0),
                      ),
                      FlatButton(
                        child: Text("홍보 및 가맹 문의"),
                        onPressed: logOutTalk,
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 10.0),
                      ),
                      FlatButton(
                        child: Text("로그아웃"),
                        onPressed: logOutTalk,
                      )
                    ],
                  )
                : Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 5.0),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            border: new Border.all(
                              color: Colors.black,
                              width: 0.5,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 35,
                            child: Icon(Icons.person),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 10.0),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: InkWell(
                          onTap: () {
                            moveLogin();
                          },
                          child: Container(
                            width: size.width / 2,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 5.0),
                                  child: Text(
                                    "로그인 해주세요.",
                                    style: TextStyle(
                                        // color: _colorText,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}
