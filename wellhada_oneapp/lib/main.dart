// @dart=2.9
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:async/async.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:wellhada_oneapp/UI/intro.dart';
import 'package:wellhada_oneapp/UI/main/bottom_detail/private_info.dart';
import 'package:wellhada_oneapp/UI/main/bottom_nav.dart';
import 'dart:io';
import 'package:uuid/uuid.dart';

import 'package:geolocator/geolocator.dart';
import 'UI/main/bottom_detail/home_screen.dart';
import 'UI/privateInfo_detail/email_login/lastSelector.dart';
import 'UI/privateInfo_detail/login.dart';

import 'UI/privateInfo_detail/user/updateUser.dart';
import 'notification/custom_notification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    KakaoContext.clientId = "be0c4a7d667d7766083ba8dcdf6048df";
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
          '/main': (context) => HomeScreen(),
          '/last_selection': (context) => LastSelection(),
          '/login': (context) => LOGIN(),
          '/private_info': (context) => PriavateInfo(),
          '/BottomNav': (context) => BottomNav(),
          '/userUpdate': (context) => UserUpdate(),
          '/Introduce': (context) => Introduce(),
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
  //final FirebaseAuth fAuth = FirebaseAuth.instance;
  final AsyncMemoizer _memoizer = AsyncMemoizer();
  var appFontColor = "#000000";
  SharedPreferences prefs;
  var userDevice;
  var appStatus;
  LatLng _currentLocation;

  @override
  void initState() {
    super.initState();

    _getCurrentLocation();
  }

  _getCurrentLocation() async {
    Position geoPos;

    try {
      geoPos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);

      prefs.setDouble("lat", geoPos.latitude);
      prefs.setDouble("lng", geoPos.longitude);
    } catch (e, stackTrace) {
      print(stackTrace);
      prefs.setDouble("lat", 37.49152820899407);
      prefs.setDouble("lng", 127.07285755753348);
    }

    _checkForCameraPermission();
  }

  _checkForCameraPermission() async {
    var cameraPermission = await Permission.camera.status;
    print("camera permissions is $cameraPermission");
    final permissionStatus = await Permission.camera.request();

    if (permissionStatus == PermissionStatus.granted) {
      startTime();
    } else {
      startTime();
    }
  }

//37.49152820899407, 127.07285755753348 대모산
//37.4835543,126.8930976 hnd
//37.49130687785801, 127.07144135121183 대모산주변병원
  @override
  void dispose() {
    super.dispose();
  }

  Future<Position> getPositon() async {
    Position geoPos;
    try {
      geoPos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);
    } catch (e) {
      geoPos = await Geolocator.getLastKnownPosition();
      print(e.toString());
    }

    return geoPos;
  }

  startTime() async {
    return new Timer(Duration(milliseconds: 200), () {
      checkFirstSeen();
    });
  }

  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);

    bool _login = (prefs.getBool('login') ?? false);

    if (_seen) {
      if (_login)
        Navigator.pushNamed(context, '/BottomNav');
      else
        Navigator.pushNamed(context, '/login');
    } else {
      prefs.setBool('seen', true);
      Navigator.pushNamed(context, '/Introduce');
    }
  }

  void goMain() {
    Navigator.pushNamed(context, '/Introduce');
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
      resizeToAvoidBottomInset: false,
      body: FutureBuilder(
          future: _function(),
          builder: (context, snapshot) {
            return Stack(
              children: <Widget>[
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                          child: Image.asset(
                        "assets/icon/intro_dosis.png",
                        //width: size.width * 0.9,
                      )),
                      // Padding(
                      //   padding: EdgeInsets.only(bottom: 20),
                      //   child: Align(
                      //     alignment: Alignment.bottomCenter,
                      //     child: Text(
                      //       'HndSolution',
                      //       style: TextStyle(
                      //         fontFamily: 'nanumB',
                      //         fontWeight: FontWeight.w900,
                      //         fontSize: 20.0,
                      //         color: Hexcolor('${appFontColor}'),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }
}
