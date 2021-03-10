import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class Email_login extends StatefulWidget {
  Email_login();
  @override
  _Email_loginState createState() => _Email_loginState();
}

class _Email_loginState extends State<Email_login> {
  var appColor = '#ffffff';
  var menuColor = '#ffd428';
  var appFontColor = '#333333';
  var menuFontColor = '#333333';
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 40.0, bottom: 10.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "welcome to\n\n골목샾",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    //color: Hexcolor('#242A37'),
                    fontFamily: "Sans",
                    fontWeight: FontWeight.w800,
                    fontSize: 15.0,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  "이메일 로그인",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    //color: Hexcolor('#242A37'),
                    fontFamily: "Sans",
                    fontWeight: FontWeight.w800,
                    fontSize: 15.0,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
            ),
            Expanded(
              child: Column(
                children: <Widget>[
                  Column(children: <Widget>[
                    Center(
                      child: Container(
                        alignment: Alignment.center,
                        height: 45.0,
                        width: width - 80.0,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Hexcolor('#FFD428'),
                            ),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0)),
                        child: TextFormField(
                          //controller: userId,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          // cursorColor: Hexcolor('#FF8900'),
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.all(13.0),
                            hintText: "EMAIL(*)",
                            hintStyle: TextStyle(
                                fontFamily: 'Godo',
                                fontSize: 14.0,
                                color: Colors.grey[500]),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Container(
                        height: 45.0,
                        width: width - 80.0,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Hexcolor('#FFD428'),
                            ),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0)),
                        child: TextFormField(
                            //controller: userPassword,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                            cursorColor: Hexcolor('#FF8900'),
                            textAlignVertical: TextAlignVertical.center,
                            obscureText: true,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(13.0),
                              hintText: "비밀번호(*)",
                              hintStyle: TextStyle(
                                  fontFamily: 'Godo',
                                  fontSize: 14.0,
                                  color: Colors.grey[500]),
                            )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                    ),
                    InkWell(
                      // onTap: () {
                      //   _insertData();
                      // },
                      child: Container(
                        height: 40.0,
                        width: width - 100,
                        decoration: BoxDecoration(
                          color: Hexcolor('#FFD428'),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: Center(
                          child: Text(
                            "로그인",
                            style: TextStyle(
                                color: Hexcolor('#242A37'),
                                letterSpacing: 0.2,
                                fontFamily: "Sans",
                                fontSize: 16.0,
                                fontWeight: FontWeight.w800),
                          ),
                        ),
                      ),
                    ),
                  ])
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
