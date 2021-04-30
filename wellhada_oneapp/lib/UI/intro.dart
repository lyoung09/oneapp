import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class Introduce extends StatefulWidget {
  @override
  _IntroduceState createState() => _IntroduceState();
}

class _IntroduceState extends State<Introduce> {
  var index;

  initState() {
    super.initState();
    index = 0;
  }

  dispose() {
    super.dispose();
    checkIndex();
  }

  checkIndex() async {
    index = 0;
    setState(() {
      index++;
    });
    print(index);
  }

  goStart() {
    Navigator.pushNamed(context, '/BottomNav');
  }

  goBack() async {
    setState(() {
      index = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        index == 0 ? _firstIntroduce() : _secondIntroduce(),

        // Align(
        //   alignment: Alignment.bottomCenter,
        //   child: FloatingActionButton(
        //     onPressed: () {},
        //     heroTag: "btn2",
        //     child: Text(''),
        //   ),
        // ),
      ],
    ));
  }

  Widget _firstIntroduce() {
    return Container(
        padding: EdgeInsets.fromLTRB(10, 30, 10, 10),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        color: Colors.black,
        child: Card(
            elevation: 5,
            child: Padding(
                padding: EdgeInsets.all(7),
                child: Stack(children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                        ),
                        // ClipPath(
                        //   clipper: OvalBottomBorderClipper(),
                        //   child: Container(
                        //     height: MediaQuery.of(context).size.height / 4 + 40,
                        //     color: Colors.white,
                        //   ),
                        // ),
                        Positioned(
                          top: -20.0,
                          left: -40.0,
                          child: Container(
                            height: 150,
                            width: 150,
                            decoration: BoxDecoration(
                                color: Colors.amberAccent,
                                shape: BoxShape.circle),
                          ),
                        ),
                        Column(
                          children: <Widget>[
                            Padding(
                                padding:
                                    const EdgeInsets.only(left: 40, top: 30),
                                child: Text("안녕하세요")),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                                padding:
                                    const EdgeInsets.only(left: 40, top: 20),
                                child: Text("웰하다입니다")),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                                padding:
                                    const EdgeInsets.only(left: 40, top: 20),
                                child: Text("여러 가게 구경하고 가세요")),
                            SizedBox(
                              width: 20,
                            )
                          ],
                        ),

                        Padding(
                          padding: EdgeInsets.all(20),
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: InkWell(
                              onTap: checkIndex,
                              child: Text("넘어가기"),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ]))));
  }

  Widget _secondIntroduce() {
    return Container(
        padding: EdgeInsets.fromLTRB(10, 30, 10, 10),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        color: Colors.black,
        child: Card(
            elevation: 5,
            child: Padding(
                padding: EdgeInsets.all(7),
                child: Stack(children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                        ),
                        // ClipPath(
                        //   clipper: OvalBottomBorderClipper(),
                        //   child: Container(
                        //     height: MediaQuery.of(context).size.height / 4 + 40,
                        //     color: Colors.white,
                        //   ),
                        // ),
                        Positioned(
                          top: -20.0,
                          left: -40.0,
                          child: Container(
                            height: 150,
                            width: 150,
                            decoration: BoxDecoration(
                                color: Colors.amberAccent,
                                shape: BoxShape.circle),
                          ),
                        ),
                        Column(
                          children: <Widget>[
                            Padding(
                                padding:
                                    const EdgeInsets.only(top: 30, left: 30),
                                child: Text("저희 가맹점들은")),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                                padding:
                                    const EdgeInsets.only(left: 40, top: 20),
                                child: Text("호잇호잇")),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                                padding:
                                    const EdgeInsets.only(left: 40, top: 20),
                                child: Text("헤에에에")),
                            SizedBox(
                              width: 20,
                            )
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.all(20),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: InkWell(
                              onTap: goBack,
                              child: Text("돌아가기"),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(20),
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: InkWell(
                              onTap: goStart,
                              child: Text("시작하기"),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ]))));
  }
}
