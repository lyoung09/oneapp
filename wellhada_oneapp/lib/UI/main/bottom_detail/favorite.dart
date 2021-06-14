// @dart=2.9
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wellhada_oneapp/UI/main/bottom_nav.dart';
import 'package:wellhada_oneapp/UI/main/home_detail/webview.dart';
import 'package:wellhada_oneapp/UI/privateInfo_detail/email_login/extraLogin.dart';
import 'package:wellhada_oneapp/UI/privateInfo_detail/login.dart';
import 'package:wellhada_oneapp/listitem/shop/shopFavorite.dart' as favorite;
import 'package:slide_popup_dialog/slide_popup_dialog.dart' as slideDialog;
import 'package:wellhada_oneapp/listitem/userFile/userList.dart' as user;
import 'package:overlay_container/overlay_container.dart';
import 'package:wellhada_oneapp/listitem/shop/shopInfoListItem.dart'
    as shopInfoListItem;

class Favorite extends StatefulWidget {
  @override
  _FavoriteState createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  List favoriteList;
  var allFavorite;
  String webviewDefault = 'http://hndsolution.iptime.org:8086/usermngr';
  var userId, userPassword, userChk;
  var userName;
  bool opening;
  var favoriteFuture;
  Map<int, bool> dayOpenShop = new Map();
  Map<int, bool> openShopSeq = new Map();
  void initState() {
    super.initState();
    getShopCategory();
    check();
  }

  void check() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        userId = prefs.getString("userKey");
        userName = prefs.getString("userName");
        userPassword = prefs.getString("userPasswordGoweb");
        userChk = prefs.getString("userChk");

