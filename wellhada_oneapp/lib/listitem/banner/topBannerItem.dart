import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class TopBanner {
  final String status;
  final int cnt;
  final List<TopBannerList> list;

  TopBanner({this.status, this.cnt, this.list});

  factory TopBanner.fromJson(Map<String, dynamic> json) =>
      _$TopBannerItemFromJson(json);

  Map<String, dynamic> toJson() => _$TopBannerItemToJson(this);
}

@JsonSerializable()
class TopBannerList {
  int rowNum;
  int bannerSeq;
  String bannerTitle;
  String bannerType;
  int cnt;
  int fileSeq;
  String fileUrl;
  String bannerContents;

  TopBannerList(
      {this.rowNum,
      this.bannerSeq,
      this.bannerTitle,
      this.bannerType,
      this.cnt,
      this.fileSeq,
      this.fileUrl,
      this.bannerContents});
  factory TopBannerList.fromJson(Map<String, dynamic> json) =>
      _$TopBannerItemListFromJson(json);
  Map<String, dynamic> toJson() => _$TopBannerItemListToJson(this);
}

TopBannerList _$TopBannerItemListFromJson(Map<String, dynamic> json) {
  return TopBannerList(
    rowNum: json['ROWNUM'] as int,
    bannerSeq: json['BANNER_SEQ'] as int,
    bannerTitle: json['BANNER_TITLE'] as String,
    bannerType: json['BANNER_TYPE'] as String,
    cnt: json['CNT'] as int,
    fileSeq: json['FILE_SEQ'] as int,
    fileUrl: json['FILE_URL'] as String,
    bannerContents: json['BANNER_CONTENTS'] as String,
  );
}

Map<String, dynamic> _$TopBannerItemListToJson(TopBannerList instance) =>
    <String, dynamic>{
      'ROWNUM': instance.rowNum,
      'BANNER_SEQ': instance.bannerSeq,
      'BANNER_TITLE': instance.bannerTitle,
      'BANNER_TYPE': instance.bannerType,
      'CNT': instance.cnt,
      'FILE_SEQ': instance.fileSeq,
      'FILE_URL': instance.fileUrl,
      'BANNER_CONTENTS': instance.bannerContents,
    };

TopBanner _$TopBannerItemFromJson(Map<String, dynamic> json) {
  return TopBanner(
    list: (json['LIST'] as List)
        ?.map((e) => e == null
            ? null
            : TopBannerList.fromJson(e as Map<String, dynamic>))
        ?.toList(),
//      meta: (json['meta'] as List)
//          ?.map((e) =>
//      e == null ? null : Meta.fromJson(e as Map<String, dynamic>))
//          ?.toList()
  );
}

Map<String, dynamic> _$TopBannerItemToJson(TopBanner instance) =>
    <String, dynamic>{'documents': instance.list};

Future<TopBanner> getAppbarList() async {
  // http.Response response = await http.post(
  //   Uri.encodeFull('https://wellhada.com/getAppNoticeList'),
  //   headers: {"Accept": "application/json"},
  //   body: {'period': 'ALL'},
  // );
  final response = await http
      .get('https://run.mocky.io/v3/15eb7a95-4d42-4b9e-866f-91b650e57a7a');
  //.get('http://192.168.0.35:8080/getTopBanner?lat=126.89300592139&lon=37.4835140850512&radius=1000&appId=com.hndsolution.wellhada');
  if (response.statusCode == 200) {
    return TopBanner.fromJson(json.decode(response.body));
  } else {
    throw HttpException(
      'Unexpected status code ${response.statusCode}:'
      ' ${response.reasonPhrase}',
      //uri: Uri.parse(query)
    );
  }
}
