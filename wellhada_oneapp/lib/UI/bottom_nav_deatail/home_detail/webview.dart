// @dart=2.9
import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:bootpay_webview_flutter/webview_flutter.dart';
import 'package:bootpay_api/model/bio_payload.dart';

import 'package:bootpay_api/model/bio_price.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:bootpay_api/bootpay_api.dart';
import 'package:bootpay_api/model/payload.dart';
import 'package:bootpay_api/model/user.dart';
import 'package:bootpay_api/model/item.dart';
import 'package:webview_flutter/platform_interface.dart';
import 'package:wellhada_oneapp/UI/main/bottom_detail/usage_history.dart';
import 'package:wellhada_oneapp/UI/main/bottom_nav.dart';
import 'package:wellhada_oneapp/listitem/shop/shopFavorite.dart' as favorite;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:wellhada_oneapp/listitem/shop/web.dart' as webLogin;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:wellhada_oneapp/listitem/userFile/userList.dart' as userList;
import 'package:wellhada_oneapp/listitem/shop/web.dart' as webItemList;

class goToWebView extends StatelessWidget {
  String userPassword, userChk, userId, placeName, number;
  int shopSeq;
  var list;

  @override
  Widget build(BuildContext context) {
    list = ModalRoute.of(context).settings.arguments;

    placeName = list['placeName'];
    shopSeq = list['shopSeq'];
    userPassword = list['userPassword'];
    userChk = list['userChk'];
    userId = list['userId'];
    number = list['number'];
    return WebViewContainer(
        placeName, shopSeq, userId, userPassword, userChk, number);
  }
}

class WebViewContainer extends StatefulWidget {
  final placeName;
  final shopSeq;
  final userId;
  final userPassword;
  final userChk;
  final number;

  WebViewContainer(this.placeName, this.shopSeq, this.userId, this.userPassword,
      this.userChk, this.number);
  @override
  createState() => _WebViewContainerState(this.placeName, this.shopSeq,
      this.userId, this.userPassword, this.userChk, this.number);
}

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(backgroundColor: Colors.lightBlue);
  }
}

class _WebViewContainerState extends State<WebViewContainer> {
  var placeName;
  var _url;
  final _key = UniqueKey();
  String _value = '0';
  bool _isFavorite = false;
  String userName, userPassword, userChk, userId, number;
  int shopSeq;
  bool userLogin;
  int paySitu;

  _WebViewContainerState(this.placeName, this.shopSeq, this.userId,
      this.userPassword, this.userChk, this.number);
  num position = 1;
  doneLoading() {
    setState(() {
      position = 0;
    });
  }

