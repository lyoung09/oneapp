// @dart=2.9
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:wellhada_oneapp/listitem/userFile/userList.dart' as user;

class Model {
  String email;
  String password;
  String phone;

  Model({this.email, this.password, this.phone});
}

class Wellhada {
  String email;
  String name;
  String shopName;
  String address;
  String category;
  String mobile;

  Wellhada(
      {this.email,
      this.name,
      this.shopName,
      this.address,
      this.category,
      this.mobile});
}

class UserData {
  String email;
  String id;
  String phone;
  String userName;
  String appAgreeMarketing;
  String userChk;
  String status;
  int cnt;
  String birthday;
  String gender;
  String profile;

  UserData(
      {this.email,
      this.id,
      this.phone,
      this.userName,
      this.appAgreeMarketing,
      this.userChk,
      this.birthday,
      this.gender,
      this.profile});

  userInsert() async {}

  userSave() async {}

  userUpdate() async {}

  userDelete() async {}
}
