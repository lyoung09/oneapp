import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

/////////////////////////////
/////////////////////////////
/////////////////////////////
/////////////////////////////
/////////////////////////////
//////////order list/////////
/////////////////////////////
/////////////////////////////
/////////////////////////////
/////////////////////////////
/////////////////////////////

// class Order {
//   String status;
//   int cnt;
//   OrderDetail inFolist;
//   final List<OrderDetail> list;

//   Order({this.status, this.cnt, this.list, this.inFolist});

//   factory Order.fromJson(Map<String, dynamic> json) => Order(
//         status: json["STATUS"],
//         inFolist: OrderDetail.fromJson(json["LIST"]),
//         cnt: json["CNT"],
//       );

//   Map<String, dynamic> toJson() => {
//         "status": status,
//         "cnt": cnt,
//         "list": inFolist.toJson(),
//       };

//   factory Order.fromJsonMap(Map<String, dynamic> json) =>
//       _$OrderItemFromJsonMap(json);

//   Map<String, dynamic> toJsonMap() => _$OrderItemToJsonMap(this);
// }

// Order _$OrderItemFromJsonMap(Map<String, dynamic> json) {
//   return Order(
//     list: (json['LIST'] as List)
//         ?.map((e) => e == null
//             ? null
//             : OrderDetail.fromJsonMap(e as Map<String, dynamic>))
//         ?.toList(),
//   );
// }

// Map<String, dynamic> _$OrderItemToJsonMap(Order instance) =>
//     <String, dynamic>{'documents': instance.list};

// class OrderDetail {
//   int orderSeq;
//   int shopSeq;
//   int orderDate;
//   int totalPrice;
//   String orderStatus;
//   int regUserSeq;
//   int regDate;
//   int userSeq;
//   String orderReq;
//   String reserveDate;
//   String reserveTime;
//   String cancelReason;
//   String totalCount;
//   int price;
//   String menuName;
//   String placeName;
//   int fileSeq;
//   String fileUrl;
//   String reviewYn;
//   int orderDtlSeq;
//   String basic;
//   String sel1;
//   String sel2;
//   OrderDetail(
//       {this.orderSeq,
//       this.orderDate,
//       this.totalPrice,
//       this.orderStatus,
//       this.regDate,
//       this.regUserSeq,
//       this.shopSeq,
//       this.orderReq,
//       this.reserveDate,
//       this.reserveTime,
//       this.cancelReason,
//       this.totalCount,
//       this.price,
//       this.userSeq,
//       this.menuName,
//       this.placeName,
//       this.fileSeq,
//       this.reviewYn,
//       this.orderDtlSeq,
//       this.basic,
//       this.sel1,
//       this.sel2,
//       this.fileUrl});
//   factory OrderDetail.fromJson(Map<String, dynamic> json) => OrderDetail(
//         orderSeq: json["ORDER_SEQ"] == null ? null : json["ORDER_SEQ"],
//         orderDate: json["ORDER_DATE"] == null ? null : json["ORDER_DATE"],
//         totalPrice: json["TOTAL_PRICE"] == null ? null : json["TOTAL_PRICE"],
//         orderStatus: json["ORDER_STATUS"] == null ? null : json["ORDER_STATUS"],
//         regDate: json["REG_DATE"] == null ? null : json["REG_DATE"],
//         regUserSeq: json["REG_USER_SEQ"] == null ? null : json["REG_USER_SEQ"],
//         shopSeq: json["SHOP_SEQ"],
//         orderReq: json["ORDER_REQ"] == null ? null : json["ORDER_REQ"],
//         reserveDate: json["RESERVE_DATE"] == null ? null : json["RESERVE_DATE"],
//         reserveTime: json["RESERVE_TIME"] == null ? null : json["RESERVE_TIME"],
//         cancelReason:
//             json["CANCEL_REASON"] == null ? null : json["CANCEL_REASON"],
//         totalCount: json["TOTAL_COUNT"] == null ? null : json["TOTAL_COUNT"],
//         price: json["PRICE"] == null ? null : json["PRICE"],
//         userSeq: json["USER_SEQ"] == null ? null : json["USER_SEQ"],
//         menuName: json["MENU_NAME"] == null ? null : json["MENU_NAME"],
//         placeName: json["SHOP_NAME"] == null ? null : json["SHOP_NAME"],
//         fileSeq: json["FILE_SEQ"] == null ? null : json["FILE_SEQ"],
//         reviewYn: json["REVIEW_YN"] == null ? null : json["REVIEW_YN"],
//         basic: json["BASIC1"] == null ? null : json["BASIC1"],
//         sel1: json["SEL1"] == null ? null : json["SEL1"],
//         sel2: json["SEL2"] == null ? null : json["SEL2"],
//         fileUrl: json["FILE_URL"] == null ? null : json["FILE_URL"],
//         orderDtlSeq:
//             json["ORDER_DTL_SEQ"] == null ? null : json["ORDER_DTL_SEQ"],
//       );

