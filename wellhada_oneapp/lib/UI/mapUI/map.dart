import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:wellhada_oneapp/listitem/shop/shopInfoListItem.dart'
    as shopInfoListItem;

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

  Map_model model = new Map_model();

  @override
  bool get wantKeepAlive {
    return true;
  }

  Uint8List everyIcon, wellhadaIcon;
  Map<String, Uint8List> iconSet = new Map();
  Map<String, Uint8List> wellhadaIconSet = new Map();
  // button click
  String category;

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

  @override
  void initState() {
    super.initState();
    //getShowAppBar();
    //_sendLocation();
    category = "MT1";
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
    return shopInfoListItem.getShopCategoryList();
  }

  void getShop() async {
    final entireShopList =
        await shopInfoListItem.getShopInfoCategoryListEntire();

    for (int i = 0; i < entireShopList.list.length; i++) {
      wellhadaIcon =
          await getBytesFromCanvas(200, 100, entireShopList.list[i].placeName);
      wellhadaIconSet[entireShopList.list[i].id] = wellhadaIcon;
    }

    setState(() {
      shopInfoList = entireShopList.list;
    });
  }

  Future<Uint8List> getBytesFromCanvas(
      int width, int height, String title) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color = Colors.yellowAccent;
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

  // List<Marker> selectMarker(List<dynamic> shopInfoList) {
  //   return shopInfoList
  //       .where((element) => element.categoryGroupCode == category)
  //       .map((element) {
  //     return Marker(
  //         markerId: MarkerId(element.id),
  //         position: LatLng(double.parse(element.y), double.parse(element.x)),
  //         icon: BitmapDescriptor.fromBytes(iconSet[element.id]),
  //         onTap: () {
  //           setState(() {
  //             itemSelected = true;
  //             model.id = element.id;
  //             model.distance = element.distance;
  //             model.placeName = element.placeName;
  //             model.phone = element.phone;
  //           });
  //         });
  //   }).toList();
  // }

  LatLngBounds latLngBounds;
  List<Marker> nullMark = [];
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
              latLngBounds.northeast.latitude > double.parse(element.y) &&
              latLngBounds.northeast.longitude > double.parse(element.x) &&
              latLngBounds.southwest.latitude < double.parse(element.y) &&
              latLngBounds.southwest.longitude < double.parse(element.x) &&
              element.wellhadaShop == "Y")
          .map((element) {
        return Marker(
            markerId: MarkerId(element.id),
            position: LatLng(double.parse(element.y), double.parse(element.x)),
            icon: BitmapDescriptor.fromBytes(wellhadaIconSet[element.id]),
            //wellhadaIconSet[element['id']
            onTap: () {
              setState(() {
                itemSelected = true;
                model.id = element.id;
                model.distance = element.distance;
                model.placeName = element.placeName;
                model.phone = element.phone;
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
                  // child: Row(
                  //   children: [
                  // Container(
                  //     child: ClipOval(
                  //   child: Material(
                  //     color: check == true
                  //         ? Colors.yellow
                  //         : Colors.white, // button color
                  //     child: Container(
                  //       decoration: new BoxDecoration(
                  //         shape: BoxShape.circle,
                  //         border: new Border.all(
                  //           color: Colors.yellow,
                  //           width: 1.0,
                  //         ),
                  //       ),
                  //       child: InkWell(
                  //           child: SizedBox(
                  //             width: 65,
                  //             height: 55,
                  //             child: Column(
                  //               children: [
                  //                 Padding(
                  //                   padding: EdgeInsets.only(
                  //                       top: 4.0, bottom: 1.0),
                  //                 ),
                  //                 Image(
                  //                   image:
                  //                       AssetImage('assets/img/cafe.png'),
                  //                   width: 25,
                  //                   height: 25,
                  //                 ),
                  //                 Padding(
                  //                   padding: EdgeInsets.only(bottom: 1.0),
                  //                 ),
                  //                 Text(
                  //                   "가맹점",
                  //                   style: TextStyle(fontSize: 13),
                  //                 )
                  //               ],
                  //             ),
                  //           ),
                  //           onTap: () {
                  //             setState(() {
                  //               check == true
                  //                   ? check = false
                  //                   : check = true;
                  //             });
                  //           }),
                  //     ),
                  //   ),
                  // )),
                  //   Expanded(
                  //   ),
                  // ],
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
                        child: GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: _currentLocation,
                            zoom: 14.4746,
                          ),
                          rotateGesturesEnabled: false,
                          tiltGesturesEnabled: false,
                          markers: Set.from(changeWellhadaMark),
                          myLocationEnabled: true,
                          onMapCreated: (GoogleMapController controller) {
                            print(_currentLocation);
                            _controller = controller;
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
                      Positioned(
                          bottom: 0,
                          width: MediaQuery.of(context).size.width,
                          child:
                              itemSelected == true ? _container() : Text("")),
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
