import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wellhada_oneapp/UI/banner/top_banner.dart';
import 'package:wellhada_oneapp/UI/mapUI/map.dart';
import 'package:provider/provider.dart';

import 'home_detail/main_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  TabController _tabController;
  var lat, lng;
  int _selectedTab;
  LatLng _currentLocation;
  GlobalKey refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    _initLocation();
    _tabController = TabController(vsync: this, length: 2);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          _selectedTab = _tabController.index;
        });
      }
    });
  }

  _getTab(index, child) {
    return Tab(
      child: SizedBox.expand(
        child: Container(
          child: child,
          decoration: BoxDecoration(
              color:
                  (_selectedTab == index ? Colors.white : Colors.grey.shade300),
              borderRadius: _generateBorderRadius(index)),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();

    super.dispose();
  }

  _generateBorderRadius(index) {
    if ((index + 1) == _selectedTab)
      return BorderRadius.only(bottomRight: Radius.circular(10.0));
    else if ((index - 1) == _selectedTab)
      return BorderRadius.only(bottomLeft: Radius.circular(10.0));
    else
      return BorderRadius.zero;
  }

  Future _getCurrentLocation() async {
    Position geoPos;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      geoPos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);

      prefs.setDouble("lat", geoPos.latitude);
      prefs.setDouble("lng", geoPos.longitude);
    } catch (e, stackTrace) {
      geoPos = await Geolocator.getLastKnownPosition();

      prefs.setDouble("lat", geoPos.latitude);
      prefs.setDouble("lng", geoPos.longitude);
      print(stackTrace);
    }

    // Navigator.of(context)
    //     .pushNamedAndRemoveUntil('', ModalRoute.withName('/'));
    //Navigator.of(context).pushReplacementNamed('/BottomNav').whenComplete();
  }

  //@override
  // void didUpdateWidget(covariant HomeScreen oldWidget) {
  //   // TODO: implement didUpdateWidget
  //   super.didUpdateWidget(oldWidget);
  //   _getCurrentLocation();
  //   _tabController = TabController(vsync: this, length: 2);
  //   _tabController.addListener(() {
  //     if (!_tabController.indexIsChanging) {
  //       setState(() {
  //         _selectedTab = _tabController.index;
  //       });
  //     }
  //   });
  // }

  _initLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    lat = prefs.getDouble("lat");
    lng = prefs.getDouble("lng");
    _currentLocation = LatLng(lat, lng);
    return _currentLocation;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Column(
          children: <Widget>[
            PreferredSize(
              preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.02),
              child: AppBar(
                title: Center(
                    child: Text(
                  '# 스토리',
                  style: TextStyle(color: Colors.black),
                )),
                actions: <Widget>[
                  RefreshIndicator(
                    onRefresh: _getCurrentLocation,
                    child: IconButton(
                      icon: Icon(
                        Icons.location_on_outlined,
                        color: Colors.black,
                      ),
                      onPressed: _getCurrentLocation,
                    ),
                  )
                ],
                backgroundColor: Colors.white,
              ),
            ),
            Container(
                height: MediaQuery.of(context).size.height * 0.115,
                width: MediaQuery.of(context).size.width,
                child: TopBanner()),
            TabBar(
              unselectedLabelColor: Colors.black,
              labelColor: Colors.blue,
              indicatorColor: Colors.white,
              controller: _tabController,
              labelPadding: const EdgeInsets.all(0.0),
              tabs: [
                _getTab(
                    0,
                    Center(
                        child: Text(
                      "리스트로 보기",
                      textAlign: TextAlign.center,
                    ))),
                _getTab(
                    1,
                    Center(
                        child: Text(
                      "지도로 보기",
                      textAlign: TextAlign.center,
                    ))),
              ],
            ),
            Expanded(
              child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                controller: _tabController,
                children: [
                  MainScreen(),
                  GoogleMapUI(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
