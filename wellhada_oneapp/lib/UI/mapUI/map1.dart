import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:geolocator/geolocator.dart';
import 'package:hexcolor/hexcolor.dart';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:wellhada_oneapp/listitem/shop/shopInfoListItem.dart'
    as shopInfoListItem;
import 'dart:ui' as ui;
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
  List<Marker> lodgement, restaurant, cafe, wellhada = [];
  String category = "all";
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

  BitmapDescriptor customMarker;
  Uint8List unitmarkers;
  @override
  void initState() {
    super.initState();
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
      _cameraPosition = new CameraPosition(target: latlng, zoom: 15.4746);
    } catch (e) {
      initCurrentLocation();
      print(e);
    }
  }

  Future<Map<String, dynamic>> getShopCategory() async {
    return shopInfoListItem.getShopCategoryList();
  }

  Future<Map<String, dynamic>> getShop() async {
    //shopInfoListItem.getShopInfoList().then((e)=>{})

    return shopInfoListItem.getShopInfoList();
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
        height: MediaQuery.of(context).size.height * 0.15,
        width: MediaQuery.of(context).size.width * 0.7,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(25.0), topLeft: Radius.circular(10.0)),
        ),
        child: InkWell(
            onTap: () {
              setState(() {
                itemSelected = false;
              });
            },
            child: Row(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.6,
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Image(image: AssetImage('assets/img/cafe.png'))),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Text(model.placeName,
                          style: TextStyle(
                              fontFamily: 'Godo',
                              fontWeight: FontWeight.w900,
                              fontSize: 15.0,
                              color: Hexcolor('#333333'))),
                      Text(model.phone,
                          style: TextStyle(
                              fontFamily: 'Godo',
                              fontWeight: FontWeight.w900,
                              fontSize: 10.0,
                              color: Hexcolor('#333333'))),
                      Text(model.distance + 'm',
                          style: TextStyle(
                              fontFamily: 'Godo',
                              fontWeight: FontWeight.w900,
                              fontSize: 10.0,
                              color: Hexcolor('#333333')))
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }

  customMark(String a) async {
    unitmarkers = await getBytesFromCanvas(200, 100, a);
  }

  Future<Uint8List> getBytesFromCanvas(int width, int height, String x) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color = Colors.white;
    final Radius radius = Radius.circular(20.0);

    canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(0.0, 0.0, width.toDouble(), height.toDouble()),
          topLeft: radius,
          topRight: radius,
          bottomLeft: radius,
          bottomRight: radius,
        ),
        paint);
    TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
    painter.text = TextSpan(
      text: x,
      style: TextStyle(fontSize: 25.0, color: Colors.white),
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
      case "wellhada":
        return wellhada;
    }

    martMarkers = shopInfoList
        .where((element) => element['category_group_code'] == "MT1")
        .map((element) {
      return Marker(
          markerId: MarkerId(element['id']),
          position:
              LatLng(double.parse(element['x']), double.parse(element['y'])),
          //icon: BitmapDescriptor.fromBytes(unitmarkers),
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
      return Marker(
          markerId: MarkerId(element['id']),
          position:
              LatLng(double.parse(element['x']), double.parse(element['y'])),
          //icon: BitmapDescriptor.fromBytes(unitmarkers),
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
      return Marker(
          markerId: MarkerId(element['id']),
          position:
              LatLng(double.parse(element['x']), double.parse(element['y'])),
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

    academy = shopInfoList
        .where((element) => element['category_group_code'] == "AC5")
        .map((element) {
      return Marker(
          markerId: MarkerId(element['id']),
          position:
              LatLng(double.parse(element['x']), double.parse(element['y'])),
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
              LatLng(double.parse(element['x']), double.parse(element['y'])),
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
              LatLng(double.parse(element['x']), double.parse(element['y'])),
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
              LatLng(double.parse(element['x']), double.parse(element['y'])),
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
              LatLng(double.parse(element['x']), double.parse(element['y'])),
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
              LatLng(double.parse(element['x']), double.parse(element['y'])),
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

            allMarkers = shopInfoList.map((element) {
              return Marker(
                markerId: MarkerId(element['id']),
                position: LatLng(
                    double.parse(element['x']), double.parse(element['y'])),
                //icon: BitmapDescriptor.fromBytes(unitmarkers),
                infoWindow: InfoWindow(
                    title: " ${element['place_name']}",
                    onTap: () {
                      setState(() {
                        itemSelected = true;
                        model.id = element['id'];
                        model.distance = element['distance'];
                        model.addressName = element['address_name'];
                        model.placeName = element['place_name'];
                        model.phone = element['phone'];
                      });
                    }),
              );
            }).toList();

            wellhada = shopInfoList
                .where((element) => element['wellhada_yn'] == "Y")
                .map((element) {
              return Marker(
                  markerId: MarkerId(element['id']),
                  position: LatLng(
                      double.parse(element['x']), double.parse(element['y'])),
                  onTap: () {
                    setState(() {
                      itemSelected = true;

                      model.id = element['id'];

                      model.distance = element['distance'];
                      model.addressName = element['address_name'];
                      model.phone = element['phone'];
                    });
                  });
            }).toList();

            List<Marker> changeMark = selectMarker(shopInfoList);
            Map<String, dynamic> shopCategory = snapshot.data[1];
            List<dynamic> shopCategoryList = shopCategory["LIST"];
            //List<String> markerId = List<String>();

            //markerId.add(shopInfoList.map((e) => e['id']).toString());
            String mak;
            mak = shopInfoList.map((e) => e['id']).toString();

            String z = mak.substring(1, mak.length - 1);

            var split = z.split(',');
            Map<int, String> values = {
              for (int i = 0; i < split.length; i++) i: split[i],
              
            };
                            
            print(values.runtimeType);

            return Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width,
                  child: _listview(shopCategoryList),
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
                        markers: category == "all"
                            ? Set.from(allMarkers)
                            : Set.from(changeMark),
                        myLocationEnabled: true,
                        onMapCreated: (GoogleMapController controller) {
                          _controllerGoogleMap.complete(controller);

                          _controller = controller;

                          values.forEach(
                            (index, item) {
                              print(item.trim());

                              allMarkerId.add(MarkerId(item.trim()));
                              _controller
                                  .showMarkerInfoWindow(MarkerId(item.trim()));
                              _controller.isMarkerInfoWindowShown(
                                  MarkerId(item.trim()));
                            },
                          );

                          // _controller
                          //     .showMarkerInfoWindow(MarkerId());
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
