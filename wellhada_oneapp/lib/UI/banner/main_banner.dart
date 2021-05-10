import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wellhada_oneapp/listitem/banner/TopBannerItem.dart'
    as TopBanner;
import 'package:wellhada_oneapp/listitem/banner/TopBannerItem.dart';

class MainBanner extends StatefulWidget {
  @override
  _MainBannerState createState() => _MainBannerState();
}

class _MainBannerState extends State<MainBanner> {
  List banner;
  int _currentPage = 0;
  PageController _pageController = PageController(
    initialPage: 0,
  );
  void initState() {
    getShowAppBar();
    //data = a();
    super.initState();
    Timer.periodic(Duration(seconds: 5), (Timer timer) {
      if (_currentPage < banner.length) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 350),
        curve: Curves.easeIn,
      );
    });
  }

  Future<void> getShowAppBar() async {
    final bannerList = await TopBanner.getAppbarList();
    setState(() {
      banner = bannerList.list;
      print(banner);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.2,
      width: MediaQuery.of(context).size.width,
      child: PageView.builder(
          controller: _pageController,
          scrollDirection: Axis.horizontal,
          itemCount: banner == null ? 0 : banner.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.8,
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Stack(
                      children: [
                        Image.asset("assets/img/cafe.png",
                            //${banner[index].fileUrl}
                            fit: BoxFit.cover,
                            height: double.infinity,
                            width: double.infinity,
                            alignment: Alignment.center),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                            "${banner[index].bannerTitle}",
                            style: TextStyle(
                              fontFamily: "nanumB",
                              fontSize: 20.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Text(
                            "${banner[index].bannerType}",
                            style: TextStyle(
                              fontFamily: "nanumR",
                              fontSize: 10.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      ],
                    ),
                  )),
            );
          }),
    );
  }
}
