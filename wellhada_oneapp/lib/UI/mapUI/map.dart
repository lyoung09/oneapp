import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wellhada_oneapp/model/map/map_model.dart';
import 'package:wellhada_oneapp/model/map/my_location.dart';

class GoogleMapUI extends StatefulWidget {
  @override
  _GoogleMapUIState createState() => _GoogleMapUIState();
}

class _GoogleMapUIState extends State<GoogleMapUI> {
  MapModel model = new MapModel();
  Future _future;
  List<Marker> allMarkers = [];
  List<Marker> cafeMarker = [];
  List<Marker> restaurantMarker, otherMarker = [];

  GoogleMapController _controller;
  int a = 0;
  bool itemSelected;
  BitmapDescriptor mapMarker;
  MyMapModel myMapModel = new MyMapModel();
  var currentlat = 37.4835727;
  var currentlng = 126.8931279;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    //_location();
    _future = loadString();
    setCustomMarker();
  }

  void setCustomMarker() async {
    // mapMarker = await BitmapDescriptor.fromAssetImage(
    //     ImageConfiguration(size: Size(4.0, 4.0)), 'assets/data/img/cafe.PNG');
  }

  Future<String> loadString() async {
    return await rootBundle.loadString('assets/data/morelatlng.json');
  }

  Widget _container() {
    //print(model.id);
    return Material(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.18,
        width: MediaQuery.of(context).size.width * 0.7,
        decoration: BoxDecoration(border: Border.all(color: Colors.black)),
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
                      child: Image.asset(model.img)),
                ),
                Column(
                  children: [
                    Text(model.name,
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
                    Text(model.distance.toStringAsFixed(2) + 'km',
                        style: TextStyle(
                            fontFamily: 'Godo',
                            fontWeight: FontWeight.w900,
                            fontSize: 10.0,
                            color: Hexcolor('#333333')))
                  ],
                ),
              ],
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        child: FutureBuilder(
          future: _future,
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }
            List<dynamic> parsedJson = jsonDecode(snapshot.data);
            allMarkers = parsedJson.map((element) {
              return Marker(
                  markerId: MarkerId(element['id']),
                  position: LatLng(element['lat'], element['lng']),
                  icon: mapMarker,
                  // infoWindow: InfoWindow(
                  //   title: 'title :' + element['title'],
                  //   snippet: 'tel : ' + element['appPhoneNum'],

                  //   //onTap: _launchURL,
                  // ),
                  onTap: () {
                    setState(() {
                      itemSelected = true;
                      model.id = element['id'];
                      model.name = element['name'];
                      model.img = element['img'];
                      model.phone = element['phone'];
                      model.sorting = element['sorting'];
                      model.sorting = element['sorting'];
                      model.distance = Geolocator.distanceBetween(currentlat,
                              currentlng, element['lat'], element['lng']) *
                          0.001;
                    });
                  });
            }).toList();

            cafeMarker =
                parsedJson.where((map) => map['sorting'] == 1).map((element) {
              return Marker(
                  markerId: MarkerId(element['id']),
                  position: LatLng(element['lat'], element['lng']),
                  // infoWindow: InfoWindow(
                  //   title: 'title :' + element['title'],
                  //   snippet: 'tel : ' + element['appPhoneNum'],

                  //   //onTap: _launchURL,
                  // ),
                  onTap: () {
                    setState(() {
                      itemSelected = true;
                      model.id = element['id'];
                      model.name = element['name'];
                      model.img = element['img'];
                      model.phone = element['phone'];
                      model.sorting = element['sorting'];
                      model.sorting = element['sorting'];
                      model.distance = Geolocator.distanceBetween(currentlat,
                              currentlng, element['lat'], element['lng']) *
                          0.001;
                    });
                  });
            }).toList();

            restaurantMarker =
                parsedJson.where((map) => map['sorting'] == 2).map((element) {
              return Marker(
                  markerId: MarkerId(element['id']),
                  position: LatLng(element['lat'], element['lng']),
                  // infoWindow: InfoWindow(
                  //   title: 'title :' + element['title'],
                  //   snippet: 'tel : ' + element['appPhoneNum'],

                  //   //onTap: _launchURL,
                  // ),
                  onTap: () {
                    setState(() {
                      itemSelected = true;
                      model.id = element['id'];
                      model.name = element['name'];
                      model.img = element['img'];
                      model.phone = element['phone'];
                      model.sorting = element['sorting'];
                      model.sorting = element['sorting'];
                      model.distance = Geolocator.distanceBetween(currentlat,
                              currentlng, element['lat'], element['lng']) *
                          0.001;
                      //          <
                      //     1
                      // ? Geolocator.distanceBetween(37.4835727, 126.8931279,
                      //         element['lat'], element['lng']) *
                      //     10
                      // : Geolocator.distanceBetween(37.4835727, 126.8931279,
                      //         element['lat'], element['lng']) *
                      //     0.001;
                    });
                  });
            }).toList();

            otherMarker =
                parsedJson.where((map) => map['sorting'] == 3).map((element) {
              return Marker(
                  markerId: MarkerId(element['id']),
                  position: LatLng(element['lat'], element['lng']),
                  // infoWindow: InfoWindow(
                  //   title: 'title :' + element['title'],
                  //   snippet: 'tel : ' + element['appPhoneNum'],

                  //   //onTap: _launchURL,
                  // ),
                  onTap: () {
                    setState(() {
                      itemSelected = true;
                      model.id = element['id'];
                      model.name = element['name'];
                      model.img = element['img'];
                      model.phone = element['phone'];
                      model.sorting = element['sorting'];
                      model.distance = Geolocator.distanceBetween(currentlat,
                              currentlng, element['lat'], element['lng']) *
                          0.001;
                    });
                  });
            }).toList();

            return Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                        target: LatLng(currentlat, currentlng), zoom: 15.4746),
                    myLocationEnabled: true,
                    markers: a == 0
                        ? Set.of(allMarkers)
                        : a == 1
                            ? Set.of(cafeMarker)
                            : a == 2
                                ? Set.of(restaurantMarker)
                                : a == 3
                                    ? Set.of(otherMarker)
                                    : Text(''),
                    onMapCreated: mapCreated,
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipOval(
                        child: Material(
                            color: Colors.white, // button color
                            child: InkWell(
                                splashColor: Colors.black, // inkwell color
                                child: SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: Icon(Icons.add),
                                ),
                                onTap: () {
                                  setState(() {
                                    a = 0;
                                  });
                                })),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 5, right: 5),
                      ),
                      ClipOval(
                        child: Material(
                            color: Colors.white, // button color
                            child: InkWell(
                                splashColor: Colors.black, // inkwell color
                                child: SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: Icon(Icons.ac_unit),
                                ),
                                onTap: () {
                                  setState(() {
                                    a = 1;
                                    //1은 카페
                                  });
                                })),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 5, right: 5),
                      ),
                      ClipOval(
                        child: Material(
                            color: Colors.white, // button color
                            child: InkWell(
                                splashColor: Colors.black, // inkwell color
                                child: SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: Icon(Icons.zoom_out_map_outlined),
                                ),
                                onTap: () {
                                  setState(() {
                                    a = 2;
                                  });

                                  //2 레스토랑
                                })),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 5, right: 5),
                      ),
                      ClipOval(
                        child: Material(
                            color: Colors.white, // button color
                            child: InkWell(
                                splashColor: Colors.black, // inkwell color
                                child: SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: Icon(Icons.mic),
                                ),
                                onTap: () {
                                  setState(() {
                                    a = 3;
                                  });
                                })),
                      ),
                    ],
                  ),
                ),
                itemSelected == true
                    ? Align(
                        alignment: Alignment.bottomCenter, child: _container())
                    : Text("")
              ],
            );
          },
        ),
      ),
    ]);
  }

  void mapCreated(controller) {
    setState(() {
      _controller = controller;
    });
  }
}