//   Map<String, dynamic> toJson() => {
//         "ORDER_SEQ": orderSeq == null ? null : orderSeq,
//         "ORDER_DATE": orderDate == null ? null : orderDate,
//         "TOTAL_PRICE": totalPrice == null ? null : totalPrice,
//         "ORDER_STATUS": orderStatus == null ? null : orderStatus,
//         "REG_DATE": regDate == null ? null : regDate,
//         "REG_USER_SEQ": regUserSeq == null ? null : regUserSeq,
//         "SHOP_SEQ": shopSeq,
//         "ORDER_REQ": orderReq == null ? null : orderReq,
//         "RESERVE_DATE": reserveDate == null ? null : reserveDate,
//         "RESERVE_TIME": reserveTime == null ? null : reserveTime,
//         "CANCEL_REASON": cancelReason == null ? null : cancelReason,
//         "TOTAL_COUNT": totalCount == null ? null : totalCount,
//         "PRICE": price == null ? null : price,
//         "USER_SEQ": userSeq == null ? null : userSeq,
//         "MENU_NAME": menuName == null ? null : menuName,
//         "SHOP_NAME": placeName == null ? null : placeName,
//         "FILE_SEQ": fileSeq == null ? null : fileSeq,
//         "REVIEW_YN": reviewYn == null ? null : reviewYn,
//         "BASIC1": basic == null ? null : basic,
//         "SEL1": sel1 == null ? null : sel1,
//         "SEL2": sel2 == null ? null : sel2,
//         "FILE_URL": fileUrl == null ? null : fileUrl,
//         "ORDER_DTL_SEQ": orderDtlSeq == null ? null : orderDtlSeq,
//       };

//   factory OrderDetail.fromJsonMap(Map<String, dynamic> json) =>
//       _$OrderDetailFromJsonMap(json);
//   Map<String, dynamic> toJsonMap() => _$OrderDetailToJsonMap(this);
// }

// OrderDetail _$OrderDetailFromJsonMap(Map<String, dynamic> json) {
//   return OrderDetail(
//     orderSeq: json["ORDER_SEQ"] == null ? null : json["ORDER_SEQ"] as int,
//     orderDate: json["ORDER_DATE"] == null ? null : json["ORDER_DATE"] as int,
//     totalPrice: json["TOTAL_PRICE"] == null ? null : json["TOTAL_PRICE"] as int,
//     orderStatus:
//         json["ORDER_STATUS"] == null ? null : json["ORDER_STATUS"] as String,
//     regDate: json["REG_DATE"] == null ? null : json["REG_DATE"] as int,
//     regUserSeq:
//         json["REG_USER_SEQ"] == null ? null : json["REG_USER_SEQ"] as int,
//     shopSeq: json["SHOP_SEQ"] as int,
//     orderReq: json["ORDER_REQ"] == null ? null : json["ORDER_REQ"] as String,
//     reserveDate:
//         json["RESERVE_DATE"] == null ? null : json["RESERVE_DATE"] as String,
//     reserveTime:
//         json["RESERVE_TIME"] == null ? null : json["RESERVE_TIME"] as String,
//     cancelReason:
//         json["CANCEL_REASON"] == null ? null : json["CANCEL_REASON"] as String,
//     totalCount:
//         json["TOTAL_COUNT"] == null ? null : json["TOTAL_COUNT"] as String,
//     price: json["PRICE"] == null ? null : json["PRICE"] as int,
//     userSeq: json["USER_SEQ"] == null ? null : json["USER_SEQ"] as int,
//     menuName: json["MENU_NAME"] == null ? null : json["MENU_NAME"] as String,
//     placeName: json["SHOP_NAME"] == null ? null : json["SHOP_NAME"] as String,
//     fileSeq: json["FILE_SEQ"] == null ? null : json["FILE_SEQ"] as int,
//     reviewYn: json["REVIEW_YN"] == null ? null : json["REVIEW_YN"] as String,
//     basic: json["BASIC1"] == null ? null : json["BASIC1"] as String,
//     sel1: json["SEL1"] == null ? null : json["SEL1"] as String,
//     sel2: json["SEL2"] == null ? null : json["SEL2"] as String,
//     fileUrl: json["FILE_URL"] == null ? null : json["FILE_URL"] as String,
//     orderDtlSeq:
//         json["ORDER_DTL_SEQ"] == null ? null : json["ORDER_DTL_SEQ"] as int,
//   );
// }

