import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';

class ShopInfo {
  String status;
  int cnt;
  UsagePoint inFolist;
  final List<UsagePoint> list;

  ShopInfo({this.status, this.cnt, this.list, this.inFolist});

  factory ShopInfo.fromJson(Map<String, dynamic> json) => ShopInfo(
        status: json["STATUS"],
        inFolist: UsagePoint.fromJson(json["LIST"]),
        cnt: json["CNT"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "cnt": cnt,
        "list": inFolist.toJson(),
      };

  factory ShopInfo.fromJsonMap(Map<String, dynamic> json) =>
      _$ShopInfoItemFromJsonMap(json);

  Map<String, dynamic> toJsonMap() => _$ShopInfoItemToJsonMap(this);
}

ShopInfo _$ShopInfoItemFromJsonMap(Map<String, dynamic> json) {
  return ShopInfo(
    list: (json['LIST'] as List)
        ?.map((e) => e == null
            ? null
            : UsagePoint.fromJsonMap(e as Map<String, dynamic>))
        ?.toList(),
//      meta: (json['meta'] as List)
//          ?.map((e) =>
//      e == null ? null : Meta.fromJson(e as Map<String, dynamic>))
//          ?.toList()
  );
}

Map<String, dynamic> _$ShopInfoItemToJsonMap(ShopInfo instance) =>
    <String, dynamic>{'documents': instance.list};

class UsagePoint {
  String usingPoint;
  String dateTime;
  String placeName;
  String order;
  String point;

  String id;

  UsagePoint(
      {this.usingPoint,
      this.dateTime,
      this.placeName,
      this.order,
      this.point,
      this.id});
  factory UsagePoint.fromJson(Map<String, dynamic> json) => UsagePoint(
        usingPoint: json["usingPoint"],
        dateTime: json["date_time"],
        order: json["order"],
        point: json["point"],
        placeName: json['place_name'],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "usingPoint": usingPoint,
        "date_time": dateTime,
        "place_name": placeName,
        "order": order,
        "point": point,
        "id": id,
      };
  factory UsagePoint.fromJsonMap(Map<String, dynamic> json) =>
      _$UsagePointFromJsonMap(json);
  Map<String, dynamic> toJsonMap() => _$UsagePointToJsonMap(this);
}

UsagePoint _$UsagePointFromJsonMap(Map<String, dynamic> json) {
  return UsagePoint(
    usingPoint: json['usingPoint'] as String,
    placeName: json['place_name'] as String,
    dateTime: json['date_time'] as String,
    order: json['order'] as String,
    point: json['point'] as String,
    id: json['id'] as String,
  );
}

Map<String, dynamic> _$UsagePointToJsonMap(UsagePoint instance) =>
    <String, dynamic>{
      'usingPoint': instance.usingPoint,
      'place_name': instance.placeName,
      'date_time': instance.dateTime,
      'order': instance.order,
      'point': instance.point,
      'id': instance.id,
    };

Future<Map<String, dynamic>> getUsagePointList() async {
  final response = await http
      .get('https://run.mocky.io/v3/4d999cbf-6105-4a4b-a98f-b56e89d2efb7');

  if (200 == response.statusCode) {
    var datauser = json.decode(response.body);
    return datauser;
  } else {
    return json.decode(response.body);
  }
}

Future<ShopInfo> getUsagePointEntire() async {
  // http.Response response = await http.post(
  //   Uri.encodeFull('https://wellhada.com/getAppNoticeList'),
  //   headers: {"Accept": "application/json"},
  //   body: {'period': 'ALL'},
  // );
  final response = await http
      .get('https://run.mocky.io/v3/4d999cbf-6105-4a4b-a98f-b56e89d2efb7');

  if (response.statusCode == 200) {
    return ShopInfo.fromJsonMap(json.decode(response.body));
  } else {
    throw HttpException(
      'Unexpected status code ${response.statusCode}:'
      ' ${response.reasonPhrase}',
      //uri: Uri.parse(query)
    );
  }
}

/////////////////////////////////////////
/////////////////////////////////////////
/////////////////////////////////////////
////////////USERFAVORITE/////////////////
/////////////////////////////////////////
/////////////////////////////////////////
/////////////////////////////////////////
/////////////////////////////////////////
/////////////////////////////////////////

class FavoriteInfo {
  String status;
  int cnt;
  Favorite favoriteList;
  final List<Favorite> list;

  FavoriteInfo({this.status, this.cnt, this.list, this.favoriteList});