  bool _favorite;
  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  void initState() {
    super.initState();

    check();
    checkFavorite();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  var userEmail, phone, birthday, birthdayJson;

  checkFavorite() async {
    return favorite.getFavorite(userId);
  }

  check() async {
    final userData = await userList.getUserInfomation(userId);

    userName = userData.userName;
    userData.userEmail == null
        ? userEmail = userId
        : userEmail = userData.userEmail;
    birthdayJson = userData.birthday;
    birthdayJson == "" || birthdayJson == null
        ? birthday = ""
        : birthday = '${birthdayJson.substring(2, 8)}';

    userData.userPhoneNumber == null
        ? phone = ""
        : phone = userData.userPhoneNumber;
  }

  startLoading() {
    setState(() {
      position = 1;
    });
  }

  insertFavorite(userId, shopSeq) async {
    final saveFavorite = await favorite.saveFavoriteShop(userId, shopSeq);

    if (this.mounted) {
      setState(() {
        print('save ============================${saveFavorite.cnt}');
      });
      showDialog(
          context: context,
          builder: (_) => CupertinoAlertDialog(
                content: Text("즐겨찾기 목록에 추가되었습니다."),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text('확인'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ));
    }
  }

  deleteFavorite(userId, shopSeq) async {
    final deleteFavorite = await favorite.deleteFavoriteShop(userId, shopSeq);

    if (this.mounted) {
      setState(() {
        print('delete ============================${deleteFavorite.cnt}');
      });
      showDialog(
          context: context,
          builder: (_) => CupertinoAlertDialog(
                content: Text("즐겨찾기 목록에서 삭제되었습니다."),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text('확인'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ));
    }
  }

  bool ordering;
  var pgUserName, pgUserEmail, pgUserPhone, itemName, uniqueId;
  sendDataToPay(payData) {
    if (payData.isEmpty || payData == null) {
    } else {
      var action = "loading";
      // Here you can write your code for open new view
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => new Bill(payData, number, action, placeName,
              shopSeq, userId, userPassword, userChk)));
    }
  }

  double opacity = 0.0;
  WebViewController _webViewController;

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    //SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amberAccent[400],
        automaticallyImplyLeading: false,
        title: Text(
          "${placeName}",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          FutureBuilder(
            future: checkFavorite(),
            builder: (context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CupertinoActivityIndicator());
              }
              Map<String, dynamic> favoriteInfo = snapshot.data;
              List<dynamic> favoriteInfoList = favoriteInfo["LIST"];

              bool checkShopFav;
              var x = favoriteInfoList
                  .where((element) =>
                      element['FAVORITE_YN'] == 'Y' &&
                      element['SHOP_SEQ'] == shopSeq)
                  .toList();
              if (x == null || x == "" || x.isEmpty) {
                _isFavorite = false;
              } else {
                _isFavorite = true;
              }
              return new DropdownButtonHideUnderline(
                  child: new IconButton(
                icon: Icon(
                  Icons.star,
                  color: _isFavorite == true ? Colors.red[400] : Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    _isFavorite = !_isFavorite;

                    _isFavorite == true
                        ? insertFavorite(userId, shopSeq)
                        : deleteFavorite(userId, shopSeq);
                  });
                },
              ));
            },
          )
        ],
      ),
      body: Column(children: <Widget>[
        Expanded(
            child: Builder(
                builder: (secondContext) => WebView(
                      key: _key,
                      javascriptMode: JavascriptMode.unrestricted,
                      onWebViewCreated: (WebViewController controller) {
                        _webViewController = controller;

                        _controller.complete(_webViewController);
                      },
                      onPageFinished: (c) {
                        // _webViewController.canGoBack();
                        // _controller.complete(_webViewController);
                      },
                      allowsInlineMediaPlayback: true,
                      gestureNavigationEnabled: true,
                      debuggingEnabled: true,
                      initialUrl:
                          'http://hndsolution.iptime.org:8086/usermngr/shopTmplatView.do?user_id=${userId}&user_password=${userPassword}&shop_seq=${shopSeq}&user_chk=${userChk}',
                      javascriptChannels: [
                        JavascriptChannel(
                            name: 'CHANNEL_NAME',
                            onMessageReceived: (message) {
                              sendDataToPay(message.message);
                              message = null;
                            }),
                      ].toSet(),
                    ))),
      ]),
    );
  }
}

class Bill extends StatefulWidget {
  final payData;
  final placeName;

  final shopSeq;
  final userId;
  final userPassword;
  final userChk;
  final number;
  final action;

  Bill(
    this.payData,
    this.number,
    this.action,
    this.placeName,
    this.shopSeq,
    this.userId,
    this.userPassword,
    this.userChk,
  );
  @override
  _BillState createState() => _BillState(
        this.payData,
        this.number,
        this.action,
        this.placeName,
        this.shopSeq,
        this.userId,
        this.userPassword,
        this.userChk,
      );
}