// Map<String, dynamic> _$OrderDetailToJsonMap(OrderDetail instance) =>
//     <String, dynamic>{
//       'ORDER_SEQ': instance.orderSeq == null ? null : instance.orderSeq,
//       'ORDER_DATE': instance.orderDate == null ? null : instance.orderDate,
//       'TOTAL_PRICE': instance.totalPrice == null ? null : instance.totalPrice,
//       'ORDER_STATUS':
//           instance.orderStatus == null ? null : instance.orderStatus,
//       'REG_DATE': instance.regDate == null ? null : instance.regDate,
//       'REG_USER_SEQ': instance.regUserSeq == null ? null : instance.regUserSeq,
//       'SHOP_SEQ': instance.shopSeq,
//       'ORDER_REQ': instance.orderReq == null ? null : instance.orderReq,
//       'RESERVE_DATE':
//           instance.reserveDate == null ? null : instance.reserveDate,
//       'RESERVE_TIME':
//           instance.reserveTime == null ? null : instance.reserveTime,
//       'CANCEL_REASON':
//           instance.cancelReason == null ? null : instance.cancelReason,
//       'TOTAL_COUNT': instance.totalCount == null ? null : instance.totalCount,
//       'PRICE': instance.price == null ? null : instance.price,
//       'USER_SEQ': instance.userSeq == null ? null : instance.userSeq,
//       'MENU_NAME': instance.menuName == null ? null : instance.menuName,
//       'SHOP_NAME': instance.placeName == null ? null : instance.placeName,
//       'FILE_SEQ': instance.fileSeq == null ? null : instance.fileSeq,
//       'REVIEW_YN': instance.reviewYn == null ? null : instance.reviewYn,
//       'BASIC1': instance.basic == null ? null : instance.basic,
//       'SEL1': instance.sel1 == null ? null : instance.sel1,
//       'SEL2': instance.sel2 == null ? null : instance.sel2,
//       'FILE_URL': instance.fileUrl == null ? null : instance.fileUrl,
//       'ORDER_DTL_SEQ':
//           instance.orderDtlSeq == null ? null : instance.orderDtlSeq,
//     };

