import 'package:flutter/material.dart';
import 'package:wellhada_oneapp/model/login/certification_data.dart';
import 'package:wellhada_oneapp/model/login/user.dart';

import 'Iamport_certification.dart';

class Certification extends StatelessWidget {
  Model model;
  Certification({this.model});
  static const String userCode = 'imp10391932';

  @override
  Widget build(BuildContext context) {
    CertificationData data = ModalRoute.of(context).settings.arguments;

    return IamportCertification(
      appBar: new AppBar(
        title: new Text('아임포트 본인인증'),
      ),
      initialChild: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/iamport-logo.png'),
              Container(
                padding: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
                child: Text('잠시만 기다려주세요...', style: TextStyle(fontSize: 20.0)),
              ),
            ],
          ),
        ),
      ),
      userCode: userCode,
      data: data,
      callback: (Map<String, String> result) {
        Navigator.pushReplacementNamed(
          context,
          '/Email_complete',
          arguments: result,
        );
      },
    );
  }
}
