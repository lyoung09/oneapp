import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:getwidget/getwidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wellhada_oneapp/UI/main/home_detail/webview.dart';
import 'package:wellhada_oneapp/UI/privateInfo_detail/login.dart';
import 'package:wellhada_oneapp/UI/usageHistory_detail/my_review.dart';
import 'package:wellhada_oneapp/UI/usageHistory_detail/review.dart';
import 'package:wellhada_oneapp/listitem/user/user.dart' as user;
import 'package:intl/intl.dart';

import 'package:slide_popup_dialog/slide_popup_dialog.dart' as slideDialog;

class UsageHistory extends StatefulWidget {
  @override
  _UsageHistoryState createState() => _UsageHistoryState();
}

class _UsageHistoryState extends State<UsageHistory> {
  String webviewDefault = 'http://192.168.0.47:8080/usermngr';
  var userId;
  String date, year, month, day;
  int _value = 1;

  @override
  initState() {
    super.initState();
    check();
  }

  @override
  void didChangeDependencies() {
    check();

    super.didChangeDependencies();
  }

  void check() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        userId = prefs.getString("userKey");
      });
      if (userId != null) {
        print('userKey :${userId}');

        print(userId);
      }
      if (userId == null || userId == "") {}
    } catch (e) {
      print(e);
    }
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
                      decoration: BoxDecoration(border: Border.all()),
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: Image.network(
                        pic,
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.height * 0.3,
                        fit: BoxFit.fitWidth,
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
                        padding: EdgeInsets.only(left: 8),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Text(
                            story,
                            //'11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111',
                            maxLines: 5,
                            style: TextStyle(
                              fontFamily: "nanumR",
                              fontWeight: FontWeight.w500,
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

  void _showOnlyReviewDialog(
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
                      decoration: BoxDecoration(border: Border.all()),
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: Image.network(
                        pic,
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.height * 0.3,
                        fit: BoxFit.fitWidth,
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
                        padding: EdgeInsets.only(left: 8),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Text(
                            story,
                            //'11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111',
                            maxLines: 5,
                            style: TextStyle(
                              fontFamily: "nanumR",
                              fontWeight: FontWeight.w500,
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

  writingReview(shopId, shopName, order, userId) async {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => new Review(shopId, shopName, order, userId)));
  }

  readingMyReview(shopId, shopName, order, userId) async {
    print("myReview");
  }

  myReview() async {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => new MyReview()));
  }

  var userPassword;
  void _handleURLButtonPress(BuildContext context, String url, String placeName,
      int userSeq, String userId) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                WebViewContainer(placeName, userSeq, userId, userPassword)));

    // Navigator.pushNamed(context, '/webview');
  }

  Widget _usageCard(reviewInfoList) {
    print(_value);

    if (_value == 1) {
    } else if (_value == 2) {
      reviewInfoList =
          reviewInfoList.where((element) => element['review'] == "Y").toList();
    } else if (_value == 3) {
      reviewInfoList =
          reviewInfoList.where((element) => element['review'] == "N").toList();
    }
    reviewInfoList
        .sort((b, a) => int.parse(a['date']).compareTo(int.parse(b['date'])));

    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: reviewInfoList.length == null ? null : reviewInfoList.length,
        padding: EdgeInsets.zero,
        itemBuilder: (context, position) {
          var date = reviewInfoList[position]['date'];

          DateTime now = DateTime.now();

          var orderDate = DateTime.parse(date);

          date = reviewInfoList[position]['date'];
          year = date.substring(0, 4);
          month = date.substring(4, 6);
          day = date.substring(6, 8);

          var width = MediaQuery.of(context).size.width;
          var height = MediaQuery.of(context).size.height;
          String showDate = '${year}년${month}월${day}일';
          int compareDate = now.difference(orderDate).inDays;

          return Container(
            height: height * 0.2,
            width: width * 0.85,
            child: Card(
                elevation: 1,
                child: Row(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(border: Border.all()),
                      width: width * 0.25,
                      height: height * 0.2,
                      child: Padding(
                        padding: EdgeInsets.only(top: height * 0.005),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _handleURLButtonPress(
                                  context,
                                  '${webviewDefault}/shopTmplatView.do',
                                  reviewInfoList[position]['place_name'],
                                  12,
                                  userId);
                            });
                          },
                          child: Image.network(
                            reviewInfoList[position]['place_url'],
                            width: MediaQuery.of(context).size.width * 0.13,
                            height: MediaQuery.of(context).size.height * 0.15,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: width * 0.005),
                    ),
                    Container(
                      width: width * 0.42,
                      height: height * 0.15,
                      child: Column(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: width * 0.01, top: height * 0.005),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _handleURLButtonPress(
                                        context,
                                        '${webviewDefault}/shopTmplatView.do',
                                        reviewInfoList[position]['place_name'],
                                        12,
                                        userId);
                                  });
                                },
                                child: reviewInfoList[position]['place_name']
                                            .length >
                                        15
                                    ? Text(
                                        // "가가가가가가가가가가가가가가가...",
                                        "${reviewInfoList[position]['place_name'].substring(0, 15)}...",
                                        style: TextStyle(
                                          fontFamily: "nanumB",
                                          fontWeight: FontWeight.w700,
                                          fontSize: 17.0,
                                        ),
                                      )
                                    : Text(
                                        reviewInfoList[position]['place_name'],
                                        //"안녕하세요요요요요요",
                                        style: TextStyle(
                                          fontFamily: "nanumB",
                                          fontWeight: FontWeight.w700,
                                          fontSize: 17.0,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: width * 0.01, top: height * 0.02),
                              child:
                                  reviewInfoList[position]['order'].length < 105
                                      ? Text(
                                          "${reviewInfoList[position]['order']}",
                                          maxLines: 5,
                                          style: TextStyle(
                                            fontFamily: "nanumR",
                                            fontWeight: FontWeight.w700,
                                            fontSize: 12,
                                          ),
                                        )
                                      : Text(
                                          "${reviewInfoList[position]['order'].substring(0, 100)}...",
                                          maxLines: 5,
                                          style: TextStyle(
                                            fontFamily: "nanumR",
                                            fontWeight: FontWeight.w700,
                                            fontSize: 12,
                                          ),
                                        ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: width * 0.3,
                      child: Column(
                        children: <Widget>[
                          reviewInfoList[position]['review'] == "Y"
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top: height * 0.01,
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.amberAccent,
                                          border: Border.all(
                                            color: Colors.amberAccent,
                                            width: 1.8,
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                  5.0) //                 <--- border radius here
                                              ),
                                        ),
                                        child: Text(
                                          '리뷰완료',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: "nanumR",
                                            fontWeight: FontWeight.w900,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: width * 0.02,
                                        right: width * 0.01,
                                        top: height * 0.01,
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.blue[400],
                                          border: Border.all(
                                            color: Colors.blueAccent,
                                            width: 1.8,
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                  5.0) //                 <--- border radius here
                                              ),
                                        ),
                                        child: Text(
                                          '포인트',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: "nanumR",
                                            fontWeight: FontWeight.w900,
                                            fontSize: 10,
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
                                      right: width * 0.01,
                                      top: height * 0.02,
                                    ),
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
                            padding: EdgeInsets.only(bottom: height * 0.01),
                          ),
                          reviewInfoList[position]['review'] == "Y"
                              ? Align(
                                  alignment: Alignment.topRight,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: height * 0.01,
                                        right: width * 0.01),
                                    child: Text(
                                      ' ${showDate}',
                                      style: TextStyle(
                                        fontFamily: "nanumR",
                                        fontWeight: FontWeight.w800,
                                        fontSize: 13.5,
                                      ),
                                    ),
                                  ),
                                )
                              : Text(""),
                          Spacer(),
                          reviewInfoList[position]['review'] == "Y"
                              ? Container(
                                  alignment: Alignment.bottomRight,
                                  child: FlatButton(
                                    onPressed: () {
                                      if (reviewInfoList[position]
                                              ['review_picture'] ==
                                          "")
                                        _showOnlyReviewDialog(
                                            showDate,
                                            reviewInfoList[position]
                                                ['place_url'],
                                            reviewInfoList[position]
                                                ['place_name'],
                                            reviewInfoList[position]['order'],
                                            reviewInfoList[position]['story']);
                                      else
                                        _showIncludePicutreDialog(
                                            showDate,
                                            reviewInfoList[position]
                                                ['review_picture'],
                                            reviewInfoList[position]
                                                ['place_name'],
                                            reviewInfoList[position]['order'],
                                            reviewInfoList[position]['story']);
                                    },
                                    child: Text('리뷰 보기',
                                        style: TextStyle(
                                          fontFamily: "nanumR",
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800,
                                        )),
                                  ),
                                )
                              : Container(
                                  alignment: Alignment.bottomRight,
                                  child: FlatButton(
                                    onPressed: () {
                                      setState(() {
                                        writingReview(
                                          reviewInfoList[position]['shopId'],
                                          reviewInfoList[position]
                                              ['place_name'],
                                          reviewInfoList[position]['order'],
                                          reviewInfoList[position]['userId'],
                                        );
                                      });
                                    },
                                    child: Text('리뷰 쓰기',
                                        style: TextStyle(
                                          fontFamily: "nanumR",
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800,
                                        )),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ],
                )),
          );
        });
  }

  Future<Map<String, dynamic>> getReview() async {
    return user.getMyReviewList();
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
        ),
        body: FutureBuilder(
            future: getReview(),
            builder: (context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CupertinoActivityIndicator());
              }
              if (!snapshot.hasData && (userId == null || userId == "")) {
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
                              " 이용내역을 확인하실수 있습니다.",
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
                        //onPressed: moveLogin,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0)),
                        padding: EdgeInsets.all(0.0),
                        child: Ink(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xff374ABE), Color(0xff64B6FF)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(20.0)),
                          child: Container(
                            constraints: BoxConstraints(
                                maxWidth: 200.0, minHeight: 30.0),
                            alignment: Alignment.center,
                            child: Text(
                              "로그인",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 18),
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
              List<dynamic> reviewInfoList = reviewInfo["LIST"];

              reviewInfoList = reviewInfoList
                  .where((element) =>
                      element['using'] == "Y" && userId == element['userId'])
                  .toList();

              return Container(
                  child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 25),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            '뭐를 샀을까요~~?',
                            style: TextStyle(
                                fontFamily: 'nanumR',
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.w900),
                          ),
                        ),
                      ),
                      Spacer(),
                      Container(
                          color: Colors.transparent,
                          padding: EdgeInsets.only(right: 7),
                          child: DropdownButton(
                              value: _value,
                              items: [
                                DropdownMenuItem(
                                  child: Text("모두 보기"),
                                  value: 1,
                                ),
                                DropdownMenuItem(
                                  child: Text("작성 완료"),
                                  value: 2,
                                ),
                                DropdownMenuItem(child: Text("미작성"), value: 3),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _value = value;
                                });
                              })),
                    ],
                  ),
                  Container(
                    child: Divider(
                      color: Color.fromRGBO(82, 110, 208, 1.0),
                    ),
                    padding:
                        EdgeInsets.only(left: 20.0, right: 20.0, bottom: 0.0),
                  ),
                  Expanded(
                      child: reviewInfoList.isEmpty
                          ? noData()
                          : _usageCard(reviewInfoList)),
                ],
              ));
            }));
  }
}
