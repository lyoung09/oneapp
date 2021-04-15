import 'dart:collection';
import 'dart:ffi';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wellhada_oneapp/UI/banner/main_banner.dart';

import 'package:wellhada_oneapp/listitem/shop/shopInfoListItem.dart'
    as shopInfoListItem;
import 'package:hexcolor/hexcolor.dart';
import 'dart:math' show cos, sqrt, asin;

import 'package:wellhada_oneapp/listitem/shop/shopInfoListItem.dart';
import 'package:wellhada_oneapp/model/map/map_model.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  var appColor = '#ffffff';
  var menuColor = '#ffd428';
  var appFontColor = '#333333';
  var menuFontColor = '#333333';
  var userChk = "01";
  var category;
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
    getShop();
    _tabController = new TabController(length: 9, vsync: this)
      ..addListener(() {
        distance = new Map();
      });

    super.initState();
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

  String _coordinateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;

    return ((12742 * asin(sqrt(a)) * 1000)).toStringAsFixed(0);
  }

  void getShop() async {
    final shopList = await shopInfoListItem.getShopCategoryEntire();
    setState(() {
      shop = shopList.list;
    });
  }

  void getShopCategory() async {
    final shopCategoryList =
        await shopInfoListItem.getShopInfoCategoryListEntire();

    setState(() {
      for (int i = 0; i < shopCategoryList.list.length; i++) {
        initDistance[int.parse(shopCategoryList.list[i].id)] =
            _coordinateDistance(
                _currentLocation.latitude,
                _currentLocation.longitude,
                double.parse(shopCategoryList.list[i].y),
                double.parse(shopCategoryList.list[i].x));
      }
      shopCategory = shopCategoryList.list
          .where((el) => 3000 > int.parse(initDistance[int.parse(el.id)]))
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
    return shopInfoListItem.getShopCategoryList();
  }

  Widget _menuList(String code) {
    List menuCode;
    List<int> sortedKeys;
    LinkedHashMap sortedMap;
    List fromUserToMarket;
    Map<int, int> newPosition;

    try {
      menuCode =
          shopCategory.where((el) => el.categoryGroupCode == code).toList();

      return Stack(children: [
        ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          controller: _controller,
          physics: ClampingScrollPhysics(),
          itemCount: menuCode.length == null ? 0 : menuCode.length,
          itemBuilder: (context, position) {
            var size = MediaQuery.of(context).size;
            newPosition = new Map();

            var alone;
            if (menuCode.length == 1) {
              alone = _coordinateDistance(
                  _currentLocation.latitude,
                  _currentLocation.longitude,
                  double.parse(menuCode[0].y),
                  double.parse(menuCode[0].x));

              newPosition[0] = 0;
            } else {
              for (int i = 0; i < menuCode.length; i++) {
                distance[i] = _coordinateDistance(
                    _currentLocation.latitude,
                    _currentLocation.longitude,
                    double.parse(menuCode[i].y),
                    double.parse(menuCode[i].x));
                sortedKeys = distance.keys.toList(growable: false)
                  ..sort((k1, k2) => int.parse(distance[k1])
                      .compareTo(int.parse(distance[k2])));

                sortedMap = new LinkedHashMap.fromIterable(sortedKeys,
                    key: (k) => k, value: (k) => distance[k]);
              }
              fromUserToMarket = sortedMap.values.toList();
            }

            return InkWell(
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
                            menuCode[position].placeUrl,
                            fit: BoxFit.fill,
                            width: 40.0,
                            height: 40.0,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 20),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width - 110,
                          child: Column(
                            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                menuCode[position].placeName,
                                style: TextStyle(fontSize: 18.0),
                              ),
                              Row(
                                verticalDirection: VerticalDirection.down,
                                children: [
                                  Text(
                                    menuCode[position].addressName,
                                    style: TextStyle(fontSize: 10.0),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 5, right: 5),
                                  ),
                                  ClipOval(
                                    child: Material(
                                      color: Colors.green,
                                      child: InkWell(
                                        onTap: () {},
                                        child: Icon(
                                          Icons.add,
                                          color: Colors.white,
                                          size: 15,
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
                                    padding: EdgeInsets.only(right: 3.0),
                                  ),
                                  Text(fromUserToMarket == null
                                      ? alone.length > 3
                                          ? '${(int.parse(alone) * 0.001).toStringAsFixed(1)}km'
                                          : '${alone}m'
                                      : fromUserToMarket[position].length > 3
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
                    print(category);
                  });
                });
          },
        ),
        Align(
          alignment: Alignment.topRight,
          child: FloatingActionButton(
              mini: true,
              onPressed: () {
                setState(() {
                  wellhada == true ? wellhada = false : wellhada = true;
                });
              },
              child: Icon(
                Icons.done_sharp,
                color: Colors.black,
              ),
              backgroundColor: wellhada == true ? Colors.yellow : Colors.white),
        ),
      ]);
    } catch (e) {
      return Center(child: CupertinoActivityIndicator());
    }
  }

  Widget _wellhadaView(String code) {
    List menuCode;

    List<int> sortedKeys;
    LinkedHashMap sortedMap;
    List fromUserToMarket;
    Map<int, int> newPosition = new Map();
    try {
      menuCode = shopCategory
          .where((el) => el.categoryGroupCode == code && el.wellhadaShop == "Y")
          .toList();

      return Stack(children: [
        ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          controller: _controller,
          physics: ClampingScrollPhysics(),
          itemCount: menuCode == null ? 0 : menuCode.length,
          itemBuilder: (context, position) {
            var size = MediaQuery.of(context).size;

            var alone;
            if (menuCode.length == 1) {
              alone = _coordinateDistance(
                  _currentLocation.latitude,
                  _currentLocation.longitude,
                  double.parse(menuCode[0].y),
                  double.parse(menuCode[0].x));

              newPosition[0] = 0;
            } else {
              for (int i = 0; i < menuCode.length; i++) {
                distance[i] = _coordinateDistance(
                    _currentLocation.latitude,
                    _currentLocation.longitude,
                    double.parse(menuCode[i].y),
                    double.parse(menuCode[i].x));
                // distance.removeWhere((key, value) => int.parse(value) > 2000);

                sortedKeys = distance.keys.toList(growable: false)
                  ..sort((k1, k2) => int.parse(distance[k1])
                      .compareTo(int.parse(distance[k2])));

                sortedMap = new LinkedHashMap.fromIterable(sortedKeys,
                    key: (k) => k, value: (k) => distance[k]);
              }

              fromUserToMarket = sortedMap.values.toList();
            }

            return InkWell(
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
                            menuCode[position].placeUrl,
                            fit: BoxFit.fill,
                            width: 40.0,
                            height: 40.0,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 20),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width - 110,
                          child: Column(
                            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                menuCode[position].placeName,
                                style: TextStyle(fontSize: 18.0),
                              ),
                              Row(
                                verticalDirection: VerticalDirection.down,
                                children: [
                                  Text(
                                    menuCode[position].addressName,
                                    style: TextStyle(fontSize: 10.0),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 5, right: 5),
                                  ),
                                  ClipOval(
                                    child: Material(
                                      color: Colors.green,
                                      child: InkWell(
                                        onTap: () {},
                                        child: Icon(
                                          Icons.add,
                                          color: Colors.white,
                                          size: 15,
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
                                    padding: EdgeInsets.only(right: 3.0),
                                  ),
                                  Text(fromUserToMarket == null
                                      ? alone.length > 3
                                          ? '${(int.parse(alone) * 0.001).toStringAsFixed(1)}km'
                                          : '${alone}m'
                                      : fromUserToMarket[position].length > 3
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
                    print(category);
                  });
                });
          },
        ),
        Align(
          alignment: Alignment.topRight,
          child: FloatingActionButton(
              mini: true,
              onPressed: () {
                setState(() {
                  wellhada == true ? wellhada = false : wellhada = true;
                });
              },
              child: Icon(
                Icons.done_sharp,
                color: Colors.black,
              ),
              backgroundColor: wellhada == true ? Colors.yellow : Colors.white),
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

          List<Widget> menuList = List<Widget>();
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

            menuView[i] = shopInfoList[i]["CATEGORY_CD"];
            menuList.add(_menuList(menuView[i]));

            wellhadaView[i] = shopInfoList[i]["CATEGORY_CD"];
            wellhadaList.add(_wellhadaView(wellhadaView[i]));
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 20, top: 10),
                // child: Text(widget.text,style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
              ),
              Container(
                  height: 20,
                  child: Padding(
                    padding: EdgeInsets.only(left: 4),
                    child: TabBar(
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.grey.shade400,
                      labelStyle:
                          TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                      unselectedLabelStyle:
                          TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
                      tabs: tabs,
                      controller: _tabController,
                      isScrollable: true,
                      indicatorWeight: 3,
                      indicatorColor: Colors.black,
                    ),
                  )),
              Expanded(
                child: TabBarView(
                    controller: _tabController,
                    children: wellhada == true ? wellhadaList : menuList
                    //  [
                    //   _menuList(menuView[_tabController.index]),
                    //   _menuList(menuView[_tabController.index]),
                    //   _menuList(menuView[_tabController.index]),
                    //   _menuList(menuView[_tabController.index]),
                    //   _menuList(menuView[_tabController.index]),
                    //   _menuList(menuView[_tabController.index]),
                    //   _menuList(menuView[_tabController.index]),
                    //   _menuList(menuView[_tabController.index]),
                    //   _menuList(menuView[_tabController.index]),
                    //   _menuList(menuView[_tabController.index]),
                    // ]
                    ),
              )
            ],
          );
        });
  }
}
