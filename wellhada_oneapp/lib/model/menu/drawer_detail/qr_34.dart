import 'package:async/async.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hexcolor/hexcolor.dart';

import '../drawer_menu.dart';

class QR_34 extends StatefulWidget {
  final int TabType;
  QR_34(this.TabType);

  @override
  _QR_34State createState() => _QR_34State(TabType);
}

class _QR_34State extends State<QR_34> {
  int TabType;
  final AsyncMemoizer _memoizer = AsyncMemoizer();
  _QR_34State(this.TabType);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  var appId;
  var accessToken;
  var userId;
  var stampCnt;

  bool _isButtonDisabled;
  int _selectedIndex = 1;

  var categoryItems;
  List stampItems = null;
  String userName;
  String _scanBarcode = 'Unknown';

  final TextEditingController couponCnt = TextEditingController(text: '');
  final TextEditingController resonText = TextEditingController(text: '');

  @override
  void initState() {
    super.initState();
    _isButtonDisabled = true;

    getAdminStampList();
  }

  Future<void> getAdminStampList() async {
    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();

    appId = prefs.getString("appId");
    accessToken = prefs.getString("accessToken");

    print(_selectedIndex.toString());

    // final goodsList = await cafeData.getAdminStampList(userScSeq,accessToken,_selectedIndex.toString());

    // setState(() {

    //   stampItems = goodsList.LIST;

    // });
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.QR);
    } on PlatformException {
      barcodeScanRes = 'Unknown';
    }

    if (!mounted) return;
    setState(() {
      if (barcodeScanRes == 'Unknown' || barcodeScanRes == "-1") {
      } else {
        _scanBarcode = barcodeScanRes;

        //  _userInfo(_scanBarcode);
      }
    });
  }

  // _userInfo(scanBarcode) async{
  //   final userInfo = await cafeData.getAdminUserStampUserInfo(userScSeq, "", "", scanBarcode, "Q");

  //   SharedPreferences prefs;
  //   prefs = await SharedPreferences.getInstance();

  //   setState(() {

  //     prefs.setString("scanBarcode",scanBarcode);

  //     userName =  userInfo.USER_NAME;
  //     stampCnt = userInfo.CNT;

  //     Navigator.of(context).pushReplacement(MaterialPageRoute(
  //         builder: (BuildContext context) {
  //           return new CafeAdminSelect(AppTitle, TabType, stampCnt, userScSeq, userName, "Q", userId, appColor, menuColor, appFontColor);
  //         },
  //         fullscreenDialog: true
  //     ));
  //   });

  // }

  @override
  void dispose() {
    super.dispose();
  }

  getInitData() async {
    return this._memoizer.runOnce(() async {
      SharedPreferences prefs;
      prefs = await SharedPreferences.getInstance();

      appId = prefs.getString("appId");
      userName = prefs.getString("userName");

      accessToken = prefs.getString("accessToken");

      //값이 박혀 있음
      // final goodsList = await cafeData.getAdminStampList(userScSeq,accessToken,_selectedIndex.toString());

      // setState(() {

      //   stampItems = goodsList.LIST;

      // });
    });
  }

  _onSelected(int index) {
    setState(() {
      TabType = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      drawer: DRAWER_MENU(),
      body: FutureBuilder(
        future: getInitData(),
        builder: (context, snapshot) {
          return Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 95.0),
                  ),
                  Container(
                    color: Colors.white,
                    height: 45.0,
                    width: size.width,
                    padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        InkWell(
                          onTap: () => _onSelected(1),
                          child: Container(
                            width: size.width / 2,
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Container(
                                    height: 29.5,
                                    padding: const EdgeInsets.only(
                                        left: 10.0, right: 10.0),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                            width: 2.0,
                                            color: TabType == 1
                                                ? Hexcolor('#FFD428')
                                                : Hexcolor('#707070')),
                                      ),
                                      color: Colors.white,
                                    ),
                                    child: Center(
                                      child: Text(
                                        'QR 스캔',
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          color: Colors.black,
                                          fontFamily: "Sans",
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () => _onSelected(2),
                          child: Container(
                            width: size.width / 2,
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Container(
                                    height: 29.5,
                                    padding: const EdgeInsets.only(
                                        left: 10.0, right: 10.0),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                            width: 2.0,
                                            color: TabType == 1
                                                ? Hexcolor('#707070')
                                                : Hexcolor('#FFD428')),
                                      ),
                                      color: Colors.white,
                                    ),
                                    child: Center(
                                      child: Text(
                                        '적립현황',
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          color: Colors.black,
                                          fontFamily: "Sans",
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      child: TabType == 1
                          ? Container(
                              padding: EdgeInsets.only(top: 100.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  InkWell(
                                    onTap: () {
                                      scanQR();
                                    },
                                    child: Container(
                                      height: 40.0,
                                      width: size.width / 2,
                                      decoration: BoxDecoration(
                                        color: _isButtonDisabled == false
                                            ? Hexcolor('#6D6B6B')
                                            : Hexcolor('#FFD428'),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'QR 스캔',
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.black,
                                            fontFamily: "Sans",
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 20.0),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      print(1);
                                    },
                                    child: Container(
                                      height: 40.0,
                                      width: size.width / 2,
                                      decoration: BoxDecoration(
                                        color: _isButtonDisabled == false
                                            ? Hexcolor('#6D6B6B')
                                            : Hexcolor('#FFD428'),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Center(
                                        child: Text(
                                          '문자입력',
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.black,
                                            fontFamily: "Sans",
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding:
                                        EdgeInsets.only(top: 50.0, left: 20.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Text(
                                              "- 10개의 스탬프가 모이면 쿠폰이 발행 됩니다.",
                                              style: TextStyle(
                                                color: Hexcolor('#242A37'),
                                                fontSize: 13.0,
                                                fontFamily: "Sans",
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Text(
                                              "- 적립 후 통신상황에 따라 확인 시간이 발생 할 수 있습니다.",
                                              style: TextStyle(
                                                color: Hexcolor('#242A37'),
                                                fontSize: 13.0,
                                                fontFamily: "Sans",
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Container(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: 10.0, bottom: 10.0),
                                    width: size.width - 50,
                                    height: 35.0,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              _selectedIndex = 1;
                                              if (stampItems != null) {
                                                stampItems.clear();
                                              }
                                              getAdminStampList();
                                            });
                                          },
                                          child: Container(
                                            decoration: _selectedIndex == 1
                                                ? BoxDecoration(
                                                    border: Border.all(
                                                        color: Hexcolor(
                                                            '#707070')),
                                                    color: Hexcolor('#FFD428'),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.0),
                                                  )
                                                : BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.0),
                                                  ),
                                            width: (size.width - 50) / 3,
                                            child: Center(
                                              child: Text(
                                                "1개월",
                                                style: TextStyle(
                                                  color: Hexcolor('#242A37'),
                                                  fontSize: 15.0,
                                                  fontFamily: "Sans",
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              _selectedIndex = 6;

                                              if (stampItems != null) {
                                                stampItems.clear();
                                              }
                                              getAdminStampList();
                                            });
                                          },
                                          child: Container(
                                            decoration: _selectedIndex == 6
                                                ? BoxDecoration(
                                                    border: Border.all(
                                                        color: Hexcolor(
                                                            '#707070')),
                                                    color: Hexcolor('#FFD428'),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.0),
                                                  )
                                                : BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.0),
                                                  ),
                                            width: (size.width - 50) / 3,
                                            child: Center(
                                              child: Text(
                                                "6개월",
                                                style: TextStyle(
                                                  color: Hexcolor('#242A37'),
                                                  fontSize: 15.0,
                                                  fontFamily: "Sans",
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              _selectedIndex = 12;
                                              if (stampItems != null) {
                                                stampItems.clear();
                                              }
                                              getAdminStampList();
                                            });
                                          },
                                          child: Container(
                                            decoration: _selectedIndex == 12
                                                ? BoxDecoration(
                                                    border: Border.all(
                                                        color: Hexcolor(
                                                            '#707070')),
                                                    color: Hexcolor('#FFD428'),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.0),
                                                  )
                                                : BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.0),
                                                  ),
                                            width: (size.width - 50) / 3,
                                            child: Center(
                                              child: Text(
                                                "12개월",
                                                style: TextStyle(
                                                  color: Hexcolor('#242A37'),
                                                  fontSize: 15.0,
                                                  fontFamily: "Sans",
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: ListView.builder(
                                        itemCount: stampItems == null
                                            ? 0
                                            : stampItems.length,
                                        itemBuilder: (context, position) {
                                          return Container(
                                            width: size.width,
                                            decoration: BoxDecoration(),
                                            child: Column(
                                              children: <Widget>[
                                                Container(
                                                  margin: EdgeInsets.all(5.0),
                                                  width: size.width - 60,
                                                  height: 50.0,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Hexcolor(
                                                            '#707070')),
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.0),
                                                  ),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: <Widget>[
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Text(
                                                            "${stampItems[position].REG_DATE}",
                                                            style: TextStyle(
                                                              color: Hexcolor(
                                                                  '#242A37'),
                                                              fontSize: 12.0,
                                                              fontFamily:
                                                                  "Sans",
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 3.0),
                                                          ),
                                                          Text(
                                                            "${stampItems[position].USER_NAME}",
                                                            style: TextStyle(
                                                              color: Hexcolor(
                                                                  '#242A37'),
                                                              fontSize: 12.0,
                                                              fontFamily:
                                                                  "Sans",
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Text(
                                                        "${stampItems[position].STAMP_CNT}" +
                                                            "개",
                                                        style: TextStyle(
                                                          color: Hexcolor(
                                                              '#242A37'),
                                                          fontSize: 12.0,
                                                          fontFamily: "Sans",
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                ],
              ),
              new Container(
                color: Hexcolor('#F1F2F6'),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        //appbar에서 말고 사이드 메뉴 불러오는 방법
                        _scaffoldKey.currentState.openDrawer();
                      },
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: 45.0, left: 20.0, right: 20.0, bottom: 20.0),
                        child: Icon(
                          Icons.menu,
                          size: 30.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 30.0, right: 20.0),
                      child: Text(
                        '#스토리',
                        style: TextStyle(
                            fontFamily: 'Godo',
                            fontWeight: FontWeight.w900,
                            fontSize: 27.0,
                            color: Hexcolor('#333333')),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: 45.0, left: 20.0, right: 20.0, bottom: 20.0),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
