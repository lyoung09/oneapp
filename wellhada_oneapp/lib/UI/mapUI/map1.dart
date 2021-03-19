import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hexcolor/hexcolor.dart';
import 'dart:io' as Io;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:wellhada_oneapp/listitem/shop/shopInfoListItem.dart'
    as shopInfoListItem;

import 'package:wellhada_oneapp/model/map/map1_model.dart';
import 'package:wellhada_oneapp/model/map/map_model.dart';

class Google1MapUI extends StatefulWidget {
  @override
  _Google1MapUIState createState() => _Google1MapUIState();
}

class _Google1MapUIState extends State<Google1MapUI> {
  Map1_model model = new Map1_model();
  List<MarkerId> allMarkerId = [];
  List<Marker> allMarkers, martMarkers = [];
  List<Marker> kindergarden, academy, convenience = [];
  List<Marker> parking, gasStation = [];
  List<Marker> lodgement,
      restaurant,
      cafe,
      wellhada,
      martWellHadaMarkers,
      all = [];
  List<Marker> kindergardenWellHada, academyWellHada, convenienceWellHada = [];
  List<Marker> parkingWellHada, gasStationWellHada = [];
  List<Marker> lodgementWellHada, restaurantWellHada, cafeWellHada = [];
  String category;
  bool itemSelected = false;
  Future _future;
  Future _categoryFuture;
  var lat, lng;
  GoogleMapController _controller;
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  Position postion;
  var geoLocator = Geolocator();
  List shops;
  CameraPosition _cameraPosition;
  bool wellHadaCheck, check;
  var icons;
  Uint8List unitmarkers;
  BitmapDescriptor defaultMarker, pinLocationIcon, a, b, c, d, e, p;

  @override
  void initState() {
    category = "all";

    super.initState();
    check = false;
    _future = getShop();

    _getCurrentLocation();
    _categoryFuture = getShopCategory();
  }

  void dispose() {
    super.dispose();
    //_getCurrentLocation();
  }

  void initCurrentLocation() async {
    LatLng latlng = LatLng(37.4835706, 126.8931126);
    _cameraPosition = new CameraPosition(target: latlng, zoom: 15.4746);
  }

