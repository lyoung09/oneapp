// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wellhada_oneapp/UI/privateInfo_detail/mileage_detail/coupon.dart';
import 'package:wellhada_oneapp/UI/privateInfo_detail/mileage_detail/point.dart';
import 'package:wellhada_oneapp/UI/privateInfo_detail/mileage_detail/stamp.dart';

class Mileage extends StatefulWidget {
  final userId;
  final userName;
  Mileage(this.userId, this.userName);
  @override
  _MileageState createState() => _MileageState(this.userId, this.userName);
}

class _MileageState extends State<Mileage> {
  String userId;
  String userName;

  _MileageState(this.userId, this.userName);

  initState() {
    super.initState();
    print(userId);
    print(userName);
  }

  pointCheck() async {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => UsagePoint(userId, userName)));
  }

  stampCheck() async {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => Stamp(userId, userName)));
  }

  couponCheck() async {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => Coupon(userId, userName)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.black,
          // automaticallyImplyLeading: false,
          title: Text(
            "마일리지 내역",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
          ),
        ),
        body: Stack(
          children: [
            Positioned(
              top: -20.0,
              right: 10.0,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width * 0.3,
                child: Image.asset(
                  "assets/icon/shopstoryIco.png",
                  //width: size.width * 0.9,
                ),
              ),
            ),
            ListView(children: <Widget>[
              Container(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height * 0.25),
              ),
              Container(
                child: Divider(
                  color: Color.fromRGBO(82, 110, 208, 1.0),
                ),
                padding: EdgeInsets.only(right: 20.0, bottom: 8.0),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FlatButton(
                      child: Text(
                        "포인트 내역",
                        style: TextStyle(
                          color: Colors.grey[900],
                          fontSize: 16.0,
                          fontFamily: "nanumB",
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      onPressed: pointCheck),
                ),
              ),
              Container(
                child: Divider(
                  color: Color.fromRGBO(82, 110, 208, 1.0),
                ),
                padding: EdgeInsets.only(right: 20.0, bottom: 8.0),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FlatButton(
                    child: Text(
                      "스탬프 내역",
                      style: TextStyle(
                        color: Colors.grey[900],
                        fontSize: 16.0,
                        fontFamily: "nanumB",
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    // onPressed: pointCheck
                  ),
                ),
              ),
              Container(
                child: Divider(
                  color: Color.fromRGBO(82, 110, 208, 1.0),
                ),
                padding: EdgeInsets.only(right: 20.0, bottom: 8.0),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FlatButton(
                    child: Text(
                      "쿠폰 내역",
                      style: TextStyle(
                        color: Colors.grey[900],
                        fontSize: 16.0,
                        fontFamily: "nanumB",
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    // onPressed: pointCheck
                  ),
                ),
              ),
              Container(
                child: Divider(
                  color: Color.fromRGBO(82, 110, 208, 1.0),
                ),
                padding: EdgeInsets.only(right: 20.0, bottom: 8.0),
              ),
            ]),
          ],
        ));
  }
}
