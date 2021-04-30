// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:hexcolor/hexcolor.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:wellhada_oneapp/UI/main/bottom_nav.dart';
// import 'package:wellhada_oneapp/model/login/user.dart';

// enum MobileVerificationState {
//   SHOW_MOBILE_FORM_STATE,
//   SHOW_OTP_FORM_STATE,
// }

// class MobileReauthen extends StatefulWidget {
//   @override
//   _MobileReauthenState createState() => _MobileReauthenState();
// }

// class _MobileReauthenState extends State<MobileReauthen> {
//   MobileVerificationState currentState =
//       MobileVerificationState.SHOW_MOBILE_FORM_STATE;

//   final phoneController = TextEditingController();
//   final otpController = TextEditingController();

//   FirebaseAuth _auth = FirebaseAuth.instance;

//   String verificationId;

//   bool showLoading = false;

//   void initState() {
//     super.initState();
//   }

//   void signInWithPhoneAuthCredential(
//       PhoneAuthCredential phoneAuthCredential) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       showLoading = true;
//     });

//     try {
//       final authCredential =
//           await _auth.signInWithCredential(phoneAuthCredential);

//       setState(() {
//         showLoading = false;
//       });

//       if (authCredential?.user != null) {
//         setState(() {
//           prefs.setString('userPhone', '${phoneController.text}');
//         });
//         Navigator.pushReplacementNamed(
//           context,
//           '/BottomNav',
//         );
//       }
//     } on FirebaseAuthException catch (e) {
//       setState(() {
//         showLoading = false;
//       });

//       _scaffoldKey.currentState
//           .showSnackBar(SnackBar(content: Text(e.message)));
//     }
//   }

//   getMobileFormWidget(context) {
//     return Column(
//       children: [
//         Spacer(),
//         TextField(
//           controller: phoneController,
//           decoration: InputDecoration(
//             hintText: "핸드폰 번호",
//             hintStyle: TextStyle(
//                 fontFamily: 'Godo', fontSize: 14.0, color: Colors.grey[500]),
//             border: UnderlineInputBorder(
//               borderSide: BorderSide(color: Colors.red),
//             ),
//             enabledBorder: UnderlineInputBorder(
//               borderSide: BorderSide(color: Hexcolor('#FFD428')),
//             ),
//             focusedBorder: UnderlineInputBorder(
//               borderSide: BorderSide(color: Hexcolor('#FFD428')),
//             ),
//           ),
//         ),
//         SizedBox(
//           height: 16,
//         ),
//         Align(
//           alignment: Alignment.centerRight,
//           child: RaisedButton.icon(
//             icon: Icon(Icons.people),
//             onPressed: () async {
//               setState(() {
//                 showLoading = true;
//               });

//               await _auth.verifyPhoneNumber(
//                 phoneNumber: '+82 ${phoneController.text}',
//                 verificationCompleted: (phoneAuthCredential) async {
//                   setState(() {
//                     showLoading = false;
//                   });
//                   //signInWithPhoneAuthCredential(phoneAuthCredential);
//                 },
//                 verificationFailed: (verificationFailed) async {
//                   setState(() {
//                     showLoading = false;
//                   });
//                   _scaffoldKey.currentState.showSnackBar(
//                       SnackBar(content: Text(verificationFailed.message)));
//                 },
//                 codeSent: (verificationId, resendingToken) async {
//                   setState(() {
//                     showLoading = false;
//                     currentState = MobileVerificationState.SHOW_OTP_FORM_STATE;
//                     this.verificationId = verificationId;
//                   });
//                 },
//                 codeAutoRetrievalTimeout: (verificationId) async {},
//               );
//             },
//             label: Text("인증하기"),
//             color: Hexcolor('#FFD428'),
//             textColor: Colors.black,
//           ),
//         ),
//         Spacer(),
//       ],
//     );
//   }

//   getOtpFormWidget(context) {
//     return Column(
//       children: [
//         Spacer(),
//         Row(
//           children: [
//             Container(
//               width: MediaQuery.of(context).size.width * 0.6,
//               child: TextField(
//                 controller: otpController,
//                 decoration: InputDecoration(
//                   hintText: "인증 번호",
//                   hintStyle: TextStyle(
//                       fontFamily: 'Godo',
//                       fontSize: 14.0,
//                       color: Colors.grey[500]),
//                   border: UnderlineInputBorder(
//                     borderSide: BorderSide(color: Colors.red),
//                   ),
//                   enabledBorder: UnderlineInputBorder(
//                     borderSide: BorderSide(color: Hexcolor('#FFD428')),
//                   ),
//                   focusedBorder: UnderlineInputBorder(
//                     borderSide: BorderSide(color: Hexcolor('#FFD428')),
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(
//               width: MediaQuery.of(context).size.width * 0.1,
//               height: 16,
//             ),
//             Container(
//               width: MediaQuery.of(context).size.width * 0.2,
//               child: FlatButton(
//                 onPressed: () async {
//                   PhoneAuthCredential phoneAuthCredential =
//                       PhoneAuthProvider.credential(
//                           verificationId: verificationId,
//                           smsCode: otpController.text);

//                   signInWithPhoneAuthCredential(phoneAuthCredential);
//                 },
//                 child: Text("확인"),
//                 color: Hexcolor('#FFD428'),
//                 textColor: Colors.black,
//               ),
//             )
//           ],
//         ),
//         Spacer(),
//       ],
//     );
//   }

//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         key: _scaffoldKey,
//         body: Container(
//           child: showLoading
//               ? Center(
//                   child: CircularProgressIndicator(),
//                 )
//               : currentState == MobileVerificationState.SHOW_MOBILE_FORM_STATE
//                   ? getMobileFormWidget(context)
//                   : getOtpFormWidget(context),
//           padding: const EdgeInsets.all(16),
//         ));
//   }
// }
