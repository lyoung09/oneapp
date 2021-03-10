/** import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:wellhadaclient/ui/browser.dart';
import 'package:wellhadaclient/ui/login/login.dart';

import 'signup_user_info.dart';

class SIGNUP_AGREE extends StatefulWidget {
  String AppTitle, UserScSeq, appColor, menuColor, appFontColor;
  SIGNUP_AGREE(this.AppTitle, this.UserScSeq, this.appColor, this.menuColor,
      this.appFontColor);

  @override
  _SIGNUP_AGREEState createState() => _SIGNUP_AGREEState(
      AppTitle, UserScSeq, appColor, menuColor, appFontColor);
}

class _SIGNUP_AGREEState extends State<SIGNUP_AGREE> {
  String AppTitle, UserScSeq, appColor, menuColor, appFontColor;
  _SIGNUP_AGREEState(this.AppTitle, this.UserScSeq, this.appColor,
      this.menuColor, this.appFontColor);

  String appAgreePush = "N";
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool checkService = false;
  bool checkPrivacy = false;
  bool checkLocation = false;
  bool checkAd = false;

  bool _isButtonDisabled;

  @override
  void initState() {
    super.initState();
    _isButtonDisabled = false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  _checkboxPress() {
    if (checkPrivacy == true && checkService == true) {
      _isButtonDisabled = true;
    } else {
      _isButtonDisabled = false;
    }
  }

  _nextButtonPress() {
    if (_isButtonDisabled == false) {
      return null;
    } else {
      return () {
        if (checkAd == true) {
          appAgreePush = "Y";
        }
        Navigator.of(context).pushReplacement(PageRouteBuilder(
            pageBuilder: (_, __, ___) => SIGNUP_USER_INFO(appAgreePush,
                AppTitle, UserScSeq, appColor, menuColor, appFontColor)));
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
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 10.0, bottom: 50.0),
              child: Text(
                "약관 동의",
                style: TextStyle(
                  color: Hexcolor('#242A37'),
                  fontWeight: FontWeight.w700,
                  fontSize: 15.0,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Checkbox(
                        value: checkService,
                        checkColor: Hexcolor('#FFFFFF'),
                        activeColor: Hexcolor('#FF8900'),
                        onChanged: (bool value) {
                          setState(() {
                            checkService = value;
                            _checkboxPress();
                          });
                        },
                      ),
                      Text(
                        "이용약관",
                        style: TextStyle(
                            color: Hexcolor('#242A37'),
                            fontSize: 13.0,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Sans"),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      //Navigator.of(context).push(PageRouteBuilder(pageBuilder: (_, __, ___) => new browser('https://www.wellhada.com/service.do')));
                    },
                    child: Text(
                      '전체보기',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontFamily: "Sans",
                        fontSize: 13.0,
                        color: Hexcolor('#242A37'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Checkbox(
                        value: checkPrivacy,
                        checkColor: Hexcolor('#FFFFFF'),
                        activeColor: Hexcolor('#FF8900'),
                        onChanged: (bool value) {
                          setState(() {
                            checkPrivacy = value;
                            _checkboxPress();
                          });
                        },
                      ),
                      Text(
                        "개인정보 수집과 이용",
                        style: TextStyle(
                            color: Hexcolor('#242A37'),
                            fontSize: 13.0,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Sans"),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      //Navigator.of(context).push(PageRouteBuilder(pageBuilder: (_, __, ___) => new browser('https://www.wellhada.com/privacy.do')));
                    },
                    child: Text(
                      '전체보기',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontFamily: "Sans",
                        fontSize: 13.0,
                        color: Hexcolor('#242A37'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Checkbox(
                        value: checkLocation,
                        checkColor: Hexcolor('#FFFFFF'),
                        activeColor: Hexcolor('#FF8900'),
                        onChanged: (bool value) {
                          setState(() {
                            checkLocation = value;
                            _checkboxPress();
                          });
                        },
                      ),
                      Text(
                        "위치정보 수집과 이용",
                        style: TextStyle(
                            color: Hexcolor('#242A37'),
                            fontSize: 13.0,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Sans"),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(PageRouteBuilder(
                          pageBuilder: (_, __, ___) => new browser(
                              'https://www.wellhada.com/privacy.do')));
                    },
                    child: Text(
                      '전체보기',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontFamily: "Sans",
                        fontSize: 13.0,
                        color: Hexcolor('#242A37'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Checkbox(
                        value: checkAd,
                        checkColor: Hexcolor('#FFFFFF'),
                        activeColor: Hexcolor('#FF8900'),
                        onChanged: (bool value) {
                          setState(() {
                            checkAd = value;
                          });
                        },
                      ),
                      Text(
                        "홍보성 정보 수신 동의(선택)",
                        style: TextStyle(
                            color: Hexcolor('#242A37'),
                            fontSize: 13.0,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Sans"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  checkService = true;
                  checkPrivacy = true;
                  checkLocation = true;
                  checkAd = true;
                  _isButtonDisabled = true;
                });
              },
              child: Container(
                height: 40.0,
                width: width - 100,
                decoration: BoxDecoration(
                  color: Hexcolor('#FFD428'),
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Icon(
                          Icons.check_circle_outline,
                          color: Hexcolor('#242A37'),
                        ),
                      ),
                      Text(
                        "전체 동의",
                        style: TextStyle(
                            color: Hexcolor('#242A37'),
                            letterSpacing: 0.2,
                            fontFamily: "Sans",
                            fontSize: 16.0,
                            fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 30.0, left: 20.0, right: 20.0, bottom: 50.0),
              child: Divider(
                color: Colors.grey,
                height: 2.0,
              ),
            ),
            InkWell(
              onTap: _nextButtonPress(),
              child: Container(
                height: 40.0,
                width: width - 100,
                decoration: BoxDecoration(
                  color: _isButtonDisabled == false
                      ? Hexcolor('#6D6B6B')
                      : Hexcolor('#FFD428'),
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Center(
                  child: Text(
                    "다음",
                    style: TextStyle(
                        color: _isButtonDisabled == false
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
            Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) {
                      return new LOGIN("defult", AppTitle, UserScSeq, appColor,
                          menuColor, appFontColor);
                      //return new SignupComplete();
                    },
                    fullscreenDialog: true));
              },
              child: Text(
                "로그인",
                style: TextStyle(
                    color: Hexcolor('#242A37'),
                    fontSize: 13.0,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Sans"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
*/
