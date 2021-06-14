// @dart=2.9
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wellhada_oneapp/model/login/userData.dart';

enum MobileVerificationState {
  SHOW_MOBILE_FORM_STATE,
  SHOW_OTP_FORM_STATE,
}

class LoginScreen extends StatefulWidget {
  Model model;
  LoginScreen({this.model});
  @override
  _LoginScreenState createState() => _LoginScreenState(this.model);
}

class _LoginScreenState extends State<LoginScreen> {
  Model model;
  _LoginScreenState(this.model);
  MobileVerificationState currentState =
      MobileVerificationState.SHOW_MOBILE_FORM_STATE;

  final phoneController = TextEditingController();
  final otpController = TextEditingController();
  var errorType;
  FirebaseAuth _auth = FirebaseAuth.instance;

  String verificationId;

  bool showLoading = false;

  void initState() {
    super.initState();
  }

  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      showLoading = true;
    });

    try {
      print("1");
      final authCredential =
          await _auth.signInWithCredential(phoneAuthCredential);

      setState(() {
        showLoading = false;
      });

      if (authCredential?.user != null) {
        setState(() {
          prefs.setString('userPhone', '${phoneController.text}');
          prefs.setString('userProfile', "");
          prefs.setString('userChk', '01');
          prefs.setString('userName', model.email);
          prefs.setInt('cookie', 1);
          prefs.setString('userEmail', model.email);
          prefs.setString('userId', model.email);
          prefs.setString('userPasswordGoweb', model.password);
        });
        Navigator.pushReplacementNamed(
          context,
          '/last_selection',
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        print("3");
        showLoading = false;
      });

      print(e.message);
      if (Platform.isAndroid) {
        switch (e.message) {
          case 'The format of the phone number provided is incorrect. Please enter the phone number in a format that can be parsed into E.164 format. E.164 phone numbers are written in the format [+][country code][subscriber number including area code]. [ TOO_SHORT ]':
          case 'The format of the phone number provided is incorrect. Please enter the phone number in a format that can be parsed into E.164 format. E.164 phone numbers are written in the format [+][country code][subscriber number including area code]. [ TOO_LONG ]':
          case 'The sms verification code used to create the phone auth credential is invalid. Please resend the verification code sms and be sure use the verification code provided by the user.':
            errorType = " SMS 확인 코드가 잘못되었습니다";
            break;
          case 'The verification ID used to create the phone auth credential is invalid.':
            //errorType = "확인 ID가 잘못되었습니다.";
            errorType = "비어있습니다.";
            break;
          default:
            errorType = e.message;
        }
      } else if (Platform.isIOS) {}
      showDialog(
          context: context,
          builder: (_) => CupertinoAlertDialog(
                content: Text(errorType),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text('확인'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ));
    }
  }

  getMobileFormWidget(context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height * 0.6,
      child: Column(
        children: [
          TextField(
            controller: phoneController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: "핸드폰 번호",
              hintStyle: TextStyle(
                  fontFamily: 'nanumB',
                  fontSize: 20.0,
                  color: Colors.grey[500]),
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Hexcolor('#FFD428')),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Hexcolor('#FFD428')),
              ),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: RaisedButton.icon(
              icon: Icon(Icons.people),
              onPressed: () async {
                setState(() {
                  showLoading = true;
                });

                await _auth.verifyPhoneNumber(
                  phoneNumber: '+82 ${phoneController.text}',
                  verificationCompleted: (phoneAuthCredential) async {
                    setState(() {
                      showLoading = false;
                    });
                    //signInWithPhoneAuthCredential(phoneAuthCredential);
                  },
                  verificationFailed: (verificationFailed) async {
                    setState(() {
                      showLoading = false;
                    });

                    print(verificationFailed.message);
                    if (Platform.isAndroid) {
                      switch (verificationFailed.message) {
                        case 'The format of the phone number provided is incorrect. Please enter the phone number in a format that can be parsed into E.164 format. E.164 phone numbers are written in the format [+][country code][subscriber number including area code]. [ TOO_LONG ]':
                        case 'The format of the phone number provided is incorrect. Please enter the phone number in a format that can be parsed into E.164 format. E.164 phone numbers are written in the format [+][country code][subscriber number including area code]. [ TOO_SHORT ]':
                        case 'The format of the phone number provided is incorrect. Please enter the phone number in a format that can be parsed into E.164 format. E.164 phone numbers are written in the format [+][country code][subscriber number including area code]. [ Invalid format. ]':
                          errorType = " 정확한 번호를 적어주세요";
                          break;
                        case 'The verification ID used to create the phone auth credential is invalid.':
                        case 'We have blocked all requests from this device due to unusual activity. Try again later.':
                          //errorType = "확인 ID가 잘못되었습니다.";
                          errorType =
                              "비정상적인 활동으로 인하여, 기기의 모든 요청을 차단했습니다. 나중에 다시 시도하십시오.";
                          break;
                        default:
                          errorType = verificationFailed.message;
                      }
                    } else if (Platform.isIOS) {}
                    showDialog(
                        context: context,
                        builder: (_) => CupertinoAlertDialog(
                              content: Text(errorType),
                              actions: <Widget>[
                                CupertinoDialogAction(
                                  child: Text('확인'),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                              ],
                            ));
                    // _scaffoldKey.currentState.showSnackBar(
                    //     SnackBar(content: Text(verificationFailed.message)));
                  },
                  codeSent: (verificationId, resendingToken) async {
                    setState(() {
                      showLoading = false;
                      currentState =
                          MobileVerificationState.SHOW_OTP_FORM_STATE;
                      this.verificationId = verificationId;
                    });
                  },
                  codeAutoRetrievalTimeout: (verificationId) async {},
                );
              },
              label: Text("인증 하기"),
              color: Hexcolor('#FFD428'),
              textColor: Colors.black,
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }

  getOtpFormWidget(context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 15),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: otpController,
                  decoration: InputDecoration(
                    hintText: "인증 번호",
                    hintStyle: TextStyle(
                        fontFamily: 'nanumB',
                        fontSize: 20.0,
                        color: Colors.grey[500]),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Hexcolor('#FFD428')),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Hexcolor('#FFD428')),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.1,
                height: 16,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.2,
                child: FlatButton(
                  onPressed: () async {
                    PhoneAuthCredential phoneAuthCredential =
                        PhoneAuthProvider.credential(
                            verificationId: verificationId,
                            smsCode: otpController.text);

                    signInWithPhoneAuthCredential(phoneAuthCredential);
                  },
                  child: Text("확인"),
                  color: Hexcolor('#FFD428'),
                  textColor: Colors.black,
                ),
              )
            ],
          ),
          Spacer(),
        ],
      ),
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: Stack(
          children: [
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
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 50.0, left: 25),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        "welcome to\n\n 핸드폰 인증",
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
                  Expanded(
                    child: showLoading
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : currentState ==
                                MobileVerificationState.SHOW_MOBILE_FORM_STATE
                            ? getMobileFormWidget(context)
                            : getOtpFormWidget(context),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
