import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wellhada_oneapp/UI/privateInfo_detail/email_login/email.dart';
import 'package:wellhada_oneapp/notification/custom_notification.dart';

class ExtraLogin extends StatefulWidget {
  @override
  _ExtraLoginState createState() => _ExtraLoginState();
}

class _ExtraLoginState extends State<ExtraLogin> {
  bool allAgree;
  bool service, private, privateSuggestion, marketing;
  bool anything;
  String serviceMent =
      "제 1장 총칙 \n제 1 조 (목적)\n이 이용약관은 e나라 표준인증에서 제공하는 인터넷 서비스(이하 서비스)의 가입조건, 당 사이트와 이용자의 권리, 의무, 책임사항과 기타 필요한 사항을 규정함을 목적으로 합니다.\n\n제 2 조 (용어의 정의)\n1. 이용자라 함은 당 사이트에 접속하여 이 약관에 따라 당 사이트가 제공하는 서비스를 받는 회원 및 비회원을 말합니다.\n2. e나라 표준인증에서 제공하는 국가표준, 인증제도, 기술기준, 인증지원 정보를 말합니다.\n3. 회원이라 함은 서비스를 이용하기 위하여 당 사이트에 개인정보를 제공하여 아이디(ID)와 비밀번호를 부여 받은 자를 말합니다.\n4. 비회원이하 함은 회원으로 가입하지 않고 e나라 표준인증에서 제공하는 서비스를 이용하는 자를 말합니다.\n5. 회원 아이디(ID)라 함은 회원의 식별 및 서비스 이용을 위하여 자신이 선정한 문자 및 숫자의 조합을 말합니다.\n6. 비밀번호라 함은 회원이 자신의 개인정보 및 직접 작성한 비공개 콘텐츠의 보호를 위하여 선정한 문자, 숫자 및 특수문자의 조합을 말합니다.  \n\n제 3 조 (이용약관의 효력 및 변경)\n1. 당 사이트는 이 약관의 내용을 회원이 알 수 있도록 당 사이트의 초기 서비스화면에 게시합니다. 다만, 약관의 내용은 이용자가 연결화면을 통하여 볼 수 있도록 할 수 있습니다.\n2. 당 사이트는 이 약관을 개정할 경우에 적용일자 및 개정사유를 명시하여 현행 약관과 함께 당 사이트의 초기화면 또는 초기화면과의 연결화면에 그 적용일자 7일 이전부터 적용일자 전일까지 공지합니다. 다만, 회원에게 불리하게 약관내용을 변경하는 경우에는 최소한 30일 이상의 사전 유예기간을 두고 공지합니다. 이 경우 당 사이트는 개정 전 내용과 개정 후 내용을 명확하게 비교하여 이용자가 알기 쉽도록 표시합니다.\n3. 당 사이트가 전항에 따라 개정약관을 공지하면서 개정일자 적용 이전까지 회원이 명시적으로 거부의 의사표시를 하지 않는 경우 회원이 개정약관에 동의한 것으로 봅니다. 라는 취지를 명확하게 공지하였음에도 회원이 명시적으로 거부의 의사표시를 하지 않은 경우에는 개정약관에 동의한 것으로 봅니다. 회원이 개정약관에 동의하지 않는 경우 당 사이트 이용계약을 해지할 수 있습니다.\n\n제 4 조(약관 외 준칙)\n1. 이 약관은 당 사이트가 제공하는 서비스에 관한 이용안내와 함께 적용됩니다.\n2. 이 약관에 명시되지 아니한 사항은 관계법령의 규정이 적용됩니다.";
  String privateMent = "개인 사생활 ~~~~~~~~~~~~~~~~~~";
  String privateSuggestionMent = "개인 사생활을 제 3자에게 ~~~~~~~";
  String marketingMent = "홍보 및 이벤트 메세지를 ~~~~~~~~~~~~~";
  String anythingMent = "abcdefghijklmnop~~~~~";
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String _messagingTitle = "";
  StreamSubscription iosSubscription;
  @override
  initState() {
    super.initState();

    checkBool();
  }

  checkBool() async {
    setState(() {
      allAgree = true;
      service = true;
      private = true;
      privateSuggestion = true;
      marketing = true;
      anything = true;
    });
  }

  selectAll() async {
    setState(() {
      allAgree = !allAgree;
      print(allAgree);
      print(service);
      if (allAgree == true) {
        private = true;
        service = true;
        privateSuggestion = true;
        marketing = true;
        anything = true;
      } else {
        private = false;
        service = false;
        privateSuggestion = false;
        marketing = false;
        anything = false;
      }
    });
  }

