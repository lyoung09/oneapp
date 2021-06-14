// @dart=2.9
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class LatLng {
  String lat;
  String lng;

  LatLng({this.lat, this.lng});

  LatLng.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    return data;
  }
}

@JsonSerializable()
class Region {
  String coords;
  String id;
  String name;
  String zoom;

  Region({this.coords, this.id, this.name, this.zoom});

  Region.fromJson(Map<String, dynamic> json) {
    coords = json['coords'];
    id = json['id'];
    name = json['name'];
    zoom = json['zoom'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['coords'] = this.coords;
    data['id'] = this.id;
    data['name'] = this.name;
    data['zoom'] = this.zoom;
    return data;
  }
}

@JsonSerializable()
class Office {
  String address;
  String id;
  String image;
  String lat;
  String lng;
  String name;
  String phone;
  String region;

  Office(
      {this.address,
      this.id,
      this.image,
      this.lat,
      this.lng,
      this.name,
      this.phone,
      this.region});

  Office.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    id = json['id'];
    image = json['image'];
    lat = json['lat'];
    lng = json['lng'];
    name = json['name'];
    phone = json['phone'];
    region = json['region'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['id'] = this.id;
    data['image'] = this.image;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['region'] = this.region;
    return data;
  }
}

@JsonSerializable()
class Locations {
  String offices;
  String regions;

  Locations({this.offices, this.regions});

  Locations.fromJson(Map<String, dynamic> json) {
    offices = json['offices'];
    regions = json['regions'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['offices'] = this.offices;
    data['regions'] = this.regions;
    return data;
  }
}

Future<Locations> getGoogleOffices() async {
  const googleLocationsURL = 'https://about.google/static/data/locations.json';

  // Retrieve the locations of Google offices
  final response = await http.get(googleLocationsURL);
  if (response.statusCode == 200) {
    return Locations.fromJson(json.decode(response.body));
  } else {
    throw HttpException(
        'Unexpected status code ${response.statusCode}:'
        ' ${response.reasonPhrase}',
        uri: Uri.parse(googleLocationsURL));
  }
}

setMyLocation(double a, double b) async {}
Future<Locations> getGoogleEx(String path) async {
  return Locations.fromJson(jsonDecode(await rootBundle.loadString(path)));
}

Future<LatLng> getGoogleLatlng(String path) async {
  return LatLng.fromJson(jsonDecode(await rootBundle.loadString(path)));
}
