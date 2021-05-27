import 'dart:collection';
import 'dart:ffi';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wellhada_oneapp/UI/banner/main_banner.dart';
import 'package:wellhada_oneapp/UI/main/home_detail/webview.dart';
import 'package:wellhada_oneapp/listitem/shop/web.dart' as webLogin;
import 'package:wellhada_oneapp/listitem/shop/shopInfoListItem.dart'
    as shopInfoListItem;
import 'package:hexcolor/hexcolor.dart';
import 'dart:math' show cos, sqrt, asin;
import 'package:wellhada_oneapp/listitem/user/user.dart' as user;

class ListScreen extends StatefulWidget {
  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> with TickerProviderStateMixin {
  var appColor = '#ffffff';
  var menuColor = '#ffd428';
  var appFontColor = '#333333';
  var menuFontColor = '#333333';
  String coupon = 'C:\Users\hndso\Desktop\icon_jandi\coupon.svg';
  var category, shopSeq;
  List shop, shopCategory;
  TabController _tabController;
  bool wellhada, init;
  Map<int, String> menuView = new Map();
  Map<int, String> wellhadaView = new Map();
  List exactDistance = [];
  LatLng _currentLocation;
  Map<int, String> initDistance = new Map();
  Map<int, String> distance = new Map();
  var lat, lng;
  String webviewDefault = 'http://192.168.0.47:8080/usermngr';
  bool opening;
  var userChk, userKey, userId;
  var userPassword;
  // For storing the current position
  @override
  void initState() {
    //_getCurrentLocation();

    // getShopCategory();
    // getShop();
    // _tabController = new TabController(length: 9, vsync: this)
    //   ..addListener(() {
    //     distance = new Map();
    //   });
    check();
    _tabController = new TabController(length: 4, vsync: this)
      ..addListener(() {
        distance = new Map();
      });

    super.initState();
  }

  void check() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        // userKey = prefs.getString("userKey") == null
        //     ? prefs.getString("userToken")
        //     : prefs.getString("userKey");
        userKey = prefs.getString("userKey");
        userPassword = prefs.getString("userPasswordGoweb");
        userChk = prefs.getString("userChk") ?? "O";
        if (userChk == "01") {
          userChk = "E";
        }
        if (userChk == "00") {
          userChk = "K";
        }

        prefs.setString("userChk", userChk);
      });
    } catch (e) {
      print(e);
    }
    // setState(() {
    //   userChk = userData.userCheck;
    // });
    // if (userChk != 'O') userDefault();
  }

  @override
  void didUpdateWidget(Widget oldWidget) {
    super.didUpdateWidget(oldWidget);

    try {
      _currentLocation = Provider.of<LatLng>(context, listen: true);
    } catch (e) {
      print(e);
    }
    getShopCategory();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  userDataCheck(category, shopSeq) async {
    print('${userKey},${userPassword},${userChk}');

    _handleURLButtonPress(context, '${webviewDefault}/shopTmplatView.do',
        category, shopSeq, userKey);
  }

  void _handleURLButtonPress(BuildContext context, String url, String placeName,
      int shopSeq, String userKey) {
    // userDataCheck();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                WebViewContainer(placeName, shopSeq, userKey, userPassword)));

    // Navigator.pushNamed(context, '/webview');
  }

  String _coordinateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;

    return ((12742 * asin(sqrt(a)) * 1000)).toStringAsFixed(0);
  }

  void getShopCategory() async {
    final shopCategoryList = await shopInfoListItem.getShopListEntire();

    setState(() {
      for (int i = 0; i < shopCategoryList.list.length; i++) {
        initDistance[shopCategoryList.list[i].shopSeq] = _coordinateDistance(
            _currentLocation.latitude,
            _currentLocation.longitude,
            shopCategoryList.list[i].latitude,
            shopCategoryList.list[i].longtitude);
        DateTime now = DateTime.now();

        String startHour, startMin, endHour, endMin;
        TimeOfDay startTime, endTime;
        if (now.weekday == 6 || now.weekday == 7) {
          startHour = shopCategoryList.list[i].weekBeginTime.substring(0, 2);
          startMin = shopCategoryList.list[i].weekBeginTime.substring(2, 4);
          endHour = shopCategoryList.list[i].weekEndTime.substring(0, 2);
          endMin = shopCategoryList.list[i].weekEndTime.substring(2, 4);

          startTime = TimeOfDay(
              hour: int.parse(startHour), minute: int.parse(startMin));
          endTime =
              TimeOfDay(hour: int.parse(endHour), minute: int.parse(endMin));
        } else {
          startHour = shopCategoryList.list[i].bsnBeginTime.substring(0, 2);
          startMin = shopCategoryList.list[i].bsnBeginTime.substring(2, 4);
          endHour = shopCategoryList.list[i].bsnEndTime.substring(0, 2);
          endMin = shopCategoryList.list[i].bsnEndTime.substring(2, 4);

          startTime = TimeOfDay(
              hour: int.parse(startHour), minute: int.parse(startMin));
          endTime =
              TimeOfDay(hour: int.parse(endHour), minute: int.parse(endMin));
        }
        openingShop(startTime, endTime);
      }
      shopCategory = shopCategoryList.list
          .where((el) => 3000 > int.parse(initDistance[el.shopSeq]))
          .toList();
    });
  }

  bool isLastPage() {
    return _tabController.index == _tabController.length - 1;
  }

