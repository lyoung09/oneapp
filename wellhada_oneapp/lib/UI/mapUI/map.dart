import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wellhada_oneapp/listitem/map_item.dart' as locations;

import 'package:wellhada_oneapp/listitem/map_info.dart' as location;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wellhada_oneapp/model/map/map_model.dart';

class GoogleMapUI extends StatefulWidget {
  @override
  _GoogleMapUIState createState() => _GoogleMapUIState();
}

class _GoogleMapUIState extends State<GoogleMapUI> {
  MapModel model = new MapModel();
  Future<String> loadString() async =>
      await rootBundle.loadString('assets/data/morelatlng.json');
  Future _future;
  List<Marker> allMarkers = [];
  GoogleMapController _controller;
  bool itemSelected;
  var lat, lng;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _location();
    _future = loadString();
  }

  _location() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(position.latitude);
    print(position.longitude);
    lat = position.latitude;
    lng = position.longitude;
  }

  Widget _container() {
    //print(model.id);
    return Material(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.2,
        width: MediaQuery.of(context).size.width * 0.8,
        child: InkWell(
            onTap: () {
              setState(() {
                itemSelected = false;
              });
            },
            child: Row(
              children: [
                SizedBox(
                    height: 80, width: 80, child: Image.network(model.img)),
                Column(
                  children: [Text(model.name), Text(model.phone)],
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
        height: MediaQuery.of(context).size.height * 0.6,
        width: MediaQuery.of(context).size.width,
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
                  position: LatLng(double.parse(element['lat']),
                      double.parse(element['lng'])),
                  // infoWindow: InfoWindow(
                  //   title: 'title :' + element['title'],
                  //   snippet: 'tel : ' + element['appPhoneNum'],

                  //   //onTap: _launchURL,
                  // ),
                  onTap: () {
                    print(element['title']);

                    setState(() {
                      itemSelected = true;
                      model.id = element['id'];
                      model.name = element['name'];
                      model.img = element['img'];
                      model.phone = element['phone'];
                    });
                  });
            }).toList();

            return Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: MaterialButton(
                    onPressed: () {},
                    color: Colors.blue,
                    textColor: Colors.white,
                    child: Icon(
                      Icons.camera_alt,
                      size: 24,
                    ),
                    padding: EdgeInsets.all(16),
                    shape: CircleBorder(),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                        target: LatLng(37.4835706, 126.8931126), zoom: 15.4746),
                    markers: Set.from(allMarkers),
                    onMapCreated: mapCreated,
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
