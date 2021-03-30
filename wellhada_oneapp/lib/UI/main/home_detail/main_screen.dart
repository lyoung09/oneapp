import 'dart:collection';
import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wellhada_oneapp/UI/banner/main_banner.dart';
import 'package:wellhada_oneapp/listitem/shop/shopInfoListItem.dart'
    as shopInfoListItem;
import 'package:hexcolor/hexcolor.dart';
import 'dart:math' show cos, sqrt, asin;

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  var appColor = '#ffffff';
  var menuColor = '#ffd428';
  var appFontColor = '#333333';
  var menuFontColor = '#333333';
  var userChk = "01";
  var category;
  List shop, shopCategory;
  TabController _tabController;
  int _tabindex = 0;
  Map<int, String> menuView = new Map();

  LatLng _currentLocation;
  Map<int, String> distance = new Map();
  Map<int, int> quickSortDistance = new Map();
  List<int> nearBy;
  // For storing the current position

  @override
  void initState() {
    _getCurrentLocation();
    getShop();
    getShopCategory();
    _tabController = new TabController(length: 9, vsync: this)
      ..addListener(() {});
    super.initState();
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
    return (12742 * asin(sqrt(a)) * 1000).toStringAsFixed(0);
  }

  _getCurrentLocation() async {
    Position geoPos;
    try {
      _currentLocation = LatLng(37.4835706, 126.8931126);

      geoPos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);

      _currentLocation = LatLng(geoPos.latitude, geoPos.longitude);
    } catch (e, stackTrace) {
      geoPos = await Geolocator.getLastKnownPosition();
      _currentLocation = LatLng(geoPos.latitude, geoPos.longitude);
      print(stackTrace);
    }
    return _currentLocation;
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
      shopCategory = shopCategoryList.list;
    });
  }

  bool isLastPage() {
    return _tabController.index == _tabController.length - 1;
  }

  //////////////quickSort////////////
  ///List<int> quickSort(List list, int low, int high) {
  List<int> quickSort(List list, int low, int high) {
    if (low < high) {
      int pi = partition(list, low, high);

      quickSort(list, low, pi - 1);
      quickSort(list, pi + 1, high);
    }

    return list;
  }

  int partition(List<int> list, low, high) {
    // Base check
    if (list.isEmpty) {
      return 0;
    }
    // Take our last element as pivot and counter i one less than low
    int pivot = list[high];

    int i = low - 1;
    for (int j = low; j < high; j++) {
      // When j is < than pivot element we increment i and swap arr[i] and arr[j]
      if (list[j] < pivot) {
        i++;
        swap(list, i, j);
      }
    }
    // Swap the last element and place in front of the i'th element
    swap(list, i + 1, high);
    return i + 1;
  }

// Swapping using a temp variable
  void swap(List list, int i, int j) {
    int temp = list[i];
    list[i] = list[j];
    list[j] = temp;
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
    List menuCode =
        shopCategory.where((el) => el.categoryGroupCode == code).toList();

    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      controller: _controller,
      physics: ClampingScrollPhysics(),
      itemCount: menuCode.length == null ? 0 : menuCode.length,
      itemBuilder: (context, position) {
        var sortedKeys;
        LinkedHashMap sortedMap;
        for (int i = 0; i < menuCode.length; i++) {
          distance[i] = _coordinateDistance(
              _currentLocation.latitude,
              _currentLocation.longitude,
              double.parse(menuCode[i].y),
              double.parse(menuCode[i].x));

          sortedKeys = distance.keys.toList(growable: false)
            ..sort((k1, k2) => distance[k1].compareTo(distance[k2]));
          sortedMap = new LinkedHashMap.fromIterable(sortedKeys,
              key: (k) => k, value: (k) => distance[k]);
        }

        var size = MediaQuery.of(context).size;
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
                              Text('${sortedMap[position]}m'),
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
    );
  }

  ScrollController _controller = new ScrollController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getShops(),
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Text("");
          }
          Map<String, dynamic> shopInfo = snapshot.data;

          List<dynamic> shopInfoList = shopInfo["LIST"];

          List<Tab> tabs = new List<Tab>();
          List<Widget> menuList = List<Widget>();

          for (int i = 0; i < shopInfoList.length; i++) {
            tabs.add(Tab(
              child: Text(
                shopInfoList[i]['CATEGORY_CDNM'],
                style: TextStyle(color: Colors.black),
              ),
            ));
            menuView[i] = shopInfoList[i]["CATEGORY_CD"];
            menuList.add(_menuList(menuView[i]));
          }

          void setstates() async {
            _menuList("MT1");
          }

          setstates();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 20, top: 10),
                // child: Text(widget.text,style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
              ),
              Container(
                height: 20,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount:
                        shopInfoList == null ? null : shopInfoList.length,
                    itemBuilder: (context, position) {
                      return Padding(
                        padding: EdgeInsets.only(left: 4),
                        child: DefaultTabController(
                          length: shopInfoList.length,
                          child: TabBar(
                            labelColor: Colors.black,
                            unselectedLabelColor: Colors.grey.shade400,
                            labelStyle: TextStyle(
                                fontSize: 11, fontWeight: FontWeight.w500),
                            unselectedLabelStyle: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.w500),
                            tabs: tabs,
                            controller: _tabController,
                            isScrollable: true,
                            indicatorWeight: 3,
                            indicatorColor: Colors.black,
                          ),
                        ),
                      );
                    }),
              ),
              Expanded(
                child: TabBarView(controller: _tabController, children: menuList
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
              ),
            ],
          );
        });
  }
}
