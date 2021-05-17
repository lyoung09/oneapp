import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wellhada_oneapp/listitem/user/user.dart' as user;

class WebViewContainer extends StatefulWidget {
  final url;
  final placeName;
  WebViewContainer(this.url, this.placeName);

  @override
  createState() => _WebViewContainerState(this.url, this.placeName);
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
  _WebViewContainerState(this._url, this.placeName);
  num position = 1;
  doneLoading() {
    setState(() {
      position = 0;
    });
  }

  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  startLoading() {
    setState(() {
      position = 1;
    });
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
            new DropdownButtonHideUnderline(
                child: new IconButton(
              icon: Icon(
                Icons.star,
                color: _isFavorite == true ? Colors.red[400] : Colors.white,
              ),
              onPressed: () {
                setState(() {
                  _isFavorite = !_isFavorite;
                });
              },
            )),
          ],
        ),
        body: Column(
          children: [
            Expanded(
                child: WebView(
              key: _key,
              javascriptMode: JavascriptMode.unrestricted,
              initialUrl: _url,
            )),
          ],
        ));
  }
}
