import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wellhada_oneapp/UI/privateInfo_detail/mobile_authen/mobil_authen.dart';
import 'package:wellhada_oneapp/UI/privateInfo_detail/mobile_authen/mobile.dart';
import 'package:wellhada_oneapp/model/login/user.dart';
import 'package:validators/validators.dart' as validator;

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
    setState(() {
      emailId = value;
    });
  }

  void checkPassword(String value) async {
    setState(() {
      passwordFirst = value;
    });
  }

  void verificationPassword(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      if (value == passwordCheck) {
        prefs.setString('userEmail', model.email);
      }
    });
    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) => Mobil_authen(model: this.model)));
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => LoginScreen(model: this.model)));
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
              Container(
                child: Text("Email"),
                alignment: Alignment.topLeft,
              ),
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
                  validator: (String value) {
                    if (!validator.isEmail(value)) {
                      return 'Please enter a valid email';
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
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height * 0.6,
      child: Form(
        key: _formKey2,
        child: Column(
          children: <Widget>[
            Column(children: <Widget>[
              Container(
                child: Text("비밀번호"),
                alignment: Alignment.topLeft,
              ),
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
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height * 0.6,
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Column(children: <Widget>[
              Container(
                child: Text("비밀번호 확인"),
                alignment: Alignment.topLeft,
              ),
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
                        fontFamily: 'Godo',
                        fontSize: 14.0,
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
        resizeToAvoidBottomPadding: false,
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
                        fontFamily: "Sans",
                        fontWeight: FontWeight.w800,
                        fontSize: 15.0,
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
