import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:wellhada_oneapp/listitem/shop/shopInfoListItem.dart'
    as shopInfoListItem;

import 'package:wellhada_oneapp/model/map/map1_model.dart';

class Google1MapUI extends StatefulWidget {
  @override
  _Google1MapUIState createState() => _Google1MapUIState();
}

class _Google1MapUIState extends State<Google1MapUI>
    with AutomaticKeepAliveClientMixin<Google1MapUI> {
  Map1_model model = new Map1_model();
  List<MarkerId> allMarkerId = [];

  @override
  bool get wantKeepAlive => true;

  //default Marker
  List<Marker> allMarkers,
      martMarkers,
      kindergarden,
      academy,
      convenience,
      parking,
      gasStation = [];
  List<Marker> lodgement,
      restaurant,
      cafe,
      wellhada,
      martWellHadaMarkers,
      all = [];
  //wellhada Marker
  List<Marker> kindergardenWellHada,
      academyWellHada,
      convenienceWellHada,
      parkingWellHada = [];
  List<Marker> gasStationWellHada,
      lodgementWellHada,
      restaurantWellHada,
      cafeWellHada = [];
  List<Uint8List> assa = [];

  Uint8List everyIcon, wellhadaIcon;
  Map<String, Uint8List> iconSet = new Map();
  Map<String, Uint8List> wellhadaIconSet = new Map();
  var iss;
  // button click
  String category;

  // contanier boolean
  bool itemSelected = false;

  Future _future;
  Future _categoryFuture;

  var lat, lng;
  GoogleMapController _controller;
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  Position _currentLocation;
  var geoLocator = Geolocator();
  List shops, entireList;
  CameraPosition _cameraPosition;
  bool wellHadaCheck, check;

  //googlemap marker icon
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => executeAfterBuildComplete(context));
  }

  executeAfterBuildComplete([BuildContext context]) {
    print("Build Process Complete");
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    //getShowAppBar();
    category = "MT1";
    check = true;
    _future = getShop();
    _getCurrentLocation();
    _categoryFuture = getShopCategory();
    super.initState();
  }

  void dispose() {
    super.dispose();
    //_getCurrentLocation();
  }

  _getCurrentLocation() async {
    Position geoPos;

    try {
      Position pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      geoPos = pos;

      LatLng latlng = LatLng(geoPos.latitude, geoPos.longitude);
      //distance(geoPos.latitude, geoPos.longitude);
      _cameraPosition = new CameraPosition(target: latlng, zoom: 14.5);
    } catch (e, stackTrace) {
      geoPos = await Geolocator.getLastKnownPosition();

      LatLng latlng = LatLng(geoPos.latitude, geoPos.longitude);
      _cameraPosition = new CameraPosition(target: latlng, zoom: 14.5);

      print(stackTrace);
    }
  }

  double _coordinateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  void distance(lat1, lat2, lon1, lon2) {
    double totalDistance = 0;
    // for (var i = 0; i < data.length - 1; i++) {
    //   totalDistance += calculateDistance(data[i]["lat"], data[i]["lng"],
    //       data[i + 1]["lat"], data[i + 1]["lng"]);
    // }
    print(totalDistance);
  }

  Future<Map<String, dynamic>> getShopCategory() async {
    return shopInfoListItem.getShopCategoryList();
  }

  Future<Map<String, dynamic>> getShop() async {
    final entireShopList =
        await shopInfoListItem.getShopInfoCategoryListEntire();

    setState(() {
      entireList = entireShopList.list;
    });

    List<shopInfoListItem.ShopInfoCategoryList> shopInfo = entireList;

    for (int i = 0; i < shopInfo.length; i++) {
      wellhadaIcon = await getBytesFromCanvas(200, 100, shopInfo[i].placeName);
      wellhadaIconSet[shopInfo[i].id] = wellhadaIcon;
    }

    return shopInfoListItem.getShopInfoCategoryList();
  }

  Future<Uint8List> getBytesFromCanvas(
      int width, int height, String title) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color = Colors.white;
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

    // canvas.drawRRect(
    //     RRect.fromRectAndCorners(
    //       Rect.fromLTWH(15, 10, width.toDouble() - 10, height.toDouble() - 10),
    //       topLeft: radius,
    //       topRight: radius,
    //       bottomLeft: radius,
    //       bottomRight: radius,
    //     ),
    //     radiusPaint);
    // // Add image

    TextPainter painter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
    );

    painter.text = TextSpan(
      text: title.length > 6 ? "${title.substring(0, 6)}..." : "title",
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
                  decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    border: new Border.all(
                      color: Colors.indigo,
                      width: 1.0,
                    ),
                  ),
                  child: InkWell(
                      child: SizedBox(
                        width: 65,
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
                              style: TextStyle(fontSize: 13),
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

  Widget _listview(List<dynamic> shopCategoryList) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 2.5, right: 2.5),
              ),
              ClipOval(
                child: Material(
                  color: Colors.white, // button color
                  child: Container(
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      border: new Border.all(
                        color: Colors.indigo,
                        width: 1.0,
                      ),
                    ),
                    child: InkWell(
                        child: SizedBox(
                          width: 65,
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
                                shopCategoryList[0]['CATEGORY_CDNM'],
                                style: TextStyle(fontSize: 13),
                              )
                            ],
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            category = "mart";
                          });
                        }),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 2.5, right: 2.5),
              ),
              ClipOval(
                child: Material(
                    color: Colors.white, // button color
                    child: Container(
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        border: new Border.all(
                          color: Colors.indigo,
                          width: 1.0,
                        ),
                      ),
                      child: InkWell(
                          splashColor: Colors.black, // inkwell color
                          child: SizedBox(
                            width: 65,
                            height: 55,
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.only(top: 4.0, bottom: 1.0),
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
                                  shopCategoryList[1]['CATEGORY_CDNM'],
                                  style: TextStyle(fontSize: 13),
                                )
                              ],
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              category = "convenience";
                            });
                          }),
                    )),
              ),
              Padding(
                padding: EdgeInsets.only(left: 2.5, right: 2.5),
              ),
              ClipOval(
                child: Material(
                    color: Colors.white, // button color
                    child: Container(
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        border: new Border.all(
                          color: Colors.indigo,
                          width: 1.0,
                        ),
                      ),
                      child: InkWell(
                          splashColor: Colors.black, // inkwell color
                          child: SizedBox(
                            width: 65,
                            height: 55,
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.only(top: 4.0, bottom: 1.0),
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
                                  shopCategoryList[2]['CATEGORY_CDNM'],
                                  style: TextStyle(fontSize: 13),
                                )
                              ],
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              category = "kindergarden";
                            });
                          }),
                    )),
              ),
              Padding(
                padding: EdgeInsets.only(left: 2.5, right: 2.5),
              ),
              ClipOval(
                child: Material(
                    color: Colors.white, // button color
                    child: Container(
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        border: new Border.all(
                          color: Colors.indigo,
                          width: 1.0,
                        ),
                      ),
                      child: InkWell(
                          splashColor: Colors.black, // inkwell color
                          child: SizedBox(
                            width: 65,
                            height: 55,
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.only(top: 4.0, bottom: 1.0),
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
                                  shopCategoryList[3]['CATEGORY_CDNM'],
                                  style: TextStyle(fontSize: 13),
                                )
                              ],
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              category = "academy";
                            });
                          }),
                    )),
              ),
              Padding(
                padding: EdgeInsets.only(left: 2.5, right: 2.5),
              ),
              ClipOval(
                child: Material(
                    color: Colors.white, // button color
                    child: Container(
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        border: new Border.all(
                          color: Colors.indigo,
                          width: 1.0,
                        ),
                      ),
                      child: InkWell(
                          splashColor: Colors.black, // inkwell color
                          child: SizedBox(
                            width: 65,
                            height: 55,
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.only(top: 4.0, bottom: 1.0),
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
                                  shopCategoryList[4]['CATEGORY_CDNM'],
                                  style: TextStyle(fontSize: 13),
                                )
                              ],
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              category = "parking";
                            });
                          }),
                    )),
              ),
              Padding(
                padding: EdgeInsets.only(left: 2.5, right: 2.5),
              ),
              ClipOval(
                child: Material(
                    color: Colors.white, // button color
                    child: Container(
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        border: new Border.all(
                          color: Colors.indigo,
                          width: 1.0,
                        ),
                      ),
                      child: InkWell(
                          splashColor: Colors.black, // inkwell color
                          child: SizedBox(
                            width: 65,
                            height: 55,
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.only(top: 4.0, bottom: 1.0),
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
                                  shopCategoryList[5]['CATEGORY_CDNM'],
                                  style: TextStyle(fontSize: 13),
                                )
                              ],
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              category = "gasStation";
                            });
                          }),
                    )),
              ),
              Padding(
                padding: EdgeInsets.only(left: 2.5, right: 2.5),
              ),
              ClipOval(
                child: Material(
                    color: Colors.white, // button color
                    child: Container(
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        border: new Border.all(
                          color: Colors.indigo,
                          width: 1.0,
                        ),
                      ),
                      child: InkWell(
                          splashColor: Colors.black, // inkwell color
                          child: SizedBox(
                            width: 65,
                            height: 55,
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.only(top: 4.0, bottom: 1.0),
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
                                  shopCategoryList[6]['CATEGORY_CDNM'],
                                  style: TextStyle(fontSize: 13),
                                )
                              ],
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              category = "lodgement";
                            });
                          }),
                    )),
              ),
              Padding(
                padding: EdgeInsets.only(left: 2.5, right: 2.5),
              ),
              ClipOval(
                child: Material(
                    color: Colors.white, // button color
                    child: Container(
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        border: new Border.all(
                          color: Colors.indigo,
                          width: 1.0,
                        ),
                      ),
                      child: InkWell(
                          splashColor: Colors.black, // inkwell color
                          child: SizedBox(
                            width: 65,
                            height: 55,
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.only(top: 4.0, bottom: 1.0),
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
                                  shopCategoryList[7]['CATEGORY_CDNM'],
                                  style: TextStyle(fontSize: 13),
                                )
                              ],
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              category = "restaurant";
                            });
                          }),
                    )),
              ),
              Padding(
                padding: EdgeInsets.only(left: 2.5, right: 2.5),
              ),
              ClipOval(
                child: Material(
                    color: Colors.white, // button color
                    child: Container(
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        border: new Border.all(
                          color: Colors.indigo,
                          width: 1.0,
                        ),
                      ),
                      child: InkWell(
                          splashColor: Colors.black, // inkwell color
                          child: SizedBox(
                            width: 65,
                            height: 55,
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.only(top: 4.0, bottom: 1.0),
                                ),
                                Image(
                                  image: AssetImage('assets/img/cafe.png'),
                                  width: 25,
                                  height: 25,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 3.0),
                                ),
                                Text(
                                  shopCategoryList[8]['CATEGORY_CDNM'],
                                  style: TextStyle(fontSize: 13),
                                )
                              ],
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              category = "cafe";
                            });
                          }),
                    )),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _container() {
    return Material(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.1,
        width: MediaQuery.of(context).size.width * 0.7,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
        child: InkWell(
            onTap: () {
              setState(() {
                itemSelected = false;
              });
            },
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 13.0),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(model.placeName,
                        style: TextStyle(
                            fontFamily: 'Godo',
                            fontWeight: FontWeight.w900,
                            fontSize: 17.0,
                            color: Hexcolor('#333333'))),
                    Text(model.phone,
                        style: TextStyle(
                            fontFamily: 'Godo',
                            fontWeight: FontWeight.w500,
                            fontSize: 12.0,
                            color: Hexcolor('#333333'))),
                    Text(model.distance + 'm',
                        style: TextStyle(
                            fontFamily: 'Godo',
                            fontWeight: FontWeight.w500,
                            fontSize: 12.0,
                            color: Hexcolor('#333333')))
                  ],
                ),
              ],
            )),
      ),
    );
  }

  List<Marker> selectMarker1(List<dynamic> shopInfoList) {
    return shopInfoList
        .where((element) => element['category_group_code'] == category)
        .map((element) {
      //martBitmap = await getMarkerIcon(element['place_url'], Size(95, 95));

      void martIconSet() async {
        everyIcon = await getBytesFromCanvas(200, 100, element['place_name']);
        iconSet[element['id']] = everyIcon;
      }

      martIconSet();

      return Marker(
          markerId: MarkerId(element['id']),
          position:
              LatLng(double.parse(element['y']), double.parse(element['x'])),
          icon: BitmapDescriptor.fromBytes(iconSet[element['id']]),
          onTap: () {
            setState(() {
              itemSelected = true;
              model.id = element['id'];
              model.distance = element['distance'];
              model.placeName = element['place_name'];
              model.phone = element['phone'];
            });
          });
    }).toList();
  }

  List<Marker> selectWellhadaMarker1(List<dynamic> shopInfoList) {
    return shopInfoList
        .where((element) =>
            element['category_group_code'] == category &&
            element['wellhada_shop'] == "Y")
        .map((element) {
      //martBitmap = await getMarkerIcon(element['place_url'], Size(95, 95));

      //print(element['place_name'] + ',');

      return Marker(
          markerId: MarkerId(element['id']),
          position:
              LatLng(double.parse(element['y']), double.parse(element['x'])),
          icon: BitmapDescriptor.fromBytes(wellhadaIconSet[element['id']]),
          // wellhadaIconSet[element['id']
          onTap: () {
            setState(() {
              itemSelected = true;
              model.id = element['id'];
              model.distance = element['distance'];
              model.placeName = element['place_name'];
              model.phone = element['phone'];
            });
          });
    }).toList();
  }

  List<Marker> selectMarker(List<dynamic> shopInfoList) {
    switch (category) {
      case "mart":
        return martMarkers;
      case "convenience":
        return convenience;
      case "kindergarden":
        return kindergarden;
      case "academy":
        return academy;
      case "parking":
        return parking;
      case "gasStation":
        return gasStation;
      case "lodgement":
        return lodgement;
      case "restaurant":
        return restaurant;
      case "cafe":
        return cafe;
    }

    martMarkers = shopInfoList
        .where((element) => element['category_group_code'] == "MT1")
        .map((element) {
      //martBitmap = await getMarkerIcon(element['place_url'], Size(95, 95));
      void martIconSet() async {
        everyIcon = await getBytesFromCanvas(200, 100, element['place_name']);
        iconSet[element['id']] = everyIcon;
      }

      martIconSet();
      return Marker(
          markerId: MarkerId(element['id']),
          position:
              LatLng(double.parse(element['y']), double.parse(element['x'])),
          icon: BitmapDescriptor.fromBytes(iconSet[element['id']]),
          onTap: () {
            setState(() {
              itemSelected = true;
              model.id = element['id'];
              model.distance = element['distance'];
              model.placeName = element['place_name'];
              model.phone = element['phone'];
            });
          });
    }).toList();

    convenience = shopInfoList
        .where((element) => element['category_group_code'] == "CS2")
        .map((element) {
      void convenIconSet() async {
        everyIcon = await getBytesFromCanvas(200, 100, element['place_name']);
        iconSet[element['id']] = everyIcon;
      }

      convenIconSet();
      return Marker(
          markerId: MarkerId(element['id']),
          position:
              LatLng(double.parse(element['y']), double.parse(element['x'])),
          icon: BitmapDescriptor.fromBytes(iconSet[element['id']]),
          onTap: () {
            setState(() {
              itemSelected = true;

              model.id = element['id'];
              model.distance = element['distance'];
              model.placeName = element['place_name'];
              model.phone = element['phone'];
            });
          });
    }).toList();

    kindergarden = shopInfoList
        .where((element) => element['category_group_code'] == "PS3")
        .map((element) {
      void kinderIconSet() async {
        everyIcon = await getBytesFromCanvas(200, 100, element['place_name']);
        iconSet[element['id']] = everyIcon;
      }

      kinderIconSet();
      return Marker(
          markerId: MarkerId(element['id']),
          position:
              LatLng(double.parse(element['y']), double.parse(element['x'])),
          icon: BitmapDescriptor.fromBytes(iconSet[element['id']]),
          onTap: () {
            setState(() {
              itemSelected = true;

              model.id = element['id'];
              model.distance = element['distance'];
              model.placeName = element['place_name'];
              model.phone = element['phone'];
            });
          });
    }).toList();

    academy = shopInfoList
        .where((element) => element['category_group_code'] == "AC5")
        .map((element) {
      void academyIconSet() async {
        everyIcon = await getBytesFromCanvas(200, 100, element['place_name']);
        iconSet[element['id']] = everyIcon;
      }

      academyIconSet();
      return Marker(
          markerId: MarkerId(element['id']),
          position:
              LatLng(double.parse(element['y']), double.parse(element['x'])),
          icon: BitmapDescriptor.fromBytes(iconSet[element['id']]),
          //icon: BitmapDescriptor.fromBytes(unitmarkers),

          onTap: () {
            setState(() {
              itemSelected = true;
              model.id = element['id'];
              model.distance = element['distance'];
              model.category = element['category_group_code'];
              model.placeName = element['place_name'];
              model.phone = element['phone'];
            });
          });
    }).toList();

    parking = shopInfoList
        .where((element) => element['category_group_code'] == "pk6")
        .map((element) {
      void parkingIconSet() async {
        everyIcon = await getBytesFromCanvas(200, 100, element['place_name']);
        iconSet[element['id']] = everyIcon;
      }

      parkingIconSet();
      return Marker(
          markerId: MarkerId(element['id']),
          position:
              LatLng(double.parse(element['y']), double.parse(element['x'])),
          icon: BitmapDescriptor.fromBytes(iconSet[element['id']]),
          onTap: () {
            setState(() {
              model.id = element['id'];
              model.category = element['category_group_code'];
              model.distance = element['distance'];
              model.placeName = element['place_name'];
              model.phone = element['phone'];
              itemSelected = true;
            });
          });
    }).toList();

    lodgement = shopInfoList
        .where((element) => element['category_group_code'] == "AD5")
        .map((element) {
      void lodgementIconSet() async {
        everyIcon = await getBytesFromCanvas(200, 100, element['place_name']);
        iconSet[element['id']] = everyIcon;
      }

      lodgementIconSet();
      return Marker(
          markerId: MarkerId(element['id']),
          position:
              LatLng(double.parse(element['y']), double.parse(element['x'])),
          icon: BitmapDescriptor.fromBytes(iconSet[element['id']]),
          onTap: () {
            setState(() {
              itemSelected = true;
              model.id = element['id'];
              model.category = element['category_group_code'];
              model.distance = element['distance'];
              model.placeName = element['place_name'];
              model.phone = element['phone'];
            });
          });
    }).toList();

    restaurant = shopInfoList
        .where((element) => element['category_group_code'] == "FD6")
        .map((element) {
      void restauIconSet() async {
        everyIcon = await getBytesFromCanvas(200, 100, element['place_name']);
        iconSet[element['id']] = everyIcon;
      }

      restauIconSet();
      return Marker(
          markerId: MarkerId(element['id']),
          position:
              LatLng(double.parse(element['y']), double.parse(element['x'])),
          icon: BitmapDescriptor.fromBytes(iconSet[element['id']]),
          onTap: () {
            setState(() {
              itemSelected = true;
              model.id = element['id'];
              model.category = element['category_group_code'];
              model.distance = element['distance'];
              model.placeName = element['place_name'];
              model.phone = element['phone'];
            });
          });
    }).toList();

    cafe = shopInfoList
        .where((element) => element['category_group_code'] == "CE7")
        .map((element) {
      void cafeIconSet() async {
        everyIcon = await getBytesFromCanvas(200, 100, element['place_name']);
        iconSet[element['id']] = everyIcon;
      }

      cafeIconSet();
      return Marker(
          markerId: MarkerId(element['id']),
          position:
              LatLng(double.parse(element['y']), double.parse(element['x'])),
          icon: BitmapDescriptor.fromBytes(iconSet[element['id']]),
          onTap: () {
            setState(() {
              itemSelected = true;
              model.id = element['id'];
              model.category = element['category_group_code'];
              model.distance = element['distance'];
              model.placeName = element['place_name'];
              model.phone = element['phone'];
            });
          });
    }).toList();

    gasStation = shopInfoList
        .where((element) => element['category_group_code'] == "OL7")
        .map((element) {
      void gasStaIconSet() async {
        everyIcon = await getBytesFromCanvas(200, 100, element['place_name']);
        iconSet[element['id']] = everyIcon;
      }

      gasStaIconSet();
      return Marker(
          markerId: MarkerId(element['id']),
          position:
              LatLng(double.parse(element['y']), double.parse(element['x'])),
          icon: BitmapDescriptor.fromBytes(iconSet[element['id']]),
          onTap: () {
            setState(() {
              itemSelected = true;

              model.id = element['id'];
              model.distance = element['distance'];
              model.category = element['category_group_code'];
              model.placeName = element['place_name'];
              model.phone = element['phone'];
            });
          });
    }).toList();
  }

  List<Marker> selectWellhadaMarker(List<dynamic> shopInfoList) {
    switch (category) {
      case "mart":
        return martWellHadaMarkers;
      case "convenience":
        return convenienceWellHada;
      case "kindergarden":
        return kindergardenWellHada;
      case "academy":
        return academyWellHada;
      case "parking":
        return parkingWellHada;
      case "gasStation":
        return gasStationWellHada;
      case "lodgement":
        return lodgementWellHada;
      case "restaurant":
        return restaurantWellHada;
      case "cafe":
        return cafeWellHada;
    }

    martWellHadaMarkers = shopInfoList
        .where((element) =>
            element['category_group_code'] == "MT1" &&
            element['wellhada_shop'] == "Y")
        .map((element) {
      return Marker(
          markerId: MarkerId(element['id']),
          position:
              LatLng(double.parse(element['y']), double.parse(element['x'])),
          icon: BitmapDescriptor.fromBytes(wellhadaIconSet[element['id']]),
          onTap: () {
            setState(() {
              itemSelected = true;
              model.id = element['id'];
              model.distance = element['distance'];
              model.placeName = element['place_name'];
              model.phone = element['phone'];
            });
          });
    }).toList();

    convenienceWellHada = shopInfoList
        .where((element) =>
            element['category_group_code'] == "CS2" &&
            element['wellhada_shop'] == "Y")
        .map((element) {
      return Marker(
          markerId: MarkerId(element['id']),
          position:
              LatLng(double.parse(element['y']), double.parse(element['x'])),
          icon: BitmapDescriptor.fromBytes(wellhadaIconSet[element['id']]),
          onTap: () {
            setState(() {
              itemSelected = true;
              model.category = element['category_group_code'];
              model.id = element['id'];
              model.distance = element['distance'];
              model.placeName = element['place_name'];
              model.phone = element['phone'];
            });
          });
    }).toList();

    kindergardenWellHada = shopInfoList
        .where((element) =>
            element['category_group_code'] == "PS3" &&
            element['wellhada_shop'] == "Y")
        .map((element) {
      return Marker(
          markerId: MarkerId(element['id']),
          position:
              LatLng(double.parse(element['y']), double.parse(element['x'])),
          icon: BitmapDescriptor.fromBytes(wellhadaIconSet[element['id']]),
          onTap: () {
            setState(() {
              itemSelected = true;
              model.category = element['category_group_code'];
              model.id = element['id'];
              model.distance = element['distance'];
              model.placeName = element['place_name'];
              model.phone = element['phone'];
            });
          });
    }).toList();

    academyWellHada = shopInfoList
        .where((element) =>
            element['category_group_code'] == "AC5" &&
            element['wellhada_shop'] == "Y")
        .map((element) {
      return Marker(
          markerId: MarkerId(element['id']),
          position:
              LatLng(double.parse(element['y']), double.parse(element['x'])),
          icon: BitmapDescriptor.fromBytes(wellhadaIconSet[element['id']]),
          onTap: () {
            setState(() {
              itemSelected = true;
              model.id = element['id'];
              model.distance = element['distance'];
              model.category = element['category_group_code'];
              model.placeName = element['place_name'];
              model.phone = element['phone'];
            });
          });
    }).toList();

    parkingWellHada = shopInfoList
        .where((element) =>
            element['category_group_code'] == "pk6" &&
            element['wellhada_shop'] == "Y")
        .map((element) {
      return Marker(
          markerId: MarkerId(element['id']),
          position:
              LatLng(double.parse(element['y']), double.parse(element['x'])),
          icon: BitmapDescriptor.fromBytes(wellhadaIconSet[element['id']]),
          onTap: () {
            setState(() {
              model.id = element['id'];
              model.category = element['category_group_code'];
              model.distance = element['distance'];
              model.placeName = element['place_name'];
              model.phone = element['phone'];
              itemSelected = true;
            });
          });
    }).toList();

    lodgementWellHada = shopInfoList
        .where((element) =>
            element['category_group_code'] == "AD5" &&
            element['wellhada_shop'] == "Y")
        .map((element) {
      return Marker(
          markerId: MarkerId(element['id']),
          position:
              LatLng(double.parse(element['y']), double.parse(element['x'])),
          icon: BitmapDescriptor.fromBytes(wellhadaIconSet[element['id']]),
          onTap: () {
            setState(() {
              itemSelected = true;
              model.id = element['id'];
              model.category = element['category_group_code'];
              model.distance = element['distance'];
              model.placeName = element['place_name'];
              model.phone = element['phone'];
            });
          });
    }).toList();

    restaurantWellHada = shopInfoList
        .where((element) =>
            element['category_group_code'] == "FD6" &&
            element['wellhada_shop'] == "Y")
        .map((element) {
      return Marker(
          markerId: MarkerId(element['id']),
          position:
              LatLng(double.parse(element['y']), double.parse(element['x'])),
          icon: BitmapDescriptor.fromBytes(wellhadaIconSet[element['id']]),
          onTap: () {
            setState(() {
              itemSelected = true;
              model.id = element['id'];
              model.category = element['category_group_code'];
              model.distance = element['distance'];
              model.placeName = element['place_name'];
              model.phone = element['phone'];
            });
          });
    }).toList();

    cafeWellHada = shopInfoList
        .where((element) =>
            element['category_group_code'] == "CE7" &&
            element['wellhada_shop'] == "Y")
        .map((element) {
      return Marker(
          markerId: MarkerId(element['id']),
          position:
              LatLng(double.parse(element['y']), double.parse(element['x'])),
          icon: BitmapDescriptor.fromBytes(wellhadaIconSet[element['id']]),
          onTap: () {
            setState(() {
              itemSelected = true;
              model.id = element['id'];
              model.category = element['category_group_code'];
              model.distance = element['distance'];
              model.placeName = element['place_name'];
              model.phone = element['phone'];
            });
          });
    }).toList();

    gasStationWellHada = shopInfoList
        .where((element) =>
            element['category_group_code'] == "OL7" &&
            element['wellhada_shop'] == "Y")
        .map((element) {
      return Marker(
          markerId: MarkerId(element['id']),
          position:
              LatLng(double.parse(element['y']), double.parse(element['x'])),
          icon: BitmapDescriptor.fromBytes(wellhadaIconSet[element['id']]),
          onTap: () {
            setState(() {
              itemSelected = true;
              model.id = element['id'];
              model.distance = element['distance'];
              model.category = element['category_group_code'];
              model.placeName = element['place_name'];
              model.phone = element['phone'];
            });
          });
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: FutureBuilder(
          future: Future.wait([_future, _categoryFuture]),
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Text("");
            }

            Map<String, dynamic> shopInfo = snapshot.data[0];

            List<dynamic> shopInfoList = shopInfo["LIST"];
            Map<String, dynamic> shopCategory = snapshot.data[1];
            List<dynamic> shopCategoryList = shopCategory["LIST"];

            List<Marker> changeWellhadaMark =
                selectWellhadaMarker1(shopInfoList);

            List<Marker> changeMark = selectMarker1(shopInfoList);

            //print(values.runtimeType);

            // allMarkers = martMarkers +
            //     convenience +
            //     kindergarden +
            //     academy +
            //     parking +
            //     gasStation +
            //     lodgement +
            //     restaurant +
            //     cafe;

            // wellhada = martWellHadaMarkers +
            //     convenienceWellHada +
            //     kindergardenWellHada +
            //     academyWellHada +
            //     parkingWellHada +
            //     gasStationWellHada +
            //     lodgementWellHada +
            //     restaurantWellHada +
            //     cafeWellHada;

            return Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      Container(
                          child: ClipOval(
                        child: Material(
                          color: check == true
                              ? Colors.yellow
                              : Colors.white, // button color
                          child: Container(
                            decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              border: new Border.all(
                                color: Colors.yellow,
                                width: 1.0,
                              ),
                            ),
                            child: InkWell(
                                child: SizedBox(
                                  width: 65,
                                  height: 55,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 4.0, bottom: 1.0),
                                      ),
                                      Image(
                                        image:
                                            AssetImage('assets/img/cafe.png'),
                                        width: 25,
                                        height: 25,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 1.0),
                                      ),
                                      Text(
                                        "가맹점",
                                        style: TextStyle(fontSize: 13),
                                      )
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    check == true
                                        ? check = false
                                        : check = true;

                                    // category != "all" &&
                                    //         category != "wellhada" &&
                                    //         check == false
                                    //     ? category = "all"
                                    //     : category == "wellhada"
                                    //         ? category = "all"
                                    //         : category = "wellhada";
                                    // category == null
                                    //     ? category = "MT1"
                                    //     : print(category);
                                  });
                                }),
                          ),
                        ),
                      )),
                      Expanded(
                        // wrap in Expanded
                        //child: _listview(shopCategoryList),
                        child: _list(shopCategoryList),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 2.0, bottom: 2.0),
                ),
                Stack(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: GoogleMap(
                        initialCameraPosition: _cameraPosition == null
                            ? CameraPosition(
                                target: LatLng(37.4835706, 126.8931126),
                                zoom: 14.5)
                            : _cameraPosition,
                        rotateGesturesEnabled: false,
                        tiltGesturesEnabled: false,
                        markers:
                            // check == false && category == "all"
                            //     ? Set.from(allMarkers)
                            //     : check == false && category != "all"
                            //         ? Set.from(changeMark)
                            //         : check == true && category == "wellhada"
                            //             ? Set.from(wellhada)
                            //             : Set.from(changeWellhadaMark),
                            check == false
                                ? Set.from(changeMark)
                                : Set.from(changeWellhadaMark),
                        myLocationEnabled: true,
                        onMapCreated: (GoogleMapController controller) {
                          setState(() {});

                          _controller = controller;
                        },
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: FloatingActionButton(
                        onPressed: _getCurrentLocation,
                        child: Icon(
                          Icons.location_on,
                          color: Colors.yellow,
                        ),
                        backgroundColor: Colors.white,
                      ),
                    ),
                    Positioned(
                        bottom: 0,
                        width: MediaQuery.of(context).size.width,
                        child: itemSelected == true ? _container() : Text("")),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    ]);
  }
}
