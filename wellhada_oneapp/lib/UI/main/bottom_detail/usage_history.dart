import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:getwidget/getwidget.dart';
import 'package:wellhada_oneapp/UI/main/home_detail/webview.dart';
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
  var userId = "112";
  String date, year, month, day;
  int _value = 1;
  @override
  initState() {
    super.initState();
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
                            fontSize: 13.0,
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
                              fontSize: 11.0,
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
                        fontSize: 14.0,
                      ),
                    ),
                    Text(
                      "에서 ",
                      style: TextStyle(
                        fontFamily: "nanumB",
                        fontWeight: FontWeight.w500,
                        fontSize: 9,
                      ),
                    ),
                    Text(
                      order,
                      style: TextStyle(
                        fontFamily: "nanumB",
                        fontWeight: FontWeight.w900,
                        fontSize: 12.5,
                      ),
                    ),
                    Text(
                      " 주문!",
                      style: TextStyle(
                        fontFamily: "nanumB",
                        fontWeight: FontWeight.w500,
                        fontSize: 9,
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
                              fontSize: 14,
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
                            fontSize: 13.0,
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
                              fontSize: 11.0,
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
                        fontSize: 14.0,
                      ),
                    ),
                    Text(
                      "에서 ",
                      style: TextStyle(
                        fontFamily: "nanumB",
                        fontWeight: FontWeight.w500,
                        fontSize: 9,
                      ),
                    ),
                    Text(
                      order,
                      style: TextStyle(
                        fontFamily: "nanumB",
                        fontWeight: FontWeight.w900,
                        fontSize: 12.5,
                      ),
                    ),
                    Text(
                      " 주문!",
                      style: TextStyle(
                        fontFamily: "nanumB",
                        fontWeight: FontWeight.w500,
                        fontSize: 9,
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
                              fontSize: 14,
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

  void _handleURLButtonPress(
      BuildContext context, String url, String placeName) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WebViewContainer(url, placeName)));

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

          String showDate = '${year}년 ${month}월 ${day}일';
          int compareDate = now.difference(orderDate).inDays;

          return Container(
            height: MediaQuery.of(context).size.height * 0.21,
            width: MediaQuery.of(context).size.width * 0.98,
            child: Card(
              elevation: 1,
              child: Column(
                children: [
                  // boxFit: BoxFit.cover,
                  Row(
                    // row align top 하는거
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 25, left: 5),
                        width: MediaQuery.of(context).size.width * 0.22,
                        height: MediaQuery.of(context).size.height * 0.1,
                        //decoration: BoxDecoration(border: Border.all()),
                        child: Padding(
                          padding: EdgeInsets.only(top: 20.0),
                          child: Image.network(
                            reviewInfoList[position]['place_url'],
                            width: MediaQuery.of(context).size.width * 0.22,
                            height: MediaQuery.of(context).size.height * 0.1,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 1.5),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 20.0, left: 6, bottom: 13),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                reviewInfoList[position]['place_name'],
                                style: TextStyle(
                                  fontFamily: "nanumB",
                                  fontWeight: FontWeight.w900,
                                  fontSize: 17.0,
                                ),
                              ),
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width * 0.34,
                                padding: EdgeInsets.only(left: 6),
                                child: Text(
                                    "${reviewInfoList[position]['order']}",
                                    //'1111111111111111111111111111111111111111111111111111111111111111111',
                                    maxLines: 3,
                                    style: TextStyle(
                                      fontFamily: "nanumR",
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                    )),
                              )
                            ],
                          ),
                        ],
                      ),

                      Spacer(),
                      reviewInfoList[position]['review'] == "Y"
                          ? Align(
                              alignment: Alignment.topRight,
                              child: Padding(
                                padding: EdgeInsets.only(top: 20, right: 0.5),
                                child: Container(
                                  width: 35,
                                  height: 12.5,
                                  decoration: BoxDecoration(
                                    color: Colors.amberAccent,
                                    border: Border.all(
                                      color: Colors.amberAccent,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            5.0) //                 <--- border radius here
                                        ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 2),
                                    child: Text(
                                      '리뷰완료',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: "nanumR",
                                        fontWeight: FontWeight.w800,
                                        fontSize: 7.3,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Align(
                              alignment: Alignment.topRight, child: Text("")),
                      Padding(
                        padding: const EdgeInsets.only(top: 20, right: 8),
                        child: Text(
                          ' ${showDate}',
                          style: TextStyle(
                            fontFamily: "nanumR",
                            fontWeight: FontWeight.w800,
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                      //InkWell(onTap: delete, child: Text("삭제")),
                    ],
                  ),

                  Spacer(),
                  Row(
                    children: [
                      Spacer(),
                      //FlatButton

                      Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            width: 73,
                            child: FlatButton(
                              color: Colors.white,
                              onPressed: () {
                                setState(() {
                                  _handleURLButtonPress(
                                      context,
                                      '${webviewDefault}/shopTmplatView.do',
                                      reviewInfoList[position]['place_name']);
                                });
                              },
                              child: Text('재주문',
                                  style: TextStyle(
                                    fontFamily: "nanumR",
                                    fontSize: 13,
                                    fontWeight: FontWeight.w900,
                                  )),
                              textColor: Colors.black,
                            ),
                          )),
                      reviewInfoList[position]['review'] == "Y"
                          ? Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                width: 93,
                                child: FlatButton(
                                  color: Colors.white,
                                  onPressed: () {
                                    if (reviewInfoList[position]
                                            ['review_picture'] ==
                                        "")
                                      _showOnlyReviewDialog(
                                          showDate,
                                          reviewInfoList[position]['place_url'],
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
                                        fontSize: 13,
                                        fontWeight: FontWeight.w900,
                                      )),
                                  textColor: Colors.black,
                                ),
                              ),
                            )
                          : Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                width: 93,
                                child: FlatButton(
                                  color: Colors.white,
                                  onPressed: () {
                                    setState(() {
                                      writingReview(
                                        reviewInfoList[position]['shopId'],
                                        reviewInfoList[position]['place_name'],
                                        reviewInfoList[position]['order'],
                                        reviewInfoList[position]['userId'],
                                      );
                                    });
                                  },
                                  child: Text('리뷰 쓰기',
                                      style: TextStyle(
                                        fontFamily: "nanumR",
                                        fontSize: 13,
                                        fontWeight: FontWeight.w900,
                                      )),
                                  textColor: Colors.black,
                                ),
                              ),
                            ),
                    ],
                  ),
                ],
              ),
            ),
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
