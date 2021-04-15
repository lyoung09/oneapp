import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wellhada_oneapp/UI/login/email_login/password_check.dart';

import 'package:wellhada_oneapp/model/login/user.dart';

import 'package:validators/validators.dart' as validator;

class Email_password extends StatefulWidget {
  Model model;
  Email_password({this.model});
  @override
  _Email_passwordState createState() => _Email_passwordState(this.model);
}

class _Email_passwordState extends State<Email_password> {
  Model model;
  _Email_passwordState(this.model);

  bool _err;
  bool _completeButton;
  final TextEditingController emailPassword = TextEditingController(text: '');
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _completeButton = false;
    _err = false;
    model.password = null;
    //_initData();
  }

  _textPress() {
    setState(() {
      if (emailPassword.text != '') {
        _completeButton = true;
      } else {
        _completeButton = false;
      }
    });
  }

  _nextButtonPress() {
    if (_completeButton == false) {
      return () {
        // _err = true;
        // if (userEmail.text == '' || !userEmail.text.contains('@')) {
        //   errorNumber = 1;
        // }
        // if (userPassword.text == '') {
        //   errorNumber = 2;
        // }
        // FlutterDialog();
      };
    } else {
      return () {
        //_SignUpWithEmail();
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      //   resizeToAvoidBottomPadding: false,
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 50.0),
            ),
            Align(
              alignment: Alignment.topLeft,
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
              alignment: Alignment.topLeft,
              child: Container(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  "Password",
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
              padding: const EdgeInsets.only(top: 40.0),
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
                          obscureText: true,
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
                            hintText: "password",
                            hintStyle: TextStyle(
                                fontFamily: 'Godo',
                                fontSize: 14.0,
                                color: Colors.grey[500]),
                          ),
                          validator: (String value) {
                            if (value.length < 7) {
                              return 'Password should be minimum 7 characters';
                            }
                            return null;
                          },
                          onSaved: (String value) {
                            model.password = value;
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
                                      builder: (context) => Email_passwordCheck(
                                          model: this.model)));
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
              ),
            ),
            // Expanded(
            //     child: PasswordForm(
            //         AppTitle, UserScSeq, appColor, menuColor, appFontColor,
            //         model: this.model))
          ],
        ),
      ),
    );
  }
}

class PasswordForm extends StatefulWidget {
  String AppTitle, UserScSeq, appColor, menuColor, appFontColor;
  Model model;
  PasswordForm(AppTitle, UserScSeq, appColor, menuColor, appFontColor,
      {this.model});
  @override
  _PasswordFormState createState() => _PasswordFormState(
      AppTitle, UserScSeq, appColor, menuColor, appFontColor, this.model);
}

class _PasswordFormState extends State<PasswordForm> {
  String AppTitle, UserScSeq, appColor, menuColor, appFontColor;
  Model model;
  _PasswordFormState(
      AppTitle, UserScSeq, appColor, menuColor, appFontColor, this.model);

  final _formKey = GlobalKey<FormState>();

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
                  hintText: "password",
                  hintStyle: TextStyle(
                      fontFamily: 'Godo',
                      fontSize: 14.0,
                      color: Colors.grey[500]),
                ),
                validator: (String value) {
                  if (value.length < 7) {
                    return 'Password should be minimum 7 characters';
                  }
                  return null;
                },
                onSaved: (String value) {
                  model.password = value;
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
                                Email_passwordCheck(model: this.model)));
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
