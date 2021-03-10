import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import 'package:kakao_flutter_sdk/auth.dart';
import 'package:kakao_flutter_sdk/user.dart';
import 'package:kakao_flutter_sdk/common.dart';
import 'account_login/signup_agree.dart';
import 'email_login/email_login.dart';
import 'email_login/email_signup.dart';

class LOGIN extends StatefulWidget {
  @override
  _LOGINState createState() => _LOGINState();
}

class _LOGINState extends State<LOGIN> {
  TextEditingController userId = TextEditingController(text: '');
  TextEditingController userPassword = TextEditingController(text: '');

  SharedPreferences prefs;
  var appId;
  var screenSeq;
  var limitYn;
  var userName;
  var mainUserScSeq;
  bool checkId = false;
  String errorText = "";
  bool _isKakaoTalkInstalled = true;
  String _kakaoEmail = 'None';

  var appColor = '#ffffff';
  var menuColor = '#ffd428';
  var appFontColor = '#333333';
  var menuFontColor = '#333333';

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _initKakaoTalkInstalled() async {
    final installed = await isKakaoTalkInstalled();
    setState(() {
      _isKakaoTalkInstalled = installed;
    });
  }

  Future<void> _initData() async {
    _initKakaoTalkInstalled();
    prefs = await SharedPreferences.getInstance();

    setState(() {
      appId = prefs.getString("appId");
      screenSeq = prefs.getString("screenSeq");
      if (prefs.getString("limitYn") == "Y") {
        checkId = true;
        userId = TextEditingController(text: '${prefs.getString("userId")}');
      }
    });
  }

  _loginWithKakao() async {
    try {
      var code = await AuthCodeClient.instance.request();
      await _issueAccessToken(code);
    } catch (e) {
      print(e);
    }
  }

  _loginWithTalk() async {
    try {
      var code = await AuthCodeClient.instance.requestWithTalk();
      await _issueAccessToken(code);
    } catch (e) {
      print(e);
    }
  }

  _issueAccessToken(String authCode) async {
    prefs = await SharedPreferences.getInstance();
    try {
      var token = await AuthApi.instance.issueAccessToken(authCode);
      String kakaoAccessToken = token.accessToken;
      AccessTokenStore.instance.toStore(token);

      final User user = await UserApi.instance.me();

      setState(() {
        _kakaoEmail = user.kakaoAccount.email;
      });
      print(_kakaoEmail);
      prefs.setString("userId", _kakaoEmail);
      prefs.setString("userName", user.kakaoAccount.profile.nickname);
      prefs.setString("appId", appId);
      prefs.setString("limitYn", 'Y');

      prefs.setString("userChk", "00");
      //userInfo(kakaoAccessToken);
    } catch (e) {
      print("error on issuing access token: $e");
    }
  }

  Future<void> _insertData() async {
    prefs = await SharedPreferences.getInstance();
    var result;
    setState(() {
      if (checkId == true) {
        limitYn = 'Y';
        prefs.setString("userId", userId.text);
      } else {
        limitYn = 'N';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Padding(
            padding: const EdgeInsets.only(right: 50.0),
            child: Text(
              "#story",
              style: TextStyle(
                  fontFamily: 'Godo',
                  fontWeight: FontWeight.w900,
                  fontSize: 20.0,
                  color: Hexcolor(appFontColor)),
            ),
          ),
        ),
        elevation: 0.0,
        flexibleSpace: Container(
          decoration: BoxDecoration(color: Hexcolor(menuColor)),
        ),
      ),
      backgroundColor: Hexcolor('#F1F2F6'),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  top: 10.0, left: 40.0, right: 40.0, bottom: 10.0),
              child: Center(
                child: Text(
                  "${errorText}",
                  style: TextStyle(
                    fontFamily: 'Godo',
                    fontSize: 14.0,
                    color: Hexcolor('#FF8900'),
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(top: 10.0, bottom: 50.0),
              child: Text(
                "로그인",
                style: TextStyle(
                  color: Hexcolor('#242A37'),
                  fontFamily: "Sans",
                  fontWeight: FontWeight.w800,
                  fontSize: 15.0,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Container(
                height: 45.0,
                width: width - 80.0,
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Hexcolor('#FFD428'),
                    ),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0)),
                child: TextFormField(
                  controller: userId,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  cursorColor: Hexcolor('#FF8900'),
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(13.0),
                    hintText: "아이디(*)",
                    hintStyle: TextStyle(
                        fontFamily: 'Godo',
                        fontSize: 14.0,
                        color: Colors.grey[500]),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Container(
                height: 45.0,
                width: width - 80.0,
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Hexcolor('#FFD428'),
                    ),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0)),
                child: TextFormField(
                    controller: userPassword,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    cursorColor: Hexcolor('#FF8900'),
                    textAlignVertical: TextAlignVertical.center,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(13.0),
                      hintText: "비밀번호(*)",
                      hintStyle: TextStyle(
                          fontFamily: 'Godo',
                          fontSize: 14.0,
                          color: Colors.grey[500]),
                    )),
              ),
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 30.0),
                  child: Checkbox(
                    value: checkId,
                    checkColor: Hexcolor('#FFFFFF'),
                    activeColor: Hexcolor('#FF8900'),
                    onChanged: (bool value) {
                      setState(() {
                        checkId = value;
                      });
                    },
                  ),
                ),
                Text(
                  "아이디 저장",
                  style: TextStyle(
                      color: Hexcolor('#242A37'),
                      fontSize: 13.0,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Sans"),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 20.0, left: 40.0, right: 40.0, bottom: 20.0),
              child: Divider(
                color: Colors.grey,
                height: 2.0,
              ),
            ),
            InkWell(
              onTap: _isKakaoTalkInstalled ? _loginWithTalk : _loginWithKakao,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.6,
                height: MediaQuery.of(context).size.height * 0.07,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.yellow),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Image.asset(
                    "assets/icon/icon_kakao.png",
                    height: 25.0,
                  ),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 7.0)),
                  Text(
                    '카카오 로그인',
                    style: TextStyle(
                        color: Colors.brown,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'NotoSans'),
                  )
                ]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 5.0, left: 40.0, right: 40.0, bottom: 5.0),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) {
                      return new Email_signup();
                    },
                    fullscreenDialog: true));
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.6,
                height: MediaQuery.of(context).size.height * 0.07,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(
                    Icons.email,
                    size: 30.0,
                  ),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 7.0)),
                  Text(
                    '이메일로 회원가입',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'NotoSans'),
                  )
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
