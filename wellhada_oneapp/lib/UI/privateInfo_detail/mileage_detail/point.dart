// @dart=2.9
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wellhada_oneapp/listitem/shop/orderList.dart' as orderList;

class UsagePoint extends StatefulWidget {
  final userId;
  final userName;

  UsagePoint(this.userId, this.userName);

  @override
  _UsagePointState createState() =>
      _UsagePointState(this.userId, this.userName);
}

class _UsagePointState extends State<UsagePoint> {
  List point;
  var usage;
  var userPoint;
  String userId;
  String userName;
  var futurePoint;
  int _value = 1;
  _UsagePointState(this.userId, this.userName);

  initState() {
    super.initState();
    print(userId);

    futurePoint = getPoint(userId);
  }

  // checkUserPoint() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();

  //   final shopList = await userPoint.getUsagePointEntire();
  //   setState(() {
  //     point = shopList.list;
  //   });
  // }

  Future<Map<String, dynamic>> getPoint(userId) async {
    return orderList.getPointHistory(userId);
  }

  Widget _card(pointInfoList) {
    if (_value == 1) {
    } else if (_value == 2) {
      pointInfoList =
          pointInfoList.where((element) => element['USE_TYPE'] == "U").toList();
    } else if (_value == 3) {
      pointInfoList =
          pointInfoList.where((element) => element['USE_TYPE'] == "S").toList();
    }

    return ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: pointInfoList.length == null ? null : pointInfoList.length,
        itemBuilder: (context, index) {
          var date;

          pointInfoList[index]['REG_DATE'] != null
              ? date = pointInfoList[index]['REG_DATE'].substring(0, 11)
              : date = "";
          print(pointInfoList[index]['REG_DATE']);
          return Padding(
            padding: const EdgeInsets.all(3.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.13,
              child: InkWell(
                onTap: () {
                  pointInfoList[index]['USE_TYPE'] == 'S'
                      ? usage = "적립"
                      : usage = "사용";
                  showDialog(
                      context: context,
                      builder: (_) => CupertinoAlertDialog(
                            title: Text('영수증'),
                            content: Text(
                                ' \n\n\n날짜 : ${pointInfoList[index]['REG_DATE']}\n\n가게 : ${pointInfoList[index]['SHOP_NAME']}\n\n포인트: ${pointInfoList[index]['POINT_PRICE']} (${usage})\n'),
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
                      Column(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: EdgeInsets.only(top: 8, left: 3),
                              child: Text(
                                '날짜 : ${date}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontFamily: "nanumB",
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                          ),
                          Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: EdgeInsets.only(left: 15.0),
                                child: Text(
                                  //"포인트포인트포인트트트트\n포인트포인트포인트트트트",
                                  pointInfoList[index]['SHOP_NAME'].length > 12
                                      ? "${pointInfoList[index]['SHOP_NAME'].substring(0, 12)}\n${pointInfoList[index]['SHOP_NAME'].substring(12, pointInfoList[index]['SHOP_NAME'].length)}"
                                      : "${pointInfoList[index]['SHOP_NAME']}",
                                  maxLines: 2,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: Colors.grey[900],
                                    fontSize: 18.0,
                                    fontFamily: "nanumB",
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              )),
                        ],
                      ),
                      Spacer(),
                      pointInfoList[index]['USE_TYPE'] == 'S'
                          ? Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: MediaQuery.of(context).size.height *
                                          0.03),
                                ),
                                Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    Text(
                                      " + ${pointInfoList[index]['POINT_PRICE']}",
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                        fontSize: 19.0,
                                        fontFamily: "nanumR",
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(right: 5.0),
                                      child: pointInfoList[index]
                                                  ['POINT_TYPE'] ==
                                              "P"
                                          ? Text(
                                              "p",
                                              textAlign: TextAlign.end,
                                              style: TextStyle(
                                                fontSize: 19.0,
                                                fontFamily: "nanumR",
                                                fontWeight: FontWeight.w800,
                                              ),
                                            )
                                          : Text(
                                              "원",
                                              textAlign: TextAlign.end,
                                              style: TextStyle(
                                                fontSize: 19.0,
                                                fontFamily: "nanumR",
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: MediaQuery.of(context).size.height *
                                          0.01),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    "(${pointInfoList[index]['POINT_TITLE']})",
                                    maxLines: 3,
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w800),
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: MediaQuery.of(context).size.height *
                                          0.03),
                                ),
                                Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    Text(
                                      " - ${pointInfoList[index]['POINT_PRICE']}",
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                        fontSize: 19.0,
                                        fontFamily: "nanumR",
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(right: 5.0),
                                      child: pointInfoList[index]
                                                  ['POINT_TYPE'] ==
                                              "P"
                                          ? Text(
                                              "p",
                                              textAlign: TextAlign.end,
                                              style: TextStyle(
                                                fontSize: 19.0,
                                                fontFamily: "nanumR",
                                                fontWeight: FontWeight.w800,
                                              ),
                                            )
                                          : Text(
                                              "원",
                                              textAlign: TextAlign.end,
                                              style: TextStyle(
                                                fontSize: 19.0,
                                                fontFamily: "nanumR",
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: MediaQuery.of(context).size.height *
                                          0.01),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    "(${pointInfoList[index]['POINT_TITLE']})",
                                    maxLines: 3,
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w800),
                                  ),
                                ),
                              ],
                            ),

