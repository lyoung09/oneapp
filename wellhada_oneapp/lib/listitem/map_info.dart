// @dart=2.9
import 'dart:convert';

import 'package:flutter/services.dart';

class more {
  int sorting;
  double lat;
  double lng;
  String id;
  String name;
  String img;
  String phone;
  String region;

  more(
      {this.sorting,
      this.lat,
      this.lng,
      this.id,
      this.name,
      this.img,
      this.phone,
      this.region});

  more.fromJson(Map<String, dynamic> json) {
    sorting = json['sorting'];
    lat = json['lat'];
    lng = json['lng'];
    id = json['id'];
    name = json['name'];
    img = json['img'];
    phone = json['phone'];
    region = json['region'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sorting'] = this.sorting;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['id'] = this.id;
    data['name'] = this.name;
    data['img'] = this.img;
    data['phone'] = this.phone;
    data['region'] = this.region;
    return data;
  }
}

Future<more> getGoogleLatlng(String path) async {
  return more.fromJson(jsonDecode(await rootBundle.loadString(path)));
}
