import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:wellhada_oneapp/UI/main/home_detail/webview.dart';
import 'package:wellhada_oneapp/listitem/user/user.dart' as user;

class MyReview extends StatefulWidget {
  @override
  _MyReviewState createState() => _MyReviewState();
}

class _MyReviewState extends State<MyReview> {
  String webviewDefault = 'http://192.168.0.47:8080/usermngr';
  var userId = "112";
  String date, year, month, day;
  delete() {
    print('delete');
    String a = "1234567890";

    print(a.substring(3, 5));
  }

  Future<Map<String, dynamic>> getReview() async {
    return user.getMyReviewList();
  }

  void _handleURLButtonPress(
      BuildContext context, String url, String placeName) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WebViewContainer(url, placeName)));

    // Navigator.pushNamed(context, '/webview');
  }

  Widget _practice(reviewInfoList) {
    reviewInfoList
        .sort((a, b) => int.parse(a['date']).compareTo(int.parse(b['date'])));

    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: reviewInfoList.length == null ? 0 : reviewInfoList.length,
        itemBuilder: (context, position) {
          date = reviewInfoList[position]['date'];
          year = date.substring(0, 4);
          month = date.substring(4, 6);
          day = date.substring(6, 8);

          String showDate = '${year}년 ${month}월 ${day}일';

          return Padding(
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
                      backgroundImage:
                          NetworkImage(reviewInfoList[position]['place_url']),
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
                                  reviewInfoList[position].placeName);
                            });
                          },
                          child: Text(
                            reviewInfoList[position]['place_name'],
                            style: TextStyle(
                              fontFamily: "nanumB",
                              fontWeight: FontWeight.w800,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                        Spacer(),
                        //InkWell(onTap: delete, child: Text("삭제")),
                      ],
                    ),
                    subtitle: Row(
                      children: [
                        Text("<주문완료>",
                            style: TextStyle(
                              fontFamily: "nanumR",
                              fontWeight: FontWeight.w500,
                              fontSize: 9.0,
                            )),
                        Padding(
                          padding: EdgeInsets.only(right: 4),
                        ),
                        Text(
                          '${showDate}',
                          style: TextStyle(
                            fontFamily: "nanumR",
                            fontWeight: FontWeight.w500,
                            fontSize: 12.0,
                          ),
                        ),
                      ],
                    ),
                  ),

                  buttonBar: GFButtonBar(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 3.0),
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
                          Column(
                            children: [
                              Text(
                                "ㅇ",
                                style: TextStyle(color: Colors.white),
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
                      element['review'] == "Y")
                  .toList();

              return _practice(reviewInfoList);
            }));
  }
}
