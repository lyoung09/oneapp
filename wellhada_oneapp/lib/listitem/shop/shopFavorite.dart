import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/////////////////////////////
/////////////////////////////
/////////////////////////////
/////////////////////////////
/////////////////////////////
///////favorite list/////////
/////////////////////////////
/////////////////////////////
/////////////////////////////
/////////////////////////////
/////////////////////////////

// class Favorite {
//   String status;
//   int cnt;
//   FavoriteDetail inFolist;
//   final List<FavoriteDetail> list;

//   Favorite({this.status, this.cnt, this.list, this.inFolist});

//   factory Favorite.fromJson(Map<String, dynamic> json) => Favorite(
//         status: json["STATUS"],
//         inFolist: FavoriteDetail.fromJson(json["LIST"]),
//         cnt: json["CNT"],
//       );

//   Map<String, dynamic> toJson() => {
//         "status": status,
//         "cnt": cnt,
//         "list": inFolist.toJson(),
//       };

//   factory Favorite.fromJsonMap(Map<String, dynamic> json) =>
//       _$FavoriteItemFromJsonMap(json);

//   Map<String, dynamic> toJsonMap() => _$FavoriteItemToJsonMap(this);
// }

// Favorite _$FavoriteItemFromJsonMap(Map<String, dynamic> json) {
//   return Favorite(
//     list: (json['LIST'] as List)
//         ?.map((e) => e == null
//             ? null
//             : FavoriteDetail.fromJsonMap(e as Map<String, dynamic>))
//         ?.toList(),
// //      meta: (json['meta'] as List)
// //          ?.map((e) =>
// //      e == null ? null : Meta.fromJson(e as Map<String, dynamic>))
// //          ?.toList()
//   );
// }

// Map<String, dynamic> _$FavoriteItemToJsonMap(Favorite instance) =>
//     <String, dynamic>{'documents': instance.list};

// class FavoriteDetail {
//   String weekBeginTime;
//   String weekEndTime;
//   String addressDetail;
//   String categoryGroupCode;
//   String phone;
//   int regDate;
//   String shopDc;
//   String bsnEndTime;
//   String telnoHideAt;
//   String telDispAt;
//   String placeName;
//   String bizrno;
//   String fileUrl;
//   int regUserSeq;
//   int shopSeq;
//   int updUserSeq;
//   String tmplatCd;
//   String address;
//   String addressZip;
//   String shopDcDispAt;
//   String bsnBeginTime;
//   String phoneOther;
//   int userSeq;
//   int updDate;
//   int fileSeq;
//   double latitude;
//   double longtitude;
//   String favoriteSeq;
//   FavoriteDetail(
//       {this.weekBeginTime,
//       this.weekEndTime,
//       this.addressDetail,
//       this.categoryGroupCode,
//       this.phone,
//       this.regDate,
//       this.shopDc,
//       this.bsnEndTime,
//       this.telnoHideAt,
//       this.telDispAt,
//       this.placeName,
//       this.bizrno,
//       this.fileUrl,
//       this.regUserSeq,
//       this.shopSeq,
//       this.updUserSeq,
//       this.tmplatCd,
//       this.address,
//       this.addressZip,
//       this.shopDcDispAt,
//       this.bsnBeginTime,
//       this.phoneOther,
//       this.userSeq,
//       this.updDate,
//       this.fileSeq,
//       this.latitude,
//       this.longtitude,
//       this.favoriteSeq});
//   factory FavoriteDetail.fromJson(Map<String, dynamic> json) => FavoriteDetail(
//         weekBeginTime:
//             json["WEEK_BEGIN_TIME"] == null ? null : json["WEEK_BEGIN_TIME"],
//         weekEndTime:
//             json["WEEK_END_TIME"] == null ? null : json["WEEK_END_TIME"],
//         addressDetail:
//             json["ADDRESS_DETAIL"] == null ? null : json["ADDRESS_DETAIL"],
//         categoryGroupCode: json["CATEGORY_CODE"],
//         phone: json["PHONE"] == null ? null : json["PHONE"],
//         regDate: json["REG_DATE"] == null ? null : json["REG_DATE"],
//         shopDc: json["SHOP_DC"] == null ? null : json["SHOP_DC"],
//         bsnEndTime: json["BSN_END_TIME"] == null ? null : json["BSN_END_TIME"],
//         telnoHideAt:
//             json["TELNO_HIDE_AT"] == null ? null : json["TELNO_HIDE_AT"],
//         telDispAt: json["TEL_DISP_AT"] == null ? null : json["TEL_DISP_AT"],
//         placeName: json["PLACE_NAME"],
//         bizrno: json["BIZRNO"] == null ? null : json["BIZRNO"],
//         fileUrl: json["FILE_URL"] == null ? null : json["FILE_URL"],
//         regUserSeq: json["REG_USER_SEQ"] == null ? null : json["REG_USER_SEQ"],
//         shopSeq: json["SHOP_SEQ"],
//         updUserSeq: json["UPD_USER_SEQ"] == null ? null : json["UPD_USER_SEQ"],
//         tmplatCd: json["TMPLAT_CD"] == null ? null : json["TMPLAT_CD"],
//         address: json["ADDRESS"] == null ? null : json["ADDRESS"],
//         addressZip: json["ADDRESS_ZIP"] == null ? null : json["ADDRESS_ZIP"],
//         shopDcDispAt:
//             json["SHOP_DC_DISP_AT"] == null ? null : json["SHOP_DC_DISP_AT"],
//         bsnBeginTime:
//             json["BSN_BEGIN_TIME"] == null ? null : json["BSN_BEGIN_TIME"],
//         phoneOther: json["PHONE_OTHER"] == null ? null : json["PHONE_OTHER"],
//         userSeq: json["USER_SEQ"] == null ? null : json["USER_SEQ"],
//         updDate: json["UPD_DATE"] == null ? null : json["UPD_DATE"],
//         fileSeq: json["FILE_SEQ"] == null ? null : json["FILE_SEQ"],
//         latitude: json["LATITUDE"],
//         longtitude: json["LONGITUDE"],
//         favoriteSeq: json["FAVORITE_YN"] == null ? null : json["FAVORITE_YN"],
//       );

