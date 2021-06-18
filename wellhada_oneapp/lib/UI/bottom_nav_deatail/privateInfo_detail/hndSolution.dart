import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

class HndSolution extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
          ClipPath(
            clipper: OvalBottomBorderClipper(),
            child: Container(
              height: MediaQuery.of(context).size.height / 4 + 40,
              color: Colors.white,
            ),
          ),
          Positioned(
            top: -20.0,
            right: -40.0,
            child: Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                  color: Colors.amberAccent, shape: BoxShape.circle),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 70, right: 20),
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  "회사 소개",
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontFamily: "nanumB",
                    fontWeight: FontWeight.w800,
                    fontSize: 25.0,
                  ),
                ),
              ),
            ),
          ),
          Container(
            child: Divider(
              color: Color.fromRGBO(82, 110, 208, 1.0),
            ),
            padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 0.0),
          ),
          Padding(
            padding: EdgeInsets.only(top: 50),
          ),
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 120, bottom: 120),
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 35),
                    ),
                    Text(
                      "회사명 :",
                      style: TextStyle(
                        // color: _colorText,
                        fontSize: 20.0,
                        fontFamily: "nanumB",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        "HndSolution",
                        style: TextStyle(
                          // color: _colorText,
                          fontSize: 16.0,
                          fontFamily: "nanumR",
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                ),
                Container(
                  child: Divider(
                    color: Color.fromRGBO(82, 110, 208, 1.0),
                  ),
                  padding:
                      EdgeInsets.only(left: 20.0, right: 20.0, bottom: 0.0),
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 35),
                    ),
                    Text(
                      "주소 :",
                      style: TextStyle(
                        // color: _colorText,
                        fontSize: 20.0,
                        fontFamily: "nanumB",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        "서울특별시 구로구 디지털로 27길 24\n(벽산 디지털밸리 1차) 801-823호",
                        style: TextStyle(
                          // color: _colorText,
                          fontSize: 12.0,
                          fontFamily: "nanumR",
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                ),
                Container(
                  child: Divider(
                    color: Color.fromRGBO(82, 110, 208, 1.0),
                  ),
                  padding:
                      EdgeInsets.only(left: 20.0, right: 20.0, bottom: 0.0),
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 35),
                    ),
                    Text(
                      "TEL :",
                      style: TextStyle(
                        // color: _colorText,
                        fontSize: 20.0,
                        fontFamily: "nanumB",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        "02-6949-1135",
                        style: TextStyle(
                          // color: _colorText,
                          fontSize: 16.0,
                          fontFamily: "nanumR",
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                ),
                Container(
                  child: Divider(
                    color: Color.fromRGBO(82, 110, 208, 1.0),
                  ),
                  padding:
                      EdgeInsets.only(left: 20.0, right: 20.0, bottom: 0.0),
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 35),
                    ),
                    Text(
                      "Email :",
                      style: TextStyle(
                        // color: _colorText,
                        fontSize: 20.0,
                        fontFamily: "nanumB",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        "hndsolution@hndsolution.com",
                        style: TextStyle(
                          // color: _colorText,
                          fontSize: 16.0,
                          fontFamily: "nanumR",
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                ),
                Container(
                  child: Divider(
                    color: Color.fromRGBO(82, 110, 208, 1.0),
                  ),
                  padding:
                      EdgeInsets.only(left: 20.0, right: 20.0, bottom: 0.0),
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 35),
                    ),
                    Text(
                      "대표 :",
                      style: TextStyle(
                        // color: _colorText,
                        fontSize: 20.0,
                        fontFamily: "nanumB",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        "방정석",
                        style: TextStyle(
                          // color: _colorText,
                          fontSize: 16.0,
                          fontFamily: "nanumR",
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                ),
                Container(
                  child: Divider(
                    color: Color.fromRGBO(82, 110, 208, 1.0),
                  ),
                  padding:
                      EdgeInsets.only(left: 20.0, right: 20.0, bottom: 0.0),
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 35),
                    ),
                    Text(
                      "사업자 번호 :",
                      style: TextStyle(
                        // color: _colorText,
                        fontSize: 20.0,
                        fontFamily: "nanumB",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        "1234-5678-110",
                        style: TextStyle(
                          // color: _colorText,
                          fontSize: 16.0,
                          fontFamily: "nanumR",
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                ),
                Container(
                  child: Divider(
                    color: Color.fromRGBO(82, 110, 208, 1.0),
                  ),
                  padding:
                      EdgeInsets.only(left: 20.0, right: 20.0, bottom: 0.0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
