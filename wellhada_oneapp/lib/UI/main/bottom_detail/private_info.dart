// @dart=2.9
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wellhada_oneapp/UI/bottom_nav_deatail/privateInfo_detail/hndSolution.dart';
import 'package:wellhada_oneapp/UI/bottom_nav_deatail/privateInfo_detail/user/mileage.dart';
import 'package:wellhada_oneapp/UI/bottom_nav_deatail/privateInfo_detail/user/mileage_detail/point.dart';
import 'package:wellhada_oneapp/UI/bottom_nav_deatail/privateInfo_detail/user/notify.dart';
import 'package:wellhada_oneapp/UI/bottom_nav_deatail/privateInfo_detail/user/proposingShop.dart';
import 'package:wellhada_oneapp/UI/bottom_nav_deatail/privateInfo_detail/user/updateUser.dart';

import 'package:wellhada_oneapp/UI/main/login/login.dart';

import 'package:wellhada_oneapp/listitem/userFile/userList.dart' as user;
import 'package:wellhada_oneapp/model/menu/drawer_detail/qr_34.dart';
import 'package:wellhada_oneapp/notification/push_message.dart';

import 'home_screen.dart';

class PriavateInfo extends StatefulWidget {
  @override
  _PriavateInfoState createState() => _PriavateInfoState();
}

class _PriavateInfoState extends State<PriavateInfo> {
  var appColor = '#ffffff';
  var menuColor = '#ffd428';
  var appFontColor = '#333333';
  var menuFontColor = '#333333';
  String userName;
  var userEmail, userPhone;
  var userChk;
  var userProfile;
  var userId;

  @override
  void initState() {
    super.initState();

    check();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    super.dispose();
    check();
  }

  //유저 로그인 체크
  void check() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      setState(() {
        userId = prefs.getString("userKey");
      });
      if (userId != null) {
        userCheck();
      } else {
        notLoginUser();
      }
    } catch (e) {
      userChk = 'O';
      print(e);
    }
  }

  void notLoginUser() {
    setState(() {
      userChk = 'O';
      userEmail = '';
      userName = '';
      userProfile = "";
      userPhone = '';
    });
  }

  //유저 로그인 되있으면 데이터 호출
  void userCheck() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // var password;
      final userData = await user.getUserInfomation(userId);

      setState(() {
        print('userData.status==================${userData.status}');

        userName = userData.userName;
        userChk = userData.userCheck;
        userProfile = userData.kakaoProfil == null ? "" : userData.kakaoProfil;
      });
    } catch (e) {
      print(e);
    }
  }

  moveLogin() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => new LOGIN(number: 3)));
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

  //회원탈퇴
  delete() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      prefs.setString("userKey", null);

      prefs.setString("userPasswordGoweb", null);
      prefs.setString("userChk", null);
      prefs.setString("userName", null);
      prefs.setBool('login', false);
      userChk = 'O';
    });
  }

//이메일로그아웃
  logOutEmail() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        prefs.setString("userKey", null);
        prefs.setString("userPasswordGoweb", null);
        prefs.setString("userChk", null);
        prefs.setString("userName", null);

        prefs.setBool('login', false);
        userChk = 'O';
      });
    } catch (e) {
      print(e);
    }
  }