Future<Map<String, dynamic>> getOrderHistory(String userChk) async {
  var bodyParam = new Map();
  bodyParam['user_id'] = userChk;

  http.Response response = await http.post(
    Uri.encodeFull('http://hndsolution.iptime.org:8086/getOrderHist'),
    headers: {"Accept": "application/json"},
    body: bodyParam,
  );

  if (200 == response.statusCode) {
    var datauser = json.decode(response.body);

    return datauser;
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
/////////review list/////////
/////////////////////////////
/////////////////////////////
/////////////////////////////
/////////////////////////////
/////////////////////////////

Future<Map<String, dynamic>> getReviewList(String userChk) async {
  var bodyParam = new Map();
  bodyParam['user_id'] = userChk;
  //bodyParam['review_comment'] = reviewComment;

  http.Response response = await http.post(
    Uri.encodeFull('http://hndsolution.iptime.org:8086/getReviewList'),
    headers: {"Accept": "application/json"},
    body: bodyParam,
  );

  if (200 == response.statusCode) {
    var datauser = json.decode(response.body);
    print(datauser);
    return datauser;
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
////////save review//////////
/////////////////////////////
/////////////////////////////
/////////////////////////////
/////////////////////////////
/////////////////////////////
class SaveR {
  final String fileSeq;
  //final bool yn;
  //final

  SaveR(
    this.fileSeq,
    //this.cnt,
  );
  // Status.fromJson(Map<String,dynamic> json):STATUS:json['STATUS'],cnt:json['cnt'];

  SaveR.fromJson(Map<String, dynamic> json) : fileSeq = json['file_seq'];
  //  cnt = json['CNT'];

  Map<String, dynamic> toJson() => {
        'file_seq': fileSeq,
        //    'CNT': cnt,
      };
}

class SaveInsert {
  final String status;
  final int cnt;

  SaveInsert(
    this.status,
    this.cnt,
  );
  // Status.fromJson(Map<String,dynamic> json):STATUS:json['STATUS'],cnt:json['cnt'];

  SaveInsert.fromJson(Map<String, dynamic> json)
      : status = json['file_seq'],
        cnt = json['CNT'];

  Map<String, dynamic> toJson() => {
        'STAUTS': status,
        'CNT': cnt,
      };
}

Future<SaveInsert> noImageReview(
    int userChk, int orderSeq, String reviewComment) async {
  var bodyParam = new Map();

  bodyParam['user_id'] = userChk.toString();
  bodyParam['order_seq'] = orderSeq.toString();
  bodyParam['review_comment'] = reviewComment;

  // bodyParam['review_img'] = image.path;
  //String baseImage = base64Encode(image.readAsBytesSync());
  //bodyParam["review_image"] = baseImage;
  http.Response response = await http.post(
      Uri.encodeFull('http://hndsolution.iptime.org:8086/insertReview'),
      headers: {
        "Accept": "application/json",
      },
      body: bodyParam);
  if (response.statusCode == 200) {
    return SaveInsert.fromJson(json.decode(response.body));
  } else {
    throw HttpException(
      'Unexpected status code ${response.statusCode}:'
      ' ${response.reasonPhrase}',
      //uri: Uri.parse(query)
    );
  }
}

Future<SaveInsert> insertReview(
    int userChk, int orderSeq, String reviewComment, String image) async {
  var bodyParam = new Map();

  bodyParam['user_id'] = userChk.toString();
  bodyParam['order_seq'] = orderSeq.toString();
  bodyParam['review_img_url'] = image;
  bodyParam['review_comment'] = reviewComment;

  // bodyParam['review_img'] = image.path;
  //String baseImage = base64Encode(image.readAsBytesSync());
  //bodyParam["review_image"] = baseImage;
  http.Response response = await http.post(
      Uri.encodeFull('http://hndsolution.iptime.org:8086/insertReview'),
      headers: {
        "Accept": "application/json",
      },
      body: bodyParam);
  if (response.statusCode == 200) {
    return SaveInsert.fromJson(json.decode(response.body));
  } else {
    throw HttpException(
      'Unexpected status code ${response.statusCode}:'
      ' ${response.reasonPhrase}',
      //uri: Uri.parse(query)
    );
  }
}

saveReview(int userChk, int orderSeq, String reviewComment, File image) async {
  var request = http.MultipartRequest(
      "POST",
      Uri.parse(
          "http://hndsolution.iptime.org:8086/usermngr/shopimg_fileupload.ajax"));
  request.fields["user_seq"] = userChk.toString();
  var pic = await http.MultipartFile.fromPath("file_upload", image.path);
  request.files.add(pic);
  var response = await request.send();
  var responseData = await response.stream.toBytes();
  var responseString = String.fromCharCodes(responseData);

  if (response.statusCode == 200) {
    print(responseString);
    return SaveR.fromJson(json.decode(responseString));
  } else {
    throw HttpException(
      'Unexpected status code ${response.statusCode}:'
      ' ${response.reasonPhrase}',
    );
  }
  // http.MultipartFile multipartFile =
  //     await http.MultipartFile.fromPath('review_img', image);
  // // request.fields["review_img"] = multipartFile.toString();
  // print(multipartFile);
  // print(multipartFile.runtimeType);

  // var che = http.MultipartFile.fromBytes(
  //     'review_img', File(image).readAsBytesSync(),
  //     filename: image.split("/").last);

  // var response = await request.send().then((response) async {
  //   // listen for response
  //   response.stream.transform(utf8.decoder).listen((value) {
  //     print(value);
  //   });
  // }).catchError((e) {
  //   print(e);
  // });

  // // var response = await request.send();

  // var responseData = await response.stream.toBytes();
  // var responseString = String.fromCharCodes(responseData);
  // //print(bodyParam);
  // if (response.statusCode == 200) {
  //   print(SaveR.fromJson(json.decode(responseString)));
  //   print(json.decode(responseString));

  //   return SaveR.fromJson(json.decode(responseString));
  // } else {
  //   throw HttpException(
  //     'Unexpected status code ${response.statusCode}:'
  //     ' ${response.reasonPhrase}',
  //     //uri: Uri.parse(query)
  //   );
  // }
  // var request = http.MultipartRequest(
  //   "POST",
  //   Uri.parse(
  //     "http://hndsolution.iptime.org:8086/usermngr/shopimg_fileupload.ajax",
  //   ),
  // );
  // Map<String, String> headers = {
  //   'Content-Type': 'multipart/form-data',
  // };

  // request.headers["Content-Type"] = 'multipart/form-data';
  // // request.headers["Accept"] = "application/json";

  // request.fields["user_seq"] = userChk.toString();
  // request.fields["order_seq"] = orderSeq.toString();
  // request.fields["review_comment"] = reviewComment;

  // if (image != null) {
  //   print(image.path.split(".").last);
  //   image.path.split(".").last == "jpg"
  //       ? image.path.split(".").last = "jpeg"
  //       : image.path.split(".").last;
  //   request.files.add(
  //     http.MultipartFile.fromBytes(
  //       "review_img_url",
  //       image.readAsBytesSync(),
  //       //filename: "${image.path.split(".").last}",
  //       contentType:
  //           MediaType("file_mime_type", "${image.path.split(".").last}"),
  //     ),
  //   );
  // } else {
  //   request.fields["file_upload"] = "";
  // }

  // request.send().then((onValue) {
  //   print(onValue.statusCode);
  // });
}

/////////////////////////////
/////////////////////////////
/////////////////////////////
/////////////////////////////
/////////////////////////////
////////delete review////////
/////////////////////////////
/////////////////////////////
/////////////////////////////
/////////////////////////////
/////////////////////////////

class DeleteR {
  final String status;
  final int cnt;

  DeleteR(
    this.status,
    this.cnt,
  );
  // Status.fromJson(Map<String,dynamic> json):STATUS:json['STATUS'],cnt:json['cnt'];

  DeleteR.fromJson(Map<String, dynamic> json)
      : status = json['STATUS'],
        cnt = json['CNT'];

  Map<String, dynamic> toJson() => {
        'STATUS': status,
        'CNT': cnt,
      };
}

Future<DeleteR> deleteReview(String userChk, int orderSeq) async {
  var bodyParam = new Map();
  bodyParam['user_id'] = userChk;
  bodyParam['order_seq'] = orderSeq.toString();

  http.Response response = await http.post(
    Uri.encodeFull('http://hndsolution.iptime.org:8086/deleteReview'),
    headers: {"Accept": "application/json"},
    body: bodyParam,
  );

  if (response.statusCode == 200) {
    return DeleteR.fromJson(json.decode(response.body));
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
////////point history////////
/////////////////////////////
/////////////////////////////
/////////////////////////////
/////////////////////////////
/////////////////////////////

Future<Map<String, dynamic>> getPointHistory(String userChk) async {
  var bodyParam = new Map();
  bodyParam['user_id'] = userChk;

  http.Response response = await http.post(
    Uri.encodeFull('http://hndsolution.iptime.org:8086/getPointHist'),
    headers: {"Accept": "application/json"},
    body: bodyParam,
  );

  if (200 == response.statusCode) {
    var datauser = json.decode(response.body);

    return datauser;
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
////////Stamp history////////
/////////////////////////////
/////////////////////////////
/////////////////////////////
/////////////////////////////
/////////////////////////////

Future<Map<String, dynamic>> getStampHistory(String userChk) async {
  var bodyParam = new Map();
  bodyParam['user_id'] = userChk;

  http.Response response = await http.post(
    Uri.encodeFull('http://hndsolution.iptime.org:8086/getStampHist'),
    headers: {"Accept": "application/json"},
    body: bodyParam,
  );

  if (200 == response.statusCode) {
    var datauser = json.decode(response.body);

    return datauser;
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
///////coupon history////////
/////////////////////////////
/////////////////////////////
/////////////////////////////
/////////////////////////////
/////////////////////////////

Future<Map<String, dynamic>> getCouponHistory(String userChk) async {
  var bodyParam = new Map();
  bodyParam['user_id'] = userChk;

  http.Response response = await http.post(
    Uri.encodeFull('http://hndsolution.iptime.org:8086/getCouponHist'),
    headers: {"Accept": "application/json"},
    body: bodyParam,
  );

  if (200 == response.statusCode) {
    var datauser = json.decode(response.body);

    return datauser;
  } else {
    throw HttpException(
      'Unexpected status code ${response.statusCode}:'
      ' ${response.reasonPhrase}',
      //uri: Uri.parse(query)
    );
  }
}
