import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wellhada_oneapp/UI/login/email_login/password.dart';

import 'package:wellhada_oneapp/model/login/user.dart';

import 'package:validators/validators.dart' as validator;

class Email_signup extends StatefulWidget {
  @override
  _Email_signupState createState() => _Email_signupState();
}

class _Email_signupState extends State<Email_signup> {
  bool _completeButton;
  final _formKey = GlobalKey<FormState>();
  bool _err = false;
  var errorText;
  Model model = Model();
  var appColor = '#ffffff';
  var menuColor = '#ffd428';
  var appFontColor = '#333333';
  var menuFontColor = '#333333';
  @override
  void initState() {
    super.initState();
    //_initData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 50.0),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "welcome to\n\n골목샾",
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Hexcolor('#242A37'),
                  fontFamily: "Sans",
                  fontWeight: FontWeight.w800,
                  fontSize: 15.0,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  "이메일 회원가입",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Hexcolor('#242A37'),
                    fontFamily: "Sans",
                    fontWeight: FontWeight.w800,
                    fontSize: 15.0,
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 70.0),
              child: Container(
                  child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Column(children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        height: 45.0,
                        width: width - 80.0,
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
                              borderSide:
                                  BorderSide(color: Hexcolor('#FFD428')),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Hexcolor('#FFD428')),
                            ),
                            hintText: "email",
                            hintStyle: TextStyle(
                                fontFamily: 'Godo',
                                fontSize: 14.0,
                                color: Colors.grey[500]),
                          ),
                          validator: (String value) {
                            if (!validator.isEmail(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                          onSaved: (String value) {
                            model.email = value;
                          },
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: FlatButton(
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Email_password(model: this.model)));
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
                                    fontFamily: "Sans",
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
              )),
            ),
            // Expanded(
            //     child: LoginForm(
            //         AppTitle, UserScSeq, appColor, menuColor, appFontColor))
          ],
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  String AppTitle, UserScSeq, appColor, menuColor, appFontColor;

  LoginForm(AppTitle, UserScSeq, appColor, menuColor, appFontColor);
  @override
  _LoginFormState createState() =>
      _LoginFormState(AppTitle, UserScSeq, appColor, menuColor, appFontColor);
}

class _LoginFormState extends State<LoginForm> {
  String AppTitle, UserScSeq, appColor, menuColor, appFontColor;

  _LoginFormState(AppTitle, UserScSeq, appColor, menuColor, appFontColor);

  final _formKey = GlobalKey<FormState>();
  Model model = Model();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // _textPress() {
  //   setState(() {
  //     if ((userEmail.text != '' && userEmail.text.contains('@'))) {
  //       _completeButton = true;
  //     } else {
  //       _completeButton = false;
  //     }
  //   });
  // }

  // _nextButtonPress() {
  //   if (_completeButton == false) {
  //     print(1);
  //     _err = true;
  //     errorText = "email error";
  //     return null;
  //   } else {
  //     return () {
  //       _SignUpWithEmail();
  //     };
  //   }
  // }

  // Future<void> _SignUpWithEmail() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     prefs.setString("userEmail", userEmail.text);
  //     prefs.setString("userPassword", userPassword.text);
  //   });
  //   Navigator.of(context).pushReplacement(PageRouteBuilder(
  //       pageBuilder: (_, __, ___) => Email_password(
  //           AppTitle, UserScSeq, appColor, menuColor, appFontColor)));
  // }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Column(children: <Widget>[
            Container(
              alignment: Alignment.center,
              height: 45.0,
              width: width - 80.0,
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
                      fontFamily: 'Godo',
                      fontSize: 14.0,
                      color: Colors.grey[500]),
                ),
                validator: (String value) {
                  if (!validator.isEmail(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
                onSaved: (String value) {
                  model.email = value;
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: FlatButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Email_password(model: this.model)));
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
                          fontFamily: "Sans",
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
    );
  }
}
