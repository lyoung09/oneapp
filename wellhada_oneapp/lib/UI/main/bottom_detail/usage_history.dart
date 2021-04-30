import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:getwidget/getwidget.dart';
import 'package:wellhada_oneapp/UI/usageHistory_detail/review.dart';

class UsageHistory extends StatefulWidget {
  @override
  _UsageHistoryState createState() => _UsageHistoryState();
}

class _UsageHistoryState extends State<UsageHistory> {
  Widget _usageCard() {
    return ListView.builder();
  }

  writingReview() async {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => new Review()));
  }

  Widget _practice() {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 45),
          ),
          GFCard(
            // boxFit: BoxFit.cover,
            titlePosition: GFPosition.start,
            image: Image.network(
              'https://placeimg.com/500/500/any',
              height: 120,
              width: 400,
              fit: BoxFit.fitWidth,
            ),
            title: GFListTile(
              title: Text(
                '가게명',
                style: TextStyle(
                  fontFamily: "Sans",
                  fontWeight: FontWeight.w800,
                  fontSize: 18.0,
                ),
              ),
              icon: Align(
                  alignment: Alignment.centerRight,
                  child: Icon(
                    Icons.star,
                    size: 25,
                  )),
            ),
            buttonBar: GFButtonBar(
              children: <Widget>[
                Text(
                  "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
                  style: TextStyle(
                    fontFamily: "Sans",
                    fontWeight: FontWeight.w600,
                    fontSize: 14.0,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      children: [
                        Text(
                          "ㅇ",
                          style: TextStyle(color: Colors.white),
                        ),
                        GFButton(
                          color: Colors.white,
                          onPressed: () {},
                          text: '재주문',
                          textColor: Colors.black,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text('--일 남음'),
                        GFButton(
                          color: Colors.white,
                          onPressed: writingReview,
                          text: '리뷰 쓰기',
                          textColor: Colors.black,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false,
          title: Text(
            "이용내역",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () {},
              child: Text(
                "내 리뷰",
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            )
          ],
        ),
        body: _practice());
  }
}