  _getCurrentLocation() async {
    Position geoPos;

    try {
      Position pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      geoPos = pos;
      _controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          bearing: 0,
          target: LatLng(geoPos.latitude, geoPos.longitude),
          zoom: 15.4746,
        ),
      ));
      LatLng latlng = LatLng(geoPos.latitude, geoPos.longitude);
      //distance(geoPos.latitude, geoPos.longitude);
      _cameraPosition = new CameraPosition(target: latlng, zoom: 15.4746);
    } catch (e) {
      initCurrentLocation();
      print(e);
    }
  }

  double calculateDistance(lat1, lat2, lon1, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
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

  Future<BitmapDescriptor> getMarkerIcon(String imagePath, Size size) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    final Radius radius = Radius.circular(size.width / 2);

    final Paint tagPaint = Paint()..color = Colors.blue;
    final double tagWidth = 40.0;

    final Paint shadowPaint = Paint()..color = Colors.blue.withAlpha(100);
    final double shadowWidth = 15.0;

    final Paint borderPaint = Paint()..color = Colors.white;
    final double borderWidth = 3.0;

    final double imageOffset = shadowWidth + borderWidth;

    // Add border circle
    canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(shadowWidth, shadowWidth,
              size.width - (shadowWidth * 2), size.height - (shadowWidth * 2)),
          topLeft: radius,
          topRight: radius,
          bottomLeft: radius,
          bottomRight: radius,
        ),
        borderPaint);

    // Add tag circle
    canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(size.width - tagWidth, 0.0, tagWidth, tagWidth),
          topLeft: radius,
          topRight: radius,
          bottomLeft: radius,
          bottomRight: radius,
        ),
        tagPaint);

    // Oval for the image
    Rect oval = Rect.fromLTWH(imageOffset, imageOffset,
        size.width - (imageOffset * 2), size.height - (imageOffset * 2));

    // Add path for oval image
    canvas.clipPath(Path()..addOval(oval));

    // Add image
    ui.Image image = await getImage(
        imagePath); // Alternatively use your own method to get the image
    paintImage(canvas: canvas, image: image, rect: oval, fit: BoxFit.fitWidth);

    // Convert canvas to image
    final ui.Image markerAsImage = await pictureRecorder
        .endRecording()
        .toImage(size.width.toInt(), size.height.toInt());

    // Convert image to bytes
    final ByteData byteData =
        await markerAsImage.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List uint8List = byteData.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(uint8List);
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
    //shopInfoListItem.getShopInfoList().then((e)=>{})

    return shopInfoListItem.getShopInfoCategoryList();
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

  void bz() async {
    defaultMarker =
        await getBitmapDescriptorFromAssetBytes("assets/img/cafeicon.png", 80);
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  Future<BitmapDescriptor> getBitmapDescriptorFromAssetBytes(
      String path, int width) async {
    final Uint8List imageData = await getBytesFromAsset(path, width);
    return BitmapDescriptor.fromBytes(imageData);
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
    print("default");
    print(category);

    martMarkers = shopInfoList
        .where((element) => element['category_group_code'] == "MT1")
        .map((element) {
      void icon() async {
        pinLocationIcon = await getMarkerIcon(
            'https://img.icons8.com/android/24/000000/restaurant.png',
            Size(70, 70));
      }

      print("!11111");
      icon();
      return Marker(
          markerId: MarkerId(element['id']),
          position:
              LatLng(double.parse(element['y']), double.parse(element['x'])),
          icon: pinLocationIcon,
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
      void z() async {
        a = await getMarkerIcon(
            'https://img.icons8.com/ios/452/cafe.png', Size(70, 70));
      }

      print("2222222222222");
      z();
      return Marker(
          markerId: MarkerId(element['id']),
          position:
              LatLng(double.parse(element['y']), double.parse(element['x'])),
          icon: a,
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

    kindergarden = shopInfoList
        .where((element) => element['category_group_code'] == "PS3")
        .map((element) {
      void bicon() async {
        b = await getMarkerIcon(
            'https://img.icons8.com/ios/452/cafe.png', Size(30, 30));
      }

      bicon();
      return Marker(
          markerId: MarkerId(element['id']),
          position:
              LatLng(double.parse(element['y']), double.parse(element['x'])),
          icon: b,
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

    academy = shopInfoList
        .where((element) => element['category_group_code'] == "AC5")
        .map((element) {
      return Marker(
          markerId: MarkerId(element['id']),
          position:
              LatLng(double.parse(element['y']), double.parse(element['x'])),
          icon: pinLocationIcon,
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
      return Marker(
          markerId: MarkerId(element['id']),
          position:
              LatLng(double.parse(element['y']), double.parse(element['x'])),
          //icon: BitmapDescriptor.fromBytes(unitmarkers),
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
      return Marker(
          markerId: MarkerId(element['id']),
          position:
              LatLng(double.parse(element['y']), double.parse(element['x'])),
          //icon: BitmapDescriptor.fromBytes(unitmarkers),
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
      return Marker(
          markerId: MarkerId(element['id']),
          position:
              LatLng(double.parse(element['y']), double.parse(element['x'])),
          //icon: BitmapDescriptor.fromBytes(unitmarkers),
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
      return Marker(
          markerId: MarkerId(element['id']),
          position:
              LatLng(double.parse(element['y']), double.parse(element['x'])),
          //icon: BitmapDescriptor.fromBytes(unitmarkers),
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
      return Marker(
          markerId: MarkerId(element['id']),
          position:
              LatLng(double.parse(element['y']), double.parse(element['x'])),
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
      void icons() async {
        c = await getMarkerIcon(
            'https://img.icons8.com/android/24/000000/restaurant.png',
            Size(30, 30));
      }

      icons();
      print("aaaaaaaaaaa");
      return Marker(
          markerId: MarkerId(element['id']),
          position:
              LatLng(double.parse(element['y']), double.parse(element['x'])),
          icon: c,
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
      void zs() async {
        d = await getMarkerIcon(
            'https://img.icons8.com/ios/452/cafe.png', Size(70, 70));
      }

      print("2222222222222");
      zs();
      return Marker(
          markerId: MarkerId(element['id']),
          position:
              LatLng(double.parse(element['y']), double.parse(element['x'])),
          icon: d,
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
      void bicon() async {
        e = await getMarkerIcon(
            'https://img.icons8.com/ios/452/cafe.png', Size(30, 30));
      }

      bicon();
      return Marker(
          markerId: MarkerId(element['id']),
          position:
              LatLng(double.parse(element['y']), double.parse(element['x'])),
          icon: e,
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

    academyWellHada = shopInfoList
        .where((element) =>
            element['category_group_code'] == "AC5" &&
            element['wellhada_shop'] == "Y")
        .map((element) {
      return Marker(
          markerId: MarkerId(element['id']),
          position:
              LatLng(double.parse(element['y']), double.parse(element['x'])),

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

    parkingWellHada = shopInfoList
        .where((element) =>
            element['category_group_code'] == "pk6" &&
            element['wellhada_shop'] == "Y")
        .map((element) {
      return Marker(
          markerId: MarkerId(element['id']),
          position:
              LatLng(double.parse(element['y']), double.parse(element['x'])),
          //icon: BitmapDescriptor.fromBytes(unitmarkers),
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
          //icon: BitmapDescriptor.fromBytes(unitmarkers),
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
          //icon: BitmapDescriptor.fromBytes(unitmarkers),
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
          //icon: BitmapDescriptor.fromBytes(unitmarkers),
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
          //icon: BitmapDescriptor.fromBytes(unitmarkers),
          //icon : marker
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
            print(category);
            category = "all";

            List<Marker> changeWellhadaMark =
                selectWellhadaMarker(shopInfoList);

            List<Marker> changeMark = selectMarker(shopInfoList);

            // void z() {
            //   category = "mart";
            //   changeMark = selectMarker(shopInfoList);
            //   changeWellhadaMark = selectWellhadaMarker(shopInfoList);

            //   category = "convenience";
            //   changeMark = selectMarker(shopInfoList);
            //   changeWellhadaMark = selectWellhadaMarker(shopInfoList);

            //   category = "kindergarden";
            //   changeMark = selectMarker(shopInfoList);
            //   changeWellhadaMark = selectWellhadaMarker(shopInfoList);

            //   allMarkers = martMarkers + convenience + kindergarden;
            //   wellhada = martWellHadaMarkers +
            //       convenienceWellHada +
            //       kindergardenWellHada;
            //   category = "all";
            // }

            allMarkers = shopInfoList.map((element) {
              Future<BitmapDescriptor> allIcons() async {
              p = await getMarkerIcon(element['place_url'], Size(30, 30));
                return p;
              }


              print(element['place_url']);

              return Marker(
                  markerId: MarkerId(element['id']),
                  position: LatLng(
                      double.parse(element['y']), double.parse(element['x'])),
                  icon: p,
                  //infoWindow: InfoWindow(title: element['place_name']),
                  onTap: () {
                    setState(() {
                      itemSelected = true;
                      model.id = element['id'];
                      model.distance = element['distance'];
                      model.addressName = element['address_name'];
                      model.placeName = element['place_name'];
                      model.phone = element['phone'];
                    });
                  });
            }).toList();

            wellhada = shopInfoList
                .where((element) => element['wellhada_shop'] == "Y")
                .map((element) {
              void wellhadaIcons() async {
                defaultMarker =
                    await getMarkerIcon(element['place_url'], Size(30, 30));
              }

              wellhadaIcons();
              print(element['place_url']);
              return Marker(
                  markerId: MarkerId(element['id']),
                  position: LatLng(
                      double.parse(element['y']), double.parse(element['x'])),
                  icon: defaultMarker,
                  onTap: () {
                    setState(() {
                      itemSelected = true;

                      model.id = element['id'];
                      model.placeName = element['place_name'];
                      model.distance = element['distance'];
                      model.addressName = element['address_name'];
                      model.phone = element['phone'];
                    });
                  });
            }).toList();

            //print(values.runtimeType);

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
                                    category != "all" &&
                                            category != "wellhada" &&
                                            check == false
                                        ? category = "all"
                                        : category == "wellhada"
                                            ? category = "all"
                                            : category = "wellhada";
                                    print(check);
                                    print(category);
                                  });
                                }),
                          ),
                        ),
                      )),
                      Expanded(
                        // wrap in Expanded
                        child: _listview(shopCategoryList),
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
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: GoogleMap(
                        initialCameraPosition: _cameraPosition,
                        // markers: check == false && category == "all"
                        //     ? Set.from(allMarkers)
                        //     : check == true && category != "wellhada"
                        //         ? Set.from(changeWellhadaMark)
                        //         : check == true && category == "wellhada"
                        //             ? Set.from(wellhada)
                        //             : Set.from(changeMark),
                        markers: Set.from(allMarkers),
                        myLocationEnabled: true,
                        onMapCreated: (GoogleMapController controller) {
                          setState(() {
                            category = "all";
                          });
                          _controllerGoogleMap.complete(controller);
                          _controller = controller;
                          print(check);
                          print(category);
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
