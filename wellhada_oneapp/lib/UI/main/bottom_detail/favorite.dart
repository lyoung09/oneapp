import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wellhada_oneapp/UI/main/home_detail/webview.dart';
import 'package:wellhada_oneapp/listitem/user/user.dart' as user;

class Favorite extends StatefulWidget {
  @override
  _FavoriteState createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  List favoriteList;
  var allFavorite;
  String webviewDefault = 'http://192.168.0.47:8080/usermngr';
  var userId = '112';
  var userName;
  void initState() {
    super.initState();
  }

  getName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      userName = prefs.getString("userName");
    });
  }

  Future<Map<String, dynamic>> getFavorite() async {
    return user.getFavoriteList();
  }

  void _handleURLButtonPress(
      BuildContext context, String url, String placeName) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WebViewContainer(url, placeName)));

    // Navigator.pushNamed(context, '/webview');
  }

  List<String> saveFav = List<String>();

  Widget _card(favoriteInfoList) {
    return GridView.builder(
        scrollDirection: Axis.vertical,
        itemCount:
            favoriteInfoList.length == null ? null : favoriteInfoList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 5.0,
          mainAxisSpacing: 10.0,
          childAspectRatio: 0.65,

          // childAspectRatio: (MediaQuery.of(context).size.width / 5) /
          //     (MediaQuery.of(context).size.height / 2),
        ),
        itemBuilder: (context, index) {
          String list = favoriteInfoList[index]['shopId'];

          bool isSaved = saveFav.contains(list);

          return InkWell(
            onTap: () {},
            child: Container(
              width: MediaQuery.of(context).size.width * 0.4,
              height: MediaQuery.of(context).size.height * 0.7,
              child: Card(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _handleURLButtonPress(
                                context,
                                '${webviewDefault}/shopTmplatView.do',
                                favoriteInfoList[index]['place_name']);
                          });
                        },
                        child: Image.network(
                          favoriteInfoList[index]['place_url'],
                          //'https://placeimg.com/500/500/any',
                          height: MediaQuery.of(context).size.width * 0.38,
                          width: MediaQuery.of(context).size.width * 0.4,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                          favoriteInfoList[index]['place_name'].length > 8
                              ? "${favoriteInfoList[index]['place_name'].substring(0, 6)}..."
                              : "${favoriteInfoList[index]['place_name']}",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.black,
                              fontWeight: FontWeight.w900)),
                    ),
                    Row(
                      children: [
                        Text(favoriteInfoList[index]['phone'],
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.black,
                                fontWeight: FontWeight.w600)),
                        Spacer(),
                        Align(
                            alignment: Alignment.bottomRight,
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  if (isSaved == true) {
                                    print(favoriteInfoList[index]);
                                    print('여기가 "Y');
                                    saveFav.remove(
                                        favoriteInfoList[index]['shopId']);
                                  } else {
                                    print(favoriteInfoList[index]);
                                    print('여기가 "N');
                                    saveFav
                                        .add(favoriteInfoList[index]['shopId']);
                                  }
                                });
                              },
                              icon: Icon(
                                Icons.star,
                                size: 25,
                                color: isSaved == false
                                    ? Colors.red[400]
                                    : Colors.grey[300],
                              ),
                            )),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false,
          title: Text(
            "즐겨찾기",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
          ),
        ),
        body: FutureBuilder(
            future: getFavorite(),
            builder: (context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CupertinoActivityIndicator());
              }

              Map<String, dynamic> favoriteInfo = snapshot.data;
              List<dynamic> favoriteInfoList = favoriteInfo["LIST"];

              favoriteInfoList = favoriteInfoList
                  .where((element) =>
                      element['favorite'] == "Y" && userId == element['userId'])
                  .toList();

              return Column(children: [
                Padding(
                  padding: EdgeInsets.only(top: 20),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Container(
                      child: Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: <Widget>[
                        userName == null
                            ? Text('호잇', style: TextStyle(fontSize: 20))
                            : Text("${userName}",
                                style: TextStyle(fontSize: 20)),
                        Text("님이", style: TextStyle(fontSize: 13)),
                      ],
                    ),
                  )),
                ),
                Container(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child:
                            Text("자주 가는 곳!", style: TextStyle(fontSize: 17)))),
                Container(
                  child: Divider(
                    color: Colors.black,
                  ),
                  padding: EdgeInsets.only(left: 12.0, bottom: 15.0),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5.0, left: 45),
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                  child: _card(favoriteInfoList),
                ))
              ]);
            }));
  }
}
