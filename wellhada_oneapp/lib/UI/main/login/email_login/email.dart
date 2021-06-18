// @dart=2.9
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:wellhada_oneapp/model/login/userData.dart';
import 'package:validators/validators.dart' as validator;
import 'package:wellhada_oneapp/listitem/userFile/userList.dart' as user;

import 'mobile.dart';

class Email extends StatefulWidget {
  @override
  _EmailState createState() => _EmailState();
}

class _EmailState extends State<Email> {
  Model model = new Model();
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  var index = 1;
  var emailId;
  var passwordFirst;
  var passwordCheck;

  void checkEmail(String value) async {
    final userData = await user.getUserInfomation(value);
    if (userData.userId != null) {
      showDialog(
          context: context,
          builder: (_) => CupertinoAlertDialog(
                content: Text("중복된 아이디입니다."),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text('확인'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ));
    } else {
      setState(() {
        emailId = value;
      });
    }
  }

  void checkPassword(String value) async {
    setState(() {
      passwordFirst = value;
      model.password = passwordFirst;
    });
  }

  verificationPassword(String value) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MobileScreen("signup", model: this.model)));

    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) => Mobil_authen(model: this.model)));
  }

  Widget email() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height * 0.6,
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Column(children: <Widget>[
              // Container(
              //   child: Text("Email"),
              //   alignment: Alignment.topLeft,
              // ),
              Container(
                alignment: Alignment.center,

                //         decoration: BoxDecoration(
                // border: Border.all(
                //   color: Hexcolor('#FFD428'),
                // ),
                // color: Colors.white,
                // borderRadius: BorderRadius.circular(10.0)),
                child: TextFormField(
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  cursorColor: Hexcolor('#FF8900'),
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Hexcolor('#FFD428')),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Hexcolor('#FFD428')),
                    ),
                    hintText: "email",
                    hintStyle: TextStyle(
                        fontFamily: 'nanumB',
                        fontSize: 20.0,
                        color: Colors.grey[500]),
                  ),
                  validator: (String value) {
                    if (!validator.isEmail(value) || value.length < 12) {
                      return '이메일 형태를 맞춰주세요';
                    }

                    return null;
                  },
                  onSaved: (String value) {
                    model.email = value;

                    checkEmail(value);

                    value = null;
                  },
                ),
              ),

              Padding(
                padding: EdgeInsets.only(bottom: 15.0),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: FlatButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();

                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) =>
                      //             Email_password(model: this.model)));
                    }
                  },
                  child: Container(
                    height: 40.0,
                    width: 80.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Center(
                      child: Text(
                        "다음   >",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            color: Hexcolor('#242A37'),
                            letterSpacing: 0.2,
                            fontFamily: "nanumR",
                            fontSize: 16.0,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                ),
              ),
            ])
          ],
        ),
      ),
    );
  }

  Widget password() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height * 0.6,
      child: Form(
        key: _formKey2,
        child: Column(
          children: <Widget>[
            Column(children: <Widget>[
              // Container(
              //   child: Text("비밀번호"),
              //   alignment: Alignment.topLeft,
              // ),
              Container(
                alignment: Alignment.center,
                //         decoration: BoxDecoration(
                // border: Border.all(
                //   color: Hexcolor('#FFD428'),
                // ),
                // color: Colors.white,
                // borderRadius: BorderRadius.circular(10.0)),
                child: TextFormField(
                  controller: passwordFirst,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  obscureText: true,
                  cursorColor: Hexcolor('#FF8900'),
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Hexcolor('#FFD428')),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Hexcolor('#FFD428')),
                    ),
                    hintText: "비밀번호",
                    hintStyle: TextStyle(
                        fontFamily: 'nanumB',
                        fontSize: 20.0,
                        color: Colors.grey[500]),
                  ),
                  validator: (String value) {
                    if (value.length < 8) {
                      return '비밀번호는 8자리 이상이여야 합니다';
                    }
                    if (value.contains(RegExp(r'[0-9]')) == false ||
                        value.contains(RegExp(r'[a-z]')) == false ||
                        value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')) ==
                            false) {
                      return "영문자 숫자 그리고 특수문자를 모두 포함해야 합니다";
                    }

                    return null;
                  },
                  onSaved: (String value) {
                    checkPassword(value);
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 15.0),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: FlatButton(
                  onPressed: () {
                    if (_formKey2.currentState.validate()) {
                      _formKey2.currentState.save();
                    }
                  },
                  child: Container(
                    height: 40.0,
                    width: 80.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Center(
                      child: Text(
                        "다음   >",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            color: Hexcolor('#242A37'),
                            letterSpacing: 0.2,
                            fontFamily: "nanumR",
                            fontSize: 16.0,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                ),
              ),
            ])
          ],
        ),
      ),
    );
  }

  Widget certainPassword() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height * 0.6,
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Column(children: <Widget>[
              // Container(
              //   child: Text("비밀번호 확인"),
              //   alignment: Alignment.topLeft,
              // ),
              Container(
                alignment: Alignment.center,

                //         decoration: BoxDecoration(
                // border: Border.all(
                //   color: Hexcolor('#FFD428'),
                // ),
                // color: Colors.white,
                // borderRadius: BorderRadius.circular(10.0)),
                child: TextFormField(
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  obscureText: true,
                  validator: (String value) {
                    if (value.length < 7) {
                      return '비밀번호는 7자리 이상이여야 합니다';
                    } else if (value != null && value != passwordFirst) {
                      return '비밀번호가 달라요';
                    }
                    verificationPassword(value);
                    return null;
                  },
                  cursorColor: Hexcolor('#FF8900'),
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Hexcolor('#FFD428')),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Hexcolor('#FFD428')),
                    ),
                    hintText: "비밀번호 확인",
                    hintStyle: TextStyle(
                        fontFamily: 'nanumB',
                        fontSize: 20.0,
                        color: Colors.grey[500]),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 15.0),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: FlatButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                    }
                  },
                  child: Container(
                    height: 40.0,
                    width: 80.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Center(
                      child: Text(
                        "다음   >",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            color: Hexcolor('#242A37'),
                            letterSpacing: 0.2,
                            fontFamily: "nanumR",
                            fontSize: 16.0,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                ),
              ),
            ])
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
            ClipPath(
              clipper: OvalBottomBorderClipper(),
              child: Container(
                height: MediaQuery.of(context).size.height / 4 + 40,
                color: Colors.white,
              ),
            ),
            Positioned(
              top: -20.0,
              left: -40.0,
              child: Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                    color: Colors.amberAccent, shape: BoxShape.circle),
              ),
            ),
            Container(
              child: Column(children: [
                Padding(
                  padding: EdgeInsets.only(top: 50.0, left: 25),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      "welcome to\n\n골목샾",
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        color: Hexcolor('#242A37'),
                        fontFamily: "nanumB",
                        fontWeight: FontWeight.w900,
                        fontSize: 25.0,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 50.0, bottom: 50),
                ),
                emailId == null
                    ? email()
                    : passwordFirst == null
                        ? password()
                        : certainPassword(),
              ]),
            ),
          ],
        ));
  }
}
