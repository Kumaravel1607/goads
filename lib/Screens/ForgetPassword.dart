import 'package:flutter/material.dart';
import 'package:services/Constant/Colors.dart';
import 'package:services/Constant/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:sms_autofill/sms_autofill.dart';
import 'CheckOtp.dart';
import 'Newpassword.dart';

class ForgetPass extends StatefulWidget {
  ForgetPass({
    Key key,
  }) : super(key: key);

  @override
  _ForgetPassState createState() => _ForgetPassState();
}

final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
final TextEditingController emailController = new TextEditingController();

class _ForgetPassState extends State<ForgetPass> {
  String _code;
  bool _isLoading = false;
  String firebase_id;
  SharedPreferences sharedPreferences;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {}

  forget_pass(
    email,
  ) async {
    Map data = {
      'email': email,
    };

    var jsonResponse = null;
    var response =
        await http.post(Uri.parse(app_api + "/forget_password"), body: data);

    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);

      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => CheckOtp(
                forgetemail: emailController.text,
              )));

      print(jsonResponse['message']);
    } else {
      jsonResponse = json.decode(response.body);
      _alerDialog(jsonResponse['message']);
      setState(() {
        _isLoading = false;
      });
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
            content: Text("please enter email"),
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
                "Forget Password",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 24, fontWeight: FontWeight.bold, color: black),
              ),
              SizedBox(
                height: 45,
              ),
              Container(
                padding: EdgeInsets.only(left: 40, right: 40),
                alignment: Alignment.bottomCenter,
                height: 400,
                decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(35),
                      topRight: Radius.circular(35)),
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 25,
                      ),
                      Text(
                        "Enter Email",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 18,
                            color: black,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 5),
                      TextFormField(
                        // validator: (value) {
                        //   if (value.isEmpty) {
                        //     return 'Please enter Email / Number';
                        //   }
                        //   return null;
                        // },
                        onSaved: (String value) {},
                        controller: emailController,
                        obscureText: false,
                        style: TextStyle(
                          fontSize: 16.0,
                          color: black,
                        ),
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.mail,
                            color: appcolor,
                          ),
                          fillColor: white,
                          filled: true,
                          contentPadding:
                              EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                          hintText: ('Enter Your Email '),
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 14.0,
                          ),
                          border: new OutlineInputBorder(
                            borderSide:
                                new BorderSide(color: appcolor, width: 1.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedErrorBorder: new OutlineInputBorder(
                            borderSide: BorderSide(color: appcolor, width: 1.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          errorBorder: new OutlineInputBorder(
                            borderSide:
                                new BorderSide(color: appcolor, width: 1.5),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: appcolor, width: 1.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: appcolor, width: 1.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 45,
                      ),
                      ButtonTheme(
                        buttonColor: appcolor,
                        minWidth: 400,
                        child: FlatButton(
                          color: appcolor,
                          padding: EdgeInsets.all(10),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              side: BorderSide(color: appcolor)),
                          onPressed: () async {
                            final signcode =
                                await SmsAutoFill().getAppSignature;
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //   builder: (BuildContext context) =>
                            //   NewPass(
                            //     // email: email.text,
                            //   ) ));
                            if (emailController.text == '') {
                              _alerBox();
                            } else {
                              _scaffoldKey.currentState.showSnackBar(SnackBar(
                                backgroundColor: appcolor,
                                content: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    CircularProgressIndicator(),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text('Please Wait'),
                                  ],
                                ),
                              ));
                              forget_pass(
                                emailController.text,
                              );
                            }
                          },
                          child: Text(
                            "Recover password",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: white),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      ButtonTheme(
                        buttonColor: appcolor,
                        minWidth: 400,
                        child: FlatButton(
                          color: appcolor,
                          padding: EdgeInsets.all(10),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              side: BorderSide(color: appcolor)),
                          onPressed: () async {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Back",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: white),
                          ),
                        ),
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
