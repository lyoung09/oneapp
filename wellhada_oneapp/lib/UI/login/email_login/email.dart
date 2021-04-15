import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wellhada_oneapp/UI/login/mobile_authen/mobil_authen.dart';

class Email extends StatefulWidget {
  @override
  _EmailState createState() => _EmailState();
}

class _EmailState extends State<Email> {
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  var index = 1;
  var emailId;
  var passwordFirst;
  var passwordCheck;

  void checkEmail(String value) async {
    setState(() {
      emailId = value;
    });
  }

  void checkPassword(String value) async {
    setState(() {
      passwordFirst = value;
    });
  }

  void verificationPassword(String value) async {}

  Widget email() {
    return Container(
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Column(children: <Widget>[
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
                        fontFamily: 'Godo',
                        fontSize: 14.0,
                        color: Colors.grey[500]),
                  ),
                  // validator: (String value) {
                  //   if (!validator.isEmail(value)) {
                  //     return 'Please enter a valid email';
                  //   }
                  //   return null;
                  // },
                  onSaved: (String value) {
                    //model.email = value;

                    checkEmail(value);

                    value = null;
                  },
                ),
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
    );
  }

  Widget password() {
    return Container(
      child: Form(
        key: _formKey2,
        child: Column(
          children: <Widget>[
            Column(children: <Widget>[
              Text("a"),
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
                    checkPassword(value);
                  },
                ),
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
    );
  }

  Widget certainPassword() {
    return Container(
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Column(children: <Widget>[
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
                      return 'Password should be minimum 7 characters';
                    } else if (value != null && value != passwordFirst) {
                      return 'Password not matched';
                    }
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
                    hintText: "password",
                    hintStyle: TextStyle(
                        fontFamily: 'Godo',
                        fontSize: 14.0,
                        color: Colors.grey[500]),
                  ),
                ),
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
                      //             Mobil_authen(model: this.model)));
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
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        // resizeToAvoidBottomPadding: false,
        body: Container(
      child: Column(children: [
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
        Padding(
          padding: EdgeInsets.only(top: 50.0, bottom: 50),
        ),
        emailId == null
            ? email()
            : passwordFirst == null
                ? password()
                : certainPassword()
      ]),
    ));
  }
}
