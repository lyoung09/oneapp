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

class UsageHistory extends StatefulWidget {
  @override
  _UsageHistoryState createState() => _UsageHistoryState();
}

class _UsageHistoryState extends State<UsageHistory> {
  String webviewDefault = 'http://192.168.0.47:8080/usermngr';
  var userId = "112";
  String date, year, month, day;
  @override
  initState() {
    super.initState();
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
    reviewInfoList
        .sort((b, a) => int.parse(a['date']).compareTo(int.parse(b['date'])));

    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: reviewInfoList.length == null ? 0 : reviewInfoList.length,
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

          return reviewInfoList[position]['review'] == "Y"
              ? Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Column(
                    children: [
                      GFCard(
                        // boxFit: BoxFit.cover,
                        titlePosition: GFPosition.start,
                        image: reviewInfoList[position]['review_picture'] == ""
                            ? null
                            : Image.network(
                                reviewInfoList[position]['review_picture'],
                                height: 120,
                                width: 400,
                                fit: BoxFit.fitWidth,
                              ),
                        title: GFListTile(
                          avatar: GFAvatar(
                            backgroundImage: NetworkImage(
                                reviewInfoList[position]['place_url']),
                            backgroundColor: Colors.white,
                          ),
                          title: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.baseline,
                                    textBaseline: TextBaseline.alphabetic,
                                    children: <Widget>[
                                      Text(
                                        reviewInfoList[position]['place_name'],
                                        style: TextStyle(
                                          fontFamily: "nanumB",
                                          fontWeight: FontWeight.w800,
                                          fontSize: 18.0,
                                        ),
                                      ),
                                      Text(
                                        '   ${showDate}',
                                        style: TextStyle(
                                          fontFamily: "nanumR",
                                          fontWeight: FontWeight.w300,
                                          fontSize: 8.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 8),
                                  ),
                                  Text(
                                    '주문 내역: ${reviewInfoList[position]['order']}',
                                    style: TextStyle(
                                      fontFamily: "nanumB",
                                      fontWeight: FontWeight.w800,
                                      fontSize: 12.0,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 3),
                                  ),
                                ],
                              ),

                              //InkWell(onTap: delete, child: Text("삭제")),
                            ],
                          ),
                        ),

                        buttonBar: GFButtonBar(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, top: 3.0),
                                child: Text(
                                  '${reviewInfoList[position]['story']}',
                                  style: TextStyle(
                                    fontFamily: "nanumR",
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12.0,
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GFButton(
                                  color: Colors.white,
                                  onPressed: () {
                                    setState(() {
                                      _handleURLButtonPress(
                                          context,
                                          '${webviewDefault}/shopTmplatView.do',
                                          reviewInfoList[position]
                                              ['place_name']);
                                    });
                                  },
                                  text: '재주문',
                                  textColor: Colors.black,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: 5),
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
                  padding: const EdgeInsets.only(left: 1.5, bottom: 5),
                  child: Column(
                    children: [
                      GFCard(
                        // boxFit: BoxFit.cover,
                        title: GFListTile(
                          avatar: GFAvatar(
                            backgroundImage: NetworkImage(
                                reviewInfoList[position]['place_url']),
                            backgroundColor: Colors.white,
                          ),
                          title: Align(
                            alignment: Alignment.topLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  reviewInfoList[position]['place_name'],
                                  style: TextStyle(
                                    fontFamily: "nanumB",
                                    fontWeight: FontWeight.w800,
                                    fontSize: 18.0,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 8),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 8),
                                ),
                                Text(
                                  '주문 내역: ${reviewInfoList[position]['order']}',
                                  style: TextStyle(
                                    fontFamily: "nanumB",
                                    fontWeight: FontWeight.w800,
                                    fontSize: 12.0,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 3),
                                ),
                              ],
                            ),
                          ),
                        ),

                        buttonBar: GFButtonBar(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      "ㅇ",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    GFButton(
                                      color: Colors.white,
                                      onPressed: () {
                                        setState(() {
                                          _handleURLButtonPress(
                                              context,
                                              '${webviewDefault}/shopTmplatView.do',
                                              reviewInfoList[position]
                                                  ['place_name']);
                                        });
                                      },
                                      text: '재주문',
                                      textColor: Colors.black,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(right: 5),
                                    )
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(compareDate > 30 && compareDate < 365
                                        ? '${(compareDate / 30).toStringAsFixed(0)}달 전'
                                        : compareDate >= 365
                                            ? '${(compareDate / 365).toStringAsFixed(0)}년 전'
                                            : '${compareDate}일 전'),
                                    GFButton(
                                      color: Colors.white,
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
                                      text: '리뷰 쓰기',
                                      textColor: Colors.black,
                                    ),
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

  Future<Map<String, dynamic>> getReview() async {
    return user.getMyReviewList();
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

              return _usageCard(reviewInfoList);
            }));
  }
}
