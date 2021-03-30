import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:wellhada_oneapp/listitem/banner/topBannerItem.dart'
    as topbanner;
import 'package:wellhada_oneapp/listitem/banner/topBannerItem.dart';

import 'package:cached_network_image/cached_network_image.dart';

class TopBanner extends StatefulWidget {
  @override
  _TopBannerState createState() => _TopBannerState();
}

class _TopBannerState extends State<TopBanner> {
  List banner;
  int _currentPage = 0;
  PageController _pageController = PageController(
    initialPage: 0,
  );

  Timer _tim;
  void initState() {
    getShowAppBar();
    //data = a();
    super.initState();
    animation();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  animation() {
    _tim = Timer.periodic(Duration(seconds: 5), (Timer timer) {
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

  @override
  void dispose() {
    _tim?.cancel();
    super.dispose();
    getShowAppBar();
  }

  Future<void> getShowAppBar() async {
    final bannerList = await topbanner.getAppbarList();
    setState(() {
      banner = bannerList.list;
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
                        // Image.asset("${banner[index].fileUrl}",
                        //     fit: BoxFit.cover,
                        //     height: double.infinity,
                        //     width: double.infinity,
                        //     alignment: Alignment.center),
                        new CachedNetworkImage(
                          fit: BoxFit.fill,
                          height: double.infinity,
                          width: double.infinity,
                          //alignment: Alignment.,
                          imageUrl: banner[index].fileUrl,

                          errorWidget: (context, url, error) =>
                              new Icon(Icons.error),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            "${banner[index].bannerTitle}",
                            style: TextStyle(
                              fontFamily: "Sans",
                              fontSize: 20.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            );
          }),
    );
  }
}