        if (userChk == "01") {
          userChk = "E";
        }
        if (userChk == "00") {
          userChk = "K";
        }
      });
      print('favorite ${userChk}');
      favoriteFuture = getFavorite(userId);
    } catch (e) {
      noData();
      print(e);
    }
  }

  getFavorite(userId) async {
    if (userId == null || userId == "") {
      return "hoit";
    } else {
      return favorite.getFavorite(userId);
    }
  }

  void _handleURLButtonPress(BuildContext context, String url, String placeName,
      int userSeq, String userId, String userChk) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WebViewContainer(
                placeName, userSeq, userId, userPassword, userChk, "2")));

    // Navigator.pushNamed(context, '/webview');
  }

  List<String> saveFav = List<String>();

  insertFavorite(userId, shopSeq) async {
    final saveFavorite = await favorite.saveFavoriteShop(userId, shopSeq);
    if (this.mounted) {
      setState(() {
        print('save ============================${saveFavorite.cnt}');
      });
    }
  }

  deleteFavorite(userId, shopSeq) async {
    final deleteFavorite = await favorite.deleteFavoriteShop(userId, shopSeq);

    if (this.mounted) {
      setState(() {
        print('delete ============================${deleteFavorite.cnt}');
      });
    }
  }

  userDataCheck(placeName, shopSeq) async {
    // final webLoginData =
    //     await webLogin.loginWebUser(userKey, userPassword, userChk);

    _handleURLButtonPress(context, '${webviewDefault}/shopTmplatView.do',
        placeName, shopSeq, userId, userChk);
  }

  var categoryCd;
  Future<Map<String, dynamic>> getShopCategory() async {
    setState(() {
      categoryCd = shopInfoListItem.getShopCodeList();
    });
    return shopInfoListItem.getShopCodeList();
  }

  //가게 열었는지 여부
  double toDouble(TimeOfDay myTime) {
    return myTime.hour + myTime.minute / 60.0;
  }

  openingShop(startTime, endTime, int shopId) async {
    setState(() {
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
    });
  }

  // void _showShopListDialog(
  //     String address,
  //     String pic,
  //     String placeName,
  //     String shopDc,
  //     String beginWeek,
  //     String endWeek,
  //     String beginWeekend,
  //     String endWeekend,
  //     int shopSeq) {
  //   var a = '${beginWeek.substring(0, 2)}시 ${beginWeek.substring(2, 4)}분 ~';
  //   var b = ' ${endWeek.substring(0, 2)}시 ${endWeek.substring(2, 4)}분까지';
  //   var c =
  //       '${beginWeekend.substring(0, 2)}시 ${beginWeekend.substring(2, 4)}분 ~';
  //   var d = ' ${endWeekend.substring(0, 2)}시 ${endWeekend.substring(2, 4)}분까지';

  //   slideDialog.showSlideDialog(
  //     context: context,
  //     child: Expanded(
  //       child: SingleChildScrollView(
  //         child: Column(
  //           children: [
  //             Container(
  //               child: InkWell(
  //                 onTap: () {
  //                   setState(() {
  //                     userDataCheck(placeName, shopSeq);
  //                   });
  //                 },
  //                 child: Column(
  //                   children: <Widget>[
  //                     Row(
  //                       crossAxisAlignment: CrossAxisAlignment.end,
  //                       textBaseline: TextBaseline.alphabetic,
  //                       children: [
  //                         Padding(
  //                             padding: EdgeInsets.only(left: 15),
  //                             child: Text(
  //                               placeName.length >= 8
  //                                   ? "${placeName.substring(0, 8)}"
  //                                   : "${placeName}",
  //                               //"이이이이이이이이",
  //                               style: TextStyle(
  //                                 fontFamily: "nanumB",
  //                                 fontWeight: FontWeight.w900,
  //                                 fontSize: 18.0,
  //                               ),
  //                             )),
  //                         Spacer(),
  //                         Align(
  //                           alignment: Alignment.centerRight,
  //                           child: Padding(
  //                             padding: EdgeInsets.only(bottom: 10.0, right: 5),
  //                             child: Text(
  //                               "평일:",
  //                               style: TextStyle(
  //                                 fontFamily: "nanumB",
  //                                 fontWeight: FontWeight.w900,
  //                                 fontSize: 13.0,
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                         Align(
  //                             alignment: Alignment.centerRight,
  //                             child: Padding(
  //                               padding:
  //                                   EdgeInsets.only(bottom: 10.0, right: 5),
  //                               child: Text(
  //                                 a + b,
  //                                 style: TextStyle(
  //                                   fontFamily: "nanumR",
  //                                   fontWeight: FontWeight.w600,
  //                                   fontSize: 11.0,
  //                                 ),
  //                               ),
  //                             )),
  //                         Padding(
  //                           padding: EdgeInsets.only(right: 5),
  //                         )
  //                       ],
  //                     ),
  //                     Row(
  //                       crossAxisAlignment: CrossAxisAlignment.end,
  //                       textBaseline: TextBaseline.alphabetic,
  //                       children: [
  //                         Spacer(),
  //                         Align(
  //                           alignment: Alignment.centerRight,
  //                           child: Padding(
  //                             padding: EdgeInsets.only(bottom: 10.0, right: 5),
  //                             child: Text(
  //                               "주말:",
  //                               style: TextStyle(
  //                                 fontFamily: "nanumB",
  //                                 fontWeight: FontWeight.w900,
  //                                 fontSize: 13.0,
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                         Align(
  //                             alignment: Alignment.centerRight,
  //                             child: Padding(
  //                               padding:
  //                                   EdgeInsets.only(bottom: 10.0, right: 5),
  //                               child: Text(
  //                                 c + d,
  //                                 style: TextStyle(
  //                                   fontFamily: "nanumR",
  //                                   fontWeight: FontWeight.w600,
  //                                   fontSize: 11.0,
  //                                 ),
  //                               ),
  //                             )),
  //                         Padding(
  //                           padding: EdgeInsets.only(right: 5),
  //                         )
  //                       ],
  //                     ),
  //                     Container(
  //                       padding: EdgeInsets.only(left: 20.0, bottom: 5.0),
  //                     ),
  //                     Row(
  //                       crossAxisAlignment: CrossAxisAlignment.end,
  //                       textBaseline: TextBaseline.alphabetic,
  //                       children: [
  //                         Padding(
  //                           padding: EdgeInsets.only(left: 20, right: 5),
  //                           child: Text(
  //                             address.length > 20
  //                                 ? '${address.substring(0, 20)}'
  //                                 : address,

  //                             // '${distance}m',
  //                             style: TextStyle(
  //                               fontFamily: "nanumR",
  //                               fontWeight: FontWeight.w600,
  //                               fontSize: 12,
  //                             ),
  //                           ),
  //                         )
  //                       ],
  //                     ),
  //                     Container(
  //                       padding: EdgeInsets.only(left: 12.0, bottom: 10.0),
  //                     ),
  //                     Padding(
  //                         padding: const EdgeInsets.only(left: 5.0, right: 5),
  //                         child: Container(
  //                           padding: EdgeInsets.only(top: 5),
  //                           //decoration: BoxDecoration(border: Border.all()),
  //                           width: MediaQuery.of(context).size.width * 0.8,
  //                           height: MediaQuery.of(context).size.height * 0.3,
  //                           child: Image.network(
  //                             'http://hndsolution.iptime.org:8086${pic}',
  //                             width: MediaQuery.of(context).size.width * 0.8,
  //                             height: MediaQuery.of(context).size.height * 0.3,
  //                             fit: BoxFit.fitWidth,
  //                           ),
  //                         )),
  //                     Container(
  //                       padding: EdgeInsets.only(left: 20.0, bottom: 10.0),
  //                     ),
  //                     Row(
  //                       crossAxisAlignment: CrossAxisAlignment.end,
  //                       textBaseline: TextBaseline.alphabetic,
  //                       children: [
  //                         Padding(
  //                           padding: EdgeInsets.only(left: 15, top: 15),
  //                         ),
  //                         Padding(
  //                             padding: EdgeInsets.only(left: 8),
  //                             child: Container(
  //                               width: MediaQuery.of(context).size.width * 0.9,
  //                               child: Text(
  //                                 shopDc,
  //                                 //'11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111',
  //                                 maxLines: 5,
  //                                 style: TextStyle(
  //                                   fontFamily: "nanumR",
  //                                   fontWeight: FontWeight.w500,
  //                                   fontSize: 18,
  //                                 ),
  //                               ),
  //                             )),
  //                       ],
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //     barrierColor: Colors.white.withOpacity(0.7),
  //     pillColor: Colors.amberAccent,
  //     backgroundColor: Colors.white,
  //   );
  // }

  moveLogin() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => new LOGIN(
              number: 2,
            )));
  }

  void _favoriteDetail(
      String address,
      String pic,
      String placeName,
      String shopDc,
      String beginWeek,
      String endWeek,
      String beginWeekend,
      String endWeekend,
      int shopSeq,
      holidayList) {
    var a = '${beginWeek.substring(0, 2)}시 ${beginWeek.substring(2, 4)}분 ~';
    var b = ' ${endWeek.substring(0, 2)}시 ${endWeek.substring(2, 4)}분';
    var c =
        '${beginWeekend.substring(0, 2)}시 ${beginWeekend.substring(2, 4)}분 ~';
    var d = ' ${endWeekend.substring(0, 2)}시 ${endWeekend.substring(2, 4)}분';

    DateTime now = DateTime.now();

    String holiday = "";
    holiday = holidayList;

    List<String> restDay;
    if (holiday != null) {
      restDay = holiday.split(',');
      for (int hold = 0; hold < restDay.length; hold++) {
        if (restDay.elementAt(hold) == now.weekday.toString()) {
          dayOpenShop[shopSeq] = false;
        }
        // print('out ${now.weekday}');
        // print('out ${restDay.elementAt(hold)}');
        else {
          dayOpenShop[shopSeq] = true;
        }
      }
    }

    String startHour, startMin, endHour, endMin;
    TimeOfDay startTime, endTime;
    if (now.weekday == 6 || now.weekday == 7) {
      startHour = beginWeek.substring(0, 2);
      startMin = endWeek.substring(2, 4);
      endHour = beginWeekend.substring(0, 2);
      endMin = endWeekend.substring(2, 4);

      startTime =
          TimeOfDay(hour: int.parse(startHour), minute: int.parse(startMin));
      endTime = TimeOfDay(hour: int.parse(endHour), minute: int.parse(endMin));
    } else {
      startHour = beginWeek.substring(0, 2);
      startMin = endWeek.substring(2, 4);
      endHour = beginWeekend.substring(0, 2);
      endMin = endWeekend.substring(2, 4);

      startTime =
          TimeOfDay(hour: int.parse(startHour), minute: int.parse(startMin));
      endTime = TimeOfDay(hour: int.parse(endHour), minute: int.parse(endMin));
    }
    openingShop(startTime, endTime, shopSeq);

    showDialog(
        context: context,
        builder: (_) => Dialog(
                child: Container(
              height: MediaQuery.of(context).size.height * 0.48,
              decoration: BoxDecoration(
                  //color: Colors.redAccent,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(35))),
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
                    padding: EdgeInsets.only(bottom: 5),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                      child: Image.network(
                        'http://hndsolution.iptime.org:8086${pic}',
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.height * 0.25,
                        fit: BoxFit.fitWidth,
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
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Text(
                          '평일 : ${a + b}',
                          style: TextStyle(
                            fontFamily: "nanumR",
                            fontWeight: FontWeight.w600,
                            fontSize: 11.0,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      )),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                  ),
                  Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Text(
                          '주말 : ${c + d}',
                          style: TextStyle(
                            fontFamily: "nanumR",
                            fontWeight: FontWeight.w600,
                            fontSize: 11.0,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      )),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        address.length > 30
                            ? '주소 : ${address.substring(0, 30)}'
                            : '주소 : ${address}',

                        //'주소: 서울시 강남구아아어라ㅣ머ㅏ러ㅣ마어ㅣ마어리ㅏㅓ이ㅏ러미ㅏ어ㅣㅏㅁㄹ어ㅣ 개포로 516 703동 205호 어어오오오오오오오',
                        maxLines: 3,
                        style: TextStyle(
                          fontFamily: "nanumR",
                          fontWeight: FontWeight.w600,
                          fontSize: 11.0,
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                          child: Text('주문'),
                          color: Colors.white,
                          textColor: Colors.black,
                        ),
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

  Widget _card(favoriteInfoList) {
    favoriteInfoList = favoriteInfoList
        .where((element) => element['FAVORITE_YN'] == 'Y')
        .toList();

    return GridView.builder(
      //scrollDirection: Axis.vertical,
      itemCount:
          favoriteInfoList.length == null ? noData() : favoriteInfoList.length,

      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 5,
        crossAxisSpacing: 5,
        childAspectRatio: 0.83,
      ),
      itemBuilder: (context, index) {
        String list = favoriteInfoList[index]['SHOP_SEQ'].toString();

        bool isSaved = saveFav.contains(list);

        return GridTile(
            child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 0.2)),
          child: InkWell(
            onTap: () {
              setState(() {
                _favoriteDetail(
                  favoriteInfoList[index]['ADDRESS'],
                  favoriteInfoList[index]['FILE_URL'],
                  favoriteInfoList[index]['PLACE_NAME'],
                  favoriteInfoList[index]['SHOP_DC'],
                  favoriteInfoList[index]['BSN_BEGIN_TIME'],
                  favoriteInfoList[index]['BSN_END_TIME'],
                  favoriteInfoList[index]['WEEK_BEGIN_TIME'],
                  favoriteInfoList[index]['WEEK_END_TIME'],
                  favoriteInfoList[index]['SHOP_SEQ'],
                  favoriteInfoList[index]['HLDY_CD'],
                );
              });
            },
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[800], width: 1.5)),
              child: Card(
                elevation: 0,
                color: Colors.transparent,
                child: Column(
                  children: <Widget>[
                    Image.network(
                      'http://hndsolution.iptime.org:8086${favoriteInfoList[index]['FILE_URL']}',
                      //'https://placeimg.com/500/500/any',
                      height: MediaQuery.of(context).size.height * 0.15,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.fitWidth,
                    ),
                    // Align(
                    //   alignment: Alignment.center,
                    //   child: Text(
                    //       favoriteInfoList[index]['PLACE_NAME'].length > 8
                    //           ? "${favoriteInfoList[index]['PLACE_NAME'].substring(0, 6)}..."
                    //           : "${favoriteInfoList[index]['PLACE_NAME']}",
                    //       textAlign: TextAlign.left,
                    //       style: TextStyle(
                    //           fontSize: 18.0,
                    //           fontFamily: 'nanumB',
                    //           color: Colors.black,
                    //           fontWeight: FontWeight.w900)),
                    // ),

                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                            favoriteInfoList[index]['PLACE_NAME'].length > 16
                                ? "${favoriteInfoList[index]['PLACE_NAME'].substring(0, 16)}"
                                : "${favoriteInfoList[index]['PLACE_NAME']}",
                            //"아아아아아아아아아아아아아아아아",
                            maxLines: 2,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 20.0,
                                fontFamily: 'nanumB',
                                color: Colors.black,
                                fontWeight: FontWeight.w900)),
                      ),
                    ),

                    Align(
                        alignment: Alignment.bottomRight,
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              if (isSaved == true) {
                                print('여기가 "Y');
                                saveFav.remove(favoriteInfoList[index]
                                        ['SHOP_SEQ']
                                    .toString());
                                insertFavorite(userId,
                                    favoriteInfoList[index]['SHOP_SEQ']);
                              } else {
                                print('여기가 "N');
                                saveFav.add(favoriteInfoList[index]['SHOP_SEQ']
                                    .toString());
                                deleteFavorite(userId,
                                    favoriteInfoList[index]['SHOP_SEQ']);
                              }
                            });
                          },
                          icon: Icon(
                            Icons.star,
                            size: 25,
                            color: isSaved == false
                                ? Colors.red[400]
                                : Colors.grey[300],
                          ),
                        )),
                  ],
                ),
              ),
            ),
          ),
        ));
      },
    );
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
            "즐겨찾기",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
          ),
        ),
        body: FutureBuilder(
            future: favoriteFuture,
            builder: (context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CupertinoActivityIndicator());
              }
              print(categoryCd);

              if (snapshot.data == "hoit") {
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
              Map<String, dynamic> favoriteInfo = snapshot.data;
              if (favoriteInfo["LIST"] == "" || favoriteInfo["LIST"] == null) {
                return Column(children: [
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 12.0),
                  //   child: Container(
                  //       child: Align(
                  //     alignment: Alignment.centerRight,
                  //     child: Row(
                  //       crossAxisAlignment: CrossAxisAlignment.end,
                  //       textBaseline: TextBaseline.alphabetic,
                  //       children: <Widget>[
                  //         Spacer(),
                  //         userName == null
                  //             ? Text(
                  //                 '${userId}',
                  //                 style: TextStyle(
                  //                   // color: _colorText,
                  //                   fontSize: 20.0,
                  //                   fontFamily: 'nanumB',
                  //                   fontWeight: FontWeight.w800,
                  //                 ),
                  //               )
                  //             : Text(
                  //                 "${userName}",
                  //                 style: TextStyle(
                  //                   // color: _colorText,
                  //                   fontSize: 20.0,
                  //                   fontFamily: 'nanumB',
                  //                   fontWeight: FontWeight.w800,
                  //                 ),
                  //               ),
                  //         Text(
                  //           "님이",
                  //           style: TextStyle(
                  //             // color: _colorText,
                  //             fontSize: 13.0,
                  //             fontFamily: 'nanumR',
                  //             fontWeight: FontWeight.w800,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   )),
                  // ),
                  Container(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "자주 가는 곳!",
                            style: TextStyle(
                              // color: _colorText,
                              fontSize: 17.0,
                              fontFamily: 'nanumB',
                              fontWeight: FontWeight.w800,
                            ),
                          ))),
                  Container(
                    child: Divider(
                      color: Colors.black,
                    ),
                    padding: EdgeInsets.only(left: 12.0, bottom: 15.0),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5.0, left: 45),
                  ),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.only(left: 3.0, right: 3.0),
                    child: noData(),
                  ))
                ]);
              } else {
                List<dynamic> favoriteInfoList = favoriteInfo["LIST"];

                return Column(children: [
                  Padding(
                    padding: EdgeInsets.only(top: 20),
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
                          userName == null
                              ? Padding(
                                  padding: const EdgeInsets.only(right: 3.0),
                                  child: Text(
                                    '${userId}',
                                    style: TextStyle(
                                      // color: _colorText,
                                      fontSize: 20.0,
                                      fontFamily: 'nanumB',
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(right: 3.0),
                                  child: Text(
                                    "${userName}",
                                    style: TextStyle(
                                      // color: _colorText,
                                      fontSize: 20.0,
                                      fontFamily: 'nanumB',
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Text(
                              "님이",
                              style: TextStyle(
                                // color: _colorText,
                                fontSize: 13.0,
                                fontFamily: 'nanumR',
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
                  ),
                  Container(
                      padding: const EdgeInsets.only(top: 8, right: 8.0),
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "자주 가는 곳!",
                            style: TextStyle(
                              // color: _colorText,
                              fontSize: 17.0,
                              fontFamily: 'nanumB',
                              fontWeight: FontWeight.w800,
                            ),
                          ))),
                  Container(
                    child: Divider(
                      color: Colors.black,
                    ),
                    padding: EdgeInsets.only(left: 12.0, bottom: 15.0),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5.0, left: 45),
                  ),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.only(left: 3.0, right: 3.0),
                    child: favoriteInfoList.length == null
                        ? noData()
                        : _card(favoriteInfoList),
                  ))
                ]);
              }
            }));
  }
}
