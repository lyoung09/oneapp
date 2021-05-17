import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

//////////////////////////shopinfo//////////////////////////////
//////
///
///
///
///
///
//////////////////////////////////////////////////////////////////////////////
class ShopInfo {
  String status;
  int cnt;
  ShopInfoList inFolist;
  final List<ShopInfoList> list;

  ShopInfo({this.status, this.cnt, this.list, this.inFolist});

  factory ShopInfo.fromJson(Map<String, dynamic> json) => ShopInfo(
        status: json["STATUS"],
        inFolist: ShopInfoList.fromJson(json["LIST"]),
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
            : ShopInfoList.fromJsonMap(e as Map<String, dynamic>))
        ?.toList(),
//      meta: (json['meta'] as List)
//          ?.map((e) =>
//      e == null ? null : Meta.fromJson(e as Map<String, dynamic>))
//          ?.toList()
  );
}

Map<String, dynamic> _$ShopInfoItemToJsonMap(ShopInfo instance) =>
    <String, dynamic>{'documents': instance.list};

class ShopInfoList {
  String placeName;
  String categoryGroupName;
  String wellhadaYn;
  String distance;
  String phone;
  String categoryGroupCode;
  String x;
  String y;
  String id;

  ShopInfoList(
      {this.placeName,
      this.categoryGroupName,
      this.wellhadaYn,
      this.distance,
      this.phone,
      this.categoryGroupCode,
      this.x,
      this.y,
      this.id});
  factory ShopInfoList.fromJson(Map<String, dynamic> json) => ShopInfoList(
        placeName: json["place_name"],
        categoryGroupName: json["category_group_name"],
        distance: json["distance"],
        phone: json["phone"],
        categoryGroupCode: json["category_group_code"],
        x: json["x"],
        y: json["y"],
        wellhadaYn: json['wellhada_yn'],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "place_name": placeName,
        "category_group_name": categoryGroupName,
        "wellhada_yn": wellhadaYn,
        "distance": distance,
        "phone": phone,
        "category_group_code": categoryGroupCode,
        "x": x,
        "y": y,
        "id": id,
      };
  factory ShopInfoList.fromJsonMap(Map<String, dynamic> json) =>
      _$ShopInfoListFromJsonMap(json);
  Map<String, dynamic> toJsonMap() => _$ShopInfoListToJsonMap(this);
}

ShopInfoList _$ShopInfoListFromJsonMap(Map<String, dynamic> json) {
  return ShopInfoList(
    placeName: json['place_name'] as String,
    wellhadaYn: json['wellhadaYn'] as String,
    categoryGroupName: json['category_group_name'] as String,
    distance: json['distance'] as String,
    phone: json['phone'] as String,
    categoryGroupCode: json['category_group_code'] as String,
    x: json['x'] as String,
    y: json['y'] as String,
    id: json['id'] as String,
  );
}

Map<String, dynamic> _$ShopInfoListToJsonMap(ShopInfoList instance) =>
    <String, dynamic>{
      'place_name': instance.placeName,
      'wellhadaYn': instance.wellhadaYn,
      'category_group_name': instance.categoryGroupName,
      'distance': instance.distance,
      'phone': instance.phone,
      'category_group_code': instance.categoryGroupCode,
      'x': instance.x,
      'y': instance.y,
      'id': instance.id,
    };

Future<Map<String, dynamic>> getShopInfoList() async {
  final response = await http
      .get('https://run.mocky.io/v3/188eca15-e4af-4b1f-bad8-a9f3c6060966');
  //.get('192.168.0.35:8080/getShopInfoList?lat=126.89300592139&lon=37.4835140850512&radius=1000&appId=com.hndsolution.wellhada');

  if (200 == response.statusCode) {
    var datauser = json.decode(response.body);
    return datauser;
  } else {
    return json.decode(response.body);
  }
}