class _BillState extends State<Bill> {
  var payData, number, action;
  var placeName, shopSeq, userId, userPassword, userChk;
  _BillState(
    this.payData,
    this.number,
    this.action,
    this.placeName,
    this.shopSeq,
    this.userId,
    this.userPassword,
    this.userChk,
  );
  initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: 200), () {
      payment(context, payData);
    });
    Future.delayed(Duration(milliseconds: 300), () {
      tt();
    });
  }

  //3초 뒤부터 cancel <- 유저가 뒤로넘겨버리면 취소화면띄움
  tt() async {
    setState(() {
      action = "cancel";
    });
  }

  var itemName, uniqueId, pgUserName, pgUserEmail, pgUserPhone;
  payment(context, payData) async {
    // print('payData ${payData}');
    var data = payData.split(',');
    var t;
    Map<dynamic, dynamic> mapPayData = new Map();
    for (int i = 0; i < data.length; i++) {
      t = data[i].split(":");
      mapPayData[t[0]] = t[1];
    }

    // wantedParts = data[0].split(':');
    // price = [wantedParts.removeAt(0), wantedParts.join(":")];
    // wantedParts = data[1].split(':');
    // name = [wantedParts.removeAt(0), wantedParts.join(":")];
    // wantedParts = data[2].split(':');
    // itemName = [wantedParts.removeAt(0), wantedParts.join(":")];
    // wantedParts = data[3].split(':');
    // pg = [wantedParts.removeAt(0), wantedParts.join(":")];
    // wantedParts = data[4].split(':');
    // quantity = [wantedParts.removeAt(0), wantedParts.join(":")];
    // wantedParts = data[5].split(':');
    // uniqueId = [wantedParts.removeAt(0), wantedParts.join(":")];
    // wantedParts = data[6].split(':');
    // appId = [wantedParts.removeAt(0), wantedParts.join(":")];
    // wantedParts = data[7].split(':');
    // orderId = [wantedParts.removeAt(0), wantedParts.join(":")];
    // wantedParts = data[8].split(':');
    // pgUserName = [wantedParts.removeAt(0), wantedParts.join(":")];
    // wantedParts = data[9].split(':');
    // pgUserEmail = [wantedParts.removeAt(0), wantedParts.join(":")];
    // wantedParts = data[10].split(':');
    // pgUserPhone = [wantedParts.removeAt(0), wantedParts.join(":")];

    // print(mapPayData['price']);
    // print(mapPayData['name']);
    // print(mapPayData['item_name']);
    // print(mapPayData['pg']);
    // print(mapPayData['qty']);
    // print(mapPayData['unique']);
    // print(mapPayData['app_id']);
    // print(mapPayData['order_id']);
    // print(mapPayData['username']);
    // print(mapPayData['email']);
    // print(mapPayData['phone']);

    goBootpayRequest(
        context,
        mapPayData['price'],
        mapPayData['name'],
        mapPayData['item_name'],
        mapPayData['pg'],
        mapPayData['qty'],
        mapPayData['unique'],
        mapPayData['order_id'],
        mapPayData['app_id'],
        mapPayData['username'],
        mapPayData['email'],
        mapPayData['phone']);
  }

  goBootpayRequest(BuildContext context, price, name, itemName, pg, quantity,
      uniqueId, orderId, appId, pgUserName, pgUserEmail, pgUserPhone) async {
    Item paymentItem = Item();
    paymentItem.itemName = itemName; // 주문정보에 담길 상품명
    paymentItem.qty = int.parse(quantity); // 해당 상품의 주문 수량
    paymentItem.unique = uniqueId; // 해당 상품의 고유 키
    paymentItem.price = double.parse(price); // 상품의 가격

    List<Item> paymentItemList = [paymentItem];

    Payload payload = Payload();
    payload.name = name;
    //payload.applicationId = androidAppid;
    //android 아이디는 13 ios 아이디는 14로 끝남
    var android = "608a4a845b2948002107c213";
    var ios = "608a4a845b2948002107c214";
    payload.applicationId = android;

    payload.androidApplicationId = android;
    payload.iosApplicationId = ios;

    payload.pg = pg;
    //payload.method = 'card';
    // payload.methods = ['card', 'phone', 'vbank', 'bank'];
    payload.name = name;
    payload.price = double.parse(price); //정기결제시 0 혹은 주석
    payload.orderId = orderId;
    // payload.params = {
    //   "callbackParam1": "value12",
    //   "callbackParam2": "value34",
    //   "callbackParam3": "value56",
    //   "callbackParam4": "value78",
    // };
//    payload.us

    User paymentUser = User();
    paymentUser.username = pgUserName;
    paymentUser.email = pgUserEmail;
    paymentUser.phone = pgUserPhone;
    // paymentUser.username = pgUserName;
    // paymentUser.email = pgUserEmail;
    // paymentUser.phone = pgUserPhone;

    // Extra extra = Extra();
    // extra.appScheme = 'bootpayFlutterSample';
    // extra.quotas = [0, 2, 3];
    // extra.popup = 1;
    // extra.quick_popup = 1;

    BootpayApi.request(
      context,
      payload,

      //extra: extra,
      user: paymentUser,
      items: paymentItemList,

      onDone: (json) {
        goToPayment(json);

        action = "finish";
        //getUserToken(appId);
      },

      onCancel: (json) {
        print('--- onCancel: $json');
        action = "cancel";
      },

      onError: (json) {
        print(' --- onError: $json');
        action = "cancel";
      },
    );
  }

  goToPayment(jsonData) async {
    Map<String, dynamic> mapJson = new Map();

    mapJson = json.decode(jsonData);

    // var action = mapJson["action"];
    // var receipt_id = mapJson['receipt_id'];

    // var price = mapJson['price'];

    // var card_code = mapJson['card_code'];

    // var card_no = mapJson['card_no'];

    // var card_name = mapJson['card_name'];

    // var card_quota = mapJson['card_quota'];

    // var receipt_url = mapJson['receipt_url'];

    // var item_name = mapJson['item_name'];

    // var order_id = mapJson['order_id'];

    // var url = mapJson['url'];

    // var tax_free = mapJson['tax_free'];

    // var payment_name = mapJson['payment_name'];

    // var pg_name = mapJson['pg_name'];

    // var pg = mapJson['pg'];

    // var method = mapJson['method'];

    // var method_name = mapJson['method_name'];

    // var payment_group = mapJson['payment_group'];

    // var payment_group_name = mapJson['payment_group_name'];

    // var requested_at = mapJson['requested_at'];

    // var purchased_at = mapJson['purchased_at'];

    // var status = mapJson['status'];

    final paymentResult = await webItemList.paymentStory(
        mapJson['receipt_id'],
        mapJson['order_id'],
        mapJson['card_code'],
        mapJson['card_name'],
        mapJson['card_no'],
        mapJson['card_quota'],
        mapJson['item_name'],
        mapJson['method'],
        mapJson['method_name'],
        mapJson['payment_group'],
        mapJson['payment_group_name'],
        mapJson['payment_name'],
        mapJson['pg'],
        mapJson['pg_name'],
        mapJson['price'].toString(),
        mapJson['purchased_at'],
        mapJson['receipt_url'],
        mapJson['requested_at'],
        mapJson['status'].toString(),
        mapJson['tax_free'].toString(),
        mapJson['url'],
        //cancelAT[1],
        "");
    // final paymentResult = await webItemList.paymentStory(
    //     receipt_id,
    //     order_id,
    //     card_code,
    //     card_name,
    //     card_no,
    //     card_quota,
    //     item_name,
    //     method,
    //     method_name,
    //     payment_group,
    //     payment_group_name,
    //     payment_name,
    //     pg,
    //     pg_name,
    //     price.toString(),
    //     purchased_at,
    //     receipt_url,
    //     requested_at,
    //     status.toString(),
    //     tax_free.toString(),
    //     url,
    //     //cancelAT[1],
    //     "");

    setState(() {
      print(
          'payment=====================================${paymentResult.cnt} , ${paymentResult.status}');
    });
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  goHome() {
    Navigator.pushNamed(context, '/BottomNav', arguments: {number: number});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            alignment: Alignment.center,
            //color: Colors.grey[300],
            child: action == "loading"
                ? Align(
                    alignment: Alignment.center,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : action == "cancel"
                    ? Container(
                        alignment: Alignment.center,
                        child: Card(
                          elevation: 5,
                          child: Container(
                            height: MediaQuery.of(context).size.height / 4,
                            width: MediaQuery.of(context).size.width / 1.5,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("                ",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 25.0,
                                      fontFamily: "Godo",
                                      fontWeight: FontWeight.w400,
                                    )),
                                Text(
                                  "결제가 취소 되었습니다",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 22.0,
                                    fontFamily: "Godo",
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Padding(padding: EdgeInsets.only(bottom: 5)),
                                Divider(
                                  thickness: 1,
                                  color: Colors.black,
                                ),
                                Container(
                                  // width: MediaQuery.of(context).size.width / 2,
                                  // height: MediaQuery.of(context).size.height / 2,
                                  margin: const EdgeInsets.all(15.0),
                                  padding: const EdgeInsets.all(3.0),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black, width: 2),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            5.0) //                 <--- border radius here
                                        ),
                                  ),
                                  child: FlatButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      "확인",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15.0,
                                        fontFamily: "Godo",
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : action == "finish"
                        ? Container(
                            alignment: Alignment.center,
                            child: Card(
                              elevation: 5,
                              child: Container(
                                height: MediaQuery.of(context).size.height / 4,
                                width: MediaQuery.of(context).size.width / 1.5,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("                ",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 25.0,
                                          fontFamily: "Godo",
                                          fontWeight: FontWeight.w400,
                                        )),
                                    Text(
                                      "결제가 완료 되었습니다",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 22.0,
                                        fontFamily: "Godo",
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(bottom: 5)),
                                    Divider(
                                      thickness: 1,
                                      color: Colors.black,
                                    ),
                                    Container(
                                      // width: MediaQuery.of(context).size.width / 2,
                                      // height: MediaQuery.of(context).size.height / 2,
                                      margin: const EdgeInsets.all(15.0),
                                      padding: const EdgeInsets.all(3.0),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.black, width: 2),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                5.0) //                 <--- border radius here
                                            ),
                                      ),
                                      child: FlatButton(
                                        onPressed: goHome,
                                        child: Text(
                                          "확인",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15.0,
                                            fontFamily: "Godo",
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : Container(
                            alignment: Alignment.center,
                            child: Card(
                              elevation: 5,
                              child: Container(
                                height: MediaQuery.of(context).size.height / 4,
                                width: MediaQuery.of(context).size.width / 1.5,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("                ",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 25.0,
                                          fontFamily: "Godo",
                                          fontWeight: FontWeight.w400,
                                        )),
                                    Text(
                                      "error",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 22.0,
                                        fontFamily: "Godo",
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(bottom: 5)),
                                    Divider(
                                      thickness: 1,
                                      color: Colors.black,
                                    ),
                                    Container(
                                      // width: MediaQuery.of(context).size.width / 2,
                                      // height: MediaQuery.of(context).size.height / 2,
                                      margin: const EdgeInsets.all(15.0),
                                      padding: const EdgeInsets.all(3.0),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.black, width: 2),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                5.0) //                 <--- border radius here
                                            ),
                                      ),
                                      child: FlatButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          "확인",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15.0,
                                            fontFamily: "Godo",
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
            // showGeneralDialog(
            //     context: context,
            //     barrierDismissible: true,
            //     barrierLabel: MaterialLocalizations.of(context)
            //         .modalBarrierDismissLabel,
            //     barrierColor: Colors.black45,
            //     transitionDuration: const Duration(milliseconds: 200),
            //     pageBuilder: (BuildContext buildContext,
            //         Animation animation, Animation secondaryAnimation) {
            //       return Center(
            //           child: Container(
            //         alignment: Alignment.center,
            //         width: MediaQuery.of(context).size.width - 10,
            //         height: MediaQuery.of(context).size.height - 10,
            //         padding: EdgeInsets.all(20),
            //         color: Colors.white,
            //         child: Column(
            //           children: [
            //             Text("결제를 취소하시겠습니까? ",
            //                 style: TextStyle(
            //                   color: Colors.black,
            //                   fontSize: 22.0,
            //                   fontFamily: "Godo",
            //                   fontWeight: FontWeight.w400,
            //                 )),
            //             Text("취소하시면 데이터는 다 날라갑니다 ",
            //                 style: TextStyle(
            //                   color: Colors.black,
            //                   fontSize: 22.0,
            //                   fontFamily: "Godo",
            //                   fontWeight: FontWeight.w400,
            //                 )),
            //             Row(
            //               children: [
            //                 RaisedButton(
            //                   onPressed: () {
            //                     Navigator.of(context)
            //                         .pushNamedAndRemoveUntil('/BottomNav',
            //                             (Route<dynamic> route) => false);
            //                   },
            //                   child: Text(
            //                     "네",
            //                     style: TextStyle(color: Colors.white),
            //                   ),
            //                   color: const Color(0xFF1BC0C5),
            //                 ),
            //                 RaisedButton(
            //                   onPressed: () {
            //                     payment(context, payData);
            //                   },
            //                   child: Text(
            //                     "재주문",
            //                     style: TextStyle(color: Colors.white),
            //                   ),
            //                   color: const Color(0xFF1BC0C5),
            //                 )
            //               ],
            //             ),
            //           ],
            //         ),
            //       ));
            //     })

            ));
  }
}
