import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(PushMessage());

class PushMessage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PushMessageState();
  }
}

class _PushMessageState extends State<PushMessage> {
  String _message = '';

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  FirebaseMessaging _fcm = FirebaseMessaging();

  _register() {
    _firebaseMessaging.getToken().then((token) => print(token));
  }

  @override
  void initState() {
    // TODO: implement initState
    sendNotification();
    super.initState();
    getMessage();
  }

  var postUrl = "https://fcm.googleapis.com/fcm/send";

  Future<void> sendNotification() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token;
    setState(() {
      token = prefs.getString("userToken");
    });
    //var token = await getToken(receiver);

    final data = {
      "notification": {"body": "잠시만 기다려 주세요", "title": "주문 접수 되었습니다"},
      "priority": "high",
      "to": "$token"
    };

    final headers = {
      'content-type': 'application/json',
      'Authorization':
          'key=AAAAus5Q41I:APA91bEO9OtQqgBMP2bs8Ibmb3_-c2tJ3IB8uVTFAqOAVrUjF6QbNjFJUEs41Sz3EFs8QWGDK2icg2pZH6Pwi2VP7hZXVHQ3rosflgMfmcJyPiSfjyjF7ElmTTwnKjjsl5Ks7ApKP5-c'
    };

    BaseOptions options = new BaseOptions(
      connectTimeout: 5000,
      receiveTimeout: 3000,
      headers: headers,
    );

    try {
      final response = await Dio(options).post(postUrl, data: data);

      if (response.statusCode == 200) {
      } else {
        print('notification sending failed');
        // on failure do sth
      }
    } catch (e) {
      print('exception $e');
    }
  }

  late StreamSubscription iosSubscription;
  void getMessage() {
    if (Platform.isIOS) {
      iosSubscription = _fcm.onIosSettingsRegistered.listen((data) {
        // save the token  OR subscribe to a topic here
      });

      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(message['notification']['title']),
              subtitle: Text(message['notification']['body']),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        // TODO optional
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        // TODO optional
      },
    );
    // _firebaseMessaging.configure(
    //     onMessage: (Map<String, dynamic> message) async {
    //   print('on message $message');
    //   setState(() {
    //     _message = message["notification"]["title"];
    //   });
    // }, onResume: (Map<String, dynamic> message) async {
    //   print('on resume $message');
    //   setState(() => _message = message["notification"]["title"]);
    // }, onLaunch: (Map<String, dynamic> message) async {
    //   print('on launch $message');
    //   setState(() => _message = message["notification"]["title"]);
    // });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Message: $_message"),
                OutlineButton(
                  child: Text("Register My Device"),
                  onPressed: () {
                    _register();
                  },
                ),
                // Text("Message: $message")
              ]),
        ),
      ),
    );
  }
}
