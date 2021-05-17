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
  String webviewDefault = 'http://192.168.0.47:8080/usermngr';
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
  @override
  void initState() {
    super.initState();
    //getShowAppBar();
    //_sendLocation();
    category = '18';
    itemSelected = false;
    getShop();
    _categoryFuture = getShopCategory();
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
  openingShop(startTime, endTime) async {
    setState(() {
      DateTime now = DateTime.now();

      if (startTime.hour < now.hour && now.hour < endTime.hour) {
        if (startTime.minute < now.minute && now.minute < endTime.minute) {
          opening = true;
        }
      }
      opening = false;
    });
  }

  void _handleURLButtonPress(
      BuildContext context, String url, String placeName) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WebViewContainer(url, placeName)));

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

  void getShop() async {
    final entireShopList = await shopInfoListItem.getShopListEntire();

    for (int i = 0; i < entireShopList.list.length; i++) {
      wellhadaIcon =
          await getBytesFromCanvas(200, 100, entireShopList.list[i].placeName);
      wellhadaIconSet[entireShopList.list[i].shopSeq] = wellhadaIcon;

      DateTime now = DateTime.now();

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
      openingShop(startTime, endTime);
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
                            Image(
                              image: AssetImage('assets/img/cafe.png'),
                              width: 25,
                              height: 25,
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

  void _showShopListDialog(
      String distance,
      String pic,
      String placeName,
      String shopDc,
      String beginWeek,
      String endWeek,
      String beginWeekend,
      String endWeekend) {
    var a = '${beginWeek.substring(0, 2)}시 ${beginWeek.substring(2, 4)}분 ~';
    var b = ' ${endWeek.substring(0, 2)}시 ${endWeek.substring(2, 4)}분까지';
    var c =
        '${beginWeekend.substring(0, 2)}시 ${beginWeekend.substring(2, 4)}분 ~';
    var d = ' ${endWeekend.substring(0, 2)}시 ${endWeekend.substring(2, 4)}분까지';

    slideDialog.showSlideDialog(
      context: context,
      child: Expanded(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
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
                              padding: EdgeInsets.only(bottom: 10.0, right: 5),
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
                              padding: EdgeInsets.only(bottom: 10.0, right: 5),
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
                          decoration: BoxDecoration(border: Border.all()),
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: MediaQuery.of(context).size.height * 0.3,
                          child: Image.network(
                            pic,
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
            ],
          ),
        ),
      ),
      barrierColor: Colors.white.withOpacity(0.7),
      pillColor: Colors.amberAccent,
      backgroundColor: Colors.white,
    );
  }

  favoriteMethod() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      print(favorite);
      favorite = !favorite;
    });
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
        return opening == true
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

                    _showShopListDialog(
                        distance,
                        element.fileUrl,
                        element.placeName,
                        element.shopDc,
                        element.bsnBeginTime,
                        element.bsnEndTime,
                        element.weekBeginTime,
                        element.weekEndTime);
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
