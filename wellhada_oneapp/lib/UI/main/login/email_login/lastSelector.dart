// @dart=2.9
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:wellhada_oneapp/UI/main/bottom_nav.dart';
import 'package:wellhada_oneapp/listitem/userFile/userList.dart' as user;
import 'package:wellhada_oneapp/model/login/userData.dart';

/////////////////////////////
/////////////////////////////
///////성별,나이 체크////////
////////없으면 없고 있으면 저장/////////////
/////여기서 db에 저장함/////////////

class LastSelection extends StatefulWidget {
  @override
  _LastSelectionState createState() => _LastSelectionState();
}

class _LastSelectionState extends State<LastSelection> {
  var userName,
      userEmail,
      userPhone,
      userPassword,
      marketing,
      userToken,
      appAgreeService,
      appAgreePrivacy,
      appPushToken,
      userId,
      appAgreePush;
  var userChk;
  var userProfile, userGenderDB, userCheckDB;
  bool isSelected;
  String deviceToken;
  final _formKey = GlobalKey<FormState>();
  List<RadioModel> sampleData = new List<RadioModel>();
  var birthday, gender, birthdayJson;
  initState() {
    super.initState();
    userCheck();
    isSelected = false;
    sampleData.add(new RadioModel(false, '남'));
    sampleData.add(new RadioModel(false, '여'));
  }

  void userCheck() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        userId = prefs.getString("userId");
        userEmail = prefs.getString("userEmail");
        userName = prefs.getString("userName");
        userProfile = prefs.getString("userProfile");
        userPhone = prefs.getString("userPhone");
        userChk = prefs.getString("userChk");

        userPassword = prefs.getString("userPasswordGoweb");
        marketing = prefs.getString("marketing");
        userToken = prefs.getString("userToken");
        appAgreeService = prefs.getString("appAgreeService");
        appAgreePrivacy = prefs.getString("appAgreePrivacy");
        appPushToken = prefs.getString("appPushToken");
        appAgreePush = prefs.getString("appAgreePush");
        deviceToken = prefs.getString("userToken");

        deviceToken = deviceToken.toLowerCase();

        //userProfile = uriUserProfile.toString();
      });
    } catch (e) {
      print(e);
    }
  }

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
                  data: ThemeData.light().copyWith(
                    primaryColor: Colors.black,
                    accentColor: Colors.white,
                    colorScheme: ColorScheme.light(primary: Colors.black),
                    buttonTheme:
                        ButtonThemeData(textTheme: ButtonTextTheme.primary),
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

  // db에 저장 (listItem/user/ insertuser()메소드)
  insertUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      deviceToken = prefs.getString("userToken");
    });

    final signUp = await user.insertUser(
      userChk,
      userId,
      userPassword == null ? "" : userPassword,
      userEmail,
      userPhone,
      userName,
      userGenderDB == null ? "" : userGenderDB,
      birthdayJson == null ? "" : birthdayJson,
      marketing,
      deviceToken,
      appAgreeService == null ? "N" : appAgreeService,
      appAgreePrivacy == null ? "N" : appAgreePrivacy,
      appAgreePush == null ? "N" : appAgreePush,
      deviceToken,
    );

    if (signUp.status == "00") {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        print('sign up =============${signUp.status}');

        prefs.setString("userKey", userId);
        prefs.setBool('login', true);
        prefs.setString("userPasswordGoweb", userPassword);
      });
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => new BottomNav(number: 3, userId: userId)));
    }

    // if (signUp.status == "20") {
    //   showDialog(
    //       context: context,
    //       builder: (_) => CupertinoAlertDialog(
    //             content: Text("중복된 아이디입니다."),
    //             actions: <Widget>[
    //               CupertinoDialogAction(
    //                 child: Text('확인'),
    //                 onPressed: () => Navigator.of(context).pop(),
    //               ),
    //             ],
    //           ));
    // }
    // Navigator.pushNamed(context, '/BottomNav');
  }

  void checkInfo() async {
    insertUser();
  }

  void skip() async {
    userGenderDB = null;
    birthdayJson = null;
    insertUser();
  }

  Widget _selectionWidget() {
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
              Padding(
                padding: EdgeInsets.only(top: 30, left: 10),
                child: Text(
                  "추가하기",
                  textScaleFactor: 2.0,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 180),
                child: Container(
                  color: Colors.white70,
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Divider(
                          color: Color.fromRGBO(82, 110, 208, 1.0),
                        ),
                        padding: EdgeInsets.only(
                            left: 20.0, right: 20.0, bottom: 0.0),
                      ),
                      Row(
                        children: [
                          Padding(
                              padding: EdgeInsets.only(left: 5),
                              child: Text(
                                "생일 : ",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 15),
                              )),
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
                          Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: Text(birthday == null ? "" : "${birthday}",
                                style: TextStyle(color: Colors.black)),
                          ),
                        ],
                      ),
                      Container(
                        child: Divider(
                          color: Color.fromRGBO(82, 110, 208, 1.0),
                        ),
                        padding: EdgeInsets.only(
                            left: 20.0, right: 20.0, bottom: 0.0),
                      ),
                      Row(
                        children: [
                          Padding(
                              padding: EdgeInsets.only(left: 5),
                              child: Text(
                                "성별 : ",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 15),
                              )),
                          Padding(
                            padding: EdgeInsets.only(left: 10, right: 10),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.width * 0.2,
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Align(
                              alignment: Alignment.center,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: sampleData.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return new InkWell(
                                    //highlightColor: Colors.red,
                                    splashColor: Colors.blueAccent,
                                    onTap: () {
                                      setState(() {
                                        sampleData.forEach((element) =>
                                            element.isSelected = false);
                                        sampleData[index].isSelected = true;

                                        gender = sampleData[index].buttonText;

                                        if (gender == "남") {
                                          userGenderDB = "M";
                                        }
                                        if (gender == "여") {
                                          userGenderDB = "F";
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
                          color: Color.fromRGBO(82, 110, 208, 1.0),
                        ),
                        padding: EdgeInsets.only(
                            left: 20.0, right: 20.0, bottom: 0.0),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                  left: (MediaQuery.of(context).size.width / 2) - 100,
                  top: 3 / 4 * (MediaQuery.of(context).size.height) - 15,
                  child: Container(
                    height: 45,
                    width: 200,
                    child: RaisedButton(
                      onPressed: skip,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.0),
                          side: BorderSide(color: Colors.black)),
                      child:
                          Text("건너뛰기", style: TextStyle(color: Colors.black)),
                      color: Colors.white,
                    ),
                  )),
              Positioned(
                  left: (MediaQuery.of(context).size.width / 2) - 100,
                  top: 3 / 4 * (MediaQuery.of(context).size.height) + 45,
                  child: Container(
                    height: 45,
                    width: 200,
                    child: RaisedButton(
                      onPressed: checkInfo,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.0),
                          side: BorderSide(color: Colors.black)),
                      child:
                          Text("업데이트", style: TextStyle(color: Colors.black)),
                      color: Colors.white,
                    ),
                  )),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _selectionWidget(),
    );
  }
}

// radio button 위젯 클래스
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
