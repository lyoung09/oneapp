import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:wellhada_oneapp/model/login/certification_data.dart';
import 'package:wellhada_oneapp/model/login/user.dart';
import 'package:hexcolor/hexcolor.dart';

class Mobil_authen extends StatefulWidget {
  Model model;
  Mobil_authen({this.model});
  @override
  _Mobil_authenState createState() => _Mobil_authenState(this.model);
}

class _Mobil_authenState extends State<Mobil_authen> {
  Model model;
  _Mobil_authenState(this.model);

  var _email;
  final TextEditingController userPhoneNumber = TextEditingController(text: '');
  final _formKey = GlobalKey<FormState>();

  String errorText;
  var userEmail;
  var userPassword;

  bool _completeButton;

  @override
  void initState() {
    super.initState();
    _completeButton = false;
    _initData();
  }

  @override
  void dispose() {
    super.dispose();
    userPhoneNumber.dispose();
  }

  _initData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      prefs.setString('userEmail', model.email);
      prefs.setString('userPhone', model.phone);
    });
  }

  _textPress() {
    setState(() {
      if (userPhoneNumber == '') {
        _completeButton = true;
      } else {
        _completeButton = false;
      }
    });
  }

  _mobile_auth() async {
    model.phone = userPhoneNumber.text;
    //appAgreePush,AppTitle, UserScSeq, appColor, menuColor, appFontColor
    //  ));
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Container(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Row(children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(top: 40.0, bottom: 10.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        " 골목샾 ",
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
                ]),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "핸드폰 인증하기",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Hexcolor('#242A37'),
                          fontFamily: "Sans",
                          fontWeight: FontWeight.w800,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 45.0),
                ),
                Expanded(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Center(
                          child: Container(
                            alignment: Alignment.center,
                            height: 45.0,
                            width: width - 150.0,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Hexcolor('#FFD428'),
                                ),
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0)),
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                color: Colors.black,
                              ),
                              validator: (String value) {
                                if (value.length < 8 || value.length > 11) {
                                  return 'check please';
                                }
                                return null;
                              },
                              onSaved: (String value) {
                                model.phone = value;
                                _initData();
                              },
                              cursorColor: Hexcolor('#FF8900'),
                              textAlignVertical: TextAlignVertical.center,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.all(13.0),
                                hintText: "핸드폰 번호",
                                hintStyle: TextStyle(
                                    fontFamily: 'Godo',
                                    fontSize: 14.0,
                                    color: Colors.grey[500]),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 10.0,
                            top: 0.0,
                            right: 0.0,
                            bottom: 0.0,
                          ),
                          child: RaisedButton.icon(
                            icon: Icon(Icons.people),
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                _formKey.currentState.save();
                                CertificationData data =
                                    CertificationData.fromJson({});

                                if (model.email != null) {
                                  data.email = model.email;
                                  print(data.email);
                                }
                                if (model.phone != null) {
                                  data.phone = model.phone;
                                  print(data.phone);
                                }

                                Navigator.pushNamed(context, '/certification',
                                    arguments: data);
                              }
                            },
                            label: Text('본인인증'),
                            color: Colors.white,
                          ),
                        ),
                      ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
