
// import 'package:flutter/material.dart';
// import 'package:flutter/gestures.dart';
// import 'package:services/Constant/Colors.dart';
// import 'package:services/Constant/api.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:sms_autofill/sms_autofill.dart';
// import 'package:http/http.dart' as http;
// import 'dart:async';
// import 'dart:convert';
// import 'BottomTab.dart';
// import 'HomePage.dart';
// import 'NotificationPage.dart';
// import 'Register.dart';

// class OTP extends StatefulWidget {
//    final String otp;
//   final String userID;
//   final String mobileNumber;
//   OTP({Key key, this.otp, this.mobileNumber, this.userID}) : super(key: key);

//   @override
//   _OTPState createState() => _OTPState();
// }

// final TextEditingController otp = new TextEditingController();
// final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final TextEditingController mobileNumber = new TextEditingController();

// class _OTPState extends State<OTP> {

//     String _code;
//   bool _isLoading = false;
//   String firebase_id;
//   SharedPreferences sharedPreferences;
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

//   @override
//   void initState() {
//    _getData();
//    getMessage();
//   }

//   void _getData() async {
//     await SmsAutoFill().listenForCode;
//   }

//   void getMessage() {
//     _firebaseMessaging.configure(
//       onMessage: (Map<String, dynamic> message) async {
//         // print('onMessage: $message');
//       },
//       onLaunch: (Map<String, dynamic> message) async {
//         // print('onMessage: $message');
//       },
//       onResume: (Map<String, dynamic> message) async {
//         // print('onMessage: $message');
//       },
//     );

//     _firebaseMessaging.getToken().then((token) {
//       print("nandhu");
//       print(token);
//       // print(token);
//       firebase_id = token;
//     });
//   }

//   firebaseID() async {
//     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//     Map data = {
//       'user_id': widget.userID,
//       'app_id': firebase_id,
//     };

//     print(data);
//     var jsonResponse;
//     var response = await http.post(app_api + "/save_app_id", body: data);
//     jsonResponse = json.decode(response.body);
//     print(jsonResponse);
//   }

//    Future<void> _alerBox() async {
//     await showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             content: Text("OTP is not match..."),
//             //title: Text(),
//             actions: <Widget>[
//               FlatButton(
//                 onPressed: () {
//                   Navigator.pop(context, "ok");
//                 },
//                 child: const Text("OK"),
//               )
//             ],
//           );
//         });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey,
//       backgroundColor: appcolor,
//       body:
//        SingleChildScrollView(child:
//        Container(
//         width: MediaQuery.of(context).size.width,
//         height: MediaQuery.of(context).size.height,
//         decoration: BoxDecoration(
//           color: appcolor,
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.end,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: <Widget>[
//             new Image.asset(
//               "assets/images/logo.png",
//                 height: 170,
//               width: 170,
//             ),
//             // Text("SMART SERVICES", style: TextStyle(fontSize: 16, color: white,fontWeight: FontWeight.w600),),
//             // SizedBox(
//             //   height: 55,
//             // ),
//             Text("Verification Code",textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: black),),
//             SizedBox(
//               height: 10,
//             ),
//             Text("Please Enter The Verification Code send to +91 "+ widget.mobileNumber,textAlign: TextAlign.center, style: TextStyle(fontSize: 18, color: white,fontWeight: FontWeight.w500),),
//             SizedBox(
//               height: 45,
//             ),
//            Container(
//              padding: EdgeInsets.only(left: 40, right: 40),
//               alignment: Alignment.bottomCenter,
//               height: 420,
//               decoration: BoxDecoration(
//                 color: white,
//               borderRadius: BorderRadius.only(topLeft: Radius.circular(35),topRight: Radius.circular(35)),

//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.start,
//             children:[
//               SizedBox(
//                 height: 25,
//               ),
//             Text("Enter OTP", textAlign: TextAlign.left, style: TextStyle(fontSize: 18, color: black,fontWeight: FontWeight.w500),),
//             SizedBox(height:15),
//             Padding(padding: EdgeInsets.only(left: 20, right: 20),
//             child: PinFieldAutoFill(
//                codeLength: 4,
//                controller: otp,
//                autofocus: true,
//               //  keyboardType: TextInputType.numberWithOptions(),
//                textInputAction: TextInputAction.go,
//                decoration: BoxLooseDecoration(
//                  strokeColorBuilder: FixedColorBuilder(Colors.black.withOpacity(0.5),
//                  ),
//                  gapSpace : 25
//                ),
//                currentCode: _code,
//               //  UnderlineDecoration(
//               //     textStyle: TextStyle(fontSize: 20, color: Colors.black),
//               //     colorBuilder: FixedColorBuilder(Colors.black.withOpacity(0.5)),
//               //   ),
//               onCodeSubmitted: (val){
//                 print(val);
//               },
//                onCodeChanged: (val){
                 
//                  print(val);
//                },
//              ),),
//             SizedBox(height:25),
//            ButtonTheme(
//               buttonColor: appcolor,
//             minWidth: 400,
//             child: FlatButton(
//               color: appcolor,
//               padding: EdgeInsets.all(13),
//               shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(10.0),
//               side: BorderSide(color: appcolor)
//               ),
//               onPressed: () async {
//                 print(widget.otp);
//                 print(widget.userID);
//                 SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//                 if (widget.otp == otp.text) {
//                   if (widget.userID != "") {
//                      _scaffoldKey.currentState.showSnackBar(SnackBar(
//                             backgroundColor: appcolor,
//                             content: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: <Widget>[
//                                 CircularProgressIndicator(),
//                                 SizedBox(
//                                   width: 10,
//                                 ),
//                                 Text('Please Wait'),
//                               ],
//                             ),
//                           ));
//                     firebaseID();
//                     sharedPreferences.setString("user_id",widget.userID);
//                     Navigator.of(context).pushAndRemoveUntil(
//                       MaterialPageRoute(builder: (BuildContext context) => BottomTab()),
//                       (Route<dynamic> route) => false);
//                     // Navigator.pushReplacement(
//                     //   context,
//                     //   MaterialPageRoute(builder: (context) => BottomTab()),
//                     // );
//                   } else {
//                     Navigator.of(context).pushAndRemoveUntil(
//                       MaterialPageRoute(builder: (BuildContext context) =>  RegisterPage(
//                       mobilenumber: widget.mobileNumber,
//                     )),
//                       (Route<dynamic> route) => false);

//                   //   Navigator.pushReplacement(
//                   //   context,
//                   //   MaterialPageRoute(builder: (context) => RegisterPage(
//                   //     mobilenumber: widget.mobileNumber,
//                   //   )),
//                   // );
//                   }
//                 } else {
//                   _alerBox();
//                 }
//               //   Navigator.pushReplacement(
//               //   context,
//               //   MaterialPageRoute(builder: (context) => NewUserPage()),
//               // );
//               },
//               child: Text("VERIFY", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: white),),
//               ),
//            ),  
//            SizedBox(
//             height: 25,
//           ),
//           // Text("Did't get the code? Resend", textAlign: TextAlign.center, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),),
//         ]),
//       ),
//           ],
//         ),
//       ),
//     ),
//     );
//   }
// }