Future<ShopInfo> getShopInfoListEntire() async {
  // http.Response response = await http.post(
  //   Uri.encodeFull('https://wellhada.com/getAppNoticeList'),
  //   headers: {"Accept": "application/json"},
  //   body: {'period': 'ALL'},
  // );
  final response = await http
      //.get('https://run.mocky.io/v3/26deeae0-46b1-49de-8ca4-c3ef28bbf906');
      //.get('https://run.mocky.io/v3/4215498a-dd9f-4473-9ebf-fc6981b5002b');
      .get('https://run.mocky.io/v3/188eca15-e4af-4b1f-bad8-a9f3c6060966');

  //.get('192.168.0.35:8080/getShopInfoList?lat=126.89300592139&lon=37.4835140850512&radius=1000&appId=com.hndsolution.wellhada');
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

//////////////////////////shopinfokeyword//////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
//////
//////
//////
//////
//////
class ShopInfokeyword {
  String status;
  int cnt;
  ShopInfokeywordList infolist;
  final List<ShopInfokeywordList> list;

  ShopInfokeyword({this.status, this.cnt, this.list, this.infolist});

  factory ShopInfokeyword.fromJson(Map<String, dynamic> json) =>
      ShopInfokeyword(
        status: json["STATUS"],
        infolist: ShopInfokeywordList.fromJson(json["LIST"]),
        cnt: json["CNT"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "cnt": cnt,
        "list": infolist.toJson(),
      };

  factory ShopInfokeyword.fromJsonMap(Map<String, dynamic> json) =>
      _$ShopInfokeywordFromJsonMap(json);

  Map<String, dynamic> toJsonMap() => _$ShopInfokeywordToJsonMap(this);
}

ShopInfokeyword _$ShopInfokeywordFromJsonMap(Map<String, dynamic> json) {
  return ShopInfokeyword(
    list: (json['LIST'] as List)
        ?.map((e) => e == null
            ? null
            : ShopInfokeywordList.fromJsonMap(e as Map<String, dynamic>))
        ?.toList(),
//      meta: (json['meta'] as List)
//          ?.map((e) =>
//      e == null ? null : Meta.fromJson(e as Map<String, dynamic>))
//          ?.toList()
  );
}

Map<String, dynamic> _$ShopInfokeywordToJsonMap(ShopInfokeyword instance) =>
    <String, dynamic>{'documents': instance.list};

class ShopInfokeywordList {
  String placeUrl;
  String placeName;
  String categoryGroupName;
  String roadAddressName;
  String categoryName;
  String distance;
  String phone;
  String categoryGroupCode;
  String x;
  String y;
  String addressName;
  String id;
  String wellhadaShop;

  ShopInfokeywordList(
      {this.placeUrl,
      this.placeName,
      this.categoryGroupName,
      this.roadAddressName,
      this.categoryName,
      this.distance,
      this.phone,
      this.categoryGroupCode,
      this.x,
      this.y,
      this.addressName,
      this.id,
      this.wellhadaShop});

  ShopInfokeywordList.fromJson(Map<String, dynamic> json) {
    placeUrl = json['place_url'];
    placeName = json['place_name'];
    categoryGroupName = json['category_group_name'];
    roadAddressName = json['road_address_name'];
    categoryName = json['category_name'];
    distance = json['distance'];
    phone = json['phone'];
    categoryGroupCode = json['category_group_code'];
    x = json['x'];
    y = json['y'];
    addressName = json['address_name'];
    id = json['id'];
    wellhadaShop = json['wellhada_shop'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['place_url'] = this.placeUrl;
    data['place_name'] = this.placeName;
    data['category_group_name'] = this.categoryGroupName;
    data['road_address_name'] = this.roadAddressName;
    data['category_name'] = this.categoryName;
    data['distance'] = this.distance;
    data['phone'] = this.phone;
    data['category_group_code'] = this.categoryGroupCode;
    data['x'] = this.x;
    data['y'] = this.y;
    data['address_name'] = this.addressName;
    data['id'] = this.id;
    data['wellhada_shop'] = this.wellhadaShop;
    return data;
  }

  factory ShopInfokeywordList.fromJsonMap(Map<String, dynamic> json) =>
      _$ShopInfokeywordListFromJsonMap(json);
  Map<String, dynamic> toJsonMap() => _$ShopInfokeywordListToJsonMap(this);
}

ShopInfokeywordList _$ShopInfokeywordListFromJsonMap(
    Map<String, dynamic> json) {
  return ShopInfokeywordList(
    placeUrl: json['place_url'] as String,
    wellhadaShop: json['wellhada_shop'] as String,
    roadAddressName: json['road_address_name'] as String,
    categoryName: json['category_name'] as String,
    addressName: json['address_name'] as String,
    placeName: json['place_name'] as String,
    categoryGroupName: json['category_group_name'] as String,
    distance: json['distance'] as String,
    phone: json['phone'] as String,
    categoryGroupCode: json['category_group_code'] as String,
    x: json['x'] as String,
    y: json['y'] as String,
    id: json['id'] as String,
  );
}

Map<String, dynamic> _$ShopInfokeywordListToJsonMap(
        ShopInfokeywordList instance) =>
    <String, dynamic>{
      'place_url': instance.placeUrl,
      'road_address_name': instance.roadAddressName,
      'category_name': instance.categoryGroupName,
      'address_name': instance.addressName,
      'place_name': instance.placeName,
      'wellhada_shop': instance.wellhadaShop,
      'category_group_name': instance.categoryGroupName,
      'distance': instance.distance,
      'phone': instance.phone,
      'category_group_code': instance.categoryGroupCode,
      'x': instance.x,
      'y': instance.y,
      'id': instance.id,
    };

Future<Map<String, dynamic>> getShopInfokeywordList() async {
  final response = await http
      .get('https://run.mocky.io/v3/6b662698-5c0b-4db8-8784-9d92813d34f5');

  //.get('192.168.0.35:8080/getShopInfokeywordList?lat=126.89300592139&lon=37.4835140850512&radius=1000&appId=com.hndsolution.wellhada&category_code=MT1&query=이마트');
  if (200 == response.statusCode) {
    var datauser = json.decode(response.body);

    return datauser;
  } else {
    return json.decode(response.body);
  }
}

Future<ShopInfokeyword> getShopInfoKeywordEntire() async {
  // http.Response response = await http.post(
  //   Uri.encodeFull('https://wellhada.com/getAppNoticeList'),
  //   headers: {"Accept": "application/json"},
  //   body: {'period': 'ALL'},
  // );
  final response = await http
      //.get('https://run.mocky.io/v3/26deeae0-46b1-49de-8ca4-c3ef28bbf906');
      //.get('https://run.mocky.io/v3/4215498a-dd9f-4473-9ebf-fc6981b5002b');
      .get('https://run.mocky.io/v3/6b662698-5c0b-4db8-8784-9d92813d34f5');

  //.get('192.168.0.35:8080/getShopInfoList?lat=126.89300592139&lon=37.4835140850512&radius=1000&appId=com.hndsolution.wellhada');
  if (response.statusCode == 200) {
    return ShopInfokeyword.fromJsonMap(json.decode(response.body));
  } else {
    throw HttpException(
      'Unexpected status code ${response.statusCode}:'
      ' ${response.reasonPhrase}',
      //uri: Uri.parse(query)
    );
  }
}

//////////////////////////////////////shopinfocategory//////////////////////
///
///
///
///
///
///
//////////////////////////////////////////////////////////////////////////////
class ShopInfoCategory {
  String status;
  ShopInfoCategoryList infolist;
  int cnt;
  final List<ShopInfoCategoryList> list;

  ShopInfoCategory({this.status, this.list, this.cnt, this.infolist});

  factory ShopInfoCategory.fromJson(Map<String, dynamic> json) =>
      ShopInfoCategory(
        status: json["STATUS"],
        infolist: ShopInfoCategoryList.fromJson(json["LIST"]),
        cnt: json["CNT"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "cnt": cnt,
        "list": infolist.toJson(),
      };
  factory ShopInfoCategory.fromJsonMap(Map<String, dynamic> json) =>
      _$ShopInfoCategoryFromJsonMap(json);

  Map<String, dynamic> toJsonMap() => _$ShopInfoCategoryToJsonMap(this);
}

ShopInfoCategory _$ShopInfoCategoryFromJsonMap(Map<String, dynamic> json) {
  return ShopInfoCategory(
    list: (json['LIST'] as List)
        ?.map((e) => e == null
            ? null
            : ShopInfoCategoryList.fromJsonMap(e as Map<String, dynamic>))
        ?.toList(),
//      meta: (json['meta'] as List)
//          ?.map((e) =>
//      e == null ? null : Meta.fromJson(e as Map<String, dynamic>))
//          ?.toList()
  );
}

Map<String, dynamic> _$ShopInfoCategoryToJsonMap(ShopInfoCategory instance) =>
    <String, dynamic>{'documents': instance.list};

class ShopInfoCategoryList {
  String placeUrl;
  String placeName;
  String categoryGroupName;
  String roadAddressName;
  String categoryName;
  String distance;
  String phone;
  String categoryGroupCode;
  String x;
  String y;
  String addressName;
  String id;
  String wellhadaShop;

  ShopInfoCategoryList({
    this.placeUrl,
    this.placeName,
    this.categoryGroupName,
    this.roadAddressName,
    this.distance,
    this.categoryName,
    this.phone,
    this.categoryGroupCode,
    this.x,
    this.y,
    this.addressName,
    this.id,
    this.wellhadaShop,
  });

  factory ShopInfoCategoryList.fromJson(Map<String, dynamic> json) =>
      ShopInfoCategoryList(
        placeUrl: json["place_url"],
        placeName: json["place_name"],
        categoryGroupName: json["category_group_name"],
        roadAddressName: json["road_address_name"],
        categoryName: json["category_name"],
        distance: json["distance"],
        phone: json["phone"],
        categoryGroupCode: json["category_group_code"],
        x: json["x"],
        y: json["y"],
        addressName: json["address_name"],
        id: json["id"],
        wellhadaShop: json["wellhada_shop"],
      );

  Map<String, dynamic> toJson() => {
        "place_url": placeUrl,
        "place_name": placeName,
        "category_group_name": categoryGroupName,
        "road_address_name": roadAddressName,
        "category_name": categoryName,
        "distance": distance,
        "phone": phone,
        "category_group_code": categoryGroupCode,
        "x": x,
        "y": y,
        "addressName": addressName,
        "id": id,
        "wellhada_shop": wellhadaShop,
      };

  factory ShopInfoCategoryList.fromJsonMap(Map<String, dynamic> json) =>
      _$ShopInfoCategoryListFromJsonMap(json);
  Map<String, dynamic> toJsonMap() => _$ShopInfoCategoryListToJsonMap(this);
}

ShopInfoCategoryList _$ShopInfoCategoryListFromJsonMap(
    Map<String, dynamic> json) {
  return ShopInfoCategoryList(
    placeName: json['place_name'] as String,
    wellhadaShop: json['wellhada_shop'] as String,
    categoryGroupName: json['category_group_name'] as String,
    distance: json['distance'] as String,
    phone: json['phone'] as String,
    categoryGroupCode: json['category_group_code'] as String,
    x: json['x'] as String,
    y: json['y'] as String,
    id: json['id'] as String,
    placeUrl: json['place_url'] as String,
    addressName: json['address_name'] as String,
    roadAddressName: json['road_address_name'] as String,
    categoryName: json['category_name'] as String,
  );
}

Map<String, dynamic> _$ShopInfoCategoryListToJsonMap(
        ShopInfoCategoryList instance) =>
    <String, dynamic>{
      'place_name': instance.placeName,
      'wellhada_shop': instance.wellhadaShop,
      'category_group_name': instance.categoryGroupName,
      'distance': instance.distance,
      'phone': instance.phone,
      'category_group_code': instance.categoryGroupCode,
      'x': instance.x,
      'y': instance.y,
      'id': instance.id,
      'place_url': instance.placeUrl,
      'address_name': instance.addressName,
      'road_address_name': instance.roadAddressName,
      'category_name': instance.categoryName
    };

Future<Map<String, dynamic>> getShopInfoCategoryList() async {
  final response = await http
      //    .get('https://run.mocky.io/v3/c5cb3e9e-b58d-4d1d-95b3-daa77d5c0617');
      //.get('https://run.mocky.io/v3/cdd16867-7a32-4335-a02e-b0f0fba54a3e');
      .get('https://run.mocky.io/v3/a2fdeec4-f539-43ad-8f17-ce45b7cfa265');

  //.get('192.168.0.35:8080/getShopInfoCategoryList?lat=126.89300592139&lon=37.4835140850512&radius=1000&appId=com.hndsolution.wellhada&category_code=MT1');
  if (200 == response.statusCode) {
    var datauser = json.decode(response.body);

    return datauser;
  } else {
    return json.decode(response.body);
  }
}

Future<ShopInfoCategory> getShopInfoCategoryListEntire() async {
  // http.Response response = await http.post(
  //   Uri.encodeFull('https://wellhada.com/getAppNoticeList'),
  //   headers: {"Accept": "application/json"},
  //   body: {'period': 'ALL'},
  // );
  final response = await http
      //.get('https://run.mocky.io/v3/26deeae0-46b1-49de-8ca4-c3ef28bbf906');
      //.get('https://run.mocky.io/v3/4215498a-dd9f-4473-9ebf-fc6981b5002b');
      //.get('https://run.mocky.io/v3/4215498a-dd9f-4473-9ebf-fc6981b5002b');
      .get('https://run.mocky.io/v3/a2fdeec4-f539-43ad-8f17-ce45b7cfa265');
  //.get('https://run.mocky.io/v3/a0b52afe-c1ab-477a-a869-3a7a8ec51eca');
  //.get(    '192.168.0.35:8080/getShopInfoList?lat=126.89300592139&lon=37.4835140850512&radius=1000&appId=com.hndsolution.wellhada');
  if (response.statusCode == 200) {
    return ShopInfoCategory.fromJsonMap(json.decode(response.body));
  } else {
    throw HttpException(
      'Unexpected status code ${response.statusCode}:'
      ' ${response.reasonPhrase}',
      //uri: Uri.parse(query)
    );
  }
}

///////////////////////////////////////////////shopcategory//////////////////////////////////////
//////
///
///
///
///
///
//////////////////////////////////////////////////////////////////////////////
class ShopCategory {
  String status;
  int cnt;
  ShopCategoryList infolist;
  final List<ShopCategoryList> list;
  ShopCategory({this.status, this.cnt, this.list, this.infolist});

  factory ShopCategory.fromJson(Map<String, dynamic> json) => ShopCategory(
        status: json["STATUS"],
        infolist: ShopCategoryList.fromJson(json["LIST"]),
        cnt: json["CNT"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "cnt": cnt,
        "list": infolist.toJson(),
      };
  factory ShopCategory.fromJsonMap(Map<String, dynamic> json) =>
      _$ShopCategoryFromJsonMap(json);

  Map<String, dynamic> toJsonMap() => _$SShopCategoryToJsonMap(this);
}

ShopCategory _$ShopCategoryFromJsonMap(Map<String, dynamic> json) {
  return ShopCategory(
    list: (json['LIST'] as List)
        ?.map((e) => e == null
            ? null
            : ShopCategoryList.fromJsonMap(e as Map<String, dynamic>))
        ?.toList(),
//      meta: (json['meta'] as List)
//          ?.map((e) =>
//      e == null ? null : Meta.fromJson(e as Map<String, dynamic>))
//          ?.toList()
  );
}

Map<String, dynamic> _$SShopCategoryToJsonMap(ShopCategory instance) =>
    <String, dynamic>{'documents': instance.list};

class ShopCategoryList {
  String categorycdnm;
  String categorycd;
  String fileurl;

  ShopCategoryList({this.categorycdnm, this.categorycd, this.fileurl});

  factory ShopCategoryList.fromJson(Map<String, dynamic> json) =>
      ShopCategoryList(
        categorycdnm: json["CATEGORY_CDNM"],
        categorycd: json["CATEGORY_CD"],
        fileurl: json["FILE_URL"],
      );

  Map<String, dynamic> toJson() => {
        "CATEGORY_CDNM": categorycdnm,
        "CATEGORY_CD": categorycd,
        "FILE_URL": fileurl,
      };

  factory ShopCategoryList.fromJsonMap(Map<String, dynamic> json) =>
      _$ShopCategoryListFromJsonMap(json);
  Map<String, dynamic> toJsonMap() => _$ShopCategoryListToJsonMap(this);
}

ShopCategoryList _$ShopCategoryListFromJsonMap(Map<String, dynamic> json) {
  return ShopCategoryList(
    categorycdnm: json['CATEGORY_CDNM'] as String,
    categorycd: json['CATEGORY_CD'] as String,
    fileurl: json['FILE_URL'] as String,
  );
}

Map<String, dynamic> _$ShopCategoryListToJsonMap(ShopCategoryList instance) =>
    <String, dynamic>{
      'CATEGORY_CDNM': instance.categorycdnm,
      'CATEGORY_CD': instance.categorycd,
      'FILE_URL': instance.fileurl,
    };

Future<Map<String, dynamic>> getShopCategoryList() async {
  final response = await http
      .get('https://run.mocky.io/v3/1024fe77-a133-4303-a5be-6f6cb30be711');
  //.get('https://192.168.0.35:8080/getShopCategoryList');

  if (200 == response.statusCode) {
    var datauser = json.decode(response.body);
    return datauser;
  } else {
    return json.decode(response.body);
  }
}

Future<ShopCategory> getShopCategoryEntire() async {
  // http.Response response = await http.post(
  //   Uri.encodeFull('https://wellhada.com/getAppNoticeList'),
  //   headers: {"Accept": "application/json"},
  //   body: {'period': 'ALL'},
  // );
  final response = await http
      //.get('https://run.mocky.io/v3/26deeae0-46b1-49de-8ca4-c3ef28bbf906');
      //.get('https://run.mocky.io/v3/4215498a-dd9f-4473-9ebf-fc6981b5002b');
      .get('https://run.mocky.io/v3/1024fe77-a133-4303-a5be-6f6cb30be711');

  //.get('https://192.168.0.35:8080/getShopInfoList?lat=126.89300592139&lon=37.4835140850512&radius=1000&appId=com.hndsolution.wellhada');
  if (response.statusCode == 200) {
    return ShopCategory.fromJsonMap(json.decode(response.body));
  } else {
    throw HttpException(
      'Unexpected status code ${response.statusCode}:'
      ' ${response.reasonPhrase}',
      //uri: Uri.parse(query)
    );
  }
}

Future<Map<String, dynamic>> getShopDetailCategoryList(String category) async {
  var bodyParam = new Map();
  bodyParam['CATEGORY_CD'] = category;

  final response = await http
      .get('https://run.mocky.io/v3/1024fe77-a133-4303-a5be-6f6cb30be711');
  //.get('https://192.168.0.35:8080/getShopCategoryList');

  if (200 == response.statusCode) {
    var datauser = json.decode(response.body);
    return datauser;
  } else {
    return json.decode(response.body);
  }
}

// Future<ShopInfo> getAppbarList() async {
//   // http.Response response = await http.post(
//   //   Uri.encodeFull('https://wellhada.com/getAppNoticeList'),
//   //   headers: {"Accept": "application/json"},
//   //   body: {'period': 'ALL'},
//   // );
//   final response = await http
//       .get('https://run.mocky.io/v3/188eca15-e4af-4b1f-bad8-a9f3c6060966');
//   //.get('192.168.0.35:8080/getShopInfoList?lat=126.89300592139&lon=37.4835140850512&radius=1000&appId=com.hndsolution.wellhada');
//   if (response.statusCode == 200) {
//     return ShopInfo.fromJsonMap(json.decode(response.body));
//   } else {
//     throw HttpException(
//       'Unexpected status code ${response.statusCode}:'
//       ' ${response.reasonPhrase}',
//       //uri: Uri.parse(query)
//     );
//   }
// }

/////////////////////////////////////////////////
/////////////////////////////////////////////////
/////////////////////////////////////////////////
/////////////////////////////////////////////////
/////////////////////////////////////////////////
/////////////////////////////////////////////////
/////////////////////////////////////////////////
/////////////////////////////////////////////////
///
///실제 서버
///
///
///

/////////////////////////////
/////////////////////////////
/////////////////////////////
/////////////////////////////
/////////////////////////////
///////shop list/////////
/////////////////////////////
/////////////////////////////
/////////////////////////////
/////////////////////////////
/////////////////////////////

class ShopList {
  String status;
  int cnt;
  ShopListDetail inFolist;
  final List<ShopListDetail> list;

  ShopList({this.status, this.cnt, this.list, this.inFolist});

  factory ShopList.fromJson(Map<String, dynamic> json) => ShopList(
        status: json["STATUS"],
        inFolist: ShopListDetail.fromJson(json["LIST"]),
        cnt: json["CNT"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "cnt": cnt,
        "list": inFolist.toJson(),
      };

  factory ShopList.fromJsonMap(Map<String, dynamic> json) =>
      _$ShopListItemFromJsonMap(json);

  Map<String, dynamic> toJsonMap() => _$ShopListItemToJsonMap(this);
}

ShopList _$ShopListItemFromJsonMap(Map<String, dynamic> json) {
  return ShopList(
    list: (json['LIST'] as List)
        ?.map((e) => e == null
            ? null
            : ShopListDetail.fromJsonMap(e as Map<String, dynamic>))
        ?.toList(),
//      meta: (json['meta'] as List)
//          ?.map((e) =>
//      e == null ? null : Meta.fromJson(e as Map<String, dynamic>))
//          ?.toList()
  );
}

Map<String, dynamic> _$ShopListItemToJsonMap(ShopList instance) =>
    <String, dynamic>{'documents': instance.list};

class ShopListDetail {
  String weekBeginTime;
  String weekEndTime;
  String addressDetail;
  String categoryGroupCode;
  String phone;
  int regDate;
  String shopDc;
  String bsnEndTime;
  String telnoHideAt;
  String telDispAt;
  String placeName;
  String bizrno;
  String fileUrl;
  int regUserSeq;
  int shopSeq;
  int updUserSeq;
  String tmplatCd;
  String address;
  String addressZip;
  String shopDcDispAt;
  String bsnBeginTime;
  String phoneOther;
  int userSeq;
  int updDate;
  int fileSeq;
  double latitude;
  double longtitude;
  ShopListDetail(
      {this.weekBeginTime,
      this.weekEndTime,
      this.addressDetail,
      this.categoryGroupCode,
      this.phone,
      this.regDate,
      this.shopDc,
      this.bsnEndTime,
      this.telnoHideAt,
      this.telDispAt,
      this.placeName,
      this.bizrno,
      this.fileUrl,
      this.regUserSeq,
      this.shopSeq,
      this.updUserSeq,
      this.tmplatCd,
      this.address,
      this.addressZip,
      this.shopDcDispAt,
      this.bsnBeginTime,
      this.phoneOther,
      this.userSeq,
      this.updDate,
      this.fileSeq,
      this.latitude,
      this.longtitude});
  factory ShopListDetail.fromJson(Map<String, dynamic> json) => ShopListDetail(
        weekBeginTime:
            json["WEEK_BEGIN_TIME"] == null ? null : json["WEEK_BEGIN_TIME"],
        weekEndTime:
            json["WEEK_END_TIME"] == null ? null : json["WEEK_END_TIME"],
        addressDetail:
            json["ADDRESS_DETAIL"] == null ? null : json["ADDRESS_DETAIL"],
        categoryGroupCode: json["CATEGORY_CODE"],
        phone: json["PHONE"] == null ? null : json["PHONE"],
        regDate: json["REG_DATE"] == null ? null : json["REG_DATE"],
        shopDc: json["SHOP_DC"] == null ? null : json["SHOP_DC"],
        bsnEndTime: json["BSN_END_TIME"] == null ? null : json["BSN_END_TIME"],
        telnoHideAt:
            json["TELNO_HIDE_AT"] == null ? null : json["TELNO_HIDE_AT"],
        telDispAt: json["TEL_DISP_AT"] == null ? null : json["TEL_DISP_AT"],
        placeName: json["PLACE_NAME"],
        bizrno: json["BIZRNO"] == null ? null : json["BIZRNO"],
        fileUrl: json["FILE_URL"] == null ? null : json["FILE_URL"],
        regUserSeq: json["REG_USER_SEQ"] == null ? null : json["REG_USER_SEQ"],
        shopSeq: json["SHOP_SEQ"] == null ? null : json["SHOP_SEQ"],
        updUserSeq: json["UPD_USER_SEQ"] == null ? null : json["UPD_USER_SEQ"],
        tmplatCd: json["TMPLAT_CD"] == null ? null : json["TMPLAT_CD"],
        address: json["ADDRESS"] == null ? null : json["ADDRESS"],
        addressZip: json["ADDRESS_ZIP"] == null ? null : json["ADDRESS_ZIP"],
        shopDcDispAt:
            json["SHOP_DC_DISP_AT"] == null ? null : json["SHOP_DC_DISP_AT"],
        bsnBeginTime:
            json["BSN_BEGIN_TIME"] == null ? null : json["BSN_BEGIN_TIME"],
        phoneOther: json["PHONE_OTHER"] == null ? null : json["PHONE_OTHER"],
        userSeq: json["USER_SEQ"] == null ? null : json["USER_SEQ"],
        updDate: json["UPD_DATE"] == null ? null : json["UPD_DATE"],
        fileSeq: json["FILE_SEQ"] == null ? null : json["FILE_SEQ"],
        latitude: json["LATITUDE"],
        longtitude: json["LONGITUDE"],
      );

  Map<String, dynamic> toJson() => {
        "WEEK_BEGIN_TIME": weekBeginTime == null ? null : weekBeginTime,
        "WEEK_END_TIME": weekEndTime == null ? null : weekEndTime,
        "ADDRESS_DETAIL": addressDetail == null ? null : addressDetail,
        "CATEGORY_CODE": categoryGroupCode,
        "PHONE": phone == null ? null : phone,
        "REG_DATE": regDate == null ? null : regDate,
        "SHOP_DC": shopDc == null ? null : shopDc,
        "BSN_END_TIME": bsnEndTime == null ? null : bsnEndTime,
        "TELNO_HIDE_AT": telnoHideAt == null ? null : telnoHideAt,
        "TEL_DISP_AT": telDispAt == null ? null : telDispAt,
        "PLACE_NAME": placeName,
        "BIZRNO": bizrno == null ? null : bizrno,
        "FILE_URL": fileUrl == null ? null : fileUrl,
        "REG_USER_SEQ": regUserSeq == null ? null : regUserSeq,
        "SHOP_SEQ": shopSeq == null ? null : shopSeq,
        "UPD_USER_SEQ": updUserSeq == null ? null : updUserSeq,
        "TMPLAT_CD": tmplatCd == null ? null : tmplatCd,
        "ADDRESS": address == null ? null : address,
        "ADDRESS_ZIP": addressZip == null ? null : addressZip,
        "SHOP_DC_DISP_AT": shopDcDispAt == null ? null : shopDcDispAt,
        "BSN_BEGIN_TIME": bsnBeginTime == null ? null : bsnBeginTime,
        "PHONE_OTHER": phoneOther == null ? null : phoneOther,
        "USER_SEQ": userSeq == null ? null : userSeq,
        "UPD_DATE": updDate == null ? null : updDate,
        "FILE_SEQ": fileSeq == null ? null : fileSeq,
        "LATITUDE": latitude,
        "LONGITUDE": longtitude,
      };

  factory ShopListDetail.fromJsonMap(Map<String, dynamic> json) =>
      _$ShopListDetailFromJsonMap(json);
  Map<String, dynamic> toJsonMap() => _$ShopListDetailToJsonMap(this);
}

ShopListDetail _$ShopListDetailFromJsonMap(Map<String, dynamic> json) {
  return ShopListDetail(
    weekBeginTime: json["WEEK_BEGIN_TIME"] == null
        ? null
        : json["WEEK_BEGIN_TIME"] as String,
    weekEndTime:
        json["WEEK_END_TIME"] == null ? null : json["WEEK_END_TIME"] as String,
    addressDetail: json["ADDRESS_DETAIL"] == null
        ? null
        : json["ADDRESS_DETAIL"] as String,
    categoryGroupCode: json["CATEGORY_CODE"] as String,
    phone: json["PHONE"] == null ? null : json["PHONE"] as String,
    regDate: json["REG_DATE"] == null ? null : json["REG_DATE"] as int,
    shopDc: json["SHOP_DC"] == null ? null : json["SHOP_DC"] as String,
    bsnEndTime:
        json["BSN_END_TIME"] == null ? null : json["BSN_END_TIME"] as String,
    telnoHideAt:
        json["TELNO_HIDE_AT"] == null ? null : json["TELNO_HIDE_AT"] as String,
    telDispAt:
        json["TEL_DISP_AT"] == null ? null : json["TEL_DISP_AT"] as String,
    placeName: json["PLACE_NAME"] as String,
    bizrno: json["BIZRNO"] == null ? null : json["BIZRNO"] as String,
    fileUrl: json["FILE_URL"] == null ? null : json["FILE_URL"] as String,
    regUserSeq:
        json["REG_USER_SEQ"] == null ? null : json["REG_USER_SEQ"] as int,
    shopSeq: json["SHOP_SEQ"] == null ? null : json["SHOP_SEQ"] as int,
    updUserSeq:
        json["UPD_USER_SEQ"] == null ? null : json["UPD_USER_SEQ"] as int,
    tmplatCd: json["TMPLAT_CD"] == null ? null : json["TMPLAT_CD"] as String,
    address: json["ADDRESS"] == null ? null : json["ADDRESS"] as String,
    addressZip:
        json["ADDRESS_ZIP"] == null ? null : json["ADDRESS_ZIP"] as String,
    shopDcDispAt: json["SHOP_DC_DISP_AT"] == null
        ? null
        : json["SHOP_DC_DISP_AT"] as String,
    bsnBeginTime: json["BSN_BEGIN_TIME"] == null
        ? null
        : json["BSN_BEGIN_TIME"] as String,
    phoneOther:
        json["PHONE_OTHER"] == null ? null : json["PHONE_OTHER"] as String,
    userSeq: json["USER_SEQ"] == null ? null : json["USER_SEQ"] as int,
    updDate: json["UPD_DATE"] == null ? null : json["UPD_DATE"] as int,
    fileSeq: json["FILE_SEQ"] == null ? null : json["FILE_SEQ"] as int,
    latitude: json["LATITUDE"] as double,
    longtitude: json["LONGITUDE"] as double,
  );
}

Map<String, dynamic> _$ShopListDetailToJsonMap(ShopListDetail instance) =>
    <String, dynamic>{
      'WEEK_BEGIN_TIME':
          instance.weekBeginTime == null ? null : instance.weekBeginTime,
      'WEEK_END_TIME':
          instance.weekEndTime == null ? null : instance.weekEndTime,
      'ADDRESS_DETAIL': instance.addressDetail,
      'CATEGORY_CODE': instance.categoryGroupCode,
      'PHONE': instance.phone == null ? null : instance.phone,
      'REG_DATE': instance.regDate == null ? null : instance.regDate,
      'SHOP_DC': instance.shopDc == null ? null : instance.shopDc,
      'BSN_END_TIME': instance.bsnEndTime == null ? null : instance.bsnEndTime,
      'TELNO_HIDE_AT':
          instance.telnoHideAt == null ? null : instance.telnoHideAt,
      'PLACE_NAME': instance.placeName,
      'TEL_DISP_AT': instance.telnoHideAt == null ? null : instance.telnoHideAt,
      'BIZRNO': instance.bizrno == null ? null : instance.bizrno,
      'FILE_URL': instance.fileUrl == null ? null : instance.fileUrl,
      'REG_USER_SEQ': instance.regUserSeq == null ? null : instance.regUserSeq,
      'SHOP_SEQ': instance.shopSeq == null ? null : instance.shopSeq,
      'UPD_USER_SEQ': instance.updUserSeq == null ? null : instance.updUserSeq,
      'TMPLAT_CD': instance.tmplatCd == null ? null : instance.tmplatCd,
      'ADDRESS': instance.address == null ? null : instance.address,
      'ADDRESS_ZIP': instance.addressZip == null ? null : instance.addressZip,
      'SHOP_DC_DISP_AT':
          instance.shopDcDispAt == null ? null : instance.shopDcDispAt,
      'BSN_BEGIN_TIME':
          instance.bsnBeginTime == null ? null : instance.bsnBeginTime,
      'PHONE_OTHER': instance.phoneOther == null ? null : instance.phoneOther,
      'USER_SEQ': instance.userSeq == null ? null : instance.userSeq,
      'UPD_DATE': instance.updDate == null ? null : instance.updDate,
      'FILE_SEQ': instance.fileSeq == null ? null : instance.fileSeq,
      'LATITUDE': instance.latitude,
      'LONGITUDE': instance.longtitude,
    };

Future<Map<String, dynamic>> getShopList() async {
  final response = await http.get('http://192.168.0.47:8080/getShopList');

  if (200 == response.statusCode) {
    var datauser = json.decode(response.body);
    return datauser;
  } else {
    return json.decode(response.body);
  }
}

Future<ShopList> getShopListEntire() async {
  // http.Response response = await http.post(
  //   Uri.encodeFull('https://wellhada.com/getAppNoticeList'),
  //   headers: {"Accept": "application/json"},
  //   body: {'period': 'ALL'},
  // );

  final response = await http.get('http://192.168.0.47:8080/getShopList');
  // final response = await http
  //     .get('https://run.mocky.io/v3/df690ee8-61d0-4cd5-b616-304d166d5b83');

  if (response.statusCode == 200) {
    return ShopList.fromJsonMap(json.decode(response.body));
  } else {
    print(2);
    throw HttpException(
      'Unexpected status code ${response.statusCode}:'
      ' ${response.reasonPhrase}',
      //uri: Uri.parse(query)
    );
  }
}

/////////////////////////////
/////////////////////////////
/////////////////////////////
/////////////////////////////
/////////////////////////////
///////shop category/////////
/////////////////////////////
/////////////////////////////
/////////////////////////////
/////////////////////////////
/////////////////////////////

class ShopCode {
  String status;
  int cnt;
  ShopCodeList infolist;
  final List<ShopCodeList> list;
  ShopCode({this.status, this.cnt, this.list, this.infolist});

  factory ShopCode.fromJson(Map<String, dynamic> json) => ShopCode(
        status: json["STATUS"],
        infolist: ShopCodeList.fromJson(json["LIST"]),
        cnt: json["CNT"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "cnt": cnt,
        "list": infolist.toJson(),
      };
  factory ShopCode.fromJsonMap(Map<String, dynamic> json) =>
      _$ShopCodeFromJsonMap(json);

  Map<String, dynamic> toJsonMap() => _$SShopCodeToJsonMap(this);
}

ShopCode _$ShopCodeFromJsonMap(Map<String, dynamic> json) {
  return ShopCode(
    list: (json['LIST'] as List)
        ?.map((e) => e == null
            ? null
            : ShopCodeList.fromJsonMap(e as Map<String, dynamic>))
        ?.toList(),
//      meta: (json['meta'] as List)
//          ?.map((e) =>
//      e == null ? null : Meta.fromJson(e as Map<String, dynamic>))
//          ?.toList()
  );
}

Map<String, dynamic> _$SShopCodeToJsonMap(ShopCode instance) =>
    <String, dynamic>{'documents': instance.list};

class ShopCodeList {
  String categorycdnm;
  String categorycd;
  //String fileurl;

  ShopCodeList({
    this.categorycdnm,
    this.categorycd,
    //this.fileurl
  });

  factory ShopCodeList.fromJson(Map<String, dynamic> json) => ShopCodeList(
        categorycdnm: json["CATEGORY_CDNM"],
        categorycd: json["CATEGORY_CD"],
        //    fileurl: json["FILE_URL"],
      );

  Map<String, dynamic> toJson() => {
        "CATEGORY_CDNM": categorycdnm,
        "CATEGORY_CD": categorycd,
        // "FILE_URL": fileurl,
      };

  factory ShopCodeList.fromJsonMap(Map<String, dynamic> json) =>
      _$ShopCodeListFromJsonMap(json);
  Map<String, dynamic> toJsonMap() => _$ShopCodeListToJsonMap(this);
}

ShopCodeList _$ShopCodeListFromJsonMap(Map<String, dynamic> json) {
  return ShopCodeList(
    categorycdnm: json['CATEGORY_CDNM'] as String,
    categorycd: json['CATEGORY_CD'] as String,

    /// fileurl: json['FILE_URL'] as String,
  );
}

Map<String, dynamic> _$ShopCodeListToJsonMap(ShopCodeList instance) =>
    <String, dynamic>{
      'CATEGORY_CDNM': instance.categorycdnm,
      'CATEGORY_CD': instance.categorycd,
      // 'FILE_URL': instance.fileurl,
    };

Future<Map<String, dynamic>> getShopCodeList() async {
  final response = await http.get('http://192.168.0.47:8080/getShopCodeList');

  if (200 == response.statusCode) {
    var datauser = json.decode(response.body);
    return datauser;
  } else {
    return json.decode(response.body);
  }
}

Future<ShopCode> getShopCodeEntire() async {
  // http.Response response = await http.post(
  //   Uri.encodeFull('https://wellhada.com/getAppNoticeList'),
  //   headers: {"Accept": "application/json"},
  //   body: {'period': 'ALL'},
  // );
  final response = await http.get('http://192.168.0.47:8080/getShopCodeList');

  if (response.statusCode == 200) {
    return ShopCode.fromJsonMap(json.decode(response.body));
  } else {
    throw HttpException(
      'Unexpected status code ${response.statusCode}:'
      ' ${response.reasonPhrase}',
      //uri: Uri.parse(query)
    );
  }
}

Future<Map<String, dynamic>> getShopDetailCodeList(String category) async {
  var bodyParam = new Map();
  bodyParam['CATEGORY_CD'] = category;

  final response = await http.get('http://192.168.0.47:8080/getShopCodeList');
  //.get('https://192.168.0.35:8080/getShopCodeList');

  if (200 == response.statusCode) {
    var datauser = json.decode(response.body);
    return datauser;
  } else {
    return json.decode(response.body);
  }
}
