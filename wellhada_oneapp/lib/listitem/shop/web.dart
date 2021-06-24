import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

loginWebUser(
  String userId,
  String userPassword,
) async {
  var bodyParam = new Map();
  bodyParam['user_id'] = userId;
  bodyParam['user_password'] = userPassword;

  http.Response response = await http.post(
    Uri.encodeFull(
        'http://hndsolution.iptime.org:8086/usermngr/shopTmplatView.do'),
    headers: {"Accept": "application/json"},
    body: bodyParam,
  );

  if (response.statusCode == 200) {
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
//////////payment////////////
/////////////////////////////
/////////////////////////////
/////////////////////////////
/////////////////////////////
/////////////////////////////

class Insert {
  final String status;
  final int cnt;

  Insert(
    this.status,
    this.cnt,
  );
  // Status.fromJson(Map<String,dynamic> json):STATUS:json['STATUS'],cnt:json['cnt'];

  Insert.fromJson(Map<String, dynamic> json)
      : status = json['STATUS'],
        cnt = json['cnt'];

  Map<String, dynamic> toJson() => {
        'STATUS': status,
        'cnt': cnt,
      };
}

Future<Insert> paymentStory(
  String reciptId,
  String orderId,
  String cardCode,
  String cardName,
  String cardNo,
  String cardQuota,
  String itemName,
  String method,
  String methodName,
  String paymentGroup,
  String paymentGroupName,
  String paymentName,
  String pg,
  String pgName,
  String price,
  String purchasedAt,
  String receiptUrl,
  String requestedAt,
  String status,
  String taxFree,
  String url,
  String canceledAT,
) async {
  var bodyParam = new Map();
  bodyParam['receipt_id'] = reciptId;
  bodyParam['order_id'] = orderId;
  bodyParam['card_code'] = cardCode;
  bodyParam['card_name'] = cardName;
  bodyParam['card_no'] = cardNo;
  bodyParam['card_quota'] = cardQuota;
  bodyParam['item_name'] = itemName;
  bodyParam['method'] = method;
  bodyParam['method_name'] = methodName;
  bodyParam['payment_group'] = paymentGroup;
  bodyParam['payment_group_name'] = paymentGroupName;
  bodyParam['payment_name'] = paymentName;
  bodyParam['pg'] = pg;
  bodyParam['pg_name'] = pgName;
  bodyParam['price'] = price;
  bodyParam['purchased_at'] = purchasedAt;
  bodyParam['receipt_url'] = receiptUrl;
  bodyParam['requested_at'] = requestedAt;
  bodyParam['status'] = status;
  bodyParam['tax_free'] = taxFree;
  bodyParam['url'] = url;
  bodyParam['canceled_at'] = canceledAT;

  http.Response response = await http.post(
    Uri.encodeFull('http://hndsolution.iptime.org:8086/insertPayment'),
    headers: {"Accept": "application/json"},
    body: bodyParam,
  );

  if (response.statusCode == 200) {
    return Insert.fromJson(json.decode(response.body));
  } else {
    throw HttpException(
      ' jy Unexpected status code ${response.statusCode}:'
      'jy ${response.reasonPhrase}',
      //uri: Uri.parse(query)
    );
  }
}

/////////////////////////////
/////////////////////////////
/////////////////////////////
/////////////////////////////
/////////////////////////////
/////////push message////////
/////////////////////////////
/////////////////////////////
/////////////////////////////
/////////////////////////////
/////////////////////////////

pushMessageUser(
  String userId,
  String userPassword,
) async {
  var bodyParam = new Map();
  bodyParam['user_id'] = userId;
  bodyParam['user_password'] = userPassword;

  http.Response response = await http.post(
    Uri.encodeFull(
        'http://hndsolution.iptime.org:8086/usermngr/shopTmplatView.do'),
    headers: {"Accept": "application/json"},
    body: bodyParam,
  );

  if (response.statusCode == 200) {
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
