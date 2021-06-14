// @dart=2.9
import 'dart:io';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:bootpay_api/bootpay_api.dart';
import 'package:bootpay_api/model/payload.dart';
import 'package:bootpay_api/model/extra.dart';
import 'package:bootpay_api/model/user.dart';
import 'package:bootpay_api/model/item.dart';
import 'package:wellhada_oneapp/listitem/shop/shopFavorite.dart' as favorite;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wellhada_oneapp/listitem/shop/web.dart' as webLogin;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:wellhada_oneapp/listitem/userFile/userList.dart' as userList;
import 'package:wellhada_oneapp/listitem/shop/web.dart' as webItemList;
import '../bottom_nav.dart';

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

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  void initState() {
    super.initState();
    check();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  var userEmail, phone, birthday, birthdayJson;

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

    print(birthday);
    userData.userPhoneNumber == null
        ? phone = ""
        : phone = userData.userPhoneNumber;
  }

  startLoading() {
    setState(() {
      position = 1;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  insertFavorite(userId, shopSeq) async {
    final saveFavorite = await favorite.saveFavoriteShop(userId, shopSeq);

    if (this.mounted) {
      setState(() {
        print('save ============================${saveFavorite.cnt}');
      });
    }
  }

  deleteFavorite(userId, shopSeq) async {
    final deleteFavorite = await favorite.deleteFavoriteShop(userId, shopSeq);
    if (this.mounted) {
      setState(() {
        print('delete ============================${deleteFavorite.cnt}');
      });
    }
  }

  var pgUserName, pgUserEmail, pgUserPhone, itemName, uniqueId;
  payment(context, payData) async {
    print("yoyo ${payData}");

    var data = payData.split(',');
    var price, name, pg, quantity, appId, orderId, wantedParts;
    wantedParts = data[0].split(':');
    price = [wantedParts.removeAt(0), wantedParts.join(":")];
    wantedParts = data[1].split(':');
    name = [wantedParts.removeAt(0), wantedParts.join(":")];
    wantedParts = data[2].split(':');
    itemName = [wantedParts.removeAt(0), wantedParts.join(":")];
    wantedParts = data[3].split(':');
    pg = [wantedParts.removeAt(0), wantedParts.join(":")];
    wantedParts = data[4].split(':');
    quantity = [wantedParts.removeAt(0), wantedParts.join(":")];
    wantedParts = data[5].split(':');
    uniqueId = [wantedParts.removeAt(0), wantedParts.join(":")];
    wantedParts = data[6].split(':');
    appId = [wantedParts.removeAt(0), wantedParts.join(":")];
    wantedParts = data[7].split(':');
    orderId = [wantedParts.removeAt(0), wantedParts.join(":")];
    wantedParts = data[8].split(':');
    pgUserName = [wantedParts.removeAt(0), wantedParts.join(":")];
    wantedParts = data[9].split(':');
    pgUserEmail = [wantedParts.removeAt(0), wantedParts.join(":")];
    wantedParts = data[10].split(':');
    pgUserPhone = [wantedParts.removeAt(0), wantedParts.join(":")];

    goBootpayRequest(
        context,
        price[1],
        name[1],
        itemName[1],
        pg[1],
        quantity[1],
        uniqueId[1],
        orderId[1],
        appId[1],
        pgUserName[1],
        pgUserEmail[1],
        pgUserPhone[1]);
  }

  goBootpayRequest(BuildContext context, price, name, itemName, pg, quantity,
      uniqueId, orderId, appId, pgUserName, pgUserEmail, pgUserPhone) async {
    //context = context.findAncestorWidgetOfExactType<Scaffold>();
    Item paymentItem = Item();
    paymentItem.itemName = itemName; // 주문정보에 담길 상품명
    paymentItem.qty = int.parse(quantity); // 해당 상품의 주문 수량
    paymentItem.unique = uniqueId; // 해당 상품의 고유 키
    paymentItem.price = double.parse(price); // 상품의 가격
    print(name);
    print(price);
    print('pg :${pg}');
    print(quantity);
    print(orderId);
    print(appId);
    List<Item> paymentItemList = [paymentItem];

    Payload payload = Payload();
    payload.name = name;
    //payload.applicationId = androidAppid;
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
    print(userName);
    print(userEmail);
    print(phone);
    // Extra extra = Extra();
    // extra.appScheme = 'bootpayFlutterSample';
    // extra.quotas = [0, 2, 3];
    // extra.popup = 1;
    // extra.quick_popup = 1;
    try {
      BootpayApi.request(
        context,
        payload,

        //extra: extra,
        user: paymentUser,
        items: paymentItemList,

        onDone: (json) {
          goToPayment(json);
          print('--- onDone: $json');

          //getUserToken(appId);
        },

        onCancel: (json) {
          print('--- onCancel: $json');
        },

        onError: (json) {
          print(' --- onError: $json');
        },
      );
    } catch (e) {
      Navigator.of(context).pop();
    }
  }

  void getUserToken(String restToken) async {
    Map<String, dynamic> body = {
      "user_id": userId,
//      "user_id": Uuid().v1(),
      "email": userEmail,
      "name": userName,

      "birth": birthday,
      "phone": phone
    };

    var url = Uri.parse('https://api.bootpay.co.kr/request/user/token');
    final response = await http.post(url,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded",
          "Authorization": restToken
        },
        body: body);
    if (response.statusCode == 200) {
      var res = json.decode(response.body);
      String token = res['data']['user_token'];
      print(token);
    } else {
      print(response.body);
    }
  }

  goToPayment(json) async {
    print('abcde ${json}');
    var data = json.split(',');
    var action,
        receipt_id,
        order_id,
        card_code,
        card_no,
        card_name,
        card_quota,
        item_name,
        method,
        method_name,
        payment_group,
        payment_group_name,
        payment_name,
        pg,
        pg_name,
        price,
        purchased_at,
        receipt_url,
        requested_at,
        status,
        tax_free,
        url,
        cancelAT,
        wantedParts;

    wantedParts = data[0].split(':');
    action = [wantedParts.removeAt(0), wantedParts.join(":")];

    wantedParts = data[1].split(':');
    receipt_id = [wantedParts.removeAt(0), wantedParts.join(":")];
    receipt_id = receipt_id[1];
    receipt_id = receipt_id.substring(1, receipt_id.length - 1);
    print('check ${receipt_id}');

    wantedParts = data[2].split(':');
    price = [wantedParts.removeAt(0), wantedParts.join(":")];
    price = price[1];
    print('check ${price}');

    wantedParts = data[3].split(':');
    card_no = [wantedParts.removeAt(0), wantedParts.join(":")];
    card_no = card_no[1];
    card_no = card_no.substring(1, card_no.length - 1);
    print('check${card_no}');

    wantedParts = data[4].split(':');
    card_code = [wantedParts.removeAt(0), wantedParts.join(":")];
    card_code = card_code[1];
    card_code = card_code.substring(1, card_code.length - 1);
    print('check${card_code}');

    wantedParts = data[5].split(':');
    card_name = [wantedParts.removeAt(0), wantedParts.join(":")];
    card_name = card_name[1];
    card_name = card_name.substring(1, card_name.length - 1);
    print('check${card_name}');

    wantedParts = data[6].split(':');
    card_quota = [wantedParts.removeAt(0), wantedParts.join(":")];
    card_quota = card_quota[1];
    card_quota = card_quota.substring(1, card_quota.length - 1);
    print('check${card_quota}');

    wantedParts = data[7].split(':');
    receipt_url = [wantedParts.removeAt(0), wantedParts.join(":")];
    receipt_url = receipt_url[1];
    receipt_url = receipt_url.substring(1, receipt_url.length - 1);
    print('check ${receipt_url}');

    wantedParts = data[8].split(':');
    item_name = [wantedParts.removeAt(0), wantedParts.join(":")];
    item_name = item_name[1];
    item_name = item_name.substring(1, item_name.length - 1);
    print('check ${item_name}');

    wantedParts = data[9].split(':');
    order_id = [wantedParts.removeAt(0), wantedParts.join(":")];
    order_id = order_id[1];
    order_id = order_id.substring(1, order_id.length - 1);
    print('check ${order_id}');

    wantedParts = data[10].split(':');
    url = [wantedParts.removeAt(0), wantedParts.join(":")];
    url = url[1];
    url = url.substring(1, url.length - 1);
    print('check ${url}');

    wantedParts = data[11].split(':');
    tax_free = [wantedParts.removeAt(0), wantedParts.join(":")];
    tax_free = tax_free[1];

    wantedParts = data[12].split(':');
    payment_name = [wantedParts.removeAt(0), wantedParts.join(":")];
    payment_name = payment_name[1];
    payment_name = payment_name.substring(1, payment_name.length - 1);
    print('check ${payment_name}');

    wantedParts = data[13].split(':');
    pg_name = [wantedParts.removeAt(0), wantedParts.join(":")];
    pg_name = pg_name[1];
    pg_name = pg_name.substring(1, pg_name.length - 1);
    print('check ${pg_name}');

    wantedParts = data[14].split(':');
    pg = [wantedParts.removeAt(0), wantedParts.join(":")];
    pg = pg[1];
    pg = pg.substring(1, pg.length - 1);
    print('check ${pg}');

    wantedParts = data[15].split(':');
    method = [wantedParts.removeAt(0), wantedParts.join(":")];
    method = method[1];
    method = method.substring(1, method.length - 1);
    print('check ${method}');

    wantedParts = data[16].split(':');
    method_name = [wantedParts.removeAt(0), wantedParts.join(":")];
    method_name = method_name[1];
    method_name = method_name.substring(1, method_name.length - 1);
    print('check ${method_name}');

    wantedParts = data[17].split(':');
    payment_group = [wantedParts.removeAt(0), wantedParts.join(":")];
    payment_group = payment_group[1];
    payment_group = payment_group.substring(1, payment_group.length - 1);
    print('check ${payment_group}');

    wantedParts = data[18].split(':');
    payment_group_name = [wantedParts.removeAt(0), wantedParts.join(":")];
    payment_group_name = payment_group_name[1];
    payment_group_name =
        payment_group_name.substring(1, payment_group_name.length - 1);
    print('check ${payment_group_name}');

    wantedParts = data[19].split(':');
    requested_at = [wantedParts.removeAt(0), wantedParts.join(":")];
    requested_at = requested_at[1];
    requested_at = requested_at.substring(1, requested_at.length - 1);
    print('check ${requested_at}');

    wantedParts = data[20].split(':');
    purchased_at = [wantedParts.removeAt(0), wantedParts.join(":")];
    purchased_at = purchased_at[1];
    purchased_at = purchased_at.substring(1, purchased_at.length - 1);
    print('check ${purchased_at}');

    wantedParts = data[21].split(':');
    status = [wantedParts.removeAt(0), wantedParts.join(":")];
    status = status[1];
    print("abcdef ${status}");
    status = status.substring(0, status.length - 1);

    print("abcde ${status}");
    final paymentResult = await webItemList.paymentStory(
        receipt_id,
        order_id,
        card_code,
        card_name,
        card_no,
        card_quota,
        item_name,
        method,
        method_name,
        payment_group,
        payment_group_name,
        payment_name,
        pg,
        pg_name,
        price,
        purchased_at,
        receipt_url,
        requested_at,
        status,
        tax_free,
        url,
        //cancelAT[1],
        "");

    setState(() {
      print(
          'payment=====================================${paymentResult.cnt} , ${paymentResult.status}');
    });
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WebViewContainer(
                placeName, shopSeq, userId, userPassword, userChk, "0")));
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);

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
            userLogin == true
                ? new DropdownButtonHideUnderline(
                    child: new IconButton(
                    icon: Icon(
                      Icons.star,
                      color:
                          _isFavorite == true ? Colors.red[400] : Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        _isFavorite = !_isFavorite;

                        _isFavorite == true
                            ? insertFavorite(userId, shopSeq)
                            : deleteFavorite(userId, shopSeq);
                      });
                    },
                  ))
                : new DropdownButtonHideUnderline(
                    child: new Text(""),
                  ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
                child: WebView(
              key: _key,
              javascriptMode: JavascriptMode.unrestricted,
              initialUrl:
                  'http://hndsolution.iptime.org:8086/usermngr/shopTmplatView.do?user_id=${userId}&user_password=${userPassword}&shop_seq=${shopSeq}&user_chk=${userChk}',
              javascriptChannels: [
                JavascriptChannel(
                    name: 'CHANNEL_NAME',
                    onMessageReceived: (message) {
                      message.message != null
                          ? payment(context, message.message)
                          : print("구경");
                    })
              ].toSet(),
            )),
          ],
        ));
  }
}