//카카오 로그아웃
  logOutTalk() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      setState(() {
        prefs.setString("userKey", null);

        prefs.setString("userPasswordGoweb", null);
        prefs.setString("userChk", null);
        prefs.setString("userName", null);

        prefs.setBool('login', false);
        userChk = 'O';
      });
      var code = await UserApi.instance.logout();
    } catch (e) {
      print(e);
    }
  }

  unlinkTalk() async {
    try {
      var code = await UserApi.instance.unlink();
    } catch (e) {
      print(e);
    }
  }

  updateUser() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => new UserUpdate()));
  }

  notification() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => new Notify()));
  }

  proposeWellhada() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => new ProposingShop()));
  }

  hndSolution() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => new HndSolution()));
  }

  pushmessage() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => new PushMessage()));
  }

  mileage() async {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => Mileage(userId, userName)));
  }

  pointCheck() async {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => UsagePoint(userId, userName)));
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Stack(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
        ),
        ClipPath(
          clipper: OvalBottomBorderClipper(),
          child: Container(
            height: MediaQuery.of(context).size.height / 4 + 40,
            color: Colors.white,
          ),
        ),
        Positioned(
          top: -20.0,
          left: 10.0,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.25,
            width: MediaQuery.of(context).size.width * 0.25,
            child: Image.asset(
              "assets/icon/shopstoryIco.png",
              //width: size.width * 0.9,
            ),
          ),
        ),
        ListView(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(bottom: 5.0),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: userChk != 'O'
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: <Widget>[
                              userProfile == null || userProfile == ""
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 55),
                                            child: Container(
                                              child: Text(
                                                //"${userPoint} P",
                                                "",
                                                style: TextStyle(
                                                  // color: _colorText,
                                                  fontSize: 0.0,
                                                  //25
                                                  fontFamily: "nanumB",
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: Container(
                                            height: 90,
                                            width: 90,
                                            decoration: new BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: new Border.all(
                                                color: Colors.black,
                                                width: 0.5,
                                              ),
                                            ),
                                            child: CircleAvatar(
                                              radius: 35,
                                              child: SvgPicture.asset(
                                                "assets/svg/defaultUser.svg",
                                                fit: BoxFit.fitHeight,
                                                width: 20,
                                                height: 20,
                                              ),
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
                                          alignment: Alignment.topRight,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 55),
                                            child: Container(
                                              child: Text(
                                                //"${
                                                //} P",
                                                "",
                                                style: TextStyle(
                                                  color: Colors.transparent,
                                                  fontSize: 0.0,
                                                  //25
                                                  fontFamily: "nanumR",
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: Container(
                                              height: 90,
                                              width: 90,
                                              decoration: new BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: new Border.all(
                                                  color: Colors.black,
                                                  width: 0.5,
                                                ),
                                              ),
                                              child:
                                                  // userChk == "E"
                                                  //     ?
                                                  CircleAvatar(
                                                radius: 50,
                                                backgroundImage:
                                                    NetworkImage(userProfile),
                                                backgroundColor: Colors.white,
                                              )
                                              // :
                                              // CircleAvatar(
                                              //     backgroundImage: Image.file(
                                              //             File(userProfile))
                                              //         .image,
                                              //     radius: 50.0,
                                              //   ),
                                              ),
                                        ),
                                      ],
                                    ),
                              Padding(
                                padding: EdgeInsets.only(bottom: 20.0),
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: InkWell(
                                  onTap: () {
                                    // Navigator.of(context).push(MaterialPageRoute(
                                    //     builder: (BuildContext context) {
                                    //       return new Account_user_info();
                                    //     },
                                    //     fullscreenDialog: true));
                                  },
                                  child: Container(
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.only(top: 10),
                                          ),
                                          userName == null
                                              ? Text("")
                                              : Text(
                                                  userName,
                                                  style: TextStyle(
                                                    // color: _colorText,
                                                    fontSize: 18.0,
                                                    fontFamily: 'nanumB',
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                ),
                                          Text(
                                            "님 안녕하세요.",
                                            style: TextStyle(
                                              //color: _colorText,
                                              fontSize: 14.0,
                                              fontFamily: "nanumR",
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
                            child: Text(
                              "내 정보",
                              style: TextStyle(
                                color: Colors.grey[900],
                                fontSize: 15.0,
                                fontFamily: "nanumB",
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            onPressed: updateUser,
                            //onPressed: pushmessage,
                          ),
                          Container(
                            child: Divider(
                              color: Color.fromRGBO(82, 110, 208, 1.0),
                            ),
                            padding: EdgeInsets.only(right: 20.0, bottom: 0.0),
                          ),
                          FlatButton(
                            child: Text(
                              "알림",
                              style: TextStyle(
                                color: Colors.grey[900],
                                fontSize: 15.0,
                                fontFamily: "nanumB",
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            onPressed: notification,
                          ),
                          Container(
                            child: Divider(
                              color: Color.fromRGBO(82, 110, 208, 1.0),
                            ),
                            padding: EdgeInsets.only(right: 20.0, bottom: 0.0),
                          ),
                          FlatButton(
                              child: Text(
                                "포인트",
                                style: TextStyle(
                                  color: Colors.grey[900],
                                  fontSize: 15.0,
                                  fontFamily: "nanumB",
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              onPressed: pointCheck),
                          Container(
                            child: Divider(
                              color: Color.fromRGBO(82, 110, 208, 1.0),
                            ),
                            padding: EdgeInsets.only(right: 20.0, bottom: 0.0),
                          ),
                          FlatButton(
                            child: Text(
                              "홍보 및 가맹 문의",
                              style: TextStyle(
                                color: Colors.grey[900],
                                fontSize: 15.0,
                                fontFamily: "nanumB",
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            onPressed: proposeWellhada,
                          ),
                          Container(
                            child: Divider(
                              color: Color.fromRGBO(82, 110, 208, 1.0),
                            ),
                            padding: EdgeInsets.only(right: 20.0, bottom: 0.0),
                          ),
                          FlatButton(
                            child: Text(
                              "회사 정보",
                              style: TextStyle(
                                color: Colors.grey[900],
                                fontSize: 15.0,
                                fontFamily: "nanumB",
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            onPressed: hndSolution,
                          ),
                          Container(
                            child: Divider(
                              color: Color.fromRGBO(82, 110, 208, 1.0),
                            ),
                            padding: EdgeInsets.only(right: 20.0, bottom: 0.0),
                          ),
                          userChk == 'K'
                              ? FlatButton(
                                  child: Text(
                                    "로그아웃",
                                    style: TextStyle(
                                      color: Colors.grey[900],
                                      fontSize: 15.0,
                                      fontFamily: "nanumB",
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  onPressed: logOutTalk,
                                )
                              : FlatButton(
                                  child: Text(
                                    "로그아웃",
                                    style: TextStyle(
                                      color: Colors.grey[900],
                                      fontSize: 15.0,
                                      fontFamily: "nanumB",
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  onPressed: logOutEmail,
                                ),
                          Container(
                            child: Divider(
                              color: Color.fromRGBO(82, 110, 208, 1.0),
                            ),
                            padding: EdgeInsets.only(right: 20.0, bottom: 0.0),
                          ),
                          FlatButton(
                            child: Text(
                              "회원 탈퇴",
                              style: TextStyle(
                                color: Colors.grey[900],
                                fontSize: 15.0,
                                fontFamily: "nanumB",
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            onPressed: delete,
                          ),
                        ],
                      )
                    : Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 5.0),
                          ),
                          InkWell(
                              onTap: () {
                                moveLogin();
                              },
                              child: Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                  height: 90,
                                  width: 90,
                                  decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: new Border.all(
                                      color: Colors.black,
                                      width: 0.5,
                                    ),
                                  ),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.amberAccent,
                                    radius: 35,
                                    child: SvgPicture.asset(
                                      "assets/svg/defaultUser.svg",
                                      fit: BoxFit.fitHeight,
                                      width: 20,
                                      height: 20,
                                    ),
                                  ),
                                ),
                              )),
                          Padding(
                            padding: EdgeInsets.only(bottom: 2.5),
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
                                    Padding(
                                      padding: EdgeInsets.only(right: 10.0),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 40, bottom: 20.0),
                          ),
                          Container(
                            child: Divider(
                              color: Color.fromRGBO(82, 110, 208, 1.0),
                            ),
                            padding: EdgeInsets.only(
                                left: 20.0, right: 20.0, bottom: 0.0),
                          ),
                          Align(
                              alignment: Alignment.centerLeft,
                              child: FlatButton(
                                child: Text(
                                  "회사 정보",
                                  style: TextStyle(
                                    color: Colors.grey[900],
                                    fontSize: 15.0,
                                    fontFamily: "nanumB",
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                onPressed: hndSolution,
                              )),
                          Padding(
                            padding: EdgeInsets.only(bottom: 10),
                          ),
                          Container(
                            child: Divider(
                              color: Color.fromRGBO(82, 110, 208, 1.0),
                            ),
                            padding: EdgeInsets.only(
                                left: 20.0, right: 20.0, bottom: 0.0),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