                      // Container(
                      //     padding: EdgeInsets.only(
                      //         left: 5,
                      //         top: MediaQuery.of(context).size.height * 0.01),
                      //     width: MediaQuery.of(context).size.width * 0.25,
                      //     child: Align(
                      //       alignment: Alignment.centerLeft,
                      //       child: Text(
                      //         pointInfoList[index]['POINT_TITLE'],
                      //         maxLines: 3,
                      //         style:
                      //          TextStyle(
                      //                     fontSize: 15.0,
                      //                     fontWeight: FontWeight.w800),
                      //       ),
                      //     )),
                      Padding(
                        padding: EdgeInsets.only(right: 8),
                      )
                    ],
                  ),
                ),
              ),
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
        body: FutureBuilder(
            future: futurePoint,
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
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.1,
                            left: 45),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.06,
                              top: 15),
                          child: Text(
                            "포인트 내역",
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              fontFamily: "nanumB",
                              fontWeight: FontWeight.w900,
                              fontSize: 28.0,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).size.height * 0.04),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Spacer(),
                          Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: Text("${userName}님 포인트:",
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w900))),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                    pointInfo["SUM"] == null ||
                                            pointInfo["SUM"] == ""
                                        ? "0p"
                                        : "${pointInfo["SUM"]}p",
                                    style: TextStyle(
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.w900)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.02),
                      ),
                      pointInfoList == null || pointInfoList.isEmpty
                          ? Text("")
                          : Padding(
                              padding: const EdgeInsets.only(right: 15.0),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                    padding: EdgeInsets.only(left: 5),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
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
                                            child: Text("사용"),
                                            value: 2,
                                          ),
                                          DropdownMenuItem(
                                              child: Text("적립"), value: 3),
                                        ],
                                        onChanged: (value) {
                                          setState(() {
                                            _value = value;
                                          });
                                        })),
                              ),
                            ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.01,
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.only(right: 10.0),
                      //   child: Align(
                      //     alignment: Alignment.centerRight,
                      //     child: Text("${pointInfo["SUM"]}p",
                      //         style: TextStyle(
                      //             fontSize: 30.0, fontWeight: FontWeight.w900)),
                      //   ),
                      // ),

                      Expanded(
                          child: pointInfoList == null || pointInfoList.isEmpty
                              ? noData()
                              : _card(pointInfoList))
                    ]),
                  ),
                ],
              );
            }));
  }
}
