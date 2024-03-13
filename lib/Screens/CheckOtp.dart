import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:services/Constant/Colors.dart';
import 'package:services/Constant/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'NewPassword.dart';

class CheckOtp extends StatefulWidget {
  final String forgetemail;
  CheckOtp({
    Key key,
    this.forgetemail,
  }) : super(key: key);

  @override
  _CheckOtpState createState() => _CheckOtpState();
}

final TextEditingController otp = new TextEditingController();
final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
final TextEditingController mobileNumber = new TextEditingController();

class _CheckOtpState extends State<CheckOtp> {
  String _code;
  bool _isLoading = false;
  String firebase_id;
  SharedPreferences sharedPreferences;

  @override
  void initState() {
    _getData();
  }

  void _getData() async {
    await SmsAutoFill().listenForCode;
  }

  check_otp(
    otp,
  ) async {
    Map data = {
      'email': widget.forgetemail,
      'otp': otp,
    };

    var jsonResponse = null;
    var response =
        await http.post(Uri.parse(app_api + "/check_otp"), body: data);
    // jsonResponse = json.decode(response.body);

    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        setState(() {
          _isLoading = false;
        });

        _alerDialog(jsonResponse['message']);

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) => NewPass(
                      useremail: widget.forgetemail,
                    )),
            (Route<dynamic> route) => false);
      }
    } else {
      jsonResponse = json.decode(response.body);
      setState(() {
        _isLoading = false;
      });
      _alerDialog(jsonResponse['message']);
    }
  }

  Future<void> _alerDialog(message) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(message),
            //title: Text(),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.pop(context, "ok");
                },
                child: const Text("OK"),
              )
            ],
          );
        });
  }

  Future<void> _alerBox() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text("OTP is not match..."),
            //title: Text(),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.pop(context, "ok");
                },
                child: const Text("OK"),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: appcolor,
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: appcolor,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Image.asset(
                "assets/images/logo-black.png",
                height: 100,
                width: 300,
              ),
              // Text("SMART SERVICES", style: TextStyle(fontSize: 16, color: white,fontWeight: FontWeight.w600),),
              // SizedBox(
              //   height: 55,
              // ),
              Text(
                "Verification Code",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 24, fontWeight: FontWeight.bold, color: black),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Please Enter The Verification Code send to " +
                    widget.forgetemail,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16, color: white, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 45,
              ),
              Container(
                padding: EdgeInsets.only(left: 40, right: 40),
                alignment: Alignment.bottomCenter,
                height: 420,
                decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(35),
                      topRight: Radius.circular(35)),
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 25,
                      ),
                      Text(
                        "Enter OTP",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 18,
                            color: black,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 15),
                      Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: PinFieldAutoFill(
                          codeLength: 4,
                          controller: otp,
                          autofocus: true,
                          keyboardType: TextInputType.numberWithOptions(),
                          textInputAction: TextInputAction.done,
                          decoration: BoxLooseDecoration(
                              strokeColorBuilder: FixedColorBuilder(
                                Colors.black.withOpacity(0.5),
                              ),
                              gapSpace: 25),
                          currentCode: _code,
                          onCodeSubmitted: (val) {
                            // print(val);
                            setState(() {
                              _code = otp.text;
                            });
                            if (otp.text == '') {
                              _alerBox();
                            } else {
                              check_otp(
                                otp.text,
                              );
                            }
                          },
                          onCodeChanged: (val) {
                            print(val);
                          },
                        ),
                      ),
                      SizedBox(height: 25),
                      ButtonTheme(
                        buttonColor: appcolor,
                        minWidth: 400,
                        child: FlatButton(
                          color: appcolor,
                          padding: EdgeInsets.all(10),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide(color: appcolor)),
                          onPressed: () async {
                            setState(() {
                              _code = otp.text;
                            });
                            if (otp.text == '') {
                              _alerBox();
                            } else {
                              check_otp(
                                otp.text,
                              );
                            }
                          },
                          child: Text(
                            "VERIFY",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: white),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
