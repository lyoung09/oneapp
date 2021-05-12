import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wellhada_oneapp/UI/banner/top_banner.dart';

import 'package:provider/provider.dart';

import 'package:location_permissions/location_permissions.dart';

import 'home_detail/list_screen.dart';
import 'home_detail/mapUI/map.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  TabController _tabController;
  double lat, lng;
  int _selectedTab;
  LatLng _currentLocation;
  bool provideLocation = false;
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
              color: (_selectedTab == index ? Colors.white : Colors.grey[200]),
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
      return BorderRadius.only(
        bottomRight: Radius.circular(10.0),
        topLeft: Radius.circular(10.0),
        topRight: Radius.circular(10.0),
        bottomLeft: Radius.circular(10.0),
      );
    else if ((index - 1) == _selectedTab)
      return BorderRadius.only(bottomLeft: Radius.circular(10.0));
    else
      return BorderRadius.zero;
  }

  _getCurrentLocation() async {
    Position geoPos;

    try {
      geoPos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);

      _currentLocation = LatLng(geoPos.latitude, geoPos.longitude);
      setState(() {
        provideLocation = !provideLocation;
      });
    } catch (e, stackTrace) {
      //try {
      setState(() {
        provideLocation = !provideLocation;
      });
      // geoPos = await Geolocator.getLastKnownPosition();
      // if (geoPos == null) {
      _currentLocation = LatLng(37.49152820899407, 127.07285755753348);
      // }
      // _currentLocation = LatLng(geoPos.latitude, geoPos.longitude);
      // } catch (e) {
      //   _currentLocation = LatLng(37.49152820899407, 127.07285755753348);
      //   setState(() {
      //     provideLocation = !provideLocation;
      //   });
      //}
    }
    // build(this.context);

    //Navigator.of(this.context, rootNavigator: true).pop(this.context);
    // Navigator.of(context)
    //     .pushNamedAndRemoveUntil('', ModalRoute.withName('/'));

    //Navigator.of(context).pushReplacementNamed('/BottomNav');

    // Navigator.popAndPushNamed(context, '/BottomNav');
    //
  }

  _initLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      lat = prefs.getDouble("lat");
      lng = prefs.getDouble("lng");
    });
    _currentLocation = LatLng(lat, lng);
  }

  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: _currentLocation,
      updateShouldNotify: (oldValue, newValue) => newValue != oldValue,
      child: Center(
        child: Container(
          child: Column(
            children: <Widget>[
              PreferredSize(
                preferredSize:
                    Size.fromHeight(MediaQuery.of(context).size.height * 0.02),
                child: AppBar(
                  centerTitle: true,
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.black,
                  title: Center(
                      child: Text(
                    '# 스토리',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w900),
                  )),
                  actions: <Widget>[
                    provideLocation
                        ? FittedBox(
                            fit: BoxFit.scaleDown,
                            child: CircularProgressIndicator(
                              valueColor: new AlwaysStoppedAnimation<Color>(
                                  Colors.white),
                            ),
                          )
                        : IconButton(
                            icon: SvgPicture.asset(
                              'assets/svg/location.svg',
                              width: 15.0,
                              height: 20.0,
                            ),
                            onPressed: () {
                              _getCurrentLocation();
                              setState(() {
                                provideLocation = !provideLocation;
                              });
                            },
                          ),
                  ],
                ),
              ),
              Container(
                  height: MediaQuery.of(context).size.height * 0.115,
                  width: MediaQuery.of(context).size.width,
                  child: TopBanner()),
              TabBar(
                //unselectedLabelColor: Colors.grey[850],
                //labelColor: Colors.grey[300],
                //indicatorColor: Colors.grey[300],
                indicatorColor: Colors.black,
                labelColor: Colors.black,

                controller: _tabController,
                labelPadding: const EdgeInsets.all(0.0),

                tabs: [
                  _getTab(
                      0,
                      Center(
                          child: Text(
                        "리스트로 보기",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 17.5,
                            fontFamily: 'nanumB',
                            color: Colors.black,
                            fontWeight: FontWeight.w700),
                      ))),
                  _getTab(
                      1,
                      Center(
                          child: Text(
                        "지도로 보기",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 17.5,
                            fontFamily: 'nanumB',
                            color: Colors.black,
                            fontWeight: FontWeight.w700),
                      ))),
                ],
              ),
              Expanded(
                child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: _tabController,
                  children: [
                    ListScreen(),
                    GoogleMapUI(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
