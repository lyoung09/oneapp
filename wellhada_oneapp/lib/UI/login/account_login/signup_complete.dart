/**import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:wellhadaclient/ui/home/home_1.dart';
import 'package:wellhadaclient/ui/home/home_2.dart';
import 'package:wellhadaclient/ui/home/home_3.dart';
import 'package:wellhadaclient/ui/home/home_4.dart';
import 'package:wellhadaclient/ui/home/home_5.dart';
import 'package:wellhadaclient/ui/home/home_18.dart';



class SIGNUP_COMPLETE extends StatefulWidget {
  String AppTitle, UserScSeq, appColor, menuColor, appFontColor;
  SIGNUP_COMPLETE(this.AppTitle, this.UserScSeq, this.appColor, this.menuColor,this.appFontColor);

  @override
  _SIGNUP_COMPLETEState createState() => _SIGNUP_COMPLETEState(AppTitle, UserScSeq, appColor, menuColor, appFontColor);
}

class _SIGNUP_COMPLETEState extends State<SIGNUP_COMPLETE> {
  String AppTitle, UserScSeq, appColor, menuColor, appFontColor;
  _SIGNUP_COMPLETEState(this.AppTitle, this.UserScSeq, this.appColor, this.menuColor,this.appFontColor);

  SharedPreferences prefs;
  var screenSeq;

  @override
  void initState() {
    super.initState();

    _initData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _initData() async{
    prefs = await SharedPreferences.getInstance();

    setState(() {
      screenSeq = prefs.getString("screenSeq");
    });

  }


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Padding(
            padding: const EdgeInsets.only(right: 50.0),
            child: Text(
              "${AppTitle}",
              style: TextStyle(
                fontFamily: 'Godo',
                fontWeight: FontWeight.w900,
                fontSize: 20.0,
                  color: Hexcolor('${appFontColor}')
              ),
            ),
          ),
        ),
        elevation: 0.0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
          color: Hexcolor('${menuColor}')
          ),
        ),
      ),
      backgroundColor: Hexcolor('#F1F2F6'),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(top: 10.0, bottom: 50.0),
              child: Text(
                "가입완료",
                style: TextStyle(
                  color: Hexcolor('#242A37'),
                  fontFamily: "Godo",
                  fontWeight: FontWeight.w800,
                  fontSize: 15.0,
                ),
              ),
            ),

            Container(
              height: height/4,
              child: Column(
                children: <Widget>[
                  Text(
                    "${AppTitle} 회원이",
                    style: TextStyle(
                      color: Hexcolor('#242A37'),
                      fontFamily: "Godo",
                      fontWeight: FontWeight.w800,
                      fontSize: 15.0,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child:Text(
                      "되신것을 환영합니다.",
                      style: TextStyle(
                        color: Hexcolor('#242A37'),
                        fontFamily: "Godo",
                        fontWeight: FontWeight.w800,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),


            Padding(
              padding: const EdgeInsets.only(
                  top: 20.0, left: 20.0, right: 20.0, bottom: 20.0),
              child: Divider(
                color: Colors.grey,
                height: 2.0,
              ),
            ),

            InkWell(
              onTap: () {
                if(screenSeq == "1"){
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (BuildContext context) {
                        ///카페
                        return new HOME_1(AppTitle, UserScSeq, appColor ,menuColor, appFontColor);
                      },
                      fullscreenDialog: true
                  ));
                }else if(screenSeq =="2"){
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (BuildContext context) {
                        ///회사
                        return new HOME_2(AppTitle, UserScSeq, appColor ,menuColor, appFontColor);
                      },
                      fullscreenDialog: true
                  ));

                }else if(screenSeq =="3"){
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (BuildContext context) {
                        ///학원
                        return new HOME_3(AppTitle, UserScSeq, appColor ,menuColor, appFontColor);
                      },
                      fullscreenDialog: true
                  ));

                }else if(screenSeq =="4"){
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (BuildContext context) {
                        ///강사
                        return new HOME_4(AppTitle, UserScSeq, appColor ,menuColor, appFontColor);
                      },
                      fullscreenDialog: true
                  ));

                }else if(screenSeq =="5"){
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (BuildContext context) {
                        //교회
                        return new HOME_5(AppTitle,UserScSeq,appColor, menuColor,appFontColor);
                      },
                      fullscreenDialog: true
                  ));

                }else if(screenSeq =="18"){
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (BuildContext context) {
                        //교회
                        return new HOME_18(AppTitle);
                      },
                      fullscreenDialog: true
                  ));

                }
              },
              child: Container(
                height: 40.0,
                width: width -100,
                decoration: BoxDecoration(
                  color: Colors.yellow[700],
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Center(
                  child: Text(
                    "마침",
                    style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 0.2,
                        fontFamily: "Godo",
                        fontSize: 16.0,
                        fontWeight: FontWeight.w800
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

    );
  }


}
*/
