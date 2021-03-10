import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class Email_complete extends StatefulWidget {
  Email_complete();

  @override
  _Email_completeState createState() => _Email_completeState();
}

class _Email_completeState extends State<Email_complete> {
  _Email_completeState();

  bool getIsSuccessed(Map<String, String> result) {
    if (result['imp_success'] == 'true') {
      return true;
    }
    if (result['success'] == 'true') {
      return true;
    }
    return false;
  }

  SharedPreferences prefs;
  var screenSeq;
  var name;
  var email;
  var phone;

  @override
  void initState() {
    super.initState();

    _initData();
    _go();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _go() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      email = prefs.getString('userEmail');
      phone = prefs.getString('userPhone');
    });
    print(email);
    print(phone);
  }

  Future<void> _initData() async {
    prefs = await SharedPreferences.getInstance();

    setState(() {
      screenSeq = prefs.getString("screenSeq");
    });
  }

  @override
  Widget build(BuildContext context) {
    Map<String, String> result = ModalRoute.of(context).settings.arguments;

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Hexcolor('#F1F2F6'),
      body: Container(
        child: Column(children: <Widget>[
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(top: 10.0, bottom: 50.0),
            child: Text(
              "가입완료",
              style: TextStyle(
                color: Hexcolor('#242A37'),
                fontFamily: "Godo",
                fontWeight: FontWeight.w800,
                fontSize: 15.0,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                  flex: 4,
                  child: Text('아임포트 번호', style: TextStyle(color: Colors.grey))),
              Expanded(
                flex: 5,
                child: Text(result['imp_uid']),
              ),
            ],
          ),
          Container(
            height: height / 4,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    "${email}" + " 환영합니다.",
                    style: TextStyle(
                      color: Hexcolor('#242A37'),
                      fontFamily: "Godo",
                      fontWeight: FontWeight.w800,
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                top: 20.0, left: 20.0, right: 20.0, bottom: 20.0),
            child: Divider(
              color: Colors.grey,
              height: 2.0,
            ),
          ),
          RaisedButton(
              child: Container(
                height: 40.0,
                width: width - 100,
                decoration: BoxDecoration(
                  color: Colors.yellow[700],
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Center(
                  child: Text(
                    "시작하기",
                    style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 0.2,
                        fontFamily: "Godo",
                        fontSize: 16.0,
                        fontWeight: FontWeight.w800),
                  ),
                ),
              ),
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //       builder: (context) => SIGNUP_COMPLETE(AppTitle, UserScSeq,
                //           appColor, menuColor, appFontColor)),
                // );
              }),
        ]),
      ),
    );
  }
}
