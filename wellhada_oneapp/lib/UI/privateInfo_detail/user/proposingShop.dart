import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:validators/validators.dart' as validator;
import 'package:intl/intl.dart';

class ProposingShop extends StatefulWidget {
  @override
  _ProposingShopState createState() => _ProposingShopState();
}

class _ProposingShopState extends State<ProposingShop> {
  final _formKey = GlobalKey<FormState>();
  var userEmail = '';
  var emailController;
  var name;
  var shopName;
  var address;
  var category;
  var mobile;
  initState() {
    super.initState();
    check();
  }

  check() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      userEmail = prefs.getString("userKey");
    });
    emailController = TextEditingController(text: '${userEmail}');
  }

  suggetion() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      prefs.setString("wellhadaName", name);
      prefs.setString("wellhadaMobile", mobile);
      prefs.setString("wellhadaEmail", userEmail);
      prefs.setString("wellhadashopName", shopName);
      prefs.setString("wellhadaAddress", address);
      prefs.setString("wellhadaCategory", category);
    });
    Navigator.pushNamed(context, '/BottomNav');
  }

  changeEmailsuggetion() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      prefs.setString("wellhadaName", name);
      prefs.setString("wellhadaMobile", mobile);
      prefs.setString("wellhadaEmail", emailController.text);
      prefs.setString("wellhadashopName", shopName);
      prefs.setString("wellhadaAddress", address);
      prefs.setString("wellhadaCategory", category);
    });
    Navigator.pushNamed(context, '/BottomNav');
  }

  proposing() async {
    if (emailController.text == '' || userEmail == emailController.text) {
      showDialog(
          context: context,
          builder: (_) => CupertinoAlertDialog(
                title: Text('문의 내역이 맞나요?'),
                content: Text(
                    ' 이름 : ${name}\n\n  핸드폰: ${mobile} \n \n이메일 : ${userEmail} \n\n 상호명 : ${shopName} \n \n주소 : ${address} \n \n 업종 : ${category} \n \n'),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text('아니요'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  CupertinoDialogAction(child: Text('네'), onPressed: suggetion),
                ],
              ));
    } else {
      showDialog(
          context: context,
          builder: (_) => CupertinoAlertDialog(
                title: Text('문의 내역이 맞나요?'),
                content: Text(
                    ' 이름 : ${name}\n\n  핸드폰: ${mobile} \n \n이메일 : ${emailController.text} \n\n 상호명 : ${shopName} \n \n주소 : ${address} \n \n 업종 : ${category} \n \n'),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text('아니요'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  CupertinoDialogAction(
                      child: Text('네'), onPressed: changeEmailsuggetion),
                ],
              ));
    }
  }

  cancel() {
    Navigator.pop(context);
  }

  Widget _proposingWellhada() {
    return ListView(
      children: <Widget>[
        Form(
          key: _formKey,
          child: Stack(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
              ),
              Positioned(
                top: -40.0,
                left: -40.0,
                child: Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                      color: Colors.amberAccent, shape: BoxShape.circle),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "문의하기",
                    textScaleFactor: 2.0,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 150),
                child: Container(
                  color: Colors.white70,
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 5),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: TextFormField(
                              decoration: InputDecoration(
                                // border: InputBorder.none,
                                focusedBorder: const OutlineInputBorder(
                                  // width: 2.0 produces a thin "hairline" border
                                  borderSide: const BorderSide(
                                      color: Colors.amberAccent, width: 2.0),
                                ),
                                contentPadding: const EdgeInsets.all(6.0),
                                hintText: "이름(*)",
                                hintStyle: TextStyle(
                                    fontFamily: 'nanumR',
                                    fontSize: 14.0,
                                    color: Colors.grey[500]),
                              ),
                              validator: (String value) {
                                if (value.isEmpty == true || value.length > 8) {
                                  return '';
                                }
                                return null;
                              },
                              onSaved: (String value) {
                                name = value;
                              },
                            ),
                          ),
                        ],
                      ),
                      Container(
                        child: Divider(
                            //  color: Color.fromRGBO(82, 110, 208, 1.0),
                            ),
                        padding: EdgeInsets.only(
                            left: 20.0, right: 20.0, bottom: 0.0),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 5),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                focusedBorder: const OutlineInputBorder(
                                  // width: 2.0 produces a thin "hairline" border
                                  borderSide: const BorderSide(
                                      color: Colors.amberAccent, width: 2.0),
                                ),
                                // border: InputBorder.none,
                                contentPadding: const EdgeInsets.all(6.0),
                                hintText: "연락처(*)",
                                hintStyle: TextStyle(
                                    fontFamily: 'nanumR',
                                    fontSize: 14.0,
                                    color: Colors.grey[500]),
                              ),
                              validator: (String value) {
                                if (value.isEmpty == true) {
                                  return '';
                                }
                                return null;
                              },
                              onSaved: (String value) {
                                mobile = value;
                              },
                            ),
                          ),
                        ],
                      ),
                      Container(
                        child: Divider(
                            //  color: Color.fromRGBO(82, 110, 208, 1.0),
                            ),
                        padding: EdgeInsets.only(
                            left: 20.0, right: 20.0, bottom: 0.0),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 5),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: TextFormField(
                              inputFormatters: [
                                new LengthLimitingTextInputFormatter(28),
                              ],
                              style: TextStyle(color: Colors.black),
                              controller: emailController,
                              decoration: InputDecoration(
                                focusedBorder: const OutlineInputBorder(
                                  // width: 2.0 produces a thin "hairline" border
                                  borderSide: const BorderSide(
                                      color: Colors.amberAccent, width: 2.0),
                                ),
                                // border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        child: Divider(
                            //  color: Color.fromRGBO(82, 110, 208, 1.0),
                            ),
                        padding: EdgeInsets.only(
                            left: 20.0, right: 20.0, bottom: 0.0),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 5),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: TextFormField(
                              decoration: InputDecoration(
                                focusedBorder: const OutlineInputBorder(
                                  // width: 2.0 produces a thin "hairline" border
                                  borderSide: const BorderSide(
                                      color: Colors.amberAccent, width: 2.0),
                                ),
                                //border: InputBorder.none,
                                contentPadding: const EdgeInsets.all(6.0),
                                hintText: "상호명(*)",
                                hintStyle: TextStyle(
                                    fontFamily: 'nanumR',
                                    fontSize: 14.0,
                                    color: Colors.grey[500]),
                              ),
                              validator: (String value) {
                                if (value.isEmpty == true) {
                                  return '';
                                }
                                return null;
                              },
                              onSaved: (String value) {
                                shopName = value;
                              },
                            ),
                          ),
                        ],
                      ),
                      Container(
                        child: Divider(
                            //  color: Color.fromRGBO(82, 110, 208, 1.0),
                            ),
                        padding: EdgeInsets.only(
                            left: 20.0, right: 20.0, bottom: 0.0),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 5),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: TextFormField(
                              decoration: InputDecoration(
                                focusedBorder: const OutlineInputBorder(
                                  // width: 2.0 produces a thin "hairline" border
                                  borderSide: const BorderSide(
                                      color: Colors.amberAccent, width: 2.0),
                                ),

                                // border: InputBorder.none,
                                contentPadding: const EdgeInsets.all(6.0),
                                hintText: "주소(*)",
                                hintStyle: TextStyle(
                                    fontFamily: 'nanumR',
                                    fontSize: 14.0,
                                    color: Colors.grey[500]),
                              ),
                              validator: (String value) {
                                if (value.isEmpty == true) {
                                  return '';
                                }
                                return null;
                              },
                              onSaved: (String value) {
                                address = value;
                              },
                            ),
                          ),
                        ],
                      ),
                      Container(
                        child: Divider(
                            // color: Color.fromRGBO(82, 110, 208, 1.0),
                            ),
                        padding: EdgeInsets.only(
                            left: 20.0, right: 20.0, bottom: 0.0),
                      ),
                      Row(children: [
                        Padding(
                          padding: EdgeInsets.only(left: 5),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: TextFormField(
                            decoration: InputDecoration(
                              focusedBorder: const OutlineInputBorder(
                                // width: 2.0 produces a thin "hairline" border
                                borderSide: const BorderSide(
                                    color: Colors.amberAccent, width: 2.0),
                              ),
                              //  border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(6.0),
                              hintText: "업종(*)",
                              hintStyle: TextStyle(
                                  fontFamily: 'nanumR',
                                  fontSize: 14.0,
                                  color: Colors.grey[500]),
                            ),
                            validator: (String value) {
                              if (value.isEmpty == true) {
                                return '';
                              }
                              return null;
                            },
                            onSaved: (String value) {
                              category = value;
                            },
                          ),
                        ),
                      ]),
                      Padding(
                        padding: EdgeInsets.only(top: 40, bottom: 20),
                      ),
                      Container(
                        height: 45,
                        width: 200,
                        child: RaisedButton(
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              proposing();
                            }
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40.0),
                              side: BorderSide(color: Colors.black)),
                          child: Text("신청하기",
                              style: TextStyle(color: Colors.black)),
                          color: Colors.white,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 20),
                      ),
                      Container(
                        height: 45,
                        width: 200,
                        child: RaisedButton(
                          onPressed: cancel,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40.0),
                              side: BorderSide(color: Colors.black)),
                          child:
                              Text("취소", style: TextStyle(color: Colors.black)),
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              // Positioned(
              //     left: (MediaQuery.of(context).size.width / 2) - 100,
              //     top: 3 / 4 * (MediaQuery.of(context).size.height),
              //     child: Container(
              //       height: 45,
              //       width: 200,
              //       child: RaisedButton(
              //         onPressed: () {
              //           if (_formKey.currentState.validate()) {
              //             _formKey.currentState.save();
              //             proposing();
              //           }
              //         },
              //         shape: RoundedRectangleBorder(
              //             borderRadius: BorderRadius.circular(40.0),
              //             side: BorderSide(color: Colors.black)),
              //         child:
              //             Text("신청하기", style: TextStyle(color: Colors.black)),
              //         color: Colors.white,
              //       ),
              //     )),
              // Positioned(
              //     left: (MediaQuery.of(context).size.width / 2) - 100,
              //     top: 3 / 4 * (MediaQuery.of(context).size.height) + 55,
              //     child: Container(
              //       height: 45,
              //       width: 200,
              //       child: RaisedButton(
              //         onPressed: cancel,
              //         shape: RoundedRectangleBorder(
              //             borderRadius: BorderRadius.circular(40.0),
              //             side: BorderSide(color: Colors.black)),
              //         child: Text("취소", style: TextStyle(color: Colors.black)),
              //         color: Colors.white,
              //       ),
              //     )),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: _proposingWellhada(),
    );
  }
}
