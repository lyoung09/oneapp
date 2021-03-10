/**import 'dart:async';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import 'signup_complete.dart';

class SIGNUP_USER_INFO extends StatefulWidget {
  final String appAgreePush,
      AppTitle,
      UserScSeq,
      appColor,
      menuColor,
      appFontColor;
  SIGNUP_USER_INFO(this.appAgreePush, this.AppTitle, this.UserScSeq,
      this.appColor, this.menuColor, this.appFontColor);

  @override
  _SIGNUP_USER_INFOState createState() => _SIGNUP_USER_INFOState(
      appAgreePush, AppTitle, UserScSeq, appColor, menuColor, appFontColor);
}

class _SIGNUP_USER_INFOState extends State<SIGNUP_USER_INFO> {
  final String appAgreePush,
      AppTitle,
      UserScSeq,
      appColor,
      menuColor,
      appFontColor;
  _SIGNUP_USER_INFOState(this.appAgreePush, this.AppTitle, this.UserScSeq,
      this.appColor, this.menuColor, this.appFontColor);

  final scaffoldKey = GlobalKey<ScaffoldState>();

  var appId = "";
  var userUuid = "";
  var userDevice = "";
  var appPushToken = "";

  var appAgreeMarketingEmail = "N";
  var appAgreeMarketingSms = "N";
  var appAgreePush_night = "N";
  String errorText = "";

  final TextEditingController userId = TextEditingController(text: '');
  final TextEditingController userPassword = TextEditingController(text: '');
  final TextEditingController userPasswordChk = TextEditingController(text: '');
  final TextEditingController userEmail = TextEditingController(text: '');
  final TextEditingController userName = TextEditingController(text: '');
  final TextEditingController userGroupName = TextEditingController(text: '');
  final TextEditingController userPhoneNumber = TextEditingController(text: '');

  bool _completeButton;

  Future<void> _initData() async {
    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();

    appId = prefs.getString("appId");
    userDevice = prefs.getString("userDevice");
    userUuid = prefs.getString("userUuid");
    appPushToken = prefs.getString("appPushToken");
  }

  Future<void> _insertData() async {
    var result;
    if (userPassword.text == userPasswordChk.text) {
      final startInfo = await loginData.getInsertUser(
          userId.text,
          userPassword.text,
          userEmail.text,
          userName.text,
          userGroupName.text,
          userPhoneNumber.text,
          appId,
          appPushToken,
          'Y',
          'Y',
          appAgreePush,
          'N',
          'N',
          'N',
          userUuid,
          userDevice);

      SharedPreferences prefs;
      prefs = await SharedPreferences.getInstance();

      setState(() {
        result = startInfo.STATUS;

        print(result);

        if (result == "00") {
          prefs.setString("userName", userName.text);

          Navigator.of(context).pushReplacement(PageRouteBuilder(
              pageBuilder: (_, __, ___) => SIGNUP_COMPLETE(
                  AppTitle, UserScSeq, appColor, menuColor, appFontColor)));
        } else if (result == "20") {
          errorText = "중복 아이디입니다.";
        }
      });
    } else {
      setState(() {
        errorText = "비밀번호가 일치하지 않습니다.";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _completeButton = false;

    userId.addListener(_textPress);
    userPassword.addListener(_textPress);
    userPasswordChk.addListener(_textPress);

    userName.addListener(_textPress);
    userGroupName.addListener(_textPress);
    userPhoneNumber.addListener(_textPress);

    _initData();
  }

  @override
  void dispose() {
    super.dispose();
    userId.dispose();
    userPassword.dispose();
    userPasswordChk.dispose();
    userEmail.dispose();
    userName.dispose();
    userGroupName.dispose();
    userPhoneNumber.dispose();
  }

  _textPress() {
    setState(() {
      if (userId.text != '' &&
          userPassword.text != '' &&
          userPasswordChk.text != '' &&
          userEmail.text != '' &&
          userName.text != '') {
        _completeButton = true;
      } else {
        _completeButton = false;
      }
    });
  }

  _nextButtonPress() {
    if (_completeButton == false) {
      return null;
    } else {
      return () {
        _insertData();
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Hexcolor('#F1F2F6'),
      appBar: AppBar(
        title: Center(
          child: Padding(
            padding: const EdgeInsets.only(right: 50.0),
            child: Text(
              "${AppTitle}",
              style: TextStyle(
                  fontFamily: 'Godo',
                  fontWeight: FontWeight.w900,
                  fontSize: 20.0,
                  color: Hexcolor('${appFontColor}')),
            ),
          ),
        ),
        elevation: 0.0,
        flexibleSpace: Container(
          decoration: BoxDecoration(color: Hexcolor('${menuColor}')),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.only(top: 10.0, bottom: 30.0),
                child: Text(
                  "회원정보 입력",
                  style: TextStyle(
                    color: Hexcolor('#242A37'),
                    fontWeight: FontWeight.w700,
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
                    onTap: () {
                      setState(() {
                        errorText = "";
                      });
                    },
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
                    ),
                    onTap: () {
                      setState(() {
                        errorText = "";
                      });
                    },
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
                    controller: userPasswordChk,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    cursorColor: Hexcolor('#FF8900'),
                    textAlignVertical: TextAlignVertical.center,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(13.0),
                      hintText: "비밀번호 재확인(*)",
                      hintStyle: TextStyle(
                          fontFamily: 'Godo',
                          fontSize: 14.0,
                          color: Colors.grey[500]),
                    ),
                    onTap: () {
                      setState(() {
                        errorText = "";
                      });
                    },
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
                    controller: userEmail,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    cursorColor: Hexcolor('#FF8900'),
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(13.0),
                      hintText: "이메일(*)",
                      hintStyle: TextStyle(
                          fontFamily: 'Godo',
                          fontSize: 14.0,
                          color: Colors.grey[500]),
                    ),
                    onTap: () {
                      setState(() {
                        errorText = "";
                      });
                    },
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
                    controller: userName,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    cursorColor: Hexcolor('#FF8900'),
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(13.0),
                      hintText: "이름(*)",
                      hintStyle: TextStyle(
                          fontFamily: 'Godo',
                          fontSize: 14.0,
                          color: Colors.grey[500]),
                    ),
                    onTap: () {
                      setState(() {
                        errorText = "";
                      });
                    },
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
                    controller: userGroupName,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    cursorColor: Hexcolor('#FF8900'),
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(13.0),
                      hintText: "단체명",
                      hintStyle: TextStyle(
                          fontFamily: 'Godo',
                          fontSize: 14.0,
                          color: Colors.grey[500]),
                    ),
                    onTap: () {
                      setState(() {
                        errorText = "";
                      });
                    },
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
                    controller: userPhoneNumber,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    keyboardType: TextInputType.number,
                    cursorColor: Hexcolor('#FF8900'),
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(13.0),
                      hintText: "전화번호",
                      hintStyle: TextStyle(
                          fontFamily: 'Godo',
                          fontSize: 14.0,
                          color: Colors.grey[500]),
                    ),
                    onTap: () {
                      setState(() {
                        errorText = "";
                      });
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 20.0, left: 40.0, right: 40.0, bottom: 20.0),
                child: Divider(
                  color: Colors.grey,
                  height: 2.0,
                ),
              ),
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
              InkWell(
                onTap: _nextButtonPress(),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 10.0, right: 10.0, bottom: 20.0, top: 10.0),
                  child: Container(
                    height: 40.0,
                    width: width - 100,
                    decoration: BoxDecoration(
                      color: _completeButton == false
                          ? Hexcolor('#6D6B6B')
                          : Hexcolor('#FFD428'),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Center(
                      child: Text(
                        "가입 완료",
                        style: TextStyle(
                            color: _completeButton == false
                                ? Colors.white
                                : Hexcolor('#242A37'),
                            letterSpacing: 0.2,
                            fontFamily: "Sans",
                            fontSize: 16.0,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/
