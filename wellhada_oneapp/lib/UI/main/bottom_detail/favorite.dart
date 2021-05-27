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
import 'package:wellhada_oneapp/listitem/user/user.dart' as user;

class Favorite extends StatefulWidget {
  @override
  _FavoriteState createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  List favoriteList;
  var allFavorite;
  String webviewDefault = 'http://192.168.0.47:8080/usermngr';
  var userId, userPassword, userChk;
  var userName;

  void initState() {
    super.initState();
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
    } catch (e) {
      print(e);
    }
  }

  getFavorite() async {
    return favorite.getFavorite(userId);
  }

  void _handleURLButtonPress(BuildContext context, String url, String placeName,
      int userSeq, String userId) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                WebViewContainer(placeName, userSeq, userId, userPassword)));

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

  userDataCheck(category, shopSeq) async {
    print('${category} ,${shopSeq}');
    // final webLoginData =
    //     await webLogin.loginWebUser(userKey, userPassword, userChk);

    _handleURLButtonPress(context, '${webviewDefault}/shopTmplatView.do',
        category, shopSeq, userId);
  }

  void _showShopListDialog(
      String address,
      String pic,
      String placeName,
      String shopDc,
      String beginWeek,
      String endWeek,
      String beginWeekend,
      String endWeekend,
      int shopSeq) {
    var a = '${beginWeek.substring(0, 2)}시 ${beginWeek.substring(2, 4)}분 ~';
    var b = ' ${endWeek.substring(0, 2)}시 ${endWeek.substring(2, 4)}분까지';
    var c =
        '${beginWeekend.substring(0, 2)}시 ${beginWeekend.substring(2, 4)}분 ~';
    var d = ' ${endWeekend.substring(0, 2)}시 ${endWeekend.substring(2, 4)}분까지';

    slideDialog.showSlideDialog(
      context: context,
      child: Expanded(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      userDataCheck(placeName, shopSeq);
                    });
                  },
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
                              padding: EdgeInsets.only(bottom: 10.0, right: 5),
                              child: Text(
                                "평일:",
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
                                padding:
                                    EdgeInsets.only(bottom: 10.0, right: 5),
                                child: Text(
                                  a + b,
                                  style: TextStyle(
                                    fontFamily: "nanumR",
                                    fontWeight: FontWeight.w600,
                                    fontSize: 11.0,
                                  ),
                                ),
                              )),
                          Padding(
                            padding: EdgeInsets.only(right: 5),
                          )
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Spacer(),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 10.0, right: 5),
                              child: Text(
                                "주말:",
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
                                padding:
                                    EdgeInsets.only(bottom: 10.0, right: 5),
                                child: Text(
                                  c + d,
                                  style: TextStyle(
                                    fontFamily: "nanumR",
                                    fontWeight: FontWeight.w600,
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
                        padding: EdgeInsets.only(left: 20.0, bottom: 5.0),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Padding(
                              padding: EdgeInsets.only(left: 15),
                              child: Text(
                                '${placeName}',
                                style: TextStyle(
                                  fontFamily: "nanumB",
                                  fontWeight: FontWeight.w900,
                                  fontSize: 26.0,
                                ),
                              )),
                          Padding(
                            padding: EdgeInsets.only(left: 20, right: 5),
                            child: Text(
                              address.length > 15
                                  ? '${address.substring(0, 14)}...'
                                  : address,

                              // '${distance}m',
                              style: TextStyle(
                                fontFamily: "nanumR",
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          )
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 12.0, bottom: 10.0),
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
                                  shopDc,
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
                    ],
                  ),
                ),
              ),
            ],
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
              number: 2,
            )));
  }

  Widget _card(favoriteInfoList) {
    favoriteInfoList = favoriteInfoList
        .where((element) => element['FAVORITE_YN'] == 'Y')
        .toList();

    return GridView.builder(
        //scrollDirection: Axis.vertical,
        itemCount: favoriteInfoList.length == null
            ? noData()
            : favoriteInfoList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 5,
          crossAxisSpacing: 5,
          childAspectRatio: 0.79,
        ),
        itemBuilder: (context, index) {
          String list = favoriteInfoList[index]['SHOP_SEQ'].toString();

          bool isSaved = saveFav.contains(list);

          return InkWell(
            onTap: () {
              setState(() {
                _showShopListDialog(
                  favoriteInfoList[index]['ADDRESS'],
                  favoriteInfoList[index]['FILE_URL'],
                  favoriteInfoList[index]['PLACE_NAME'],
                  favoriteInfoList[index]['SHOP_DC'],
                  favoriteInfoList[index]['BSN_BEGIN_TIME'],
                  favoriteInfoList[index]['BSN_END_TIME'],
                  favoriteInfoList[index]['WEEK_BEGIN_TIME'],
                  favoriteInfoList[index]['WEEK_END_TIME'],
                  favoriteInfoList[index]['SHOP_SEQ'],
                );
              });
            },
            child: Container(
              // decoration: BoxDecoration(
              //     border: Border.all(color: Colors.grey[800], width: 1)),
              child: Card(
                elevation: 0,
                color: Colors.transparent,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Image.network(
                        'http://192.168.0.47:8080${favoriteInfoList[index]['FILE_URL']}',
                        //'https://placeimg.com/500/500/any',
                        height: MediaQuery.of(context).size.height * 0.15,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                          favoriteInfoList[index]['PLACE_NAME'].length > 8
                              ? "${favoriteInfoList[index]['PLACE_NAME'].substring(0, 6)}..."
                              : "${favoriteInfoList[index]['PLACE_NAME']}",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 18.0,
                              fontFamily: 'nanumB',
                              color: Colors.black,
                              fontWeight: FontWeight.w900)),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 3.5),
                          child: Text(
                              favoriteInfoList[index]['ADDRESS'].length > 13
                                  ? "${favoriteInfoList[index]['ADDRESS'].substring(0, 12)}..."
                                  : "${favoriteInfoList[index]['ADDRESS']}",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 10.0,
                                  fontFamily: 'nanumR',
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700)),
                        ),
                        Spacer(),
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
                                    saveFav.add(favoriteInfoList[index]
                                            ['SHOP_SEQ']
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
                    )
                  ],
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
            future: getFavorite(),
            builder: (context, AsyncSnapshot snapshot) {
              // if (!snapshot.hasData && (userId == null || userId == "")) {
              //   return Column(
              //     children: <Widget>[
              //       Padding(
              //         padding: EdgeInsets.only(top: 20, bottom: 20),
              //       ),
              //       Padding(
              //         padding: const EdgeInsets.only(left: 12.0),
              //         child: Container(
              //             child: Align(
              //           alignment: Alignment.centerRight,
              //           child: Row(
              //             crossAxisAlignment: CrossAxisAlignment.end,
              //             textBaseline: TextBaseline.alphabetic,
              //             children: <Widget>[
              //               Spacer(),
              //               Text(
              //                 "",
              //                 style: TextStyle(
              //                   // color: _colorText,
              //                   fontSize: 23.0,
              //                   fontFamily: 'nanumB',
              //                   fontWeight: FontWeight.w800,
              //                 ),
              //               ),
              //             ],
              //           ),
              //         )),
              //       ),
              //       Padding(
              //         child: Divider(
              //           color: Colors.black,
              //           thickness: 3,
              //         ),
              //         padding: EdgeInsets.only(bottom: 40),
              //       ),
              //       Padding(
              //         padding: const EdgeInsets.all(12.0),
              //         child: Container(
              //             child: Align(
              //           alignment: Alignment.centerLeft,
              //           child: Column(
              //             crossAxisAlignment: CrossAxisAlignment.baseline,
              //             textBaseline: TextBaseline.alphabetic,
              //             children: <Widget>[
              //               Text("",
              //                   style: TextStyle(
              //                     // color: _colorText,
              //                     fontSize: 20.0,
              //                     fontFamily: 'nanumR',
              //                     fontWeight: FontWeight.w800,
              //                   )),
              //               Text("",
              //                   style: TextStyle(
              //                     // color: _colorText,
              //                     fontSize: 18.0,
              //                     fontFamily: 'nanumR',
              //                     fontWeight: FontWeight.w800,
              //                   )),
              //             ],
              //           ),
              //         )),
              //       ),
              //       Padding(
              //         padding: EdgeInsets.only(top: 20.0, bottom: 20),
              //       ),
              //       Container(
              //           padding: const EdgeInsets.only(left: 12.0, bottom: 20),
              //           child: Align(
              //               alignment: Alignment.center,
              //               child: Text(
              //                 "로그인을 하시면",
              //                 style: TextStyle(
              //                   // color: _colorText,
              //                   fontSize: 16.0,
              //                   fontFamily: 'nanumR',
              //                   fontWeight: FontWeight.w800,
              //                 ),
              //               ))),
              //       Container(
              //           padding: const EdgeInsets.only(left: 12.0, bottom: 3),
              //           child: Align(
              //               alignment: Alignment.center,
              //               child: Text(
              //                 " 좋아요 목록을 확인하실수 있습니다.",
              //                 style: TextStyle(
              //                   // color: _colorText,
              //                   fontSize: 16.0,
              //                   fontFamily: 'nanumR',
              //                   fontWeight: FontWeight.w800,
              //                 ),
              //               ))),
              //       Padding(
              //         padding: EdgeInsets.only(top: 20.0, bottom: 20),
              //       ),
              //       Container(
              //         height: 50.0,
              //         margin: EdgeInsets.all(10),
              //         child: RaisedButton(
              //           onPressed: moveLogin,
              //           shape: RoundedRectangleBorder(
              //               borderRadius: BorderRadius.circular(80.0)),
              //           padding: EdgeInsets.all(0.0),
              //           child: Ink(
              //             decoration: BoxDecoration(
              //                 gradient: LinearGradient(
              //                   colors: [Color(0xff374ABE), Color(0xff64B6FF)],
              //                   begin: Alignment.centerLeft,
              //                   end: Alignment.centerRight,
              //                 ),
              //                 borderRadius: BorderRadius.circular(30.0)),
              //             child: Container(
              //               constraints: BoxConstraints(
              //                   maxWidth: 250.0, minHeight: 50.0),
              //               alignment: Alignment.center,
              //               child: Text(
              //                 "로그인",
              //                 textAlign: TextAlign.center,
              //                 style:
              //                     TextStyle(color: Colors.white, fontSize: 15),
              //               ),
              //             ),
              //           ),
              //         ),
              //       ),
              //       Padding(
              //         padding: EdgeInsets.only(top: 20.0, bottom: 20),
              //       ),
              //     ],
              //   );
              // }
              if (!snapshot.hasData) {
                return Center(child: CupertinoActivityIndicator());
              }
              Map<String, dynamic> favoriteInfo = snapshot.data;

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
                            ? Text(
                                '${userId}',
                                style: TextStyle(
                                  // color: _colorText,
                                  fontSize: 20.0,
                                  fontFamily: 'nanumB',
                                  fontWeight: FontWeight.w800,
                                ),
                              )
                            : Text(
                                "${userName}",
                                style: TextStyle(
                                  // color: _colorText,
                                  fontSize: 20.0,
                                  fontFamily: 'nanumB',
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                        Text(
                          "님이",
                          style: TextStyle(
                            // color: _colorText,
                            fontSize: 13.0,
                            fontFamily: 'nanumR',
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  )),
                ),
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
                  child: favoriteInfoList.length == null
                      ? noData()
                      : _card(favoriteInfoList),
                ))
              ]);
            }));
  }
}
