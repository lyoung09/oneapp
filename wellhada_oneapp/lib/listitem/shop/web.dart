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
    Uri.encodeFull('http://192.168.0.47:8080/usermngr/shopTmplatView.do'),
    headers: {"Accept": "application/json"},
    body: bodyParam,
  );

  if (response.statusCode == 200) {
    print(" status code : ${response.statusCode}");
    var datauser = json.decode(response.body);
    print("json ${datauser}");
    return datauser;
  } else {
    throw HttpException(
      'b'
      'Unexpected status code ${response.statusCode}:'
      ' ${response.reasonPhrase}',
      //uri: Uri.parse(query)
    );
  }
}