//   Map<String, dynamic> toJson() => {
//         "WEEK_BEGIN_TIME": weekBeginTime == null ? null : weekBeginTime,
//         "WEEK_END_TIME": weekEndTime == null ? null : weekEndTime,
//         "ADDRESS_DETAIL": addressDetail == null ? null : addressDetail,
//         "CATEGORY_CODE": categoryGroupCode,
//         "PHONE": phone == null ? null : phone,
//         "REG_DATE": regDate == null ? null : regDate,
//         "SHOP_DC": shopDc == null ? null : shopDc,
//         "BSN_END_TIME": bsnEndTime == null ? null : bsnEndTime,
//         "TELNO_HIDE_AT": telnoHideAt == null ? null : telnoHideAt,
//         "TEL_DISP_AT": telDispAt == null ? null : telDispAt,
//         "PLACE_NAME": placeName,
//         "BIZRNO": bizrno == null ? null : bizrno,
//         "FILE_URL": fileUrl == null ? null : fileUrl,
//         "REG_USER_SEQ": regUserSeq == null ? null : regUserSeq,
//         "SHOP_SEQ": shopSeq,
//         "UPD_USER_SEQ": updUserSeq == null ? null : updUserSeq,
//         "TMPLAT_CD": tmplatCd == null ? null : tmplatCd,
//         "ADDRESS": address == null ? null : address,
//         "ADDRESS_ZIP": addressZip == null ? null : addressZip,
//         "SHOP_DC_DISP_AT": shopDcDispAt == null ? null : shopDcDispAt,
//         "BSN_BEGIN_TIME": bsnBeginTime == null ? null : bsnBeginTime,
//         "PHONE_OTHER": phoneOther == null ? null : phoneOther,
//         "USER_SEQ": userSeq == null ? null : userSeq,
//         "UPD_DATE": updDate == null ? null : updDate,
//         "FILE_SEQ": fileSeq == null ? null : fileSeq,
//         "LATITUDE": latitude,
//         "LONGITUDE": longtitude,
//         "FAVORITE_YN": favoriteSeq == null ? null : favoriteSeq
//       };

//   factory FavoriteDetail.fromJsonMap(Map<String, dynamic> json) =>
//       _$FavoriteDetailFromJsonMap(json);
//   Map<String, dynamic> toJsonMap() => _$FavoriteDetailToJsonMap(this);
// }

