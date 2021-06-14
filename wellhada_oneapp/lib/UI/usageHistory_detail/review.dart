// @dart=2.9
import 'dart:async';
import 'dart:io';
import 'package:wellhada_oneapp/UI/main/bottom_nav.dart';
import 'package:wellhada_oneapp/listitem/shop/orderList.dart' as orderList;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:validators/validators.dart' as validator;

class Review extends StatefulWidget {
  var orderSeq;
  var shopName;
  var order;
  var userId;
  var userSeq;
  Review(this.orderSeq, this.shopName, this.order, this.userId, this.userSeq);
  @override
  _ReviewState createState() =>
      _ReviewState(orderSeq, shopName, order, userId, userSeq);
}

class _ReviewState extends State<Review> {
  var orderSeq;
  var shopName;
  var order, userId, userSeq;
  _ReviewState(
      this.orderSeq, this.shopName, this.order, this.userId, this.userSeq);
  File _image;
  var story;
  var reviewImage;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(userSeq);
    print(userSeq.runtimeType);
  }

  final _formKey = GlobalKey<FormState>();
  _imgFromCamera() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _image = image;
      reviewImage = _image.path;
    });
  }

  _imgFromGallery() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = image;
      reviewImage = _image.path;
    });
  }

  checkReview() async {
    final saveReview = await orderList.saveReview(
        userSeq, orderSeq, story, _image == null ? "" : _image);
    var fileSeq;

    fileSeq = saveReview.fileSeq;

    if (fileSeq != null) {
      final insertReview =
          await orderList.insertReview(userSeq, orderSeq, story, fileSeq);
      setState(() {
        print('insertReview======================== ${insertReview.cnt}');
      });
    }
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => BottomNav(
                number: 1,
              )),
    );
  }

  noImageReview() async {
    final saveReview = await orderList.noImageReview(userSeq, orderSeq, story);

    setState(() {
      print('saveReview======================== ${saveReview.cnt}');
    });

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => BottomNav(
                number: 1,
              )),
    );
  }

  cancel() {
    Navigator.pop(context);
  }

  Widget _review() {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.height * 0.6,
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                textBaseline: TextBaseline.alphabetic,
                children: <Widget>[
                  Text(
                    "${shopName}",
                    style: TextStyle(
                      fontSize: 21.0,
                      fontFamily: "nanumB",
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    "에서 주문하신",
                    style: TextStyle(
                      fontSize: 12.0,
                      fontFamily: "nanumR",
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(right: 5)),
                ],
              ),
              Align(
                alignment: Alignment.topRight,
                child: Text(
                  order,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontFamily: "nanumB",
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10, bottom: 10),
              ),
              Center(
                child: GestureDetector(
                  onTap: () {
                    _showPicker(context);
                  },
                  child: _image != null
                      ? Image.file(
                          _image,
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.grey[800],
                            size: 50,
                          ),
                        ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(15.0),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: TextFormField(
                  cursorColor: Colors.black,
                  textAlign: TextAlign.left,
                  maxLines: 8,
                  decoration: new InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                      ),
                    ),
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(0.0),
                      ),
                      borderSide: new BorderSide(
                        color: Colors.black,
                        width: 1.5,
                      ),
                    ),
                  ),
                  validator: (String value) {
                    if (value.isEmpty == true || value.length < 10) {
                      return '10자 이상은 써주셔야되요ㅠㅠ';
                    }
                    return null;
                  },
                  onSaved: (String value) {
                    story = value;
                  },
                ),
              ),
              Container(
                child: Divider(
                    // color: Color.fromRGBO(82, 110, 208, 1.0),
                    ),
                padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
              ),
              Container(
                height: 45,
                width: 200,
                child: RaisedButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      print(_image);
                      _image == null ? noImageReview() : checkReview();
                    }
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40.0),
                      side: BorderSide(color: Colors.black)),
                  child: Text("등록하기", style: TextStyle(color: Colors.black)),
                  color: Colors.white,
                ),
              ),
              Container(
                child: Divider(
                    // color: Color.fromRGBO(82, 110, 208, 1.0),
                    ),
                padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
              ),
              Container(
                height: 45,
                width: 200,
                child: RaisedButton(
                  onPressed: cancel,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40.0),
                      side: BorderSide(color: Colors.black)),
                  child: Text("취소", style: TextStyle(color: Colors.black)),
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new SvgPicture.asset(
                        "assets/svg/album.svg",
                        fit: BoxFit.fill,
                        width: 20,
                        height: 20,
                      ),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new SvgPicture.asset(
                      "assets/svg/camera.svg",
                      fit: BoxFit.fill,
                      width: 20,
                      height: 20,
                    ),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Stack(
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
              left: -40.0,
              child: Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                    color: Colors.amberAccent, shape: BoxShape.circle),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height,
              child: Column(children: [
                Padding(
                  padding: EdgeInsets.only(top: 40.0, left: 45),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      "리뷰 쓰기",
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontFamily: "Sans",
                        fontWeight: FontWeight.w800,
                        fontSize: 25.0,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                ),
                Expanded(child: _review())
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
