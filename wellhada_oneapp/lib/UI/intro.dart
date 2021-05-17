import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wellhada_oneapp/notification/custom_notification.dart';

class Introduce extends StatefulWidget {
  @override
  _IntroduceState createState() => _IntroduceState();
}

class _IntroduceState extends State<Introduce> {
  var index;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String _messagingTitle = "";
  StreamSubscription iosSubscription;
  initState() {
    super.initState();
    index = 0;
    firebaseCloudMessagingListener();
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

  dispose() {
    super.dispose();
    checkIndex();
  }

  checkIndex() async {
    index = 0;
    setState(() {
      index++;
    });
    print(index);
  }

  goStart() {
    Navigator.pushNamed(context, '/BottomNav');
  }

  goBack() async {
    setState(() {
      index = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {},
      child: Scaffold(
          body: Stack(
        children: <Widget>[
          index == 0 ? _firstIntroduce() : _secondIntroduce(),

          // Align(
          //   alignment: Alignment.bottomCenter,
          //   child: FloatingActionButton(
          //     onPressed: () {},
          //     heroTag: "btn2",
          //     child: Text(''),
          //   ),
          // ),
        ],
      )),
    );
  }

  Widget _firstIntroduce() {
    return Container(
        padding: EdgeInsets.fromLTRB(10, 30, 10, 10),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        color: Colors.black,
        child: Card(
            elevation: 5,
            child: Padding(
                padding: EdgeInsets.all(7),
                child: Stack(children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: MediaQuery.of(context).size.height * 0.8,
                        ),
                        // ClipPath(
                        //   clipper: OvalBottomBorderClipper(),
                        //   child: Container(
                        //     height: MediaQuery.of(context).size.height / 4 + 40,
                        //     color: Colors.white,
                        //   ),
                        // ),
                        Positioned(
                          top: -20.0,
                          left: -40.0,
                          child: Container(
                            height: 150,
                            width: 150,
                            decoration: BoxDecoration(
                                color: Colors.amberAccent,
                                shape: BoxShape.circle),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          verticalDirection: VerticalDirection.down,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 30, bottom: 30),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '어서오세요',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 30.0),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Container(
                                  child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: <Widget>[
                                    Text("#STORY",
                                        style: TextStyle(fontSize: 27)),
                                    Text("를 사용하여",
                                        style: TextStyle(fontSize: 13)),
                                  ],
                                ),
                              )),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                '빠르고 싸게 물건을 구하세요!',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 15.0),
                              ),
                            ),
                          ],
                        ),

                        Padding(
                          padding: EdgeInsets.all(40),
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: InkWell(
                              onTap: checkIndex,
                              child: Icon(Icons.arrow_forward_ios_outlined),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ]))));
  }

  Widget _secondIntroduce() {
    return Container(
        padding: EdgeInsets.fromLTRB(10, 30, 10, 10),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        color: Colors.black,
        child: Card(
            elevation: 5,
            child: Padding(
                padding: EdgeInsets.all(7),
                child: Stack(children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                        ),
                        // ClipPath(
                        //   clipper: OvalBottomBorderClipper(),
                        //   child: Container(
                        //     height: MediaQuery.of(context).size.height / 4 + 40,
                        //     color: Colors.white,
                        //   ),
                        // ),
                        Positioned(
                          top: -20.0,
                          left: -40.0,
                          child: Container(
                            height: 150,
                            width: 150,
                            decoration: BoxDecoration(
                                color: Colors.amberAccent,
                                shape: BoxShape.circle),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          verticalDirection: VerticalDirection.down,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 30, bottom: 30),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '저희 가맹점들은',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 30.0),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Container(
                                  child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: <Widget>[
                                    Text("#STORY",
                                        style: TextStyle(fontSize: 27)),
                                    Text("를 사용하여",
                                        style: TextStyle(fontSize: 13)),
                                  ],
                                ),
                              )),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                '너네를 편하게 해준답니다!',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 15.0),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.all(40),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: InkWell(
                              onTap: goBack,
                              child: Icon(Icons.arrow_back_ios_outlined),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(40),
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: InkWell(
                              onTap: goStart,
                              child: Text(
                                "시작하기",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w900),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ]))));
  }
}
