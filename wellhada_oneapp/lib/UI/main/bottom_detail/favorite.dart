import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wellhada_oneapp/listitem/user/user.dart' as user;

class Favorite extends StatefulWidget {
  @override
  _FavoriteState createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  List favoriteList;
  var allFavorite;

  var userId = '112';
  void initState() {
    super.initState();
  }

  Future<Map<String, dynamic>> getFavorite() async {
    return user.getFavoriteList();
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
          childAspectRatio: 0.7,

          // childAspectRatio: (MediaQuery.of(context).size.width / 5) /
          //     (MediaQuery.of(context).size.height / 2),
        ),
        itemBuilder: (context, index) {
          String list = favoriteInfoList[index]['shopId'];

          bool isSaved = saveFav.contains(list);

          return Container(
            width: MediaQuery.of(context).size.width * 0.4,
            height: MediaQuery.of(context).size.height * 0.7,
            child: Card(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: GestureDetector(
                      onTap: () {},
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
                                  print(isSaved);
                                  print('여기가 "Y');
                                  saveFav.remove(
                                      favoriteInfoList[index]['shopId']);
                                } else {
                                  print(isSaved);
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
            style: TextStyle(
              color: Colors.white,
            ),
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
                Container(
                    child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: <Widget>[
                      Text("이제영", style: TextStyle(fontSize: 20)),
                      Text("님이", style: TextStyle(fontSize: 13)),
                    ],
                  ),
                )),
                Container(
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child:
                            Text("자주 가는 곳!", style: TextStyle(fontSize: 17)))),
                Container(
                  child: Divider(
                    color: Colors.black,
                  ),
                  padding:
                      EdgeInsets.only(left: 20.0, right: 20.0, bottom: 15.0),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5.0, left: 45),
                ),
                Expanded(child: _card(favoriteInfoList))
              ]);
            }));
  }
}
