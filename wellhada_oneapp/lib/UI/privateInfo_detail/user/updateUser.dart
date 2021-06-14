// @dart=2.9
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kakao_flutter_sdk/user.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wellhada_oneapp/UI/main/bottom_detail/private_info.dart';
import 'package:wellhada_oneapp/UI/main/bottom_nav.dart';
import 'package:wellhada_oneapp/UI/privateInfo_detail/email_login/mobile.dart';

import 'package:wellhada_oneapp/listitem/userFile/userList.dart' as user;
import 'package:wellhada_oneapp/model/login/certification_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wellhada_oneapp/model/login/userData.dart';

class UserUpdate extends StatefulWidget {
  @override
  _UserUpdateState createState() => _UserUpdateState();
}

class _UserUpdateState extends State<UserUpdate> {
  var userChk;
  var userEmail, userPhone = '';
  String userName;
  var userProfile = '';
  var nicknameController = TextEditingController(text: '');
  var mobileController = TextEditingController(text: '');
  final _formKey = GlobalKey<FormState>();
  var birthday, birthdayJson, gender = '';
  bool isSelected;
  List<RadioModel> sampleData = new List<RadioModel>();
  File _image;
  String errorType;
  var cookie;
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool showLoading = false;
  final otpController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  MobileVerificationState currentState =
      MobileVerificationState.SHOW_MOBILE_FORM_STATE;
  var userKey;
  String verificationId;
  bool mobileChecking;
  @override
  initState() {
    super.initState();
    check();
    mobileChecking = false;
    isSelected = false;
    sampleData.add(new RadioModel(false, '남'));
    sampleData.add(new RadioModel(false, '여'));
  }

  @override
  void dispose() {
    super.dispose();
  }

