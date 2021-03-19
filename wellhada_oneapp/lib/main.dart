import 'dart:async';

import 'package:async/async.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:wellhada_oneapp/UI/login/login.dart';
import 'package:wellhada_oneapp/UI/main/bottom_detail/private_info.dart';
import 'package:wellhada_oneapp/UI/main/bottom_nav.dart';

import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:wellhada_oneapp/UI/main/main_screen.dart';
import 'package:wellhada_oneapp/UI/main/map_scene.dart';
import 'package:wellhada_oneapp/model/map/my_location.dart';
import 'UI/login/email_login/email_complete.dart';
import 'package:geolocator/geolocator.dart';

import 'UI/login/mobile_authen/certification.dart';
import 'UI/login/mobile_authen/certification_result.dart';
import 'notification/custom_notification.dart';

void main() {
  KakaoContext.clientId = "be0c4a7d667d7766083ba8dcdf6048df";

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return OverlaySupport(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'wellhada Client',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MyHomePage(title: 'wellhada Client'),
        routes: {
          '/main': (context) => MainScreen(),
          '/map': (context) => MapScreen(),
          '/Email_complete': (context) => Email_complete(),
          '/certification': (context) => Certification(),
          '/certification-result': (context) => CertificationResult(),
          '/login': (context) => LOGIN(),
          '/private_info': (context) => PriavateInfo(),
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  //final FirebaseAuth fAuth = FirebaseAuth.instance;
  final AsyncMemoizer _memoizer = AsyncMemoizer();
  StreamSubscription iosSubscription;
  String _messagingTitle = "";
  var appFontColor = "#000000";
  SharedPreferences prefs;
  var userDevice;
  var appStatus;
  MyMapModel myMapModel = new MyMapModel();
  @override
  void initState() {
    super.initState();

    startTime();
    // if (Platform.isIOS) {
    //   iosSubscription =
    //       _firebaseMessaging.onIosSettingsRegistered.listen((data) {
    //     //_saveDeviceToken();
    //   });
    //   _firebaseMessaging
    //       .requestNotificationPermissions(IosNotificationSettings());
    // } else {
    //   //_saveDeviceToken();
    // }
    // _firebaseMessaging.configure(
    //   onMessage: (Map<String, dynamic> message) async {
    //     _messagingTitle = message['notification']['title'].toString();
    //     if (_messagingTitle.endsWith("null")) {
    //       _messagingTitle = "";
    //     }
    //     showOverlayNotification((context) {
    //       return MessageNotification(
    //         title: _messagingTitle,
    //         message: message['notification']['body'],
    //         onReply: () {
    //           OverlaySupportEntry.of(context).dismiss();
    //           //toast('you checked this message');
    //         },
    //       );
    //     }, duration: Duration(milliseconds: 4000));
    //   },
    //   onLaunch: (Map<String, dynamic> message) async {
    //     print("onLaunch: $message");
    //   },
    //   onResume: (Map<String, dynamic> message) async {
    //     print("onResume: $message");
    //   },
    // );
    // _firebaseMessaging.requestNotificationPermissions(
    //     const IosNotificationSettings(sound: true, badge: true, alert: true));
    // _firebaseMessaging.onIosSettingsRegistered
    //     .listen((IosNotificationSettings settings) {
    //   print("Settings registered: $settings");
    // });
    // _firebaseMessaging.getToken().then((String token) {
    //   assert(token != null);
    //   print("Push Messaging token: $token");
    //   setState(() async {
    //     SharedPreferences prefs;
    //     prefs = await SharedPreferences.getInstance();
    //     prefs.setString("appPushToken", "$token");
    //   });
    // });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<Position> getPositon() async {
    Position geoPos;
    try {
      geoPos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);
    } catch (e, stackTrace) {
      geoPos = await Geolocator.getLastKnownPosition();
      print(e.toString());
    }
    print(geoPos.latitude);
    print(geoPos.longitude);

    return geoPos;
  }

  startTime() async {
    return new Timer(Duration(milliseconds: 200), goMain);
  }

  void goMain() {
    Navigator.of(context).pushReplacement(
        (PageRouteBuilder(pageBuilder: (_, __, ___) => BottomNav())));
  }

  _function() async {
    return this._memoizer.runOnce(() async {
      prefs = await SharedPreferences.getInstance();
      var uuid = new Uuid();

      setState(() {
        if (prefs.getString("userUuid") == "" ||
            prefs.getString("userUuid") == null) {
          prefs.setString("userUuid", uuid.v4());
        }

        if (Platform.isIOS) {
          prefs.setString("userDevice", "IOS");
        } else if (Platform.isAndroid) {
          prefs.setString("userDevice", "Android");
        }
        userDevice = prefs.getString("userDevice");
      });

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: FutureBuilder(
          future: _function(),
          builder: (context, snapshot) {
            return Stack(
              children: <Widget>[
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: size.height / 4),
                      ),
                      Text(
                        '#스토리',
                        style: TextStyle(
                          fontFamily: 'Godo',
                          fontWeight: FontWeight.w900,
                          fontSize: 40.0,
                          color: Hexcolor('${appFontColor}'),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: size.height / 2),
                      ),
                      Text(
                        'hndSolution',
                        style: TextStyle(
                          fontFamily: 'Godo',
                          fontWeight: FontWeight.w900,
                          fontSize: 20.0,
                          color: Hexcolor('${appFontColor}'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }
}