// FavoriteDetail _$FavoriteDetailFromJsonMap(Map<String, dynamic> json) {
//   return FavoriteDetail(
//     weekBeginTime: json["WEEK_BEGIN_TIME"] == null
//         ? null
//         : json["WEEK_BEGIN_TIME"] as String,
//     weekEndTime:
//         json["WEEK_END_TIME"] == null ? null : json["WEEK_END_TIME"] as String,
//     addressDetail: json["ADDRESS_DETAIL"] == null
//         ? null
//         : json["ADDRESS_DETAIL"] as String,
//     categoryGroupCode: json["CATEGORY_CODE"] as String,
//     phone: json["PHONE"] == null ? null : json["PHONE"] as String,
//     regDate: json["REG_DATE"] == null ? null : json["REG_DATE"] as int,
//     shopDc: json["SHOP_DC"] == null ? null : json["SHOP_DC"] as String,
//     bsnEndTime:
//         json["BSN_END_TIME"] == null ? null : json["BSN_END_TIME"] as String,
//     telnoHideAt:
//         json["TELNO_HIDE_AT"] == null ? null : json["TELNO_HIDE_AT"] as String,
//     telDispAt:
//         json["TEL_DISP_AT"] == null ? null : json["TEL_DISP_AT"] as String,
//     placeName: json["PLACE_NAME"] as String,
//     bizrno: json["BIZRNO"] == null ? null : json["BIZRNO"] as String,
//     fileUrl: json["FILE_URL"] == null ? null : json["FILE_URL"] as String,
//     regUserSeq:
//         json["REG_USER_SEQ"] == null ? null : json["REG_USER_SEQ"] as int,
//     shopSeq: json["SHOP_SEQ"] as int,
//     updUserSeq:
//         json["UPD_USER_SEQ"] == null ? null : json["UPD_USER_SEQ"] as int,
//     tmplatCd: json["TMPLAT_CD"] == null ? null : json["TMPLAT_CD"] as String,
//     address: json["ADDRESS"] == null ? null : json["ADDRESS"] as String,
//     addressZip:
//         json["ADDRESS_ZIP"] == null ? null : json["ADDRESS_ZIP"] as String,
//     shopDcDispAt: json["SHOP_DC_DISP_AT"] == null
//         ? null
//         : json["SHOP_DC_DISP_AT"] as String,
//     bsnBeginTime: json["BSN_BEGIN_TIME"] == null
//         ? null
//         : json["BSN_BEGIN_TIME"] as String,
//     phoneOther:
//         json["PHONE_OTHER"] == null ? null : json["PHONE_OTHER"] as String,
//     userSeq: json["USER_SEQ"] == null ? null : json["USER_SEQ"] as int,
//     updDate: json["UPD_DATE"] == null ? null : json["UPD_DATE"] as int,
//     fileSeq: json["FILE_SEQ"] == null ? null : json["FILE_SEQ"] as int,
//     latitude: json["LATITUDE"] as double,
//     longtitude: json["LONGITUDE"] as double,
//     favoriteSeq:
//         json["FAVORITE_YN"] == null ? null : json["FAVORITE_YN"] as String,
//   );
// }

// Map<String, dynamic> _$FavoriteDetailToJsonMap(FavoriteDetail instance) =>
//     <String, dynamic>{
//       'WEEK_BEGIN_TIME':
//           instance.weekBeginTime == null ? null : instance.weekBeginTime,
//       'WEEK_END_TIME':
//           instance.weekEndTime == null ? null : instance.weekEndTime,
//       'ADDRESS_DETAIL': instance.addressDetail,
//       'CATEGORY_CODE': instance.categoryGroupCode,
//       'PHONE': instance.phone == null ? null : instance.phone,
//       'REG_DATE': instance.regDate == null ? null : instance.regDate,
//       'SHOP_DC': instance.shopDc == null ? null : instance.shopDc,
//       'BSN_END_TIME': instance.bsnEndTime == null ? null : instance.bsnEndTime,
//       'TELNO_HIDE_AT':
//           instance.telnoHideAt == null ? null : instance.telnoHideAt,
//       'PLACE_NAME': instance.placeName,
//       'TEL_DISP_AT': instance.telnoHideAt == null ? null : instance.telnoHideAt,
//       'BIZRNO': instance.bizrno == null ? null : instance.bizrno,
//       'FILE_URL': instance.fileUrl == null ? null : instance.fileUrl,
//       'REG_USER_SEQ': instance.regUserSeq == null ? null : instance.regUserSeq,
//       'SHOP_SEQ': instance.shopSeq,
//       'UPD_USER_SEQ': instance.updUserSeq == null ? null : instance.updUserSeq,
//       'TMPLAT_CD': instance.tmplatCd == null ? null : instance.tmplatCd,
//       'ADDRESS': instance.address == null ? null : instance.address,
//       'ADDRESS_ZIP': instance.addressZip == null ? null : instance.addressZip,
//       'SHOP_DC_DISP_AT':
//           instance.shopDcDispAt == null ? null : instance.shopDcDispAt,
//       'BSN_BEGIN_TIME':
//           instance.bsnBeginTime == null ? null : instance.bsnBeginTime,
//       'PHONE_OTHER': instance.phoneOther == null ? null : instance.phoneOther,
//       'USER_SEQ': instance.userSeq == null ? null : instance.userSeq,
//       'UPD_DATE': instance.updDate == null ? null : instance.updDate,
//       'FILE_SEQ': instance.fileSeq == null ? null : instance.fileSeq,
//       'LATITUDE': instance.latitude,
//       'LONGITUDE': instance.longtitude,
//       'FAVORITE_YN': instance.favoriteSeq == null ? null : instance.favoriteSeq,
//     };