//////////
  ///
///////////////////////////////////////////////
  @override
  void dispose() {
    _tabController.dispose();

    super.dispose();
  }

  Future<Map<String, dynamic>> getShops() async {
    return shopInfoListItem.getShopCodeList();
  }

  // Widget _menuList(String code) {
  //   List menuCode;
  //   List<int> sortedKeys;
  //   LinkedHashMap sortedMap;
  //   List fromUserToMarket;
  //   Map<int, int> newPosition;

  //   try {
  //     menuCode =
  //         shopCategory.where((el) => el.categoryGroupCode == code).toList();

  //     return Stack(children: [
  //       ListView.builder(
  //         scrollDirection: Axis.vertical,
  //         shrinkWrap: true,
  //         controller: _controller,
  //         physics: ClampingScrollPhysics(),
  //         itemCount: menuCode.length == null ? 0 : menuCode.length,
  //         itemBuilder: (context, position) {
  //           var size = MediaQuery.of(context).size;
  //           newPosition = new Map();

  //           var alone;
  //           if (menuCode.length == 1) {
  //             alone = _coordinateDistance(
  //                 _currentLocation.latitude,
  //                 _currentLocation.longitude,
  //                 double.parse(menuCode[0].y),
  //                 double.parse(menuCode[0].x));

  //             newPosition[0] = 0;
  //           } else {
  //             for (int i = 0; i < menuCode.length; i++) {
  //               distance[i] = _coordinateDistance(
  //                   _currentLocation.latitude,
  //                   _currentLocation.longitude,
  //                   double.parse(menuCode[i].y),
  //                   double.parse(menuCode[i].x));
  //               sortedKeys = distance.keys.toList(growable: false)
  //                 ..sort((k1, k2) => int.parse(distance[k1])
  //                     .compareTo(int.parse(distance[k2])));

  //               sortedMap = new LinkedHashMap.fromIterable(sortedKeys,
  //                   key: (k) => k, value: (k) => distance[k]);
  //             }
  //             fromUserToMarket = sortedMap.values.toList();
  //           }

  //           return InkWell(
  //               child: Card(
  //                 child: Padding(
  //                   padding: const EdgeInsets.all(16.0),
  //                   child: Row(
  //                     children: [
  //                       Padding(
  //                         padding: EdgeInsets.only(right: 10),
  //                       ),
  //                       Container(
  //                         child: Image.network(
  //                           menuCode[position].placeUrl,
  //                           fit: BoxFit.fill,
  //                           width: 40.0,
  //                           height: 40.0,
  //                         ),
  //                       ),
  //                       Padding(
  //                         padding: EdgeInsets.only(right: 20),
  //                       ),
  //                       Container(
  //                         width: MediaQuery.of(context).size.width - 110,
  //                         child: Column(
  //                           //mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: <Widget>[
  //                             Text(
  //                               menuCode[position].placeName,
  //                               style: TextStyle(fontSize: 18.0),
  //                             ),
  //                             Row(
  //                               verticalDirection: VerticalDirection.down,
  //                               children: [
  //                                 Text(
  //                                   menuCode[position].addressName,
  //                                   style: TextStyle(fontSize: 10.0),
  //                                 ),
  //                                 Padding(
  //                                   padding: EdgeInsets.only(left: 5, right: 5),
  //                                 ),
  //                                 ClipOval(
  //                                   child: Material(
  //                                     color: Colors.green,
  //                                     child: InkWell(
  //                                       onTap: () {},
  //                                       child: SvgPicture.asset(
  //                                         "assets/svg/coupon.svg",
  //                                         fit: BoxFit.fill,
  //                                         width: 20,
  //                                         height: 20,
  //                                       ),
  //                                     ),
  //                                   ),
  //                                 ),
  //                                 Spacer(),
  //                                 SvgPicture.asset(
  //                                   'assets/svg/location.svg',
  //                                   width: 15.0,
  //                                   height: 20.0,
  //                                 ),
  //                                 Padding(
  //                                   padding: EdgeInsets.only(right: 3.0),
  //                                 ),
  //                                 Text(fromUserToMarket == null
  //                                     ? alone.length > 3
  //                                         ? '${(int.parse(alone) * 0.001).toStringAsFixed(1)}km'
  //                                         : '${alone}m'
  //                                     : fromUserToMarket[position].length > 3
  //                                         ? '${(int.parse(fromUserToMarket[position]) * 0.001).toStringAsFixed(1)}km'
  //                                         : '${fromUserToMarket[position]}m'),
  //                               ],
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //               onTap: () {
  //                 setState(() {
  //                   category = menuCode[position].placeName;
  //                   print(category);
  //                   _handleURLButtonPress(context,
  //                       '${webviewDefault}/shopTmplatView.do', category);
  //                 });
  //               });
  //         },
  //       ),

  //     ]);
  //   } catch (e) {
  //     return Center(child: CupertinoActivityIndicator());
  //   }
  // }
  Widget noData() {
    return Center(
      child: Image.asset('assets/icon/noImage.png'),
    );
  }

  openingShop(startTime, endTime) async {
    setState(() {
      DateTime now = DateTime.now();

      if (startTime.hour < now.hour && now.hour < endTime.hour) {
        if (startTime.minute < now.minute && now.minute < endTime.minute) {
          opening = false;
        }
      }
      opening = true;
    });
  }

  Widget _wellhadaView(String code) {
    List menuCode;

    List<int> sortedKeys;
    LinkedHashMap sortedMap;
    List fromUserToMarket;
    Map<int, int> newPosition = new Map();
    try {
      menuCode =
          shopCategory.where((el) => el.categoryGroupCode == code).toList();

      return menuCode.isEmpty
          ? noData()
          : Stack(children: [
              ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                controller: _controller,
                physics: ClampingScrollPhysics(),
                itemCount: menuCode.length == null ? 0 : menuCode.length,
                itemBuilder: (context, position) {
                  var size = MediaQuery.of(context).size;

                  var alone;
                  if (menuCode.length == 1) {
                    alone = _coordinateDistance(
                        _currentLocation.latitude,
                        _currentLocation.longitude,
                        menuCode[0].latitude,
                        menuCode[0].longtitude);

                    newPosition[0] = 0;
                  } else {
                    for (int i = 0; i < menuCode.length; i++) {
                      distance[i] = _coordinateDistance(
                          _currentLocation.latitude,
                          _currentLocation.longitude,
                          menuCode[i].latitude,
                          menuCode[i].longtitude);
                      // distance.removeWhere((key, value) => int.parse(value) > 2000);

                      sortedKeys = distance.keys.toList(growable: false)
                        ..sort((k1, k2) => int.parse(distance[k1])
                            .compareTo(int.parse(distance[k2])));

                      sortedMap = new LinkedHashMap.fromIterable(sortedKeys,
                          key: (k) => k, value: (k) => distance[k]);
                    }

                    fromUserToMarket = sortedMap.values.toList();
                  }

                  // DateTime now = DateTime.now();

                  // String startHour, startMin, endHour, endMin;
                  // TimeOfDay startTime, endTime;
                  // if (now.weekday == 6 || now.weekday == 7) {
                  //   startHour =
                  //       menuCode[position].weekBeginTime.substring(0, 2);
                  //   startMin = menuCode[position].weekBeginTime.substring(2, 4);
                  //   endHour = menuCode[position].weekEndTime.substring(0, 2);
                  //   endMin = menuCode[position].weekEndTime.substring(2, 4);

                  //   startTime = TimeOfDay(
                  //       hour: int.parse(startHour),
                  //       minute: int.parse(startMin));
                  //   endTime = TimeOfDay(
                  //       hour: int.parse(endHour), minute: int.parse(endMin));
                  // } else {
                  //   startHour = menuCode[position].bsnBeginTime.substring(0, 2);
                  //   startMin = menuCode[position].bsnBeginTime.substring(2, 4);
                  //   endHour = menuCode[position].bsnEndTime.substring(0, 2);
                  //   endMin = menuCode[position].bsnEndTime.substring(2, 4);

                  //   startTime = TimeOfDay(
                  //       hour: int.parse(startHour),
                  //       minute: int.parse(startMin));
                  //   endTime = TimeOfDay(
                  //       hour: int.parse(endHour), minute: int.parse(endMin));
                  // }
                  // openingShop(startTime, endTime);
                  print(
                      'http://192.168.0.47:8080${menuCode[position].fileUrl}');
                  return opening == true
                      ? InkWell(
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(right: 10),
                                  ),
                                  Container(
                                    child: Image.network(
                                      'http://192.168.0.47:8080${menuCode[position].fileUrl}',
                                      fit: BoxFit.fill,
                                      width: 40.0,
                                      height: 40.0,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(right: 20),
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width - 110,
                                    child: Column(
                                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          menuCode[position].placeName,
                                          style: TextStyle(fontSize: 18.0),
                                        ),
                                        Row(
                                          verticalDirection:
                                              VerticalDirection.down,
                                          children: [
                                            Text(
                                              menuCode[position].address,
                                              style: TextStyle(fontSize: 10.0),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 5, right: 5),
                                            ),
                                            ClipOval(
                                              child: Material(
                                                color: Colors.green,
                                                child: InkWell(
                                                  onTap: () {},
                                                  child: SvgPicture.asset(
                                                    "assets/svg/coupon.svg",
                                                    fit: BoxFit.fill,
                                                    width: 20,
                                                    height: 20,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Spacer(),
                                            Image.asset(
                                              'assets/img/location.png',
                                              width: 20.0,
                                              height: 20.0,
                                            ),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(right: 3.0),
                                            ),
                                            Text(fromUserToMarket == null
                                                ? alone.length > 3
                                                    ? '${(int.parse(alone) * 0.001).toStringAsFixed(1)}km'
                                                    : '${alone}m'
                                                : fromUserToMarket[position]
                                                            .length >
                                                        3
                                                    ? '${(int.parse(fromUserToMarket[position]) * 0.001).toStringAsFixed(1)}km'
                                                    : '${fromUserToMarket[position]}m'),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              category = menuCode[position].placeName;
                              shopSeq = menuCode[position].shopSeq;

                              userDataCheck(category, shopSeq);
                            });
                          })
                      : Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 10),
                                ),
                                Stack(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(top: 10.0),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text("준비중",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'nanumB',
                                            )),
                                      ),
                                    ),
                                    Container(
                                      child: Image.network(
                                        'http://192.168.0.47:8080/${menuCode[position].fileUrl}',
                                        fit: BoxFit.fill,
                                        width: 40.0,
                                        height: 40.0,
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: 20),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width - 130,
                                  child: Column(
                                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        menuCode[position].placeName,
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            color: Colors.grey[500]),
                                      ),
                                      Row(
                                        verticalDirection:
                                            VerticalDirection.down,
                                        children: [
                                          Text(
                                            menuCode[position].address,
                                            style: TextStyle(
                                                fontSize: 10.0,
                                                color: Colors.grey[500]),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 5, right: 5),
                                          ),
                                          ClipOval(
                                            child: Material(
                                              color: Colors.green,
                                              child: InkWell(
                                                onTap: () {},
                                                child: SvgPicture.asset(
                                                  "assets/svg/coupon.svg",
                                                  fit: BoxFit.fill,
                                                  width: 20,
                                                  height: 20,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Spacer(),
                                          Image.asset(
                                            'assets/img/location.png',
                                            width: 20.0,
                                            height: 20.0,
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsets.only(right: 3.0),
                                          ),
                                          Text(
                                            fromUserToMarket == null
                                                ? alone.length > 3
                                                    ? '${(int.parse(alone) * 0.001).toStringAsFixed(1)}km'
                                                    : '${alone}m'
                                                : fromUserToMarket[position]
                                                            .length >
                                                        3
                                                    ? '${(int.parse(fromUserToMarket[position]) * 0.001).toStringAsFixed(1)}km'
                                                    : '${fromUserToMarket[position]}m',
                                            style: TextStyle(
                                                color: Colors.grey[500]),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                },
              ),
            ]);
    } catch (e) {
      print(e);
      return Center(child: CupertinoActivityIndicator());
    }
  }

  ScrollController _controller = new ScrollController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getShops(),
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CupertinoActivityIndicator());
          }

          Map<String, dynamic> shopInfo = snapshot.data;

          List<dynamic> shopInfoList = shopInfo["LIST"];

          List<Tab> tabs = new List<Tab>();

          //List<Widget> menuList = List<Widget>();
          List<Widget> wellhadaList = List<Widget>();

          for (int i = 0; i < shopInfoList.length; i++) {
            tabs.add(
              Tab(
                child: Text(
                  shopInfoList[i]['CATEGORY_CDNM'],
                  style: TextStyle(color: Colors.black),
                ),
              ),
            );

            // menuView[i] = shopInfoList[i]["CATEGORY_CD"];
            // menuList.add(_menuList(menuView[i]));

            wellhadaView[i] = shopInfoList[i]["CATEGORY_CD"];
            wellhadaList.add(_wellhadaView(wellhadaView[i]));
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
                // child: Text(widget.text,style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                    height: 22,
                    child: Padding(
                      padding: EdgeInsets.only(left: 4),
                      child: TabBar(
                        labelColor: Colors.black,
                        unselectedLabelColor: Colors.grey.shade400,
                        indicator: ShapeDecoration(
                            // color: Colors.redAccent,
                            shape: BeveledRectangleBorder(
                                side: BorderSide(
                          width: 1.2,
                          color: Colors.white70,
                        ))),
                        labelStyle: TextStyle(
                          fontSize: 18.5,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'nanumB',
                        ),
                        unselectedLabelStyle: TextStyle(
                          fontSize: 15.5,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'nanumR',
                        ),
                        tabs: tabs,
                        controller: _tabController,
                        isScrollable: true,
                        indicatorWeight: 4,
                        indicatorColor: Colors.black,
                      ),
                    )),
              ),
              Expanded(
                child: TabBarView(
                    controller: _tabController, children: wellhadaList),
              )
            ],
          );
        });
  }
}
