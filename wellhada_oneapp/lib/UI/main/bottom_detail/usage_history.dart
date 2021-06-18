// @dart=2.9
import 'dart:collection';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:getwidget/getwidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wellhada_oneapp/UI/bottom_nav_deatail/usageHistory_detail/my_review.dart';
import 'package:wellhada_oneapp/UI/bottom_nav_deatail/usageHistory_detail/review.dart';
import 'package:wellhada_oneapp/UI/main/login/login.dart';

import 'package:wellhada_oneapp/listitem/userFile/userList.dart' as user;
import 'package:intl/intl.dart';
import 'package:wellhada_oneapp/listitem/shop/orderList.dart' as orderList;
import 'package:slide_popup_dialog/slide_popup_dialog.dart' as slideDialog;

class UsageHistory extends StatefulWidget {
  @override
  _UsageHistoryState createState() => _UsageHistoryState();
}

class _UsageHistoryState extends State<UsageHistory> {
  String webviewDefault = 'http://hndsolution.iptime.org:8086/usermngr';
  String userId, userChk;
  String date, year, month, day;
  int _value = 1;
  var orderFuture;

  Map<int, bool> openShopSeq = new Map();
  Map<int, bool> dayOpenShop = new Map();
  @override
  void initState() {
    check();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void check() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (this.mounted) {
        setState(() {
          userId = prefs.getString("userKey");
          userPassword = prefs.getString("userPasswordGoweb");
          userChk = prefs.getString("userChk");
          if (userChk == "01") {
            userChk = "E";
          }
          if (userChk == "00") {
            userChk = "K";
          }
        });

        orderFuture = getOrderUsageHistory(userId);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  delete(userId, orderSeq) async {
    final deleteReview = await orderList.deleteReview(userId, orderSeq);
    if (this.mounted) {
      setState(() {
        print('delete ============================${deleteReview.cnt}');
      });
    }
    Navigator.pop(context);
  }

  double toDouble(TimeOfDay myTime) {
    return myTime.hour + myTime.minute / 60.0;
  }

  openingShop(startTime, endTime, int shopId) async {
    DateTime now = DateTime.now();
    var nowTimeofDay = TimeOfDay(hour: now.hour, minute: now.minute);

    double toStart = toDouble(startTime);
    double toNow = toDouble(nowTimeofDay);
    double toEnd = toDouble(endTime);

    if (toStart <= toNow && toNow <= toEnd) {
      print("영업중");
      openShopSeq[shopId] = true;
    } else {
      print("영업 시작 안함");
      openShopSeq[shopId] = false;
    }
  }

  userDataCheck(placeName, shopSeq) async {
    // final webLoginData =
    //     await webLogin.loginWebUser(userKey, userPassword, userChk);

    _handleURLButtonPress(context, '${webviewDefault}/shopTmplatView.do',
        placeName, shopSeq, userId);
  }

  void _showIncludePicutreDialog(
      String date, String pic, String placeName, String order, String story) {
    slideDialog.showSlideDialog(
      context: context,
      child: Expanded(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Spacer(),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 5.0, right: 5),
                        child: Text(
                          "날짜:",
                          style: TextStyle(
                            fontFamily: "nanumB",
                            fontWeight: FontWeight.w900,
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                    ),
                    Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 5.0, right: 5),
                          child: Text(
                            date,
                            style: TextStyle(
                              fontFamily: "nanumB",
                              fontWeight: FontWeight.w500,
                              fontSize: 13.0,
                            ),
                          ),
                        )),
                    Padding(
                      padding: EdgeInsets.only(right: 5),
                    )
                  ],
                ),
                Container(
                  padding: EdgeInsets.only(left: 20.0, bottom: 15.0),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Spacer(),
                    Text(
                      '${placeName}',
                      style: TextStyle(
                        fontFamily: "nanumB",
                        fontWeight: FontWeight.w900,
                        fontSize: 18.0,
                      ),
                    ),
                    Text(
                      "에서 ",
                      style: TextStyle(
                        fontFamily: "nanumB",
                        fontWeight: FontWeight.w500,
                        fontSize: 11,
                      ),
                    ),
                    Text(
                      order,
                      style: TextStyle(
                        fontFamily: "nanumB",
                        fontWeight: FontWeight.w900,
                        fontSize: 15.5,
                      ),
                    ),
                    Text(
                      " 주문!",
                      style: TextStyle(
                        fontFamily: "nanumB",
                        fontWeight: FontWeight.w500,
                        fontSize: 11,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 5),
                    )
                  ],
                ),
                Container(
                  padding: EdgeInsets.only(left: 12.0, bottom: 20.0),
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 5.0, right: 5),
                    child: Container(
                      padding: EdgeInsets.only(top: 5),
                      // decoration: BoxDecoration(border: Border.all()),
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: Image.file(
                        File(pic),
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.height * 0.3,
                        fit: BoxFit.fitHeight,
                      ),
                    )),
                Container(
                  padding: EdgeInsets.only(left: 20.0, bottom: 10.0),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 15, top: 15),
                    ),
                    Padding(
                        padding: EdgeInsets.only(left: 12),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Text(
                            story,
                            //'11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111',
                            maxLines: 7,
                            style: TextStyle(
                              fontFamily: "nanumR",
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                            ),
                          ),
                        )),
                  ],
                ),
                // Padding(
                //     padding: EdgeInsets.only(bottom: 15, left: 15),
                //     child: Align(
                //       alignment: Alignment.bottomRight,
                //       child: FlatButton(
                //         color: Colors.black,
                //         onPressed: () {
                //           Navigator.of(context).pop();
                //         },
                //         child: Text('확인',
                //             style: TextStyle(
                //               fontFamily: "nanumR",
                //               fontSize: 13,
                //               fontWeight: FontWeight.w900,
                //             )),
                //         textColor: Colors.black,
                //       ),
                //     )),
              ],
            ),
          ),
        ),
      ),
      barrierColor: Colors.white.withOpacity(0.7),
      pillColor: Colors.amberAccent,
      backgroundColor: Colors.white,
    );
  }

  moveLogin() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => new LOGIN(
              number: 1,
            )));
  }

  void _showOnlyReviewDialog(
      String date,
      // String pic,
      String placeName,
      String order,
      String story,
      int orderSeq) {
    slideDialog.showSlideDialog(
      context: context,
      child: Expanded(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Spacer(),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 5.0, right: 5),
                        child: Text(
                          "날짜:",
                          style: TextStyle(
                            fontFamily: "nanumB",
                            fontWeight: FontWeight.w900,
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                    ),
                    Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 5.0, right: 5),
                          child: Text(
                            date,
                            style: TextStyle(
                              fontFamily: "nanumB",
                              fontWeight: FontWeight.w500,
                              fontSize: 13.0,
                            ),
                          ),
                        )),
                    Padding(
                      padding: EdgeInsets.only(right: 5),
                    )
                  ],
                ),
                Container(
                  padding: EdgeInsets.only(left: 20.0, bottom: 15.0),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Spacer(),
                    Text(
                      '${placeName}',
                      style: TextStyle(
                        fontFamily: "nanumB",
                        fontWeight: FontWeight.w900,
                        fontSize: 18.0,
                      ),
                    ),
                    Text(
                      "에서 ",
                      style: TextStyle(
                        fontFamily: "nanumB",
                        fontWeight: FontWeight.w500,
                        fontSize: 11,
                      ),
                    ),
                    Text(
                      order,
                      style: TextStyle(
                        fontFamily: "nanumB",
                        fontWeight: FontWeight.w900,
                        fontSize: 15.5,
                      ),
                    ),
                    Text(
                      " 주문!",
                      style: TextStyle(
                        fontFamily: "nanumB",
                        fontWeight: FontWeight.w500,
                        fontSize: 11,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 5),
                    )
                  ],
                ),
                Container(
                  padding: EdgeInsets.only(left: 12.0, bottom: 20.0),
                ),
                // Padding(
                //     padding: const EdgeInsets.only(left: 5.0, right: 5),
                //     child: Container(
                //       padding: EdgeInsets.only(top: 5),
                //       decoration: BoxDecoration(border: Border.all()),
                //       width: MediaQuery.of(context).size.width * 0.8,
                //       height: MediaQuery.of(context).size.height * 0.3,
                //       child: Image.network(
                //         pic,
                //         width: MediaQuery.of(context).size.width * 0.8,
                //         height: MediaQuery.of(context).size.height * 0.3,
                //         fit: BoxFit.fitWidth,
                //       ),
                //     )),
                Container(
                  padding: EdgeInsets.only(left: 20.0, bottom: 10.0),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 15, top: 15),
                    ),
                    Padding(
                        padding: EdgeInsets.only(left: 30, top: 30),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Text(
                            story,
                            //'11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111',
                            maxLines: 5,
                            style: TextStyle(
                              fontFamily: "nanumR",
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                            ),
                          ),
                        )),
                  ],
                ),
                // Container(
                //   alignment: Alignment.bottomRight,
                //   child: FlatButton(
                //     onPressed: delete(userId, orderSeq),
                //     child: Text('리뷰 삭제',
                //         style: TextStyle(
                //           fontFamily: "nanumR",
                //           fontSize: 16,
                //           fontWeight: FontWeight.w800,
                //         )),
                //   ),
                // )
                // Padding(
                //     padding: EdgeInsets.only(bottom: 15, left: 15),
                //     child: Align(
                //       alignment: Alignment.bottomRight,
                //       child: FlatButton(
                //         color: Colors.black,
                //         onPressed: () {
                //           Navigator.of(context).pop();
                //         },
                //         child: Text('확인',
                //             style: TextStyle(
                //               fontFamily: "nanumR",
                //               fontSize: 13,
                //               fontWeight: FontWeight.w900,
                //             )),
                //         textColor: Colors.black,
                //       ),
                //     )),
              ],
            ),
          ),
        ),
      ),
      barrierColor: Colors.white.withOpacity(0.7),
      pillColor: Colors.amberAccent,
      backgroundColor: Colors.white,
    );
  }

  void _showCancelDialog(
    String date,
    String reason,
    String placeName,
    String order,
    int orderSeq,
    String pic,
    int shopSeq,
  ) {
    slideDialog.showSlideDialog(
      context: context,
      child: Expanded(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Row(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Padding(
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.25)),
                    Text(
                      '${placeName}',
                      style: TextStyle(
                        fontFamily: "nanumB",
                        fontWeight: FontWeight.w900,
                        fontSize: 18.0,
                      ),
                    ),
                    Text(
                      "에서 ",
                      style: TextStyle(
                        fontFamily: "nanumB",
                        fontWeight: FontWeight.w500,
                        fontSize: 11,
                      ),
                    ),
                    Text(
                      order,
                      style: TextStyle(
                        fontFamily: "nanumB",
                        fontWeight: FontWeight.w900,
                        fontSize: 15.5,
                      ),
                    ),
                    Text(
                      " 취소!",
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontFamily: "nanumB",
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 15),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.02),
                ),
                Row(
                  //crossAxisAlignment: CrossAxisAlignment.end,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Padding(
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.4)),
                    Text(
                      "취소 사유:",
                      style: TextStyle(
                        fontFamily: "nanumB",
                        fontWeight: FontWeight.w900,
                        fontSize: 16.0,
                      ),
                    ),
                    reason == "1"
                        ? Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: EdgeInsets.only(right: 1),
                              child: Text(
                                "고객 요청",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: "nanumR",
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          )
                        : reason == "2"
                            ? Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: EdgeInsets.only(),
                                  child: Text(
                                    "재료 소진",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: "nanumR",
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              )
                            : reason == "3"
                                ? Align(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                      padding: EdgeInsets.only(),
                                      child: Text(
                                        "업소 사정",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: "nanumR",
                                          fontWeight: FontWeight.w700,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  )
                                : Align(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                      padding: EdgeInsets.only(),
                                      child: Text(
                                        "변심",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: "nanumR",
                                          fontWeight: FontWeight.w700,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ),
                    Padding(
                      padding: EdgeInsets.only(right: 5),
                    )
                  ],
                ),
                Container(
                  padding: EdgeInsets.only(left: 20.0, bottom: 15.0),
                ),
                Container(
                  padding: EdgeInsets.only(left: 12.0, bottom: 20.0),
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 5.0, right: 10),
                    child: Container(
                        padding: EdgeInsets.only(top: 5),
                        decoration: BoxDecoration(border: Border.all()),
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.height * 0.3,
                        child: Image.network(
                          'http://hndsolution.iptime.org:8086${pic}',
                          width: MediaQuery.of(context).size.width * 0.13,
                          height: MediaQuery.of(context).size.height * 0.15,
                          fit: BoxFit.fitHeight,
                        ))),
                Container(
                  padding: EdgeInsets.only(left: 20.0, bottom: 10.0),
                ),

                openShopSeq[shopSeq] == true && dayOpenShop[shopSeq] == true
                    ? Container(
                        alignment: Alignment.bottomCenter,
                        child: FlatButton(
                          onPressed: () {
                            webView(placeName, shopSeq, userId, userPassword);
                          },
                          child: Text('재주문',
                              style: TextStyle(
                                fontFamily: "nanumR",
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              )),
                        ),
                      )
                    : Container(
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          '준비중',
                          style: TextStyle(
                            color: Colors.red,
                            fontFamily: "nanumR",
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                // Padding(
                //     padding: EdgeInsets.only(bottom: 15, left: 15),
                //     child: Align(
                //       alignment: Alignment.bottomRight,
                //       child: FlatButton(
                //         color: Colors.black,
                //         onPressed: () {
                //           Navigator.of(context).pop();
                //         },
                //         child: Text('확인',
                //             style: TextStyle(
                //               fontFamily: "nanumR",
                //               fontSize: 13,
                //               fontWeight: FontWeight.w900,
                //             )),
                //         textColor: Colors.black,
                //       ),
                //     )),
                Padding(
                  padding: EdgeInsets.only(bottom: 1.5),
                ),
              ],
            ),
          ),
        ),
      ),
      barrierColor: Colors.white.withOpacity(0.7),
      pillColor: Colors.amberAccent,
      backgroundColor: Colors.white,
    );
  }

  void _usageDetail(
    String date,
    int price,
    String placeName,
    String order,
    int orderSeq,
    String pic,
    int shopSeq,
    String beginWeek,
    String endWeek,
    String beginWeekend,
    String endWeekend,
  ) {
    showDialog(
        context: context,
        builder: (_) => Dialog(
                child: Container(
              height: MediaQuery.of(context).size.height * 0.5,
              decoration: BoxDecoration(
                  //color: Colors.redAccent,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.02),
                  ),
                  Text(
                    placeName.length > 14
                        ? "${placeName.substring(0, 14)}"
                        : "${placeName}",
                    style: TextStyle(
                      fontFamily: "nanumB",
                      fontWeight: FontWeight.w900,
                      fontSize: 21.0,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                  ),
                  Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Text(
                          '날짜 : ${date}',
                          style: TextStyle(
                            fontFamily: "nanumB",
                            fontWeight: FontWeight.w700,
                            fontSize: 11.0,
                          ),
                        ),
                      )),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                      child: Image.network(
                        'http://hndsolution.iptime.org:8086${pic}',
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.height * 0.25,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12))),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 25),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        order == null
                            ? ""
                            : order.length > 100
                                ? "주문 내역: ${order.substring(0, 99)}"
                                : "주문 내역: ${order}",
                        maxLines: 3,
                        style: TextStyle(
                          fontFamily: "nanumR",
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: OutlineButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3)),
                          borderSide: BorderSide(
                            color: Colors.black, //Color of the border
                            style: BorderStyle.solid, //Style of the border
                            width: 0.5, //width of the border
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('취소'),
                          textColor: Colors.black,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      OutlineButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3)),
                        borderSide: BorderSide(
                          color: Colors.black, //Color of the border
                          style: BorderStyle.solid, //Style of the border
                          width: 0.5, //width of the border
                        ),
                        onPressed: () {
                          openShopSeq[shopSeq] == true &&
                                  dayOpenShop[shopSeq] == true
                              ? userDataCheck(placeName, shopSeq)
                              : showDialog(
                                  context: context,
                                  builder: (_) => CupertinoAlertDialog(
                                        content: Text("영업 시간이 아닙니다"),
                                        actions: <Widget>[
                                          CupertinoDialogAction(
                                            child: Text('확인'),
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                          ),
                                        ],
                                      ));
                        },
                        child: Text('재주문'),
                        color: Colors.white,
                        textColor: Colors.black,
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 1.5),
                  ),
                ],
              ),
            )));
  }

  void _reviewPicStory(String date, String shopName, String menuName,
      String review, String pic) {
    showDialog(
        context: context,
        builder: (_) => Dialog(
                child: Container(
              height: MediaQuery.of(context).size.height * 0.5,
              decoration: BoxDecoration(
                  //color: Colors.redAccent,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.02),
                  ),
                  Text(
                    shopName.length > 14
                        ? "${shopName.substring(0, 14)}"
                        : "${shopName}",
                    style: TextStyle(
                      fontFamily: "nanumB",
                      fontWeight: FontWeight.w900,
                      fontSize: 21.0,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                  ),
                  Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Text(
                          '날짜 : ${date}',
                          style: TextStyle(
                            fontFamily: "nanumB",
                            fontWeight: FontWeight.w700,
                            fontSize: 11.0,
                          ),
                        ),
                      )),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                      child: Image.network(
                        'http://hndsolution.iptime.org:8086${pic}',
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.height * 0.3,
                      ),
                    ),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12))),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                  ),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          menuName == null ? "" : '내역 : ${menuName}',
                          style: TextStyle(
                            fontFamily: "nanumB",
                            fontWeight: FontWeight.w700,
                            fontSize: 11.0,
                          ),
                        ),
                      )),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        review.length > 100
                            ? " ${review.substring(0, 99)}"
                            : review,
                        maxLines: 3,
                        style: TextStyle(
                          fontFamily: "nanumR",
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                  OutlineButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3)),
                    borderSide: BorderSide(
                      color: Colors.black, //Color of the border
                      style: BorderStyle.solid, //Style of the border
                      width: 0.5, //width of the border
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('확인'),
                    textColor: Colors.black,
                    color: Colors.white,
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 1.5),
                  ),
                ],
              ),
            )));
  }

  void _reviewStory(
      String date, String shopName, String menuName, String review) {
    showDialog(
        context: context,
        builder: (_) => Dialog(
                child: Container(
              height: MediaQuery.of(context).size.height * 0.3,
              decoration: BoxDecoration(
                  //color: Colors.redAccent,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.02),
                  ),
                  Text(
                    shopName.length > 14
                        ? "${shopName.substring(0, 14)}"
                        : "${shopName}",
                    style: TextStyle(
                      fontFamily: "nanumB",
                      fontWeight: FontWeight.w900,
                      fontSize: 21.0,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                  ),
                  Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Text(
                          '날짜 : ${date}',
                          style: TextStyle(
                            fontFamily: "nanumB",
                            fontWeight: FontWeight.w700,
                            fontSize: 11.0,
                          ),
                        ),
                      )),
                  Padding(
                    padding: EdgeInsets.only(bottom: 15),
                  ),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Text(
                          menuName == null ? "" : '내역 : ${menuName}',
                          style: TextStyle(
                            fontFamily: "nanumB",
                            fontWeight: FontWeight.w700,
                            fontSize: 11.0,
                          ),
                        ),
                      )),
                  Padding(
                    padding: EdgeInsets.only(bottom: 15),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        review.length > 100
                            ? " ${review.substring(0, 99)}"
                            : review,
                        maxLines: 3,
                        style: TextStyle(
                          fontFamily: "nanumR",
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: OutlineButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3)),
                      borderSide: BorderSide(
                        color: Colors.black, //Color of the border
                        style: BorderStyle.solid, //Style of the border
                        width: 0.5, //width of the border
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('확인'),
                      textColor: Colors.black,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            )));
  }

  // void _showCancelDetail(
  //   String date,
  //   String reason,
  //   String shopName,
  //   String order,
  //   int orderSeq,
  //   String pic,
  //   int shopSeq,
  //   String beginWeek,
  //   String endWeek,
  //   String beginWeekend,
  //   String endWeekend,
  // ) {
  //   DateTime now = DateTime.now();

  //   String startHour, startMin, endHour, endMin;
  //   TimeOfDay startTime, endTime;
  //   if (now.weekday == 6 || now.weekday == 7) {
  //     startHour = beginWeek.substring(0, 2);
  //     startMin = endWeek.substring(2, 4);
  //     endHour = beginWeekend.substring(0, 2);
  //     endMin = endWeekend.substring(2, 4);

  //     startTime =
  //         TimeOfDay(hour: int.parse(startHour), minute: int.parse(startMin));
  //     endTime = TimeOfDay(hour: int.parse(endHour), minute: int.parse(endMin));
  //   } else {
  //     startHour = beginWeek.substring(0, 2);
  //     startMin = endWeek.substring(2, 4);
  //     endHour = beginWeekend.substring(0, 2);
  //     endMin = endWeekend.substring(2, 4);

  //     startTime =
  //         TimeOfDay(hour: int.parse(startHour), minute: int.parse(startMin));
  //     endTime = TimeOfDay(hour: int.parse(endHour), minute: int.parse(endMin));
  //   }
  //   openingShop(startTime, endTime);

  //   showDialog(
  //       context: context,
  //       builder: (_) => Dialog(
  //               child: Container(
  //             height: MediaQuery.of(context).size.height * 0.5,
  //             decoration: BoxDecoration(
  //                 //color: Colors.redAccent,
  //                 shape: BoxShape.rectangle,
  //                 borderRadius: BorderRadius.all(Radius.circular(12))),
  //             child: Column(
  //               children: <Widget>[
  //                 Padding(
  //                   padding: EdgeInsets.only(
  //                       top: MediaQuery.of(context).size.height * 0.02),
  //                 ),
  //                 Text(
  //                   shopName.length > 14
  //                       ? "${shopName.substring(0, 14)}"
  //                       : "${shopName}",
  //                   style: TextStyle(
  //                     fontFamily: "nanumB",
  //                     fontWeight: FontWeight.w900,
  //                     fontSize: 21.0,
  //                   ),
  //                 ),
  //                 Padding(
  //                   padding: EdgeInsets.only(bottom: 10),
  //                 ),
  //                 Align(
  //                     alignment: Alignment.centerRight,
  //                     child: Padding(
  //                       padding: const EdgeInsets.only(right: 12),
  //                       child: Text(
  //                         '날짜 : ${date}',
  //                         style: TextStyle(
  //                           fontFamily: "nanumB",
  //                           fontWeight: FontWeight.w700,
  //                           fontSize: 11.0,
  //                         ),
  //                       ),
  //                     )),
  //                 Container(
  //                   child: Padding(
  //                     padding: const EdgeInsets.only(left: 12.0, right: 12.0),
  //                     child: Image.network(
  //                       'http://hndsolution.iptime.org:8086${pic}',
  //                       width: MediaQuery.of(context).size.width * 0.8,
  //                       height: MediaQuery.of(context).size.height * 0.25,
  //                       fit: BoxFit.fitWidth,
  //                     ),
  //                   ),
  //                   width: double.infinity,
  //                   decoration: BoxDecoration(
  //                       color: Colors.white,
  //                       shape: BoxShape.rectangle,
  //                       borderRadius: BorderRadius.only(
  //                           topLeft: Radius.circular(12),
  //                           topRight: Radius.circular(12))),
  //                 ),
  //                 Padding(
  //                   padding: const EdgeInsets.only(left: 12.0),
  //                   child: Align(
  //                     alignment: Alignment.centerLeft,
  //                     child: Text(
  //                       order.length > 100
  //                           ? " ${order.substring(0, 99)}"
  //                           : order,
  //                       maxLines: 3,
  //                       style: TextStyle(
  //                         fontFamily: "nanumR",
  //                         fontWeight: FontWeight.w600,
  //                         fontSize: 15,
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //                 Padding(
  //                   padding: EdgeInsets.only(bottom: 15),
  //                 ),
  //                 Align(
  //                     alignment: Alignment.centerLeft,
  //                     child: Padding(
  //                       padding: const EdgeInsets.only(left: 12),
  //                       child: Text(
  //                         reason == "1"
  //                             ? '취소사유 : 고객 요청'
  //                             : reason == "2"
  //                                 ? '취소사유 : 재료 소진'
  //                                 : reason == "3"
  //                                     ? '취소사유 : 업소 사정'
  //                                     : '취소사유 : 기타',
  //                         style: TextStyle(
  //                           fontFamily: "nanumB",
  //                           fontWeight: FontWeight.w700,
  //                           fontSize: 11.0,
  //                         ),
  //                       ),
  //                     )),
  //                 Spacer(),
  //                 Row(
  //                   mainAxisSize: MainAxisSize.min,
  //                   children: <Widget>[
  //                     Align(
  //                       alignment: Alignment.bottomCenter,
  //                       child: OutlineButton(
  //                         shape: RoundedRectangleBorder(
  //                             borderRadius: BorderRadius.circular(3)),
  //                         borderSide: BorderSide(
  //                           color: Colors.black, //Color of the border
  //                           style: BorderStyle.solid, //Style of the border
  //                           width: 0.5, //width of the border
  //                         ),
  //                         onPressed: () {
  //                           Navigator.of(context).pop();
  //                         },
  //                         child: Text('취소'),
  //                         textColor: Colors.black,
  //                         color: Colors.white,
  //                       ),
  //                     ),
  //                     SizedBox(
  //                       width: 15,
  //                     ),
  //                     Align(
  //                         alignment: Alignment.bottomCenter,
  //                         child: OutlineButton(
  //                           shape: RoundedRectangleBorder(
  //                               borderRadius: BorderRadius.circular(3)),
  //                           borderSide: BorderSide(
  //                             color: Colors.black, //Color of the border
  //                             style: BorderStyle.solid, //Style of the border
  //                             width: 0.5, //width of the border
  //                           ),
  //                           onPressed: () {
  //                             opening == true
  //                                 ? userDataCheck(shopName, shopSeq)
  //                                 : showDialog(
  //                                     context: context,
  //                                     builder: (_) => CupertinoAlertDialog(
  //                                           content: Text("영업 시간이 아닙니다"),
  //                                           actions: <Widget>[
  //                                             CupertinoDialogAction(
  //                                               child: Text('확인'),
  //                                               onPressed: () =>
  //                                                   Navigator.of(context).pop(),
  //                                             ),
  //                                           ],
  //                                         ));
  //                           },
  //                           child: Text('주문'),
  //                           color: Colors.white,
  //                           textColor: Colors.black,
  //                         ))
  //                   ],
  //                 ),
  //                 Padding(
  //                   padding: EdgeInsets.only(bottom: 1.5),
  //                 ),
  //               ],
  //             ),
  //           )));
  // }

  // void _showDetailDialog(
  //   String date,
  //   int price,
  //   String placeName,
  //   String order,
  //   int orderSeq,
  //   String pic,
  //   int shopSeq,
  // ) {
  //   slideDialog.showSlideDialog(
  //     context: context,
  //     child: Expanded(
  //       child: SingleChildScrollView(
  //         child: Container(
  //           child: Column(
  //             children: <Widget>[
  //               Row(
  //                 // crossAxisAlignment: CrossAxisAlignment.center,
  //                 textBaseline: TextBaseline.alphabetic,
  //                 children: [
  //                   Padding(
  //                       padding: EdgeInsets.only(
  //                           left: MediaQuery.of(context).size.width * 0.25)),
  //                   Text(
  //                     '${placeName}',
  //                     style: TextStyle(
  //                       fontFamily: "nanumB",
  //                       fontWeight: FontWeight.w900,
  //                       fontSize: 18.0,
  //                     ),
  //                   ),
  //                   Text(
  //                     "에서 ",
  //                     style: TextStyle(
  //                       fontFamily: "nanumB",
  //                       fontWeight: FontWeight.w500,
  //                       fontSize: 11,
  //                     ),
  //                   ),
  //                   Text(
  //                     " 주문!",
  //                     style: TextStyle(
  //                       fontFamily: "nanumB",
  //                       fontWeight: FontWeight.w500,
  //                       fontSize: 18,
  //                     ),
  //                   ),
  //                   Padding(
  //                     padding: EdgeInsets.only(right: 15),
  //                   ),
  //                 ],
  //               ),
  //               Padding(
  //                 padding: EdgeInsets.only(
  //                     top: MediaQuery.of(context).size.height * 0.02),
  //               ),

  //               Container(
  //                 padding: EdgeInsets.only(left: 20.0, bottom: 15.0),
  //               ),
  //               Container(
  //                 padding: EdgeInsets.only(left: 12.0, bottom: 20.0),
  //               ),
  //               Padding(
  //                   padding: const EdgeInsets.only(left: 5.0, right: 5),
  //                   child: Container(
  //                       padding: EdgeInsets.only(top: 5),
  //                       decoration: BoxDecoration(border: Border.all()),
  //                       width: MediaQuery.of(context).size.width * 0.8,
  //                       height: MediaQuery.of(context).size.height * 0.3,
  //                       child: Image.network(
  //                         'http://hndsolution.iptime.org:8086${pic}',
  //                         width: MediaQuery.of(context).size.width * 0.13,
  //                         height: MediaQuery.of(context).size.height * 0.15,
  //                         fit: BoxFit.fitWidth,
  //                       ))),
  //               Container(
  //                 padding: EdgeInsets.only(left: 20.0, bottom: 10.0),
  //               ),

  //               Row(
  //                 crossAxisAlignment: CrossAxisAlignment.end,
  //                 textBaseline: TextBaseline.alphabetic,
  //                 children: [
  //                   Padding(
  //                     padding: EdgeInsets.only(left: 15, top: 15),
  //                   ),
  //                   Padding(
  //                       padding: EdgeInsets.only(left: 10, top: 30),
  //                       child: Container(
  //                         width: MediaQuery.of(context).size.width * 0.9,
  //                         child: order.length > 45
  //                             ? Text(
  //                                 "${order.substring(0, 43)}...",
  //                                 //'가ㅏ가가각가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가각가가가가가ㅏ가각가가ㅏ가가각',
  //                                 maxLines: 7,
  //                                 style: TextStyle(
  //                                   fontFamily: "nanumR",
  //                                   fontWeight: FontWeight.w700,
  //                                   fontSize: 15,
  //                                 ),
  //                               )
  //                             : Text(
  //                                 order,
  //                                 //'가ㅏ가가각가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가각가가가가가ㅏ가각가가ㅏ가가각',
  //                                 maxLines: 7,
  //                                 style: TextStyle(
  //                                   fontFamily: "nanumR",
  //                                   fontWeight: FontWeight.w700,
  //                                   fontSize: 15,
  //                                 ),
  //                               ),
  //                       )),
  //                 ],
  //               ),
  //               Padding(
  //                 padding: EdgeInsets.only(right: 5, bottom: 20),
  //               ),

  //               // Padding(
  //               //     padding: EdgeInsets.only(bottom: 15, left: 15),
  //               //     child: Align(
  //               //       alignment: Alignment.bottomRight,
  //               //       child: FlatButton(
  //               //         color: Colors.black,
  //               //         onPressed: () {
  //               //           Navigator.of(context).pop();
  //               //         },
  //               //         child: Text('확인',
  //               //             style: TextStyle(
  //               //               fontFamily: "nanumR",
  //               //               fontSize: 13,
  //               //               fontWeight: FontWeight.w900,
  //               //             )),
  //               //         textColor: Colors.black,
  //               //       ),
  //               //     )),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //     barrierColor: Colors.white.withOpacity(0.7),
  //     pillColor: Colors.amberAccent,
  //     backgroundColor: Colors.white,
  //   );
  // }

  writingReview(orderSeq, shopName, order, userId, userSeq) async {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            new Review(orderSeq, shopName, order, userId, userSeq)));
  }

  webView(placeName, shopSeq, userId, userPassword) async {
    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) => WebViewContainer(
    //             placeName: placeName,
    //             shopSeq: shopSeq,
    //             userId: userId,
    //             userPassword: userPassword,
    //             userChk: userChk,
    //             number: "1")));
    Navigator.pushReplacementNamed(context, '/webview', arguments: {
      'placeName': placeName,
      'shopSeq': shopSeq,
      'userId': userId,
      'userPassword': userPassword,
      'userChk': userChk,
      'number': "1"
    });
  }

  readingMyReview(shopId, shopName, order, userId) async {
    print("myReview");
  }

  myReview() async {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => new MyReview(userId)));
  }

  var userPassword;
  void _handleURLButtonPress(BuildContext context, String url, String placeName,
      int shopSeq, String userId) {
    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) => WebViewContainer(
    //             placeName: placeName,
    //             shopSeq: shopSeq,
    //             userId: userId,
    //             userPassword: userPassword,
    //             userChk: userChk,
    //             number: "1")));
    Navigator.pushReplacementNamed(context, '/webview', arguments: {
      'placeName': placeName,
      'shopSeq': shopSeq,
      'userId': userId,
      'userPassword': userPassword,
      'userChk': userChk,
      'number': "1"
    });
  }

  Widget _usageCard(reviewInfoList) {
    if (_value == 1) {
    } else if (_value == 2) {
      reviewInfoList = reviewInfoList
          .where((element) => element['ORDER_STATUS'] == "3")
          .toList();
    } else if (_value == 3) {
      reviewInfoList = reviewInfoList
          .where((element) => element['ORDER_STATUS'] == "9")
          .toList();
    }

    reviewInfoList.sort((b, a) =>
        int.parse(a['RESERVE_DATE']).compareTo(int.parse(b['RESERVE_DATE'])));

    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: reviewInfoList.length == null ? null : reviewInfoList.length,
        padding: EdgeInsets.zero,
        itemBuilder: (context, position) {
          var date = reviewInfoList[position]['RESERVE_DATE'];

          DateTime now = DateTime.now();

          var orderDate = DateTime.parse(date);

          date = reviewInfoList[position]['RESERVE_DATE'];
          year = date.substring(0, 4);
          month = date.substring(4, 6);
          day = date.substring(6, 8);

          var width = MediaQuery.of(context).size.width;
          var height = MediaQuery.of(context).size.height;
          String showDate = '${year}년${month}월${day}일';
          int compareDate = now.difference(orderDate).inDays;

          String startHour, startMin, endHour, endMin;
          TimeOfDay startTime, endTime;
          String holiday = "";
          holiday = reviewInfoList[position]['HLDY_CD'];

          List<String> restDay;

          if (holiday != null) {
            restDay = holiday.split(',');

            for (int hold = 0; hold < restDay.length; hold++) {
              if (restDay.elementAt(hold) == now.weekday.toString()) {
                dayOpenShop[reviewInfoList[position]["SHOP_SEQ"]] = false;
              }
              // print('out ${now.weekday}');
              // print('out ${restDay.elementAt(hold)}');
              else {
                dayOpenShop[reviewInfoList[position]["SHOP_SEQ"]] = true;
              }
            }
          }

          if (now.weekday == 6 || now.weekday == 7) {
            startHour =
                reviewInfoList[position]['WEEK_BEGIN_TIME'].substring(0, 2);
            startMin =
                reviewInfoList[position]['WEEK_BEGIN_TIME'].substring(2, 4);
            endHour = reviewInfoList[position]['WEEK_END_TIME'].substring(0, 2);
            endMin = reviewInfoList[position]['WEEK_END_TIME'].substring(2, 4);

            startTime = TimeOfDay(
                hour: int.parse(startHour), minute: int.parse(startMin));
            endTime =
                TimeOfDay(hour: int.parse(endHour), minute: int.parse(endMin));
          } else {
            startHour =
                reviewInfoList[position]['BSN_BEGIN_TIME'].substring(0, 2);
            startMin =
                reviewInfoList[position]['BSN_BEGIN_TIME'].substring(2, 4);
            endHour = reviewInfoList[position]['BSN_END_TIME'].substring(0, 2);
            endMin = reviewInfoList[position]['BSN_END_TIME'].substring(2, 4);

            startTime = TimeOfDay(
                hour: int.parse(startHour), minute: int.parse(startMin));
            endTime =
                TimeOfDay(hour: int.parse(endHour), minute: int.parse(endMin));
          }
          openingShop(startTime, endTime, reviewInfoList[position]['SHOP_SEQ']);

          return reviewInfoList[position]['ORDER_STATUS'] == "3"
              ? SingleChildScrollView(
                  physics: ScrollPhysics(),
                  child: Container(
                    height: height * 0.233,
                    width: width * 0.9,
                    child: Column(
                      children: [
                        Card(
                            elevation: 1,
                            child: Row(
                              children: <Widget>[
                                Container(
                                  //decoration: BoxDecoration(border: Border.all()),
                                  width: width * 0.3,
                                  height: height * 0.1,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: width * 0.01,
                                        top: height * 0.005),
                                    child: InkWell(
                                        onTap: () {},
                                        child: reviewInfoList[position]
                                                    ['FILE_URL'] ==
                                                null
                                            ? Image.asset(
                                                'assets/icon/noImage.png')
                                            : Image.network(
                                                'http://hndsolution.iptime.org:8086${reviewInfoList[position]['FILE_URL']}',
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.28,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.2,
                                                fit: BoxFit.fitWidth,
                                              )),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: width * 0.01),
                                ),
                                Container(
                                  width: width * 0.34,
                                  height: height * 0.14,
                                  child: Column(
                                    children: <Widget>[
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            left: width * 0.01,
                                            top: height * 0.03,
                                          ),
                                          child: InkWell(
                                            onTap: () {
                                              if (this.mounted) {
                                                setState(() {
                                                  userDataCheck(
                                                      reviewInfoList[position]
                                                          ['SHOP_NAME'],
                                                      reviewInfoList[position]
                                                          ['SHOP_SEQ']);
                                                });
                                              }
                                            },
                                            child: reviewInfoList[position]
                                                            ['SHOP_NAME']
                                                        .length >
                                                    14
                                                ? Text(
                                                    "${reviewInfoList[position]['SHOP_NAME'].substring(0, 15)}...",
                                                    style: TextStyle(
                                                      fontFamily: "nanumB",
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 16.0,
                                                    ),
                                                  )
                                                : Text(
                                                    reviewInfoList[position]
                                                        ['SHOP_NAME'],
                                                    //"가나다라마바사하아나자아러너",
                                                    style: TextStyle(
                                                      fontFamily: "nanumB",
                                                      fontWeight:
                                                          FontWeight.w900,
                                                      fontSize: 18.0,
                                                    ),
                                                  ),
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            left: width * 0.01,
                                            top: height * 0.008,
                                          ),
                                          child: reviewInfoList[position]
                                                      ['MENU_NAME'] ==
                                                  null
                                              ? Text("")
                                              : reviewInfoList[position]
                                                              ['MENU_NAME']
                                                          .length <
                                                      60
                                                  ? Text(
                                                      "${reviewInfoList[position]['MENU_NAME']}",
                                                      maxLines: 6,
                                                      style: TextStyle(
                                                        fontFamily: "nanumB",
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 15,
                                                      ),
                                                    )
                                                  : Text(
                                                      "${reviewInfoList[position]['MENU_NAME'].substring(0, 35)}",
                                                      // "아이스 아메리카노 2개 카푸치노 1개 삼겹살 2인분 소주 6병",
                                                      maxLines: 3,
                                                      style: TextStyle(
                                                        fontFamily: "nanumB",
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 12.5,
                                                      ),
                                                    ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Spacer(),
                                Container(
                                  width: width * 0.32,
                                  height: height * 0.14,
                                  child: Column(
                                    children: <Widget>[
                                      reviewInfoList[position]['REVIEW_YN'] ==
                                              "Y"
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: <Widget>[
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 5, top: 5),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors
                                                          .blueAccent[100],
                                                      border: Border.all(
                                                        color:
                                                            Colors.transparent,
                                                        width: 2,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  15.0) //                 <--- border radius here
                                                              ),
                                                    ),
                                                    child: Text(
                                                      '리뷰 완료',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontFamily: "nanumR",
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        fontSize: 11,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 5, top: 5),
                                                  child: Container(
                                                    child: InkWell(
                                                      onTap: () {
                                                        showDialog(
                                                            context: context,
                                                            builder: (_) =>
                                                                CupertinoAlertDialog(
                                                                  title: Text(
                                                                      '정말 삭제하시겠어요?'),
                                                                  content:
                                                                      Text(""),
                                                                  actions: <
                                                                      Widget>[
                                                                    CupertinoDialogAction(
                                                                      child: Text(
                                                                          '아니요'),
                                                                      onPressed:
                                                                          () =>
                                                                              Navigator.of(context).pop(),
                                                                    ),
                                                                    CupertinoDialogAction(
                                                                        child: Text(
                                                                            '네'),
                                                                        onPressed:
                                                                            () {
                                                                          if (this
                                                                              .mounted) {
                                                                            setState(() {
                                                                              delete(userId, reviewInfoList[position]['ORDER_SEQ']);
                                                                            });
                                                                          }
                                                                        }),
                                                                  ],
                                                                ));
                                                      },
                                                      child: Icon(
                                                        Icons.delete,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Align(
                                              alignment: Alignment.topRight,
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    right: width * 0.02,
                                                    top: height * 0.02),
                                                child: Text(
                                                  ' ${showDate}',
                                                  style: TextStyle(
                                                    fontFamily: "nanumR",
                                                    fontWeight: FontWeight.w800,
                                                    fontSize: 13.5,
                                                  ),
                                                ),
                                              )),
                                      Padding(
                                        padding:
                                            EdgeInsets.only(top: height * 0.01),
                                      ),
                                      Spacer(),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            right: width * 0.03,
                                            bottom: height * 0.02),
                                        child: Align(
                                          alignment: Alignment.bottomRight,
                                          child: reviewInfoList[position]
                                                          ['TOTAL_PRICE']
                                                      .toString()
                                                      .length >
                                                  7
                                              ? Text(
                                                  "총액: ${reviewInfoList[position]['TOTAL_PRICE']}원",
                                                  //"총액: 200,000원",
                                                  textAlign: TextAlign.end,
                                                  style: TextStyle(
                                                    fontFamily: "nanumR",
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 12,
                                                  ),
                                                )
                                              : Text(
                                                  "총액: ${reviewInfoList[position]['TOTAL_PRICE']}원",
                                                  //"총액: 200,000원",
                                                  textAlign: TextAlign.end,
                                                  style: TextStyle(
                                                    fontFamily: "nanumR",
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )),
                        reviewInfoList[position]['REVIEW_YN'] == "N"
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Spacer(),
                                  Container(
                                    alignment: Alignment.bottomRight,
                                    child: FlatButton(
                                      onPressed: () {
                                        // _showDetailDialog(
                                        //     showDate,
                                        //     reviewInfoList[position]['TOTAL_PRICE'],
                                        //     reviewInfoList[position]['SHOP_NAME'],
                                        //     reviewInfoList[position]['MENU_NAME'],
                                        //     reviewInfoList[position]['ORDER_SEQ'],
                                        //     reviewInfoList[position]['FILE_URL'],
                                        //     reviewInfoList[position]['SHOP_SEQ']);
                                        _usageDetail(
                                            showDate,
                                            reviewInfoList[position]
                                                ['TOTAL_PRICE'],
                                            reviewInfoList[position]
                                                ['SHOP_NAME'],
                                            reviewInfoList[position]
                                                ['MENU_NAME'],
                                            reviewInfoList[position]
                                                ['ORDER_SEQ'],
                                            reviewInfoList[position]
                                                ['FILE_URL'],
                                            reviewInfoList[position]
                                                ['SHOP_SEQ'],
                                            reviewInfoList[position]
                                                ['BSN_BEGIN_TIME'],
                                            reviewInfoList[position]
                                                ['BSN_END_TIME'],
                                            reviewInfoList[position]
                                                ['WEEK_BEGIN_TIME'],
                                            reviewInfoList[position]
                                                ['WEEK_END_TIME']);
                                      },
                                      child: Text('상세 내역',
                                          style: TextStyle(
                                            fontFamily: "nanumR",
                                            fontSize: 13.5,
                                            fontWeight: FontWeight.w600,
                                          )),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                      right: width * 0.005,
                                    ),
                                    alignment: Alignment.bottomRight,
                                    child: FlatButton(
                                      onPressed: () {
                                        if (this.mounted) {
                                          setState(() {
                                            writingReview(
                                              reviewInfoList[position]
                                                  ['ORDER_SEQ'],
                                              reviewInfoList[position]
                                                  ['SHOP_NAME'],
                                              reviewInfoList[position]
                                                          ['MENU_NAME'] ==
                                                      null
                                                  ? ""
                                                  : reviewInfoList[position]
                                                      ['MENU_NAME'],
                                              userId,
                                              reviewInfoList[position]
                                                  ['USER_SEQ'],
                                            );
                                          });
                                        }
                                      },
                                      child: Text('리뷰 쓰기',
                                          style: TextStyle(
                                            fontFamily: "nanumR",
                                            fontSize: 13.5,
                                            fontWeight: FontWeight.w800,
                                          )),
                                    ),
                                  ),
                                ],
                              )
                            : Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Spacer(),
                                  Container(
                                    alignment: Alignment.bottomRight,
                                    child: FlatButton(
                                      onPressed: () {
                                        // _showDetailDialog(
                                        //   showDate,
                                        //   reviewInfoList[position]['TOTAL_PRICE'],
                                        //   reviewInfoList[position]['SHOP_NAME'],
                                        //   reviewInfoList[position]['MENU_NAME'],
                                        //   reviewInfoList[position]['ORDER_SEQ'],
                                        //   reviewInfoList[position]['FILE_URL'],
                                        //   reviewInfoList[position]['SHOP_SEQ'],
                                        // );
                                        _usageDetail(
                                            showDate,
                                            reviewInfoList[position]
                                                ['TOTAL_PRICE'],
                                            reviewInfoList[position]
                                                ['SHOP_NAME'],
                                            reviewInfoList[position]
                                                ['MENU_NAME'],
                                            reviewInfoList[position]
                                                ['ORDER_SEQ'],
                                            reviewInfoList[position]
                                                ['FILE_URL'],
                                            reviewInfoList[position]
                                                ['SHOP_SEQ'],
                                            reviewInfoList[position]
                                                ['BSN_BEGIN_TIME'],
                                            reviewInfoList[position]
                                                ['BSN_END_TIME'],
                                            reviewInfoList[position]
                                                ['WEEK_BEGIN_TIME'],
                                            reviewInfoList[position]
                                                ['WEEK_END_TIME']);
                                      },
                                      child: Text('상세 내역',
                                          style: TextStyle(
                                            fontFamily: "nanumR",
                                            fontSize: 13.5,
                                            fontWeight: FontWeight.w600,
                                          )),
                                    ),
                                  ),
                                  Container(
                                    padding:
                                        EdgeInsets.only(right: width * 0.005),
                                    alignment: Alignment.bottomRight,
                                    child: FlatButton(
                                      onPressed: () {
                                        reviewInfoList[position]
                                                        ['REVIEW_IMG_URL'] ==
                                                    null ||
                                                reviewInfoList[position]
                                                        ['REVIEW_IMG_URL'] ==
                                                    ""
                                            ? _reviewStory(
                                                showDate,
                                                reviewInfoList[position]
                                                    ['SHOP_NAME'],
                                                reviewInfoList[position]
                                                    ['MENU_NAME'],
                                                reviewInfoList[position]
                                                    ['REVIEW_COMMENT'],
                                              )
                                            : _reviewPicStory(
                                                showDate,
                                                reviewInfoList[position]
                                                    ['SHOP_NAME'],
                                                reviewInfoList[position]
                                                    ['MENU_NAME'],
                                                reviewInfoList[position]
                                                    ['REVIEW_COMMENT'],
                                                reviewInfoList[position]
                                                    ['REVIEW_IMG_URL'],
                                              );
                                      },
                                      child: Text('리뷰 보기',
                                          style: TextStyle(
                                            fontFamily: "nanumR",
                                            fontSize: 13.5,
                                            fontWeight: FontWeight.w600,
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                        Container(
                          child: Divider(
                            height: 1.5,
                            color: Colors.black,
                          ),
                          padding: EdgeInsets.only(left: 12.0, right: 12.0),
                        ),
                      ],
                    ),
                  ),
                )
              : SingleChildScrollView(
                  physics: ScrollPhysics(),
                  child: Container(
                    height: height * 0.233,
                    width: width * 0.9,
                    child: Column(
                      children: [
                        Card(
                            elevation: 1,
                            child: Row(
                              children: <Widget>[
                                Container(
                                  //decoration: BoxDecoration(border: Border.all()),
                                  width: width * 0.3,
                                  height: height * 0.1,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: width * 0.01,
                                        top: height * 0.005),
                                    child: InkWell(
                                        onTap: () {},
                                        child: reviewInfoList[position]
                                                    ['FILE_URL'] ==
                                                null
                                            ? Image.asset(
                                                'assets/icon/noImage.png')
                                            : Image.network(
                                                'http://hndsolution.iptime.org:8086${reviewInfoList[position]['FILE_URL']}',
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.28,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.2,
                                                fit: BoxFit.fitWidth,
                                              )),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: width * 0.01),
                                ),
                                Container(
                                  width: width * 0.34,
                                  height: height * 0.14,
                                  child: Column(
                                    children: <Widget>[
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            left: width * 0.01,
                                            top: height * 0.03,
                                          ),
                                          child: InkWell(
                                            onTap: () {
                                              if (this.mounted) {
                                                setState(() {
                                                  userDataCheck(
                                                      reviewInfoList[position]
                                                          ['SHOP_NAME'],
                                                      reviewInfoList[position]
                                                          ['SHOP_SEQ']);
                                                });
                                              }
                                            },
                                            child: reviewInfoList[position]
                                                            ['SHOP_NAME']
                                                        .length >
                                                    14
                                                ? Text(
                                                    "${reviewInfoList[position]['SHOP_NAME'].substring(0, 15)}...",
                                                    style: TextStyle(
                                                      color: Colors.grey[400],
                                                      fontFamily: "nanumR",
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 16.0,
                                                    ),
                                                  )
                                                : Text(
                                                    reviewInfoList[position]
                                                        ['SHOP_NAME'],
                                                    style: TextStyle(
                                                      color: Colors.grey[400],
                                                      fontFamily: "nanumR",
                                                      fontWeight:
                                                          FontWeight.w900,
                                                      fontSize: 18.0,
                                                    ),
                                                  ),
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            left: width * 0.01,
                                            top: height * 0.008,
                                          ),
                                          child: reviewInfoList[position]
                                                      ['MENU_NAME'] ==
                                                  null
                                              ? Text("")
                                              : reviewInfoList[position]
                                                              ['MENU_NAME']
                                                          .length <
                                                      60
                                                  ? Text(
                                                      "${reviewInfoList[position]['MENU_NAME']}",
                                                      maxLines: 6,
                                                      style: TextStyle(
                                                        color: Colors.grey[400],
                                                        fontFamily: "nanumR",
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        fontSize: 15,
                                                      ),
                                                    )
                                                  : Text(
                                                      "${reviewInfoList[position]['MENU_NAME'].substring(0, 60)}",
                                                      maxLines: 6,
                                                      style: TextStyle(
                                                        color: Colors.grey[400],
                                                        fontFamily: "nanumR",
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Spacer(),
                                Container(
                                  width: width * 0.32,
                                  height: height * 0.14,
                                  child: Column(
                                    children: <Widget>[
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: Padding(
                                          padding:
                                              EdgeInsets.only(right: 5, top: 5),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.redAccent[100],
                                              border: Border.all(
                                                color: Colors.transparent,
                                                width: 2,
                                              ),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(
                                                      15.0) //                 <--- border radius here
                                                  ),
                                            ),
                                            child: Text(
                                              '주문취소',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontFamily: "nanumR",
                                                fontWeight: FontWeight.w900,
                                                fontSize: 11,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Spacer(),
                                      // Align(
                                      //                                       alignment: Alignment.topRight,
                                      //                                       child: Padding(
                                      //                                         padding: EdgeInsets.only(
                                      //                                             right: width * 0.02,
                                      //                                             top: height * 0.02),
                                      //                                         child: Text(
                                      //                                           ' ${showDate}',
                                      //                                           style: TextStyle(
                                      //                                             color: Colors.grey[400],
                                      //                                             fontFamily: "nanumR",
                                      //                                             fontWeight: FontWeight.w800,
                                      //                                             fontSize: 13.5,
                                      //                                           ),
                                      //                                         ),
                                      //                                       )),

                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: Padding(
                                            padding: EdgeInsets.only(
                                                right: width * 0.03,
                                                bottom: height * 0.02),
                                            child: Text(
                                              reviewInfoList[position]
                                                          ['CANCEL_REASON'] ==
                                                      "1"
                                                  ? '고객 요청'
                                                  : reviewInfoList[position][
                                                              'CANCEL_REASON'] ==
                                                          "2"
                                                      ? '재료 소진'
                                                      : reviewInfoList[position]
                                                                  [
                                                                  'CANCEL_REASON'] ==
                                                              "3"
                                                          ? '업소 사정'
                                                          : '기타',
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontFamily: "nanumB",
                                                fontWeight: FontWeight.w700,
                                                fontSize: 14.0,
                                              ),
                                            )),
                                      ),

                                      // Align(
                                      //         alignment: Alignment.topRight,
                                      //         child: Padding(
                                      //           padding: EdgeInsets.only(
                                      //               right: width * 0.01,
                                      //               top: height * 0.02),
                                      //           child: Text(
                                      //             ' ${showDate}',
                                      //             style: TextStyle(
                                      //               fontFamily: "nanumR",
                                      //               fontWeight: FontWeight.w800,
                                      //               fontSize: 13.5,
                                      //             ),
                                      //           ),
                                      //         )),
                                    ],
                                  ),
                                ),
                              ],
                            )),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          //textBaseline: TextBaseline.alphabetic,
                          children: [
                            Spacer(),
                            Container(
                              padding: EdgeInsets.only(right: width * 0.005),
                              alignment: Alignment.bottomRight,
                              child: FlatButton(
                                onPressed: () {
                                  openShopSeq[reviewInfoList[position]
                                                  ['SHOP_SEQ']] ==
                                              true &&
                                          dayOpenShop[reviewInfoList[position]
                                                  ['SHOP_SEQ']] ==
                                              true
                                      ? setState(() {
                                          userDataCheck(
                                              reviewInfoList[position]
                                                  ['SHOP_NAME'],
                                              reviewInfoList[position]
                                                  ['SHOP_SEQ']);
                                        })
                                      : showDialog(
                                          context: context,
                                          builder: (_) => CupertinoAlertDialog(
                                                content: Text("영업 시간이 아닙니다"),
                                                actions: <Widget>[
                                                  CupertinoDialogAction(
                                                    child: Text('확인'),
                                                    onPressed: () =>
                                                        Navigator.of(context)
                                                            .pop(),
                                                  ),
                                                ],
                                              ));
                                  ;
                                },
                                child: Text('주문 하기',
                                    style: TextStyle(
                                      fontFamily: "nanumR",
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w600,
                                    )),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          child: Divider(
                            height: 1.5,
                            color: Colors.black,
                          ),
                          padding: EdgeInsets.only(left: 12.0, right: 12.0),
                        ),
                      ],
                    ),
                  ),
                );
        });
  }

  getOrderUsageHistory(userId) async {
    if (userId == null || userId == "") {
      return "nologin";
    } else {
      return orderList.getOrderHistory(userId);
    }
  }

  Widget noData() {
    return Center(
      child: Image.asset('assets/icon/noImage.png'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false,
          title: Text(
            "이용내역",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
          ),
          actions: <Widget>[
            FlatButton(
                child: Text("내 리뷰",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w900)),
                onPressed: myReview)
          ],
        ),
        body: FutureBuilder(
            future: orderFuture,
            builder: (context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Center();
              }

              if (snapshot.data == "nologin") {
                return Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 20, bottom: 20),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Container(
                          child: Align(
                        alignment: Alignment.centerRight,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          textBaseline: TextBaseline.alphabetic,
                          children: <Widget>[
                            Spacer(),
                            Text(
                              "",
                              style: TextStyle(
                                // color: _colorText,
                                fontSize: 23.0,
                                fontFamily: 'nanumB',
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      )),
                    ),
                    Padding(
                      child: Divider(
                        color: Colors.black,
                        thickness: 3,
                      ),
                      padding: EdgeInsets.only(bottom: 40),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Container(
                          child: Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: <Widget>[
                            Text("",
                                style: TextStyle(
                                  // color: _colorText,
                                  fontSize: 20.0,
                                  fontFamily: 'nanumR',
                                  fontWeight: FontWeight.w800,
                                )),
                            Text("",
                                style: TextStyle(
                                  // color: _colorText,
                                  fontSize: 18.0,
                                  fontFamily: 'nanumR',
                                  fontWeight: FontWeight.w800,
                                )),
                          ],
                        ),
                      )),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0, bottom: 20),
                    ),
                    Container(
                        padding: const EdgeInsets.only(left: 12.0, bottom: 20),
                        child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "로그인을 하시면",
                              style: TextStyle(
                                // color: _colorText,
                                fontSize: 16.0,
                                fontFamily: 'nanumR',
                                fontWeight: FontWeight.w800,
                              ),
                            ))),
                    Container(
                        padding: const EdgeInsets.only(left: 12.0, bottom: 3),
                        child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              " 좋아요 목록을 확인하실수 있습니다.",
                              style: TextStyle(
                                // color: _colorText,
                                fontSize: 16.0,
                                fontFamily: 'nanumR',
                                fontWeight: FontWeight.w800,
                              ),
                            ))),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0, bottom: 20),
                    ),
                    Container(
                      height: 50.0,
                      margin: EdgeInsets.all(10),
                      child: RaisedButton(
                        onPressed: moveLogin,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(80.0)),
                        padding: EdgeInsets.all(0.0),
                        child: Ink(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xff374ABE), Color(0xff64B6FF)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(30.0)),
                          child: Container(
                            constraints: BoxConstraints(
                                maxWidth: 250.0, minHeight: 50.0),
                            alignment: Alignment.center,
                            child: Text(
                              "로그인",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0, bottom: 20),
                    ),
                  ],
                );
              }

              Map<String, dynamic> reviewInfo = snapshot.data;

              if (reviewInfo["LIST"] == "" || reviewInfo["LIST"] == null) {
                return Container(
                    child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                    ),
                    Row(
                      children: [
                        Spacer(),
                        Container(
                            padding: EdgeInsets.only(
                                right:
                                    MediaQuery.of(context).size.width * 0.08),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3.0),
                                color: Colors.transparent,
                                border: Border.all()),
                            child: DropdownButton(
                                value: _value,
                                items: [
                                  DropdownMenuItem(
                                    child: Text("모두 보기"),
                                    value: 1,
                                  ),
                                  DropdownMenuItem(
                                    child: Text("조리 완료"),
                                    value: 2,
                                  ),
                                  DropdownMenuItem(child: Text("취소"), value: 3),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    _value = value;
                                  });
                                })),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                    ),
                    new SizedBox(
                      height: 10.0,
                      child: new Center(
                        child: new Container(
                          margin: new EdgeInsetsDirectional.only(
                              start: 1.0, end: 1.0),
                          height: 2.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          left: 20.0, right: 20.0, bottom: 10.0),
                    ),
                    Expanded(child: noData()),
                  ],
                ));
              } else {
                List<dynamic> reviewInfoList = reviewInfo["LIST"];

                return Container(
                    child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.01),
                    ),
                    Row(
                      children: [
                        Spacer(),
                        reviewInfoList.isEmpty
                            ? Text("")
                            : Container(
                                //  height: MediaQuery.of(context).size.height * 0.8,
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 10.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(3.0),
                                    color: Colors.transparent,
                                    border: Border.all()),
                                child: DropdownButton(
                                    value: _value,
                                    items: [
                                      DropdownMenuItem(
                                        child: Text("모두 보기"),
                                        value: 1,
                                      ),
                                      DropdownMenuItem(
                                        child: Text("조리 완료"),
                                        value: 2,
                                      ),
                                      DropdownMenuItem(
                                          child: Text("취소"), value: 3),
                                    ],
                                    onChanged: (value) {
                                      setState(() {
                                        _value = value;
                                      });
                                    })),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                    ),
                    new SizedBox(
                      height: 10.0,
                      child: new Center(
                        child: new Container(
                          margin: new EdgeInsetsDirectional.only(
                              start: 1.0, end: 1.0),
                          height: 2.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          left: 20.0, right: 20.0, bottom: 10.0),
                    ),
                    reviewInfoList.isEmpty
                        ? noData()
                        : Expanded(
                            child: SingleChildScrollView(
                              child: _usageCard(reviewInfoList),
                            ),
                          ),
                  ],
                ));
              }
            }));
  }
}