Future<Map<String, dynamic>> getFavorite(String userChk) async {
  var bodyParam = new Map();
  bodyParam['user_id'] = userChk;

  http.Response response = await http.post(
    //Uri.encodeFull('http://hndsolution.iptime.org:8080/getUserInfo'),
    Uri.encodeFull('http://hndsolution.iptime.org:8086/getFavorite'),
    headers: {"Accept": "application/json"},
    body: bodyParam,
  );

  if (200 == response.statusCode) {
    var datauser = json.decode(response.body);

    return datauser;
  } else {
    return json.decode(response.body);
  }
}

// Future<Favorite> getFavoriteEntire() async {
//   // http.Response response = await http.post(
//   //   Uri.encodeFull('https://wellhada.com/getAppNoticeList'),
//   //   headers: {"Accept": "application/json"},
//   //   body: {'period': 'ALL'},
//   // );

//   final response = await http.get('http://hndsolution.iptime.org:8086/getFavorite');
//   // final response = await http
//   //     .get('https://run.mocky.io/v3/df690ee8-61d0-4cd5-b616-304d166d5b83');

//   if (response.statusCode == 200) {
//     return Favorite.fromJsonMap(json.decode(response.body));
//   } else {
//     throw HttpException(
//       'Unexpected status code ${response.statusCode}:'
//       ' ${response.reasonPhrase}',
//       //uri: Uri.parse(query)
//     );
//   }
// }

// Future<Favorite> getFavoriteDetailList(String userChk) async {
//   var bodyParam = new Map();
//   bodyParam['user_id'] = userChk;

//   http.Response response = await http.post(
//     //Uri.encodeFull('http://hndsolution.iptime.org:8080/getUserInfo'),
//     Uri.encodeFull('http://hndsolution.iptime.org:8086/getFavorite'),
//     headers: {"Accept": "application/json"},
//     body: bodyParam,
//   );
//   if (200 == response.statusCode) {
//     return Favorite.fromJsonMap(json.decode(response.body));
//   } else {
//     return json.decode(response.body);
//   }
// }
/////////////////////////////
/////////////////////////////
/////////////////////////////
/////////////////////////////
/////////////////////////////
///////save favorite/////////
/////////////////////////////
/////////////////////////////
/////////////////////////////
/////////////////////////////
/////////////////////////////

class SaveF {
  final String status;
  final int cnt;

  SaveF(
    this.status,
    this.cnt,
  );
  // Status.fromJson(Map<String,dynamic> json):STATUS:json['STATUS'],cnt:json['cnt'];

  SaveF.fromJson(Map<String, dynamic> json)
      : status = json['STATUS'],
        cnt = json['CNT'];

  Map<String, dynamic> toJson() => {
        'STATUS': status,
        'CNT': cnt,
      };
}

Future<SaveF> saveFavoriteShop(
  String userChk,
  int shopId,
) async {
  var bodyParam = new Map();
  bodyParam['user_id'] = userChk;
  bodyParam['shop_seq'] = shopId.toString();

  http.Response response = await http.post(
    Uri.encodeFull('http://hndsolution.iptime.org:8086/insertFavorite'),
    headers: {"Accept": "application/json"},
    body: bodyParam,
  );
  print('bodyparam ${bodyParam}');
  if (response.statusCode == 200) {
    print("yyyy");
    return SaveF.fromJson(json.decode(response.body));
  } else {
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
///////delete favorite///////
/////////////////////////////
/////////////////////////////
/////////////////////////////
/////////////////////////////
/////////////////////////////

class DeleteF {
  final String status;
  final int cnt;

  DeleteF(
    this.status,
    this.cnt,
  );
  // Status.fromJson(Map<String,dynamic> json):STATUS:json['STATUS'],cnt:json['cnt'];

  DeleteF.fromJson(Map<String, dynamic> json)
      : status = json['STATUS'],
        cnt = json['CNT'];

  Map<String, dynamic> toJson() => {
        'STATUS': status,
        'CNT': cnt,
      };
}

Future<DeleteF> deleteFavoriteShop(
  String userChk,
  int shopId,
) async {
  var bodyParam = new Map();
  bodyParam['user_id'] = userChk;
  bodyParam['shop_seq'] = shopId.toString();

  http.Response response = await http.post(
    Uri.encodeFull('http://hndsolution.iptime.org:8086/deleteFavorite'),
    headers: {"Accept": "application/json"},
    body: bodyParam,
  );

  if (response.statusCode == 200) {
    return DeleteF.fromJson(json.decode(response.body));
  } else {
    throw HttpException(
      'Unexpected status code ${response.statusCode}:'
      ' ${response.reasonPhrase}',
      //uri: Uri.parse(query)
    );
  }
}
