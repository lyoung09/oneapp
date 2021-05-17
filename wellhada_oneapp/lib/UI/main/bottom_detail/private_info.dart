import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wellhada_oneapp/UI/privateInfo_detail/hndSolution.dart';

import 'package:wellhada_oneapp/UI/privateInfo_detail/login.dart';
import 'package:wellhada_oneapp/UI/privateInfo_detail/user/notify.dart';
import 'package:wellhada_oneapp/UI/privateInfo_detail/user/point.dart';
import 'package:wellhada_oneapp/UI/privateInfo_detail/user/proposingShop.dart';
import 'package:wellhada_oneapp/UI/privateInfo_detail/user/updateUser.dart';
import 'package:wellhada_oneapp/listitem/user/user.dart' as user;
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

  var userName, userEmail, userPhone;
  var userChk, userPoint;
  var userProfile, cookie;
  @override
  void initState() {
    super.initState();
    check();
    // userCheck();
    // userEmailCheck();
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

  void check() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        userChk = prefs.getString("userChk");
      });
      if (userChk == '02' || userChk == null)
        notLoginUser();
      else
        userCheck();
    } catch (e) {
      userChk = '02';
      print(e);
    }
  }

  void notLoginUser() {
    setState(() {
      userChk = '02';
      userEmail = '';
      userName = '';
      userProfile = '';
      userPhone = '';
      cookie = '';
    });
  }

  void userCheck() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var password;

      setState(() {
        userEmail = prefs.getString("userEmail");
        userName = prefs.getString("userName");
        userProfile = prefs.getString("userProfile");
        userPhone = prefs.getString("userPhone");
        userChk = prefs.getString("userChk");
        cookie = prefs.getInt("cookie");
        userPoint = prefs.getString("userPoint");
        password = prefs.getString("password");
        //userProfile = uriUserProfile.toString();
      });
    } catch (e) {
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

  logOutEmail() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        prefs.setString('userEmail', null);
        prefs.setString('userPhone', null);
        prefs.setString('userProfile', null);
        prefs.setString('userName', null);
        prefs.setString("userChk", '02');
        prefs.setString("marketing", null);
        userChk = '02';
      });
    } catch (e) {
      print(e);
    }
  }

  logOutTalk() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      setState(() {
        prefs.setString('userEmail', null);
        prefs.setString('userPhone', null);
        prefs.setString('userProfile', null);
        prefs.setString('userName', null);
        prefs.setString("userChk", '02');
        prefs.setString("marketing", null);
        userChk = '02';
      });
      var code = await UserApi.instance.logout();

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

  pointCheck() async {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => new UsagePoint()));
  }

  @override
  Widget build(BuildContext context) {
    check();

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
          left: -40.0,
          child: Container(
            height: 150,
            width: 150,
            decoration: BoxDecoration(
                color: Colors.amberAccent, shape: BoxShape.circle),
          ),
        ),
        ListView(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(bottom: 10.0),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: userChk != '02'
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: <Widget>[
                              userProfile == null
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
                                                "${userPoint} P",
                                                style: TextStyle(
                                                  // color: _colorText,
                                                  fontSize: 25.0,
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
                                                fit: BoxFit.fill,
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
                                                "${userPoint} P",
                                                style: TextStyle(
                                                  // color: _colorText,
                                                  fontSize: 25.0,
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
                                            child: cookie == 00
                                                ? CircleAvatar(
                                                    radius: 50,
                                                    backgroundImage:
                                                        NetworkImage(
                                                            userProfile),
                                                    backgroundColor:
                                                        Colors.white,
                                                  )
                                                : CircleAvatar(
                                                    backgroundImage: Image.file(
                                                            File(userProfile))
                                                        .image,
                                                    radius: 35.0,
                                                  ),
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
                                                    fontSize: 16.0,
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
                            child: Text("내 정보"),
                            onPressed: updateUser,
                          ),
                          Container(
                            child: Divider(
                              color: Color.fromRGBO(82, 110, 208, 1.0),
                            ),
                            padding: EdgeInsets.only(
                                left: 20.0, right: 20.0, bottom: 0.0),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 10.0),
                          ),
                          FlatButton(
                            child: Text("알림"),
                            onPressed: notification,
                          ),
                          Container(
                            child: Divider(
                              color: Color.fromRGBO(82, 110, 208, 1.0),
                            ),
                            padding: EdgeInsets.only(
                                left: 20.0, right: 20.0, bottom: 0.0),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 10.0),
                          ),
                          FlatButton(child: Text("포인트"), onPressed: pointCheck),
                          Container(
                            child: Divider(
                              color: Color.fromRGBO(82, 110, 208, 1.0),
                            ),
                            padding: EdgeInsets.only(
                                left: 20.0, right: 20.0, bottom: 0.0),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 10.0),
                          ),
                          FlatButton(
                            child: Text("홍보 및 가맹 문의"),
                            onPressed: proposeWellhada,
                          ),
                          Container(
                            child: Divider(
                              color: Color.fromRGBO(82, 110, 208, 1.0),
                            ),
                            padding: EdgeInsets.only(
                                left: 20.0, right: 20.0, bottom: 0.0),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 10.0),
                          ),
                          FlatButton(
                            child: Text("회사 정보"),
                            onPressed: hndSolution,
                          ),
                          Container(
                            child: Divider(
                              color: Color.fromRGBO(82, 110, 208, 1.0),
                            ),
                            padding: EdgeInsets.only(
                                left: 20.0, right: 20.0, bottom: 0.0),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 10.0),
                          ),
                          userChk == '00'
                              ? FlatButton(
                                  child: Text("로그아웃"),
                                  onPressed: logOutTalk,
                                )
                              : FlatButton(
                                  child: Text("로그아웃"),
                                  onPressed: logOutEmail,
                                )
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
                                      fit: BoxFit.fill,
                                      width: 20,
                                      height: 20,
                                    ),
                                  ),
                                ),
                              )),
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
                                child: Text("회사 정보"),
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
