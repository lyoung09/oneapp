import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wellhada_oneapp/notification/custom_notification.dart';

class Notify extends StatefulWidget {
  @override
  _NotifyState createState() => _NotifyState();
}

class _NotifyState extends State<Notify> {
  bool _switchValue;
  var certain;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String _messagingTitle = "";
  StreamSubscription iosSubscription;

  @override
  initState() {
    super.initState();

    check();
  }

  check() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      certain = prefs.getString("marketing");
      if (certain == "Y")
        _switchValue = true;
      else
        _switchValue = false;
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

  sendYN() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      var x;
      if (_switchValue == true) {
        x = "Y";
        firebaseCloudMessagingListener();
      } else {
        x = "N";
        prefs.setString("userToken", '');
      }
      prefs.setString("marketing", x);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _switchValue == null ? Text("") : notify());
  }

  Widget notify() {
    return ListView(
      children: <Widget>[
        Stack(children: <Widget>[
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
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(top: 45, left: 25),
              child: Container(
                child: Text("알람 설정"),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 180),
            child: Container(
                color: Colors.white70,
                child: Column(children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 14),
                      child: Text(
                        '알람 설정',
                      ),
                    ),
                  ),
                  Container(
                    child: Divider(
                      color: Color.fromRGBO(82, 110, 208, 1.0),
                    ),
                    padding:
                        EdgeInsets.only(left: 20.0, right: 20.0, bottom: 0.0),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 20),
                      ),
                      Text(
                        "홍보 및 알림 설정  ",
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                      Spacer(),
                      Container(
                        child: CupertinoSwitch(
                          activeColor: Hexcolor('#FFD428'),
                          value: _switchValue,
                          onChanged: (value) {
                            setState(() {
                              _switchValue = value;
                            });
                            sendYN();
                            _switchValue == true
                                ? Text("")
                                : showDialog(
                                    context: context,
                                    builder: (_) => CupertinoAlertDialog(
                                          content: Text(' 아쉬워요 ㅠㅠ'),
                                        ));
                          },
                        ),
                      ),
                    ],
                  ),
                  Container(
                    child: Divider(
                      color: Color.fromRGBO(82, 110, 208, 1.0),
                    ),
                    padding:
                        EdgeInsets.only(left: 20.0, right: 20.0, bottom: 0.0),
                  ),
                ])),
          )
        ]),
      ],
    );
  }
}
