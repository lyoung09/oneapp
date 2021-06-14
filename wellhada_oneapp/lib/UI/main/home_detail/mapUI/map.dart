// @dart=2.9
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wellhada_oneapp/UI/main/home_detail/webview.dart';
import 'dart:math' show cos, sqrt, asin;
import 'package:wellhada_oneapp/listitem/shop/shopInfoListItem.dart'
    as shopInfoListItem;
import 'package:slide_popup_dialog/slide_popup_dialog.dart' as slideDialog;
import 'package:wellhada_oneapp/model/map/map_model.dart';
import 'package:wellhada_oneapp/listitem/userFile/userList.dart' as user;
import 'package:wellhada_oneapp/listitem/shop/web.dart' as webLogin;

import '../../bottom_nav.dart';

class GoogleMapUI extends StatefulWidget {
  @override
  _Google1MapUIState createState() => _Google1MapUIState();
}

class _Google1MapUIState extends State<GoogleMapUI>
    with AutomaticKeepAliveClientMixin<GoogleMapUI> {
  var lat;
  var lng;
  var click = false;
  _Google1MapUIState();

  MapModel model = new MapModel();

  @override
  bool get wantKeepAlive {
    return true;
  }

  Uint8List everyIcon, wellhadaIcon;
  Map<String, Uint8List> iconSet = new Map();
  Map<int, Uint8List> wellhadaIconSet = new Map();
  // button click
  String category;
  String webviewDefault = 'http://hndsolution.iptime.org:8086/usermngr';
  // contanier boolean
  bool itemSelected;
  Future _categoryFuture;
  GoogleMapController _controller;
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  LatLng _currentLocation;
  var geoLocator = Geolocator();
  CameraPosition _cameraPosition;
  List<dynamic> shopInfoList = [];
  List shopCategory;
  //googlemap marker icon
  bool favorite = false;
  LatLngBounds latLngBounds;
  Map<int, bool> openShopSeq = new Map();
  Map<int, bool> dayOpenShop = new Map();
  List<Marker> nullMark = [];
  var placeName,
      shopSeq,
      phone,
      distance,
      image,
      beginWeekDate,
      endWeekDate,
      beginWeekendDate,
      endWeekendDate;
  bool opening;
  bool openingDay;
  var userChk, userKey, userId, userPassword;
  @override
  void initState() {
    super.initState();
    //getShowAppBar();
    //_sendLocation();
    category = '18';
    itemSelected = false;
    getShop();
    _categoryFuture = getShopCategory();
    check();
  }

  void check() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        userKey = prefs.getString("userKey");
        userPassword = prefs.getString("userPasswordGoweb");
        userChk = prefs.getString("userChk") ?? "O";

        if (userChk == "01") {
          userChk = "E";
        }
        if (userChk == "00") {
          userChk = "K";
        }
      });
      print('list : ${userChk}');
    } catch (e) {
      print(e);
    }
    // setState(() {
    //   userChk = userData.userCheck;
    // });
    // if (userChk != 'O') userDefault();
  }

  @override
  void didUpdateWidget(Widget oldWidget) {
    super.didUpdateWidget(oldWidget);
    try {
      _currentLocation = Provider.of<LatLng>(context, listen: true);
    } catch (e) {
      print(e);
    }
    getShop();
    _categoryFuture = getShopCategory();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    getShopCategory();
    //_sendLocation();
    getShop();
    super.dispose();
  }

  // void _sendLocation() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();

  //   lat = prefs.getDouble("lat");
  //   lng = prefs.getDouble("lng");

  //   _currentLocation = LatLng(lat, lng);
  //   //_currentLocation = Provider.of<LatLng>(context, listen: true);
  //   //distance(geoPos.latitude, geoPos.longitude);
  // }
  double toDouble(TimeOfDay myTime) {
    return myTime.hour + myTime.minute / 60.0;
  }

  openingShop(startTime, endTime, int shopId) async {
    setState(() {
      DateTime now = DateTime.now();
      var nowTimeofDay = TimeOfDay(hour: now.hour, minute: now.minute);

      double toStart = toDouble(startTime);
      double toNow = toDouble(nowTimeofDay);
      double toEnd = toDouble(endTime);

      if (toStart <= toNow && toNow <= toEnd) {
        print("영업중");
        openShopSeq[shopId] = true;
      } else {
        print("영업 시작 안함");
        openShopSeq[shopId] = false;
      }
    });
  }

  userDataCheck(category, shopSeq) async {
    _handleURLButtonPress(context, '${webviewDefault}/shopTmplatView.do',
        category, shopSeq, userKey, userChk);
  }

  void _handleURLButtonPress(BuildContext context, String url, String placeName,
      int shopSeq, String userKey, String userChk) {
    print(userKey);
    if (userKey == null || userKey == "") {
      showDialog(
          context: context,
          builder: (_) => CupertinoAlertDialog(
                content: Text("로그인 이후 사용해주세요"),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text('확인'),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BottomNav(
                                number: 3,
                              )),
                    ),
                  ),
                ],
              ));
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => WebViewContainer(
                  placeName, shopSeq, userKey, userPassword, userChk, "0")));
    }
    // Navigator.pushNamed(context, '/webview');
  }

  _determinePosition() async {
    bool serviceEnabled;

    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    Position geoPos;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    print(isLocationServiceEnabled);
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    geoPos = await Geolocator.getLastKnownPosition();
    _currentLocation = LatLng(geoPos.latitude, geoPos.longitude);

    _controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: _currentLocation, zoom: 14.4746),
    ));
  }

  Future<Map<String, dynamic>> getShopCategory() async {
    return shopInfoListItem.getShopCodeList();
  }

  var shopId;
  void getShop() async {
    final entireShopList = await shopInfoListItem.getShopListEntire();

    for (int i = 0; i < entireShopList.list.length; i++) {
      wellhadaIcon =
          await getBytesFromCanvas(200, 100, entireShopList.list[i].placeName);
      wellhadaIconSet[entireShopList.list[i].shopSeq] = wellhadaIcon;

      DateTime now = DateTime.now();
      String holiday = "";
      holiday = entireShopList.list[i].holiday;
      List<String> restDay;

      if (holiday != null) {
        restDay = holiday.split(',');

        for (int hold = 0; hold < restDay.length; hold++) {
          if (restDay.elementAt(hold) == now.weekday.toString()) {
            dayOpenShop[entireShopList.list[i].shopSeq] = false;
          }
          // print('out ${now.weekday}');
          // print('out ${restDay.elementAt(hold)}');
          else {
            dayOpenShop[entireShopList.list[i].shopSeq] = true;
          }
        }
      }

      String startHour, startMin, endHour, endMin;
      TimeOfDay startTime, endTime;
      if (now.weekday == 6 || now.weekday == 7) {
        startHour = entireShopList.list[i].weekBeginTime.substring(0, 2);
        startMin = entireShopList.list[i].weekBeginTime.substring(2, 4);
        endHour = entireShopList.list[i].weekEndTime.substring(0, 2);
        endMin = entireShopList.list[i].weekEndTime.substring(2, 4);

        startTime =
            TimeOfDay(hour: int.parse(startHour), minute: int.parse(startMin));
        endTime =
            TimeOfDay(hour: int.parse(endHour), minute: int.parse(endMin));
      } else {
        startHour = entireShopList.list[i].bsnBeginTime.substring(0, 2);
        startMin = entireShopList.list[i].bsnBeginTime.substring(2, 4);
        endHour = entireShopList.list[i].bsnEndTime.substring(0, 2);
        endMin = entireShopList.list[i].bsnEndTime.substring(2, 4);

        startTime =
            TimeOfDay(hour: int.parse(startHour), minute: int.parse(startMin));
        endTime =
            TimeOfDay(hour: int.parse(endHour), minute: int.parse(endMin));
      }
      shopId = entireShopList.list[i].shopSeq;
      openingShop(startTime, endTime, shopId);
    }

    setState(() {
      shopInfoList = entireShopList.list;
    });
  }

  Future<Uint8List> getBytesFromCanvas(
      int width, int height, String title) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color = Colors.grey[400];
    final Radius radius = Radius.circular(20.0);
    final radiusPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..color = Colors.indigo;
    canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(0.0, 0.0, width.toDouble(), height.toDouble()),
          topLeft: radius,
          topRight: radius,
          bottomLeft: radius,
          bottomRight: radius,
        ),
        paint);

    TextPainter painter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
    );

    painter.text = TextSpan(
      text: title.length > 6 ? "${title.substring(0, 6)}..." : "${title}",
      style: TextStyle(fontSize: 25.0, color: Colors.black),
    );
    painter.layout();
    painter.paint(
        canvas,
        Offset((width * 0.5) - painter.width * 0.5,
            (height * 0.5) - painter.height * 0.5));
    final img = await pictureRecorder.endRecording().toImage(width, height);
    final data = await img.toByteData(format: ui.ImageByteFormat.png);
    return data.buffer.asUint8List();
  }

  Future<ui.Image> getImage(String path) async {
    Completer<ImageInfo> completer = Completer();
    var img = new NetworkImage(path);
    img.resolve(ImageConfiguration()).addListener(
      ImageStreamListener(
        (ImageInfo info, bool _) {
          completer.complete(info);
        },
      ),
    );
    ImageInfo imageInfo = await completer.future;
    return imageInfo.image;
  }

  Widget _list(List<dynamic> shopCategoryList) {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: shopCategoryList == null ? 0 : shopCategoryList.length,
        itemBuilder: (context, position) {
          return Container(
            alignment: Alignment.topCenter,
            child: ClipOval(
              child: Material(
                color: Colors.white, // button color
                child: Container(
                  decoration:
                      category == shopCategoryList[position]['CATEGORY_CD']
                          ? new BoxDecoration(
                              shape: BoxShape.circle,
                              border: new Border.all(
                                color: Colors.indigo,
                                width: 3.0,
                              ),
                            )
                          : new BoxDecoration(
                              shape: BoxShape.circle,
                              border: new Border.all(
                                color: Colors.indigo,
                                width: 1.0,
                              ),
                            ),
                  child: InkWell(
                      child: SizedBox(
                        width: 75,
                        height: 55,
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 4.0, bottom: 1.0),
                            ),
                            Image.network(
                              'http://hndsolution.iptime.org:8086/${shopCategoryList[position]['IMG_URL']}',
                              width: 25,
                              height: 25,
                              fit: BoxFit.fitWidth,
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 1.0),
                            ),
                            Text(
                              shopCategoryList[position]['CATEGORY_CDNM'],
                              style: TextStyle(fontSize: 11),
                            )
                          ],
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          category = shopCategoryList[position]['CATEGORY_CD'];
                        });
                      }),
                ),
              ),
            ),
          );
        });
  }

  void _shopDetail(
      String distance,
      String pic,
      String placeName,
      String shopDc,
      String beginWeek,
      String endWeek,
      String beginWeekend,
      String endWeekend,
      int shopSeq) {
    var a = '${beginWeek.substring(0, 2)}시 ${beginWeek.substring(2, 4)}분 ';
    var b = ' ${endWeek.substring(0, 2)}시 ${endWeek.substring(2, 4)}분';
    var c =
        '${beginWeekend.substring(0, 2)}시 ${beginWeekend.substring(2, 4)}분 ';
    var d = ' ${endWeekend.substring(0, 2)}시 ${endWeekend.substring(2, 4)}분';

    showDialog(
        context: context,
        builder: (_) => Dialog(
                child: Container(
              height: MediaQuery.of(context).size.height * 0.5,
              decoration: BoxDecoration(
                  //color: Colors.redAccent,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.02),
                  ),
                  Text(
                    placeName.length > 14
                        ? "${placeName.substring(0, 14)}"
                        : "${placeName}",
                    style: TextStyle(
                      fontFamily: "nanumB",
                      fontWeight: FontWeight.w900,
                      fontSize: 21.0,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 15),
                  ),
                  Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12, bottom: 3),
                        child: Text(
                          distance.length > 3
                              ? '거리 : ${(int.parse(distance) * 0.001).toStringAsFixed(1)}km'
                              : '거리 : ${distance}m',
                          style: TextStyle(
                            fontFamily: "nanumB",
                            fontWeight: FontWeight.w700,
                            fontSize: 15.0,
                          ),
                        ),
                      )),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                      child: Image.network(
                        'http://hndsolution.iptime.org:8086${pic}',
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.height * 0.25,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12))),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                  ),
                  Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Text(
                          '평일 : ${a + b}',
                          style: TextStyle(
                            fontFamily: "nanumR",
                            fontWeight: FontWeight.w600,
                            fontSize: 11.0,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      )),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                  ),
                  Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Text(
                          '주말 : ${c + d}',
                          style: TextStyle(
                            fontFamily: "nanumR",
                            fontWeight: FontWeight.w600,
                            fontSize: 11.0,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      )),
                  Spacer(),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Align(
                          alignment: Alignment.bottomCenter,
                          child: OutlineButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3)),
                            borderSide: BorderSide(
                              color: Colors.black, //Color of the border
                              style: BorderStyle.solid, //Style of the border
                              width: 0.5, //width of the border
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('취소'),
                            textColor: Colors.black,
                            color: Colors.white,
                          )),
                      SizedBox(
                        width: 15,
                      ),
                      Align(
                          alignment: Alignment.bottomCenter,
                          child: OutlineButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3)),
                            borderSide: BorderSide(
                              color: Colors.black, //Color of the border
                              style: BorderStyle.solid, //Style of the border
                              width: 0.5, //width of the border
                            ),
                            onPressed: () {
                              userDataCheck(placeName, shopSeq);
                            },
                            child: Text('주문'),
                            color: Colors.white,
                            textColor: Colors.black,
                          ))
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 1.5),
                  ),
                ],
              ),
            )));
  }

  void _showShopListDialog(
      String distance,
      String pic,
      String placeName,
      String shopDc,
      String beginWeek,
      String endWeek,
      String beginWeekend,
      String endWeekend,
      int shopSeq) {
    var a = '${beginWeek.substring(0, 2)}시 ${beginWeek.substring(2, 4)}분';
    var b = ' ${endWeek.substring(0, 2)}시 ${endWeek.substring(2, 4)}분';
    var c = '${beginWeekend.substring(0, 2)}시 ${beginWeekend.substring(2, 4)}분';
    var d = ' ${endWeekend.substring(0, 2)}시 ${endWeekend.substring(2, 4)}분';

    slideDialog.showSlideDialog(
      context: context,
      child: Expanded(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      userDataCheck(placeName, shopSeq);
                    });
                  },
                  child: Column(
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Spacer(),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 10.0, right: 5),
                              child: Text(
                                "평일:",
                                style: TextStyle(
                                  fontFamily: "nanumB",
                                  fontWeight: FontWeight.w900,
                                  fontSize: 13.0,
                                ),
                              ),
                            ),
                          ),
                          Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding:
                                    EdgeInsets.only(bottom: 10.0, right: 5),
                                child: Text(
                                  a + b,
                                  style: TextStyle(
                                    fontFamily: "nanumR",
                                    fontWeight: FontWeight.w600,
                                    fontSize: 11.0,
                                  ),
                                ),
                              )),
                          Padding(
                            padding: EdgeInsets.only(right: 5),
                          )
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Spacer(),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 10.0, right: 5),
                              child: Text(
                                "주말:",
                                style: TextStyle(
                                  fontFamily: "nanumB",
                                  fontWeight: FontWeight.w900,
                                  fontSize: 13.0,
                                ),
                              ),
                            ),
                          ),
                          Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding:
                                    EdgeInsets.only(bottom: 10.0, right: 5),
                                child: Text(
                                  c + d,
                                  style: TextStyle(
                                    fontFamily: "nanumR",
                                    fontWeight: FontWeight.w600,
                                    fontSize: 11.0,
                                  ),
                                ),
                              )),
                          Padding(
                            padding: EdgeInsets.only(right: 5),
                          )
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 20.0, bottom: 5.0),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Padding(
                              padding: EdgeInsets.only(left: 15),
                              child: Text(
                                '${placeName}',
                                style: TextStyle(
                                  fontFamily: "nanumB",
                                  fontWeight: FontWeight.w900,
                                  fontSize: 26.0,
                                ),
                              )),
                          Spacer(),
                          Padding(
                            padding: EdgeInsets.only(right: 18),
                            child: Text(
                              distance.length > 3
                                  ? '${(int.parse(distance) * 0.001).toStringAsFixed(1)}km'
                                  : '${distance}m',
                              // '${distance}m',
                              style: TextStyle(
                                fontFamily: "nanumB",
                                fontWeight: FontWeight.w700,
                                fontSize: 17.5,
                              ),
                            ),
                          )
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 12.0, bottom: 10.0),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(left: 5.0, right: 5),
                          child: Container(
                            padding: EdgeInsets.only(top: 5),
                            // decoration: BoxDecoration(border: Border.all()),
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: MediaQuery.of(context).size.height * 0.3,
                            child: Image.network(
                              'http://hndsolution.iptime.org:8086${pic}',
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: MediaQuery.of(context).size.height * 0.3,
                              fit: BoxFit.fitWidth,
                            ),
                          )),

                      Container(
                        padding: EdgeInsets.only(left: 20.0, bottom: 10.0),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 15, top: 15),
                          ),
                          Padding(
                              padding: EdgeInsets.only(left: 8),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                child: Text(
                                  shopDc,
                                  //'11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111',
                                  maxLines: 5,
                                  style: TextStyle(
                                    fontFamily: "nanumR",
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                  ),
                                ),
                              )),
                        ],
                      ),
                      // Padding(
                      //     padding: EdgeInsets.only(bottom: 15, left: 15),
                      //     child: Align(
                      //       alignment: Alignment.bottomRight,
                      //       child: FlatButton(
                      //         color: Colors.black,
                      //         onPressed: () {
                      //           Navigator.of(context).pop();
                      //         },
                      //         child: Text('확인',
                      //             style: TextStyle(
                      //               fontFamily: "nanumR",
                      //               fontSize: 13,
                      //               fontWeight: FontWeight.w900,
                      //             )),
                      //         textColor: Colors.black,
                      //       ),
                      //     )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierColor: Colors.white.withOpacity(0.7),
      pillColor: Colors.amberAccent,
      backgroundColor: Colors.white,
    );
  }

  String _coordinateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;

    return ((12742 * asin(sqrt(a)) * 1000)).toStringAsFixed(0);
  }

  List<Marker> selectWellhadaMarker() {
    try {
      getCenter().then((result) {
        setState(() {
          latLngBounds = result;
        });
      }).catchError((error) {
        print(error);
      });

      return shopInfoList
          .where((element) =>
              element.categoryGroupCode == category &&
              latLngBounds.northeast.latitude > element.latitude &&
              latLngBounds.northeast.longitude > element.longtitude &&
              latLngBounds.southwest.latitude < element.latitude &&
              latLngBounds.southwest.longitude < element.longtitude)
          .map((element) {
        print(" ${shopId} :${openShopSeq[shopId]}");
        print(" ${shopId} :${dayOpenShop[shopId]}");
        return openShopSeq[element.shopSeq] == true &&
                dayOpenShop[element.shopSeq] == true
            ? Marker(
                markerId: MarkerId(element.shopSeq.toString()),
                position: LatLng(element.latitude, element.longtitude),
                icon: BitmapDescriptor.fromBytes(
                    wellhadaIconSet[element.shopSeq]),
                //wellhadaIconSet[element['id']
                onTap: () {
                  setState(() {
                    //itemSelected = true;

                    distance = _coordinateDistance(
                        _currentLocation.latitude,
                        _currentLocation.longitude,
                        element.latitude,
                        element.longtitude);

                    // _showShopListDialog(
                    //   distance,
                    //   element.fileUrl,
                    //   element.placeName,
                    //   element.shopDc,
                    //   element.bsnBeginTime,
                    //   element.bsnEndTime,
                    //   element.weekBeginTime,
                    //   element.weekEndTime,
                    //   element.shopSeq,
                    // );
                    _shopDetail(
                      distance,
                      element.fileUrl,
                      element.placeName,
                      element.shopDc,
                      element.bsnBeginTime,
                      element.bsnEndTime,
                      element.weekBeginTime,
                      element.weekEndTime,
                      element.shopSeq,
                    );
                  });
                })
            : Marker(
                markerId: MarkerId(element.shopSeq.toString()),
                position: LatLng(element.latitude, element.longtitude),
                icon: BitmapDescriptor.fromBytes(
                    wellhadaIconSet[element.shopSeq]),
                //wellhadaIconSet[element['id']
                onTap: () {
                  setState(() {
                    //itemSelected = true;

                    showDialog(
                        context: context,
                        builder: (_) => CupertinoAlertDialog(
                              content: Text("영업 시간이 아닙니다"),
                              actions: <Widget>[
                                CupertinoDialogAction(
                                  child: Text('확인'),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                              ],
                            ));
                  });
                });
      }).toList();
    } catch (e) {
      return nullMark;
    }
  }

  Future<LatLngBounds> getCenter() async {
    LatLngBounds bounds;
    try {
      bounds = await _controller.getVisibleRegion();

      return bounds;
    } catch (e) {
      print(e);
      return null;
    }
    // print(center);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: FutureBuilder(
          future: _categoryFuture,
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Text("");
            }

            Map<String, dynamic> shopCategory = snapshot.data;
            List<dynamic> shopCategoryList = shopCategory["LIST"];

            List<Marker> changeWellhadaMark = selectWellhadaMarker();

            // List<Marker> changeMark = selectMarker(shopInfoList);

            return Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(top: 8.0),
                  child: _list(shopCategoryList),

                  //),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 2.0),
                ),
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        //height: MediaQuery.of(context).size.height * 0.5,
                        child: _currentLocation == null
                            ? CupertinoAlertDialog()
                            : GoogleMap(
                                initialCameraPosition: CameraPosition(
                                  target: _currentLocation,
                                  zoom: 14.4746,
                                ),
                                rotateGesturesEnabled: false,
                                tiltGesturesEnabled: false,
                                markers: Set.from(changeWellhadaMark),
                                myLocationEnabled: true,
                                onMapCreated: (GoogleMapController controller) {
                                  _controller = controller;
                                  if (_controller != null && controller != null)
                                    getCenter();
                                },
                                onCameraMove: (position) {
                                  getCenter();
                                },
                              ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: FloatingActionButton(
                          onPressed: _determinePosition,
                          child: Icon(
                            Icons.location_on,
                            color: Colors.yellow,
                          ),
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    ]);
  }
}
