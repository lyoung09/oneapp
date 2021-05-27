import 'dart:io';
import 'dart:ui';
import 'package:wellhada_oneapp/listitem/shop/shopFavorite.dart' as favorite;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wellhada_oneapp/listitem/shop/web.dart' as webLogin;

class WebViewContainer extends StatefulWidget {
  final placeName;
  final shopSeq;
  final userId;
  final userPassword;
  WebViewContainer(
      this.placeName, this.shopSeq, this.userId, this.userPassword);

  @override
  createState() => _WebViewContainerState(
      this.placeName, this.shopSeq, this.userId, this.userPassword);
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
  String userName, userPassword, userChk, userId;
  int shopSeq;
  bool userLogin;
  _WebViewContainerState(
      this.placeName, this.shopSeq, this.userId, this.userPassword);
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

  check() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      userChk = prefs.getString("userChk");
      if (userChk == "O") userLogin = false;
      if (userChk == "K" ||
          userChk == "E" ||
          userChk == "00" ||
          userChk == "01") userLogin = true;
    });
  }

  startLoading() {
    setState(() {
      position = 1;
    });
  }

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

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    print(
        'http://192.168.0.47:8080/usermngr/shopTmplatView.do?user_id=${userId}&user_password=${userPassword}');
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
                  'http://192.168.0.47:8080/usermngr/shopTmplatView.do?user_id=${userId}&user_password=${userPassword}',
            )),
          ],
        ));
  }
}
