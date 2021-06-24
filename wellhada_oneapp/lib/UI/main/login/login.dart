// @dart=2.9
import 'dart:async';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import 'package:kakao_flutter_sdk/auth.dart';
import 'package:kakao_flutter_sdk/user.dart';
import 'package:kakao_flutter_sdk/common.dart';
import 'package:wellhada_oneapp/UI/main/bottom_nav.dart';

import 'package:wellhada_oneapp/listitem/userFile/userList.dart' as user;
import 'package:wellhada_oneapp/model/login/userData.dart';
import 'package:wellhada_oneapp/notification/custom_notification.dart';

import 'email_login/extraLogin.dart';

/////////////////////////////
/////////////////////////////
///////로그인 페이지 ////////
///////카카오로그인할지 회원가입할지 로그인할지//////////
/////////////////////////////

class LOGIN extends StatefulWidget {
  var number;

  LOGIN({this.number});

  @override
  _LOGINState createState() => _LOGINState(number: number);
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
  String _kakaoEmail = 'None';
  var email, password, userChk;
  var appColor = '#ffffff';
  var menuColor = '#ffd428';
  var appFontColor = '#333333';
  var menuFontColor = '#333333';
  bool _isKakaoTalkInstalled = false;
  final _formKey2 = GlobalKey<FormState>();
  var uriUserProfile;
  String userProfile = '';
  var number;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String _messagingTitle = "";
  StreamSubscription iosSubscription;
  _LOGINState({this.number});

  @override
  void initState() {
    super.initState();
    //firebaseCloudMessagingListener();
    _initKakaoTalkInstalled();

    number == null ? number = 0 : number = number;
  }

  @override
  void dispose() {
    super.dispose();
  }

  //카카오 설치되있는지
  _initKakaoTalkInstalled() async {
    final installed = await isKakaoTalkInstalled();
    setState(() {
      _isKakaoTalkInstalled = installed;
    });
  }

  // firebaseCloudMessagingListener() async {
  //   if (Platform.isIOS) {
  //     _firebaseMessaging.requestNotificationPermissions(
  //         const IosNotificationSettings(
  //             sound: true, badge: true, alert: true, provisional: true));

  //     iosSubscription =
  //         _firebaseMessaging.onIosSettingsRegistered.listen((data) {
  //       //_saveDeviceToken();
  //     });
  //     _firebaseMessaging
  //         .requestNotificationPermissions(IosNotificationSettings());
  //   } else {
  //     // _firebaseMessaging.getToken().then((token) {
  //     //   print('token:' + token);
  //     // });
  //     //_saveDeviceToken();
  //   }

  //   _firebaseMessaging.configure(
  //     onMessage: (Map<String, dynamic> message) async {
  //       _messagingTitle = message['notification']['title'].toString();
  //       if (_messagingTitle.endsWith("null")) {
  //         _messagingTitle = "";
  //       }
  //       showOverlayNotification((context) {
  //         return MessageNotification(
  //           title: _messagingTitle,
  //           message: message['notification']['body'],
  //           onReply: () {
  //             OverlaySupportEntry.of(context).dismiss();
  //             //toast('you checked this message');
  //           },
  //         );
  //       }, duration: Duration(milliseconds: 4000));
  //     },
  //     onLaunch: (Map<String, dynamic> message) async {
  //       print("onLaunch: $message");
  //     },
  //     onResume: (Map<String, dynamic> message) async {
  //       print("onResume: $message");
  //     },
  //   );
  //   _firebaseMessaging.requestNotificationPermissions(
  //       const IosNotificationSettings(sound: true, badge: true, alert: true));
  //   _firebaseMessaging.onIosSettingsRegistered
  //       .listen((IosNotificationSettings settings) {
  //     print("Settings registered: $settings");
  //   });
  //   _firebaseMessaging.onIosSettingsRegistered
  //       .listen((IosNotificationSettings settings) {
  //     print("Settings registered: $settings");
  //   });
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   _firebaseMessaging.getToken().then((String token) {
  //     assert(token != null);
  //     print("Push Messaging token: $token");
  //     setState(() {
  //       prefs.setString("userToken", "$token");
  //       userToken = token;
  //       //_homeScreenText = "Push Messaging token: $token";
  //     });
  //   });
  // }

  //로그인 체크
  var userToken;
  checkEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userToken = prefs.getString("userToken");
    });
    final loginData = await user.loginUser(
        userId.text, userPassword.text, "Y", "E", userToken);

