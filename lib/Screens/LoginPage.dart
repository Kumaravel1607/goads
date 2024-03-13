import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:services/Constant/Colors.dart';
import 'package:services/Constant/api.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'OTP.dart';
import 'BottomTab.dart';
import 'Register.dart';
import 'ForgetPassword.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
final TextEditingController emailmobileNumber = new TextEditingController();
final TextEditingController password = new TextEditingController();

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  SharedPreferences sharedPreferences;
  String firebase_id;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    getMessage();
  }

  void getMessage() {
    _firebaseMessaging.getToken().then((token) {
      print(token);
      firebase_id = token;
      print("-----------NK---------------");
    });
  }

  login(
    emailmobilenumber,
    pass,
  ) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'email': emailmobilenumber,
      'password': pass,
      'app_id': "",
    };

    print(data);

    var jsonResponse;
    var response = await http.post(Uri.parse(app_api + "/login"), body: data);
    // var response = await http.post(app_api + "/about_us");
    jsonResponse = json.decode(response.body);
    print(jsonResponse);

    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        setState(() {
          _isLoading = false;
        });
        // Navigator.push(
        //           context,
        //           MaterialPageRoute(
        //           builder: (BuildContext context) =>
        //           OTP(
        //           mobileNumber: mobileNumber.text,
        //           otp: jsonResponse['otp'].toString(),
        //           userID: jsonResponse['user_id'].toString(),
        //         ) ));
        sharedPreferences.setString(
            "user_id", jsonResponse['user_id'].toString());

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => BottomTab()),
            (Route<dynamic> route) => false);
        // _alerDialog(jsonResponse['message']);
      }
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
            content: Text("Please Enter Mobile Number"),
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
              SizedBox(
                height: 30,
              ),
              Text(
                "LOGIN",
                style: TextStyle(
                    fontSize: 24, fontWeight: FontWeight.bold, color: black),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "via Email / Mobile Number",
                style: TextStyle(
                    fontSize: 16, color: white, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 20,
              ),
              SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(left: 40, right: 40, top: 20),
                  alignment: Alignment.bottomCenter,
                  height: 420,
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(35),
                        topRight: Radius.circular(35)),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Email / Mobile Number",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 16,
                                color: black,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 5),
                          TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter Email / Number';
                              }
                              return null;
                            },
                            onSaved: (String value) {},
                            controller: emailmobileNumber,
                            obscureText: false,
                            style: TextStyle(
                              fontSize: 16.0,
                              color: black,
                            ),
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.send_to_mobile,
                                color: appcolor,
                              ),
                              fillColor: white,
                              filled: true,
                              contentPadding:
                                  EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                              hintText: ('Enter Email/Mobile Number'),
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
                                borderSide:
                                    BorderSide(color: appcolor, width: 1.0),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              errorBorder: new OutlineInputBorder(
                                borderSide:
                                    new BorderSide(color: appcolor, width: 1.5),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: appcolor, width: 1.0),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: appcolor, width: 1.0),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Password",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 16,
                                color: black,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 5),
                          TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter password';
                              }
                              return null;
                            },
                            onSaved: (String value) {},
                            controller: password,
                            obscureText: true,
                            style: TextStyle(
                              fontSize: 16.0,
                              color: black,
                            ),
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.lock,
                                color: appcolor,
                              ),
                              fillColor: white,
                              filled: true,
                              contentPadding:
                                  EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                              hintText: ('Enter Password'),
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
                                borderSide:
                                    BorderSide(color: appcolor, width: 1.0),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              errorBorder: new OutlineInputBorder(
                                borderSide:
                                    new BorderSide(color: appcolor, width: 1.5),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: appcolor, width: 1.0),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: appcolor, width: 1.0),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                          SizedBox(height: 30),
                          ButtonTheme(
                            buttonColor: appcolor,
                            minWidth: double.infinity,
                            child: FlatButton(
                              color: appcolor,
                              padding: EdgeInsets.all(8),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  side: BorderSide(color: appcolor)),
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  _formKey.currentState.save();
                                  _scaffoldKey.currentState
                                      .showSnackBar(SnackBar(
                                    backgroundColor: appcolor,
                                    content: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        CircularProgressIndicator(),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text('Please Wait'),
                                      ],
                                    ),
                                  ));
                                  login(emailmobileNumber.text, password.text);
                                  // final signcode = await SmsAutoFill().getAppSignature;
                                }
                              },
                              child: Text(
                                "SUBMIT",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: white),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          ButtonTheme(
                            buttonColor: appcolor,
                            minWidth: double.infinity,
                            child: FlatButton(
                              color: appcolor,
                              padding: EdgeInsets.all(8),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  side: BorderSide(color: appcolor)),
                              onPressed: () async {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            RegisterPage()));
                              },
                              child: Text(
                                "REGISTER",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: white),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 7,
                          ),
                          Container(
                            alignment: Alignment.topRight,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            ForgetPass()));
                                print("forget password");
                              },
                              child: Text(
                                "Forget Password ?",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: appcolor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          )
                        ]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
