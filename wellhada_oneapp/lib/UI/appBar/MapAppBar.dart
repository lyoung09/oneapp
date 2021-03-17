import 'package:flutter/material.dart';

class MapAppBar extends StatefulWidget {
  @override
  _MapAppBarState createState() => _MapAppBarState();
}

class _MapAppBarState extends State<MapAppBar> {
  String category;
  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Material(
        color: Colors.white, // button color
        child: Container(
          decoration: new BoxDecoration(
            shape: BoxShape.circle,
            border: new Border.all(
              color: Colors.indigo,
              width: 1.0,
            ),
          ),
          child: InkWell(
              child: SizedBox(
                width: 65,
                height: 65,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 5.0, bottom: 2.0),
                    ),
                    Image(
                      image: AssetImage('assets/img/cafe.png'),
                      width: 25,
                      height: 25,
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 1.0),
                    ),
                    Text(
                      "가맹점 보기",
                      style: TextStyle(fontSize: 13.5),
                    )
                  ],
                ),
              ),
              onTap: () {
                setState(() {
                  category = "wellhada";
                });
              }),
        ),
      ),
    );
  }
}
