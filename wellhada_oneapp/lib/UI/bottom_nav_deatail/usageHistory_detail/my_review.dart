// @dart=2.9
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:wellhada_oneapp/listitem/userFile/userList.dart' as user;
import 'package:wellhada_oneapp/listitem/shop/orderList.dart' as orderList;

class MyReview extends StatefulWidget {
  var userId;

  MyReview(this.userId);
  @override
  _MyReviewState createState() => _MyReviewState(userId);
}

class _MyReviewState extends State<MyReview> {
  String webviewDefault = 'http://hndsolution.iptime.org:8086/usermngr';
  var userId, userChk;

  String date, year, month, day;

  var orderFuture;
  _MyReviewState(this.userId);

  @override
  initState() {
    super.initState();
    check();
  }

  delete(userId) async {
    final deleteReview = await orderList.deleteReview(userId, 12);

    if (this.mounted) {
      setState(() {
        print('delete ============================${deleteReview.cnt}');
      });
    }
  }

  check() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userPassword = prefs.getString("userPasswordGoweb");
      userChk = prefs.getString("userChk") ?? "O";
      if (userChk == "01") {
        userChk = "E";
      }
      if (userChk == "00") {
        userChk = "K";
      }
    });
  }

  getOrderUsageHistory() async {
    return orderList.getOrderHistory(userId);
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

    // Navigator.pushNamed(context, '/webview');
  }

  Widget _practice(reviewInfoList) {
    reviewInfoList.sort((a, b) =>
        int.parse(a['RESERVE_DATE']).compareTo(int.parse(b['RESERVE_DATE'])));

    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: reviewInfoList.length == null ? 0 : reviewInfoList.length,
        itemBuilder: (context, position) {
          date = reviewInfoList[position]['RESERVE_DATE'];
          year = date.substring(0, 4);
          month = date.substring(4, 6);
          day = date.substring(6, 8);

          String showDate = '${year}년 ${month}월 ${day}일';

          return reviewInfoList[position]['REVIEW_IMG_URL'] == "" ||
                  reviewInfoList[position]['REVIEW_IMG_URL'] == null
              ? Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Column(
                    children: [
                      GFCard(
                        // boxFit: BoxFit.cover,
                        titlePosition: GFPosition.start,
                        title: GFListTile(
                          avatar: GFAvatar(
                            backgroundImage: NetworkImage(
                                'http://hndsolution.iptime.org:8086${reviewInfoList[position]['FILE_URL']}'),
                            backgroundColor: Colors.white,
                          ),
                          title: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    _handleURLButtonPress(
                                        context,
                                        '${webviewDefault}/shopTmplatView.do',
                                        reviewInfoList[position]['SHOP_NAME'],
                                        reviewInfoList[position]['SHOP_SEQ'],
                                        userId);
                                  });
                                },
                                child: Text(
                                  reviewInfoList[position]['SHOP_NAME'],
                                  style: TextStyle(
                                    fontFamily: "nanumB",
                                    fontWeight: FontWeight.w800,
                                    fontSize: 18.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(
                                top: 3, bottom: 3, left: 3),
                            child: Text(
                              '${showDate}',
                              style: TextStyle(
                                fontFamily: "nanumR",
                                fontWeight: FontWeight.w500,
                                fontSize: 11.0,
                              ),
                            ),
                          ),
                        ),

                        buttonBar: GFButtonBar(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 3.0),
                                child: Text(
                                  '${reviewInfoList[position]['REVIEW_COMMENT']}',
                                  //"아아아아아아아아아아아아아아아아아아아아아아아아아아아아아아아아아아아아아아아아아아아아아아아아아아아아아아아아아아아아아아아아아아아아아아아아아아아아아아아아아아아아아아아아아아아아아아아아",
                                  style: TextStyle(
                                    fontFamily: "nanumR",
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Column(
                                  children: [
                                    Align(
                                        alignment: Alignment.topRight,
                                        child: InkWell(
                                          onTap: () {
                                            delete(userId);
                                          },
                                          child: Icon(
                                            Icons.delete,
                                          ),
                                        )),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Column(
                    children: [
                      GFCard(
                        // boxFit: BoxFit.cover,
                        titlePosition: GFPosition.start,
                        image: Image.network(
                          'http://hndsolution.iptime.org:8086${reviewInfoList[position]['REVIEW_IMG_URL']}',
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: MediaQuery.of(context).size.height * 0.3,
                        ),
                        title: GFListTile(
                          avatar: GFAvatar(
                            backgroundImage: NetworkImage(
                                'http://hndsolution.iptime.org:8086${reviewInfoList[position]['FILE_URL']}'),
                            backgroundColor: Colors.white,
                          ),
                          title: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    _handleURLButtonPress(
                                        context,
                                        '${webviewDefault}/shopTmplatView.do',
                                        reviewInfoList[position]['SHOP_NAME'],
                                        reviewInfoList[position]['SHOP_SEQ'],
                                        userId);
                                  });
                                },
                                child: Text(
                                  reviewInfoList[position]['SHOP_NAME'],
                                  style: TextStyle(
                                    fontFamily: "nanumB",
                                    fontWeight: FontWeight.w800,
                                    fontSize: 18.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(
                                top: 3, bottom: 3, left: 3),
                            child: Text(
                              '${showDate}',
                              style: TextStyle(
                                fontFamily: "nanumR",
                                fontWeight: FontWeight.w500,
                                fontSize: 11.0,
                              ),
                            ),
                          ),
                        ),

                        buttonBar: GFButtonBar(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 3.0),
                                child: Text(
                                  '${reviewInfoList[position]['REVIEW_COMMENT']}',
                                  style: TextStyle(
                                    fontFamily: "nanumR",
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Column(
                                  children: [
                                    Align(
                                        alignment: Alignment.topRight,
                                        child: InkWell(
                                          onTap: () {
                                            delete(userId);
                                          },
                                          child: Icon(
                                            Icons.delete,
                                          ),
                                        )),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
        });
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
          title: Text(
            "내 리뷰",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
          ),
        ),
        body: FutureBuilder(
            future: getOrderUsageHistory(),
            builder: (context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CupertinoActivityIndicator());
              }

              Map<String, dynamic> reviewInfo = snapshot.data;
              print('reviewInfo : ${reviewInfo}');
              if (reviewInfo["LIST"].isEmpty || reviewInfo["LIST"] == "") {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Image.asset('assets/icon/noImage.png'),
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 10)),
                    Text(
                      "작성하신 리뷰가 없어요",
                      style: TextStyle(
                        fontFamily: "nanumB",
                        fontWeight: FontWeight.w800,
                        fontSize: 18.0,
                      ),
                    )
                  ],
                );
              }

              List<dynamic> reviewInfoList = reviewInfo["LIST"];
              print('reviewInfoList : ${reviewInfoList}');
              reviewInfoList = reviewInfoList
                  .where((element) => element['REVIEW_YN'] == "Y")
                  .toList();

              return reviewInfoList == null
                  ? noData()
                  : _practice(reviewInfoList);
            }));
  }
}
