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

  @override
  initState() {
    super.initState();
  }

  writingReview(shopId, shopName, order, userId) async {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => new Review(shopId, shopName, order, userId)));
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
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: reviewInfoList.length == null ? 0 : reviewInfoList.length,
        itemBuilder: (context, position) {
          var date = reviewInfoList[position]['date'];

          DateTime now = DateTime.now();

//          var orderDate = DateFormat('yyyyMMMMd').parse(date);
          var orderDate = DateTime.parse(date);

          var compareDate = now.difference(orderDate).inDays;

          return Padding(
            padding: const EdgeInsets.only(left: 3.0, right: 3.0),
            child: Column(
              children: [
                GFCard(
                  // boxFit: BoxFit.cover,
                  titlePosition: GFPosition.start,
                  image: Image.network(
                    reviewInfoList[position]['place_url'],
                    height: 120,
                    width: 400,
                    fit: BoxFit.fitWidth,
                  ),
                  title: GFListTile(
                    title: InkWell(
                      onTap: () {
                        setState(() {
                          _handleURLButtonPress(
                              context,
                              '${webviewDefault}/shopTmplatView.do',
                              reviewInfoList[position].placeName);
                        });
                      },
                      child: Text(
                        reviewInfoList[position]['place_name'],
                        style: TextStyle(
                          fontFamily: "Sans",
                          fontWeight: FontWeight.w800,
                          fontSize: 18.0,
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
                              '${reviewInfoList[position]['order']}',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontFamily: "Sans",
                                fontWeight: FontWeight.w400,
                                fontSize: 12.0,
                              ),
                            ),
                          )),
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
                                onPressed: () {},
                                text: '재주문',
                                textColor: Colors.black,
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text('${compareDate}일 전'),
                              GFButton(
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
          actions: <Widget>[
            FlatButton(
              onPressed: myReview,
              child: Text(
                "내 리뷰",
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            )
          ],
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
                      element['using'] == "Y" &&
                      userId == element['userId'] &&
                      element['review'] == "N")
                  .toList();

              return _usageCard(reviewInfoList);
            }));
  }
}
