// @dart=2.9
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
import 'package:wellhada_oneapp/listitem/userFile/userList.dart' as user;

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
  String userToken;
  @override
  initState() {
    super.initState();

    check();
  }

  check() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      userKey = prefs.getString("userKey");
      certain = prefs.getString("marketing");
      userToken = prefs.getString("userToken");
      if (certain == "Y")
        _switchValue = true;
      else
        _switchValue = false;
    });
  }

  var name, phone, birthday, gender, profile, userKey, password;
  sendYN() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final userData = await user.getUserInfomation(userKey);
    setState(() {
      var x;
      if (_switchValue == true) {
        x = "Y";
      } else {
        x = "N";
      }
      password = prefs.getString("userPasswordGoweb");
      name = userData.userName;

      prefs.setString("marketing", x);
      phone = userData.userPhoneNumber;
      birthday = userData.birthday;
      gender = userData.gender;
      profile = userData.kakaoProfil;
      userToken = userData.userToken;
    });
    final updateMarketing = await user.updateUser(
        userKey,
        password,
        phone == null ? "" : phone,
        name == null ? "" : name,
        gender == null ? "" : gender,
        birthday == null ? "" : birthday,
        prefs.getString("marketing"),
        profile == null ? "" : profile,
        userKey,
        userToken);

    setState(() {
      print('update =================${updateMarketing.status}');
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