  factory FavoriteInfo.fromJson(Map<String, dynamic> json) => FavoriteInfo(
        status: json["STATUS"],
        favoriteList: Favorite.fromJson(json["LIST"]),
        cnt: json["CNT"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "cnt": cnt,
        "list": favoriteList.toJson(),
      };

  factory FavoriteInfo.fromJsonMap(Map<String, dynamic> json) =>
      _$FavoriteInfoItemFromJsonMap(json);

  Map<String, dynamic> toJsonMap() => _$FavoriteInfoItemToJsonMap(this);
}

FavoriteInfo _$FavoriteInfoItemFromJsonMap(Map<String, dynamic> json) {
  return FavoriteInfo(
    list: (json['LIST'] as List)
        ?.map((e) =>
            e == null ? null : Favorite.fromJsonMap(e as Map<String, dynamic>))
        ?.toList(),
//      meta: (json['meta'] as List)
//          ?.map((e) =>
//      e == null ? null : Meta.fromJson(e as Map<String, dynamic>))
//          ?.toList()
  );
}

Map<String, dynamic> _$FavoriteInfoItemToJsonMap(FavoriteInfo instance) =>
    <String, dynamic>{'documents': instance.list};

class Favorite {
  String placeUrl;
  String placeName;
  String roadAddressName;
  String addressName;
  String userId;
  String wellhadaShop;
  String favorite;
  String shopId;
  String phone;
  Favorite(
      {this.placeUrl,
      this.placeName,
      this.roadAddressName,
      this.addressName,
      this.shopId,
      this.userId,
      this.favorite,
      this.wellhadaShop});
  factory Favorite.fromJson(Map<String, dynamic> json) => Favorite(
        placeUrl: json["place_url"],
        roadAddressName: json["road_address_name"],
        addressName: json["address_name"],
        placeName: json['place_name'],
        shopId: json["shopId"],
        userId: json["userId"],
        favorite: json["favorite"],
        wellhadaShop: json["wellhada_shop"],
      );

  Map<String, dynamic> toJson() => {
        "place_url": placeUrl,
        "road_address_name": roadAddressName,
        "place_name": placeName,
        "address_name": addressName,
        "shopId": shopId,
        "userId": userId,
        "favorite": favorite,
        "wellhada_shop": wellhadaShop,
      };
  factory Favorite.fromJsonMap(Map<String, dynamic> json) =>
      _$FavoriteFromJsonMap(json);
  Map<String, dynamic> toJsonMap() => _$FavoriteToJsonMap(this);
}

Favorite _$FavoriteFromJsonMap(Map<String, dynamic> json) {
  return Favorite(
    placeUrl: json['place_url'] as String,
    placeName: json['place_name'] as String,
    roadAddressName: json['road_address_name'] as String,
    addressName: json['address_name'] as String,
    shopId: json['shopId'] as String,
    userId: json['userId'] as String,
    favorite: json['favorite'] as String,
    wellhadaShop: json['wellhada_shop'] as String,
  );
}

Map<String, dynamic> _$FavoriteToJsonMap(Favorite instance) =>
    <String, dynamic>{
      'place_url': instance.placeUrl,
      'place_name': instance.placeName,
      'road_address_name': instance.roadAddressName,
      'address_name': instance.addressName,
      'shopId': instance.shopId,
      'userId': instance.userId,
      'favorite': instance.favorite,
      'wellhada_shop': instance.wellhadaShop,
    };

Future<Map<String, dynamic>> getFavoriteList() async {
  final response = await http
      .get('https://run.mocky.io/v3/20c189c1-8ae8-445e-8b07-c65edad3026b');

  if (200 == response.statusCode) {
    var datauser = json.decode(response.body);
    return datauser;
  } else {
    return json.decode(response.body);
  }
}

Future<Favorite> getFavoriteEntire() async {
  // http.Response response = await http.post(
  //   Uri.encodeFull('https://wellhada.com/getAppNoticeList'),
  //   headers: {"Accept": "application/json"},
  //   body: {'period': 'ALL'},
  // );
  final response = await http
      .get('https://run.mocky.io/v3/20c189c1-8ae8-445e-8b07-c65edad3026b');

  if (response.statusCode == 200) {
    return Favorite.fromJsonMap(json.decode(response.body));
  } else {
    throw HttpException(
      'Unexpected status code ${response.statusCode}:'
      ' ${response.reasonPhrase}',
      //uri: Uri.parse(query)
    );
  }
}
