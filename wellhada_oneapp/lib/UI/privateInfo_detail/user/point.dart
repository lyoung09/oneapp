import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wellhada_oneapp/listitem/user/user.dart' as user;

class UsagePoint extends StatefulWidget {
  @override
  _UsagePointState createState() => _UsagePointState();
}

class _UsagePointState extends State<UsagePoint> {
  List point;
  var usage;
  var userPoint;
  initState() {
    super.initState();
    checkUserPoint();
    getPoint();
  }

  checkUserPoint() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final shopList = await user.getUsagePointEntire();
    setState(() {
      userPoint = prefs.getString("userPoint");
      point = shopList.list;
    });
  }

  Future<Map<String, dynamic>> getPoint() async {
    return user.getUsagePointList();
  }

  Widget _card(pointInfoList) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: pointInfoList.length == null ? null : pointInfoList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(3.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.12,
              child: InkWell(
                onTap: () {
                  pointInfoList[index]['usingPoint'] == 'Y'
                      ? usage = "적립"
                      : usage = "사용";
                  showDialog(
                      context: context,
                      builder: (_) => CupertinoAlertDialog(
                            title: Text('영수증'),
                            content: Text(
                                ' \n\n\n날짜 : ${pointInfoList[index]['date_time']}\n\n가게 : ${pointInfoList[index]['place_name']}\n\n주문 내역: ${pointInfoList[index]['order']}\n\n포인트: ${pointInfoList[index]['point']} (${usage})\n'),
                            actions: <Widget>[
                              CupertinoDialogAction(
                                  child: Text('확인'),
                                  onPressed: () => Navigator.of(context).pop()),
                            ],
                          ));
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      pointInfoList[index]['usingPoint'] == 'Y'
                          ? Text(
                              " 적립",
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                fontSize: 21.0,
                                fontFamily: "nanumB",
                                fontWeight: FontWeight.w800,
                              ),
                            )
                          : Text(
                              "사용",
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                fontSize: 21.0,
                                fontFamily: "nanumB",
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "${pointInfoList[index]['date_time']}",
                                    style: TextStyle(
                                        fontSize: 11.0,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 15),
                              ),
                              Text(
                                pointInfoList[index]['place_name'].length > 8
                                    ? "${pointInfoList[index]['place_name'].substring(0, 6)}..."
                                    : "${pointInfoList[index]['place_name']}",
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w800),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "${pointInfoList[index]['order']}",
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      pointInfoList[index]['usingPoint'] == 'Y'
                          ? Text(
                              " + ${pointInfoList[index]['point']} Point",
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                fontSize: 21.0,
                                fontFamily: "nanumR",
                                fontWeight: FontWeight.w800,
                              ),
                            )
                          : Text(
                              "- ${pointInfoList[index]['point']} Point",
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                fontSize: 21.0,
                                fontFamily: "nanumR",
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            future: getPoint(),
            builder: (context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CupertinoActivityIndicator());
              }

              Map<String, dynamic> pointInfo = snapshot.data;
              List<dynamic> pointInfoList = pointInfo["LIST"];

              return Stack(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                  ),
                  Positioned(
                    top: 10.0,
                    left: -40.0,
                    child: Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                          color: Colors.amberAccent, shape: BoxShape.circle),
                    ),
                  ),
                  Container(
                    child: Column(children: [
                      Padding(
                        padding: EdgeInsets.only(top: 80.0, left: 45),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            "포인트 내역",
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              fontFamily: "nanumB",
                              fontWeight: FontWeight.w800,
                              fontSize: 25.0,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0, bottom: 20),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text("${userPoint}p",
                              style: TextStyle(
                                  fontSize: 30.0, fontWeight: FontWeight.w900)),
                        ),
                      ),
                      Expanded(child: _card(pointInfoList))
                    ]),
                  ),
                ],
              );
            }));
  }
}