    if (loginData.status == "00") {
      final userData = await user.getUserInfomation(userId.text);

      setState(() {
        prefs.setBool('login', true);
        prefs.setString("userKey", userId.text);
        prefs.setString("userPasswordGoweb", userPassword.text);

        prefs.setString("marketing", userData.appAgreeMarketing);
        prefs.setString("userProfile", userData.kakaoProfil);
        prefs.setString("userEmail", userData.userEmail);
        prefs.setString("userId", userData.userId);
        prefs.setString("userName", userData.userName);
        prefs.setString("userChk", userData.userCheck);
        prefs.setString("userPhone", userData.userPhoneNumber);
        prefs.setString("userToken", userToken);
      });

      showDialog(
          context: context,
          builder: (_) => CupertinoAlertDialog(
                content: Text("로그인 되었습니다"),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text('확인'),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              BottomNav(number: number, userId: userId)),
                    ),
                  ),
                ],
              ));
    } else if (loginData.status == "10") {
      showDialog(
          context: context,
          builder: (_) => CupertinoAlertDialog(
                content: Text("아이디 비밀번호를 다시 확인해주세요!"),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text('확인'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ));
    } else {
      showDialog(
          context: context,
          builder: (_) => CupertinoAlertDialog(
                content: Text("다시 한번 확인 해주세요"),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text('확인'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ));
    }
  }

  //카카오 설치요청
  _loginWithKakao() async {
    try {
      var code = await AuthCodeClient.instance.request();
      await _issueAccessToken(code);
    } catch (e) {
      print(e);
    }
  }

//카카오 로그인
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
      final User userKakao = await UserApi.instance.me();

      setState(() {
        _kakaoEmail = userKakao.kakaoAccount.email;
        uriUserProfile = userKakao.kakaoAccount.profile.profileImageUrl;

        userProfile = uriUserProfile.toString();
      });

      final userData = await user.getUserInfomation(_kakaoEmail);

      if (userData.userId != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        setState(() {
          prefs.setString("userKey", _kakaoEmail);
          prefs.setString("userPasswordGoweb", "");
          prefs.setBool('login', true);
          prefs.setString("marketing", userData.appAgreeMarketing);
          prefs.setString("userProfile", userData.kakaoProfil);
          prefs.setString("userEmail", userData.userEmail);
          prefs.setString("userId", userData.userId);
          prefs.setString("userName", userData.userName);
          prefs.setString("userChk", userData.userCheck);
          prefs.setString("userPhone", userData.userPhoneNumber);
          prefs.setString("userToken", userData.userToken);

          // prefs.setInt("cookie", 00);
        });
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                new BottomNav(number: number, userId: userId)));
      } else {
        prefs.setString("marketing", "N");
        prefs.setString("userProfile", userProfile);
        prefs.setString("userEmail", _kakaoEmail);
        prefs.setString("userId", _kakaoEmail);

        prefs.setString(
            "userName",
            userKakao.kakaoAccount.profile.nickname == null
                ? _kakaoEmail
                : userKakao.kakaoAccount.profile.nickname);
        prefs.setString("userChk", 'K');
        prefs.setString("userPhone", '');

        Navigator.pushNamed(context, '/last_selection');
      } //userInfo(kakaoAccessToken);
    } catch (e) {
      print("error on issuing access token: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    isKakaoTalkInstalled();
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        title: Text(
          "#STORY",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
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
                    fontFamily: 'nanumR',
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
                  fontFamily: "nanumB",
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
                        fontFamily: 'nanumB',
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
                          fontFamily: 'nanumB',
                          fontSize: 14.0,
                          color: Colors.grey[500]),
                    )),
              ),
            ),
            InkWell(
              onTap: checkEmail,
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
                    '로그인',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'nanumB'),
                  )
                ]),
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
                        fontFamily: 'nanumB'),
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
                      return new ExtraLogin();
                      //return new Mobil_authen();
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
                        fontFamily: 'nanumB'),
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
