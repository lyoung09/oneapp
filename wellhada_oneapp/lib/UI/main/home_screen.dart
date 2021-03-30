import 'package:flutter/material.dart';
import 'package:wellhada_oneapp/UI/banner/top_banner.dart';
import 'package:wellhada_oneapp/UI/mapUI/map1.dart';

import 'home_detail/main_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  int _selectedTab;

  @override
  void initState() {
    super.initState();
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

  _generateBorderRadius(index) {
    if ((index + 1) == _selectedTab)
      return BorderRadius.only(bottomRight: Radius.circular(10.0));
    else if ((index - 1) == _selectedTab)
      return BorderRadius.only(bottomLeft: Radius.circular(10.0));
    else
      return BorderRadius.zero;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                Google1MapUI(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