  void check() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        userKey = prefs.getString("userKey");
      });
      if (userKey != null) {
        userDefault();
      }
    } catch (e) {
      userChk = 'O';
      print(e);
    }
  }

  _imgFromCamera() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);

    showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
              title: Text('이미지로 저장하시겠습니까?'),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text('아니요'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                CupertinoDialogAction(
                    child: Text('네'),
                    onPressed: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();

                      setState(() {
                        cookie = prefs.setInt("cookie", 1);
                        _image = image;
                        userProfile = _image.path;
                        prefs.setString("userProfile", userProfile);
                      });
                      Navigator.of(context).pop();
                    }),
              ],
            ));
  }

  _imgFromGallery() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);

    // showSave();
    showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
              title: Text('이미지로 저장하시겠습니까?'),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text('아니요'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                CupertinoDialogAction(
                    child: Text('네'),
                    onPressed: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();

                      setState(() {
                        cookie = prefs.setInt("cookie", 1);
                        _image = image;
                        userProfile = _image.path;
                        prefs.setString("userProfile", userProfile);
                      });
                      Navigator.of(context).pop();
                    }),
              ],
            ));
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new SvgPicture.asset(
                        "assets/svg/album.svg",
                        fit: BoxFit.fill,
                        width: 20,
                        height: 20,
                      ),
                      title: new Text('앨범'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new SvgPicture.asset(
                      "assets/svg/camera.svg",
                      fit: BoxFit.fill,
                      width: 20,
                      height: 20,
                    ),
                    title: new Text('카메라'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  var userToken;
  var checkPhone;
  userDefault() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      final userData = await user.getUserInfomation(userKey);

      setState(() {
        cookie = prefs.getInt("cookie");
        password = prefs.getString("userPasswordGoweb");
        marketing = prefs.getString("marketing");
        userToken = prefs.getString("userToken");
        userPhone = userData.userPhoneNumber;
        checkPhone = userPhone;
      });
      userName = userData.userName;
      userEmail = userData.userEmail;
      userProfile = userData.kakaoProfil == null ? "" : userData.kakaoProfil;
      birthdayJson = userData.birthday;
      birthdayJson == "" || birthdayJson == null
          ? birthday = ""
          : birthday =
              '${birthdayJson.substring(0, 4)}.${birthdayJson.substring(4, 6)}.${birthdayJson.substring(6, 8)}';

      print('user token ${userToken}');
      genderDb = userData.gender;

      if (genderDb == "M") gender = "남";
      if (genderDb == "F") gender = "여";

      nicknameController = TextEditingController(text: '${userName}');
      mobileController = TextEditingController(text: '${userPhone}');
    } catch (e) {
      print(e);
    }
  }

  //Method for showing the date picker
  void _pickDateDialog() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            //which date will display when user open the picker
            helpText: '생년월일', // Can be used as title
            cancelText: '취소',
            confirmText: '확인',
            firstDate: DateTime(1950),
            builder: (context, child) {
              return FittedBox(
                child: Theme(
                  //isMaterialAppTheme: true,
                  data: ThemeData.light().copyWith(
                    primaryColor: Colors.black,
                    accentColor: Colors.white,
                    colorScheme: ColorScheme.light(primary: Colors.black),

                    // buttonTheme:
                    //     ButtonThemeData(textTheme: ButtonTextTheme.primary),
                  ),
                  child: child,
                ),
              );
            },
            lastDate: DateTime
                .now()) //what will be the up to supported date in picker
        .then((pickedDate) {
      //then usually do the future job
      if (pickedDate == null) {
        //if user tap cancel then this function will stop
        return;
      }
      DateFormat formatter = DateFormat('yyyy.MM.dd');
      DateFormat formatterSave = DateFormat('yyyyMMdd');
      setState(() {
        //for rebuilding the ui
        birthdayJson = formatterSave.format(pickedDate);
        birthday = formatter.format(pickedDate);
      });
    });
  }

  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      showLoading = true;
    });

    try {
      final authCredential =
          await _auth.signInWithCredential(phoneAuthCredential);

      setState(() {
        showLoading = false;
      });

      if (authCredential?.user != null) {
        setState(() {
          mobileChecking = false;
          prefs.setString('userPhone', '${mobileController.text}');

          currentState = MobileVerificationState.SHOW_MOBILE_FORM_STATE;
        });
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        showLoading = false;
      });
      if (Platform.isAndroid) {
        print(e.message);
        switch (e.message) {
          case 'The format of the phone number provided is incorrect. Please enter the phone number in a format that can be parsed into E.164 format. E.164 phone numbers are written in the format [+][country code][subscriber number including area code]. [ TOO_SHORT ]':
          case 'The format of the phone number provided is incorrect. Please enter the phone number in a format that can be parsed into E.164 format. E.164 phone numbers are written in the format [+][country code][subscriber number including area code]. [ TOO_LONG ]':
          case 'The sms verification code used to create the phone auth credential is invalid. Please resend the verification code sms and be sure use the verification code provided by the user.':
            errorType = " SMS 확인 코드가 잘못되었습니다";
            break;
          case 'The format of the phone number provided is incorrect. Please enter the phone number in a format that can be parsed into E.164 format. E.164 phone numbers are written in the format [+][country code][subscriber number including area code].':
            errorType = " 핸드폰 번호가 없습니다";
            break;
          case 'We have blocked all requests from this device due to unusual activity. Try again later.':
          case 'The verification ID used to create the phone auth credential is invalid.':
            //errorType = "확인 ID가 잘못되었습니다.";
            errorType = "비정상적인 활동으로 인해이 기기의 모든 요청을 차단했습니다. 나중에 다시 시도하십시오.";
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

      // _scaffoldKey.currentState
      //     .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  getOtpFormWidget(context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
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
              alignment: Alignment.center,
              child: Row(
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
                            fontSize: 14.0,
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
            ),
          ],
        ));
  }

  var genderDb;
  var marketing, password;

  checkUpdate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final update = await user.updateUser(
        userKey,
        password == null ? "" : password,
        mobileController.text == null ? "" : mobileController.text,
        nicknameController.text == "" ? userName : nicknameController.text,
        genderDb == null ? "" : genderDb,
        birthdayJson == null ? "" : birthdayJson,
        marketing,
        userProfile == null ? "" : userProfile,
        userKey,
        userToken

        //gender, birthdayJson
        );

    setState(() {
      print('update =====================${update.status}');
      prefs.setString("userName", nicknameController.text);
    });

    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => new BottomNav(number: 3)));
  }

  cancel() async {
    Navigator.pop(context);
  }

  profileUpdate() {
    _showPicker(context);
  }

  dialog() {
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

  Widget _updateWidget() {
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
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 45),
                  child: Container(
                    height: 90,
                    width: 90,
                    child: userProfile == ""
                        ? IconButton(
                            icon: SvgPicture.asset(
                              "assets/svg/defaultUser.svg",
                              fit: BoxFit.fill,
                              width: 20,
                              height: 20,
                            ),
                            onPressed: profileUpdate,
                            color: Color.fromRGBO(82, 110, 208, 1.0),
                          )
                        : cookie == 00
                            ? InkWell(
                                onTap: profileUpdate,
                                child: CircleAvatar(
                                  radius: 50,
                                  backgroundImage: NetworkImage(userProfile),
                                  backgroundColor: Colors.white,
                                ),
                              )
                            : InkWell(
                                onTap: profileUpdate,
                                child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(12.0)),
                                    child: CircleAvatar(
                                      backgroundImage:
                                          Image.file(File(userProfile)).image,
                                      radius: 100.0,
                                    )),
                              ),
                    decoration: BoxDecoration(
                      border: Border.all(
                          width: 3,
                          color: Color.fromRGBO(82, 110, 208, 1.0),
                          style: BorderStyle.solid),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 180),
                child: Container(
                  color: Colors.white70,
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(padding: EdgeInsets.only(left: 8)),
                          Text(
                            "닉네임 : ",
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.78,
                            child: TextFormField(
                              inputFormatters: [
                                new LengthLimitingTextInputFormatter(28),
                              ],
                              style: TextStyle(color: Colors.black),
                              controller: nicknameController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Container(
                      //   child: Divider(
                      //     color: Color.fromRGBO(82, 110, 208, 1.0),
                      //   ),
                      //   padding:
                      //       EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
                      // ),
                      // Row(
                      //   children: [
                      //     Text(
                      //       "이메일 : ",
                      //       style: TextStyle(color: Colors.black, fontSize: 20),
                      //     ),
                      //     Container(
                      //         width: MediaQuery.of(context).size.width * 0.8,
                      //         child: Text(
                      //           "${userEmail}",
                      //           style: TextStyle(color: Colors.black),
                      //         )),
                      //   ],
                      // ),
                      Container(
                        child: Divider(
                            // color: Color.fromRGBO(82, 110, 208, 1.0),
                            ),
                        padding: EdgeInsets.only(
                            left: 20.0, right: 20.0, bottom: 10.0),
                      ),
                      Row(
                        children: [
                          Padding(padding: EdgeInsets.only(left: 8)),
                          Text(
                            "핸드폰 : ",
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          ),
                          Container(
                              width: MediaQuery.of(context).size.width * 0.49,
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                style: TextStyle(color: Colors.black),
                                controller: mobileController,
                                onChanged: (value) {
                                  setState(() {
                                    if (value != userPhone) {
                                      mobileChecking = true;
                                    }
                                    if (value == userPhone) {
                                      mobileChecking = false;
                                    }
                                  });
                                },
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                ),
                              )),
                          userChk == 'E'
                              ? Align(
                                  alignment: Alignment.centerRight,
                                  child: FlatButton(
                                    onPressed: () async {
                                      await _auth.verifyPhoneNumber(
                                        phoneNumber:
                                            '+82 ${mobileController.text}',
                                        verificationCompleted:
                                            (phoneAuthCredential) async {
                                          setState(() {
                                            showLoading = false;
                                          });
                                          //signInWithPhoneAuthCredential(phoneAuthCredential);
                                        },
                                        verificationFailed:
                                            (verificationFailed) async {
                                          setState(() {
                                            showLoading = false;
                                          });
                                          if (Platform.isAndroid) {
                                            print(verificationFailed.message);
                                            switch (
                                                verificationFailed.message) {
                                              case 'The format of the phone number provided is incorrect. Please enter the phone number in a format that can be parsed into E.164 format. E.164 phone numbers are written in the format [+][country code][subscriber number including area code]. [ TOO_SHORT ]':
                                              case 'The format of the phone number provided is incorrect. Please enter the phone number in a format that can be parsed into E.164 format. E.164 phone numbers are written in the format [+][country code][subscriber number including area code]. [ TOO_LONG ]':
                                              case 'The format of the phone number provided is incorrect. Please enter the phone number in a format that can be parsed into E.164 format. E.164 phone numbers are written in the format [+][country code][subscriber number including area code]. [ Invalid format. ]':
                                                errorType = " 정확한 번호를 적어주세요";
                                                break;
                                              case 'We have blocked all requests from this device due to unusual activity. Try again later.':
                                              case 'The verification ID used to create the phone auth credential is invalid.':
                                                //errorType = "이미 있는 id 입니다.";
                                                errorType =
                                                    "비정상적인 활동으로 인해이 기기의 모든 요청을 차단했습니다. 나중에 다시 시도하십시오..";
                                                break;
                                            }
                                          } else if (Platform.isIOS) {}
                                          showDialog(
                                              context: context,
                                              builder: (_) =>
                                                  CupertinoAlertDialog(
                                                    content: Text(errorType),
                                                    actions: <Widget>[
                                                      CupertinoDialogAction(
                                                        child: Text('확인'),
                                                        onPressed: () =>
                                                            Navigator.of(
                                                                    context)
                                                                .pop(),
                                                      ),
                                                    ],
                                                  ));
                                          // _scaffoldKey.currentState
                                          //     .showSnackBar(SnackBar(
                                          //         content: Text(
                                          //             verificationFailed
                                          //                 .message))
                                          //   );
                                        },
                                        codeSent: (verificationId,
                                            resendingToken) async {
                                          setState(() {
                                            showLoading = false;
                                            currentState =
                                                MobileVerificationState
                                                    .SHOW_OTP_FORM_STATE;
                                            this.verificationId =
                                                verificationId;
                                          });
                                        },
                                        codeAutoRetrievalTimeout:
                                            (verificationId) async {},
                                      );
                                    },
                                    child: Text('변경하기'),
                                    color: Colors.white,
                                  ),
                                )
                              : Align(
                                  alignment: Alignment.centerRight,
                                  child: RaisedButton.icon(
                                    icon: SvgPicture.asset(
                                      "assets/svg/defaultUser.svg",
                                      fit: BoxFit.fill,
                                      width: 20,
                                      height: 20,
                                    ),
                                    onPressed: () async {
                                      await _auth.verifyPhoneNumber(
                                        phoneNumber:
                                            '+82 ${mobileController.text}',
                                        verificationCompleted:
                                            (phoneAuthCredential) async {
                                          setState(() {
                                            showLoading = false;
                                          });
                                          //signInWithPhoneAuthCredential(phoneAuthCredential);
                                        },
                                        verificationFailed:
                                            (verificationFailed) async {
                                          setState(() {
                                            showLoading = false;
                                          });
                                          if (Platform.isAndroid) {
                                            print(verificationFailed.message);
                                            switch (
                                                verificationFailed.message) {
                                              case 'The format of the phone number provided is incorrect. Please enter the phone number in a format that can be parsed into E.164 format. E.164 phone numbers are written in the format [+][country code][subscriber number including area code]. [ TOO_SHORT ]':
                                              case 'The format of the phone number provided is incorrect. Please enter the phone number in a format that can be parsed into E.164 format. E.164 phone numbers are written in the format [+][country code][subscriber number including area code]. [ Invalid format. ]':
                                              case 'The format of the phone number provided is incorrect. Please enter the phone number in a format that can be parsed into E.164 format. E.164 phone numbers are written in the format [+][country code][subscriber number including area code]. [ TOO_LONG ]':
                                                errorType = " 정확한 번호를 적어주세요";
                                                break;

                                              case 'We have blocked all requests from this device due to unusual activity. Try again later.':
                                              case 'The verification ID used to create the phone auth credential is invalid.':
                                                errorType =
                                                    "비정상적인 활동으로 인해이 기기의 모든 요청을 차단했습니다. 나중에 다시 시도하십시오.";
                                                break;
                                              default:
                                                errorType =
                                                    verificationFailed.message;
                                            }
                                          } else if (Platform.isIOS) {}
                                          showDialog(
                                              context: context,
                                              builder: (_) =>
                                                  CupertinoAlertDialog(
                                                    content: Text(errorType),
                                                    actions: <Widget>[
                                                      CupertinoDialogAction(
                                                        child: Text('확인'),
                                                        onPressed: () =>
                                                            Navigator.of(
                                                                    context)
                                                                .pop(),
                                                      ),
                                                    ],
                                                  ));

                                          // _scaffoldKey.currentState
                                          //     .showSnackBar(SnackBar(
                                          //         content: Text(
                                          //             verificationFailed
                                          //                 .message)));
                                        },
                                        codeSent: (verificationId,
                                            resendingToken) async {
                                          setState(() {
                                            showLoading = false;
                                            currentState =
                                                MobileVerificationState
                                                    .SHOW_OTP_FORM_STATE;
                                            this.verificationId =
                                                verificationId;
                                          });
                                        },
                                        codeAutoRetrievalTimeout:
                                            (verificationId) async {},
                                      );
                                    },
                                    label: Text('본인인증'),
                                    color: Colors.white,
                                  ),
                                )
                        ],
                      ),
                      Container(
                        child: Divider(
                            //color: Color.fromRGBO(82, 110, 208, 1.0),
                            ),
                        padding: EdgeInsets.only(
                            left: 20.0, right: 20.0, bottom: 10.0),
                      ),
                      Row(
                        children: [
                          Padding(padding: EdgeInsets.only(left: 8)),
                          Text(
                            "생일 : ",
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10, right: 10),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.59,
                            child: Text(birthday == null ? "" : "${birthday}",
                                style: TextStyle(color: Colors.black)),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10, right: 10),
                          ),
                          IconButton(
                            icon: SvgPicture.asset(
                              "assets/svg/calender.svg",
                              fit: BoxFit.fill,
                              width: 20,
                              height: 20,
                            ),
                            onPressed: _pickDateDialog,
                          ),
                        ],
                      ),
                      Container(
                        child: Divider(
                            //color: Color.fromRGBO(82, 110, 208, 1.0),
                            ),
                        padding: EdgeInsets.only(
                            left: 20.0, right: 20.0, bottom: 10.0),
                      ),
                      Row(
                        children: [
                          Padding(padding: EdgeInsets.only(left: 8)),
                          Text(
                            "성별 : ",
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 30, right: 30),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.width * 0.2,
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: Align(
                              alignment: Alignment.center,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: sampleData.length,
                                itemBuilder: (BuildContext context, int index) {
                                  if (gender == sampleData[index].buttonText) {
                                    sampleData[index].isSelected = true;
                                    return new InkWell(
                                      //highlightColor: Colors.red,
                                      splashColor: Colors.blueAccent,
                                      onTap: () {
                                        setState(() {
                                          sampleData.forEach((element) =>
                                              element.isSelected = false);
                                          sampleData[index].isSelected = true;
                                          print(sampleData[index].buttonText);
                                          gender = sampleData[index].buttonText;
                                        });
                                      },
                                      child: new RadioItem(sampleData[index]),
                                    );
                                  }
                                  return new InkWell(
                                    //highlightColor: Colors.red,
                                    splashColor: Colors.blueAccent,
                                    onTap: () {
                                      setState(() {
                                        sampleData.forEach((element) =>
                                            element.isSelected = false);
                                        sampleData[index].isSelected = true;
                                        print(sampleData[index].buttonText);
                                        gender = sampleData[index].buttonText;
                                        if (gender == "남") {
                                          genderDb = "M";
                                        }
                                        if (gender == "여") {
                                          genderDb = "F";
                                        }
                                      });
                                    },
                                    child: new RadioItem(sampleData[index]),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        child: Divider(
                            // color: Color.fromRGBO(82, 110, 208, 1.0),
                            ),
                        padding: EdgeInsets.only(
                            left: 20.0, right: 20.0, bottom: 10.0),
                      ),
                      Container(
                        height: 45,
                        width: 200,
                        child: RaisedButton(
                          onPressed: mobileChecking == true
                              ? showDialog(
                                  context: context,
                                  builder: (_) => CupertinoAlertDialog(
                                        content: Text("핸드폰 인증을 해주세요"),
                                        actions: <Widget>[
                                          CupertinoDialogAction(
                                            child: Text('확인'),
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                          ),
                                        ],
                                      ))
                              : checkUpdate,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40.0),
                              side: BorderSide(color: Colors.black)),
                          child: Text("업데이트",
                              style: TextStyle(color: Colors.black)),
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        child: Divider(
                            // color: Color.fromRGBO(82, 110, 208, 1.0),
                            ),
                        padding: EdgeInsets.only(
                            left: 20.0, right: 20.0, bottom: 10.0),
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
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final _pos = MediaQuery.of(context).size.height / 4 + 20;
    // check();
    return Scaffold(
        //body: userChk == 00 ? _updateWidget() : _email(),
        body: showLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : currentState == MobileVerificationState.SHOW_MOBILE_FORM_STATE
                ? _updateWidget()
                : getOtpFormWidget(context));
  }
}

class WaveClipper1 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // TODO: implement getClip
    Path path = Path();
    path.lineTo(0, 0);
    path.quadraticBezierTo(size.width / 4, 40, size.width / 2, 20);
    path.quadraticBezierTo(3 / 4 * size.width, 0.0, size.width, 10);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return false;
  }
}

class RadioItem extends StatelessWidget {
  final RadioModel _item;
  RadioItem(this._item);
  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: new EdgeInsets.all(15.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          new Container(
            height: 50.0,
            width: 50.0,
            child: new Center(
              child: new Text(_item.buttonText,
                  style: new TextStyle(
                      color: _item.isSelected ? Colors.white : Colors.black,
                      //fontWeight: FontWeight.bold,
                      fontSize: 18.0)),
            ),
            decoration: new BoxDecoration(
              color: _item.isSelected ? Colors.black : Colors.transparent,
              border: new Border.all(
                  width: 1.0,
                  color: _item.isSelected ? Colors.black : Colors.grey),
              borderRadius: const BorderRadius.all(const Radius.circular(2.0)),
            ),
          ),
        ],
      ),
    );
  }
}

class RadioModel {
  bool isSelected;
  final String buttonText;

  RadioModel(this.isSelected, this.buttonText);
}