  serviceMethod() async {
    setState(() {
      service = !service;
      if (service == false) allAgree = false;
    });
  }

  privateMethod() async {
    setState(() {
      private = !private;
      if (private == false) allAgree = false;
    });
  }

  privateSuggestionMethod() async {
    setState(() {
      privateSuggestion = !privateSuggestion;
      if (privateSuggestion == false) allAgree = false;
    });
  }

  marketingMethod() async {
    setState(() {
      marketing = !marketing;
      if (marketing == false) allAgree = false;
    });
  }

  anythingMethod() async {
    setState(() {
      anything = !anything;
      if (anything == false) allAgree = false;
    });
  }

  firebaseCloudMessagingListener() async {
    if (Platform.isIOS) {
      _firebaseMessaging.requestNotificationPermissions(
          const IosNotificationSettings(
              sound: true, badge: true, alert: true, provisional: true));

      iosSubscription =
          _firebaseMessaging.onIosSettingsRegistered.listen((data) {
        //_saveDeviceToken();
      });
      _firebaseMessaging
          .requestNotificationPermissions(IosNotificationSettings());
    } else {
      // _firebaseMessaging.getToken().then((token) {
      //   print('token:' + token);
      // });
      //_saveDeviceToken();
    }

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        _messagingTitle = message['notification']['title'].toString();
        if (_messagingTitle.endsWith("null")) {
          _messagingTitle = "";
        }
        showOverlayNotification((context) {
          return MessageNotification(
            title: _messagingTitle,
            message: message['notification']['body'],
            onReply: () {
              OverlaySupportEntry.of(context).dismiss();
              //toast('you checked this message');
            },
          );
        }, duration: Duration(milliseconds: 4000));
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      print("Push Messaging token: $token");
      setState(() {
        prefs.setString("userToken", "$token");

        //_homeScreenText = "Push Messaging token: $token";
      });
    });
  }

  check() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      if (marketing == true) {
        prefs.setString("marketing", "Y");
        firebaseCloudMessagingListener();
      } else {
        prefs.setString("marketing", "N");
        prefs.setString("userToken", '');
      }
    });
    if (allAgree == true ||
        (service == true &&
            private == true &&
            privateSuggestion == true &&
            anything == true)) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (BuildContext context) {
        return new Email();
        //return new Mobil_authen();
      }));
    } else {}
  }

  serviceDetail() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: BoxDecoration(border: Border.all(color: Colors.black)),
            child: SingleChildScrollView(
                child: Card(
                    child: Container(
                        child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 30),
                ),
                Text("${serviceMent}"),
                Padding(
                  padding: EdgeInsets.only(top: 30),
                ),
                FlatButton(
                  child: Text("동의합니다"),
                  onPressed: () {
                    setState(() {
                      service = true;
                    });
                    Navigator.pop(context);
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30),
                ),
              ],
            )))));
      },
    );
  }

  privateDetail() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: BoxDecoration(border: Border.all(color: Colors.black)),
            child: SingleChildScrollView(
                child: Card(
                    child: Container(
                        child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 30),
                ),
                Text("${privateMent}"),
                Padding(
                  padding: EdgeInsets.only(top: 30),
                ),
                FlatButton(
                  child: Text("동의합니다"),
                  onPressed: () {
                    setState(() {
                      private = true;
                    });
                    Navigator.pop(context);
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30),
                ),
              ],
            )))));
      },
    );
  }

  privaateSuggestionDetail() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: BoxDecoration(border: Border.all(color: Colors.black)),
            child: SingleChildScrollView(
                child: Card(
                    child: Container(
                        child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 30),
                ),
                Text("${privateSuggestionMent}"),
                Padding(
                  padding: EdgeInsets.only(top: 30),
                ),
                FlatButton(
                  child: Text("동의합니다"),
                  onPressed: () {
                    setState(() {
                      privateSuggestion = true;
                    });
                    Navigator.pop(context);
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30),
                ),
              ],
            )))));
      },
    );
  }

  anythingDetail() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: BoxDecoration(border: Border.all(color: Colors.black)),
            child: SingleChildScrollView(
                child: Card(
                    child: Container(
                        child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 30),
                ),
                Text("${anythingMent}"),
                Padding(
                  padding: EdgeInsets.only(top: 30),
                ),
                FlatButton(
                  child: Text("동의합니다"),
                  onPressed: () {
                    setState(() {
                      anything = true;
                    });
                    Navigator.pop(context);
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30),
                ),
              ],
            )))));
      },
    );
  }

  marketingDetail() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: BoxDecoration(border: Border.all(color: Colors.black)),
            child: SingleChildScrollView(
                child: Card(
                    child: Container(
                        child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 30),
                ),
                Text("${marketingMent}"),
                Padding(
                  padding: EdgeInsets.only(top: 30),
                ),
                FlatButton(
                  child: Text("동의합니다"),
                  onPressed: () {
                    setState(() {
                      marketing = true;
                    });
                    Navigator.pop(context);
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30),
                ),
              ],
            )))));
      },
    );
  }

  Widget mustService() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.8,
      child: Column(
        children: <Widget>[
          Container(
            child: Divider(
              color: Color.fromRGBO(82, 110, 208, 1.0),
            ),
            padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 0.0),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 14.0),
                child: Text("모든 약관에 동의하십니까"),
              ),
              FlatButton(
                child: Icon(
                  Icons.check,
                  color: allAgree == true ||
                          (service == true &&
                              private == true &&
                              privateSuggestion == true &&
                              marketing == true &&
                              anything == true)
                      ? Colors.grey[800]
                      : Colors.grey[400],
                ),
                onPressed: selectAll,
              ),
            ],
          ),
          Container(
            child: Divider(
              color: Colors.black,
            ),
            padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 0.0),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              InkWell(
                  onTap: serviceDetail,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 14.0),
                    child: Text("서비스 이용약관[필수]  ▼"),
                  )),
              FlatButton(
                child: Icon(
                  Icons.check,
                  color: service == true ? Colors.grey[800] : Colors.grey[400],
                ),
                onPressed: serviceMethod,
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 5, bottom: 5),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              InkWell(
                  onTap: privateDetail,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 14.0),
                    child: Text("개인정보 처리방침[필수]  ▼"),
                  )),
              FlatButton(
                child: Icon(
                  Icons.check,
                  color: private == true ? Colors.grey[800] : Colors.grey[400],
                ),
                onPressed: privateMethod,
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 5, bottom: 5),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              InkWell(
                  onTap: privaateSuggestionDetail,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 14.0),
                    child: Text("개인정보 제3차 제공동의[필수]  ▼"),
                  )),
              FlatButton(
                child: Icon(
                  Icons.check,
                  color: privateSuggestion == true
                      ? Colors.grey[800]
                      : Colors.grey[400],
                ),
                onPressed: privateSuggestionMethod,
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 5, bottom: 5),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              InkWell(
                  onTap: anythingDetail,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 14.0),
                    child: Text("not yet which story goes on[필수]  ▼"),
                  )),
              FlatButton(
                child: Icon(
                  Icons.check,
                  color: anything == true ? Colors.grey[800] : Colors.grey[400],
                ),
                onPressed: anythingMethod,
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 5, bottom: 5),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              InkWell(
                  onTap: marketingDetail,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 14.0),
                    child: Text("마케팅ㆍ홍보 수신 동의[선택]  ▼"),
                  )),
              FlatButton(
                child: Icon(
                  Icons.check,
                  color:
                      marketing == true ? Colors.grey[800] : Colors.grey[400],
                ),
                onPressed: marketingMethod,
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 50),
          ),
          Padding(
              padding: EdgeInsets.only(top: 20),
              child: RaisedButton(
                color: allAgree == true ||
                        (service == true &&
                            private == true &&
                            privateSuggestion == true &&
                            anything == true)
                    ? Colors.grey[400]
                    : Colors.grey[100],
                child: Text("확인"),
                onPressed: check,
              ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Stack(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.65,
            ),
            // ClipPath(
            //   clipper: OvalBottomBorderClipper(),
            //   child: Container(
            //     height: MediaQuery.of(context).size.height / 4 + 40,
            //     color: Colors.white,
            //   ),
            // ),
            Positioned(
              top: -40.0,
              left: -40.0,
              child: Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                    color: Colors.amberAccent, shape: BoxShape.circle),
              ),
            ),
            SingleChildScrollView(
                child: Container(
              child: Column(children: [
                Padding(
                  padding: EdgeInsets.only(top: 6.0, left: 10),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 35.0, top: 50),
                    child: Text(
                      "약관 동의",
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        // color: Hexcolor('#242A37'),
                        fontFamily: "nanumB",
                        fontWeight: FontWeight.w900,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 25.0, bottom: 25),
                ),
                mustService(),
              ]),
            )),
          ],
        ));
  }
}
