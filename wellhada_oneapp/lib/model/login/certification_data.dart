// @dart=2.9
import 'dart:convert';

import './iamport_url.dart';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';

class CertificationData {
  String merchnatUid; // 주문번호
  String company; // 회사명 또는 URL
  String carrier; // 통신사
  String name; // 본인인증 할 이름
  String phone; // 본인인증 할 휴대폰 번호
  String email;
  int minAge; // 허용 최소 만 나이

  CertificationData(
    this.merchnatUid,
    this.company,
    this.carrier,
    this.name,
    this.phone,
    this.email,
    this.minAge,
  );

  CertificationData.fromJson(Map<String, dynamic> data)
      : merchnatUid = data['merchantUid'],
        company = data['company'],
        carrier = data['carrier'],
        name = data['name'],
        phone = data['phone'],
        email = data['email'],
        minAge = data['minAge'];

  String toJsonString() {
    Map<String, dynamic> jsonData = {
      'email': email,
      'phone': phone,
      'm_redirect_url': IamportUrl.redirectUrl,
    };

    if (merchnatUid != null) {
      jsonData['merchnatUid'] = merchnatUid;
    }
    if (company != null) {
      jsonData['company'] = company;
    }
    if (carrier != null) {
      jsonData['carrier'] = carrier;
    }
    if (name != null) {
      jsonData['name'] = name;
    }
    if (phone != null) {
      jsonData['phone'] = phone;
    }
    if (minAge != null) {
      jsonData['min_age'] = minAge;
    }
    if (email != null) {
      jsonData['email'] = email;
    }
    return jsonEncode(jsonData);
  }

  //로그인 체크
  Future<CertificationData> getLoginChk(String name, String phone) async {
    var bodyParam = new Map();
    bodyParam['name'] = name;
    bodyParam['phone'] = phone;

    http.Response response = await http.post(
      Uri.encodeFull('https://wellhada.com/loginChk'),
      headers: {"Accept": "application/json"},
      body: bodyParam,
    );

    // if (response.statusCode == 200) {
    //   return MainItem.fromJson(json.decode(response.body));
    // } else {
    //   throw HttpException(
    //     'Unexpected status code ${response.statusCode}:'
    //     ' ${response.reasonPhrase}',
    //     //uri: Uri.parse(query)
    //   );
    // }
  }
}
