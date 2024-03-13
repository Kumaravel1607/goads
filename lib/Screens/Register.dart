import 'package:flutter/material.dart';
import 'package:services/Constant/Colors.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:services/Constant/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'BottomTab.dart';

class RegisterPage extends StatefulWidget {
  // final String mobilenumber;
  // RegisterPage({Key key, this.mobilenumber}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController fname = new TextEditingController();
  final TextEditingController lname = new TextEditingController();
  final TextEditingController mobilenumber = new TextEditingController();
  final TextEditingController email = new TextEditingController();
  final TextEditingController password = new TextEditingController();

  String _gender = '';

  String firebase_id;
  SharedPreferences sharedPreferences;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  bool _isLoading = false;

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

  register(
    mobile,
    fname,
    lname,
    email,
    gender,
    pass,
  ) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'mobile_no': mobile,
      'first_name': fname,
      'last_name': lname,
      'email': email,
      'gender': gender,
      'app_id': firebase_id,
      'password': pass,
    };

    print(data);
    var jsonResponse;
    var response =
        await http.post(Uri.parse(app_api + "/register"), body: data);

    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if (jsonResponse != null) {
        setState(() {
          _isLoading = false;
        });

        sharedPreferences.setString(
            "user_id", json.decode(response.body)['user_id'].toString());

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => BottomTab()),
            (Route<dynamic> route) => false);
        // _alerDialog(jsonResponse['message']);
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      jsonResponse = json.decode(response.body);
      // print(jsonResponse['message']);
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
            content: Text("Please fill Required field"),
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
      backgroundColor: white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(25, 10, 25, 20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "New Register",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: black,
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "First Name",
                    style: TextStyle(color: black, fontSize: 16),
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your first name';
                      }
                      return null;
                    },
                    cursorHeight: 18,
                    onSaved: (String value) {},
                    controller: fname,
                    obscureText: false,
                    onTap: () {},
                    style: TextStyle(
                      fontSize: 14.0,
                      color: black,
                    ),
                    keyboardType: TextInputType.text,
                    decoration: textDecoration(
                      'First name',
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Text(
                    "Last Name",
                    style: TextStyle(color: black, fontSize: 16),
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your last name';
                      }
                      return null;
                    },
                    cursorHeight: 18,
                    onSaved: (String value) {},
                    controller: lname,
                    obscureText: false,
                    onTap: () {},
                    style: TextStyle(
                      fontSize: 14.0,
                      color: black,
                    ),
                    keyboardType: TextInputType.text,
                    decoration: textDecoration(
                      'Last name',
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Text(
                    "Email",
                    style: TextStyle(color: black, fontSize: 16),
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your Email';
                      }
                      return null;
                    },
                    cursorHeight: 18,
                    onSaved: (String value) {},
                    controller: email,
                    obscureText: false,
                    onTap: () {},
                    style: TextStyle(
                      fontSize: 14.0,
                      color: black,
                    ),
                    keyboardType: TextInputType.text,
                    decoration: textDecoration(
                      'Email',
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Text(
                    "Mobile Number",
                    style: TextStyle(color: black, fontSize: 16),
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your number';
                      }
                      return null;
                    },
                    cursorHeight: 18,
                    onSaved: (String value) {},
                    controller: mobilenumber,
                    obscureText: false,
                    onTap: () {},
                    style: TextStyle(
                      fontSize: 14.0,
                      color: black,
                    ),
                    keyboardType: TextInputType.text,
                    decoration: textDecoration(
                      'Mobile Number',
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Text(
                    "Password",
                    style: TextStyle(color: black, fontSize: 16),
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your Password';
                      }
                      return null;
                    },
                    cursorHeight: 18,
                    onSaved: (String value) {},
                    controller: password,
                    obscureText: true,
                    onTap: () {},
                    style: TextStyle(
                      fontSize: 14.0,
                      color: black,
                    ),
                    keyboardType: TextInputType.text,
                    decoration: textDecoration(
                      'Password',
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Text(
                    "Gender",
                    style: TextStyle(color: black, fontSize: 16),
                  ),
                  DropdownButtonFormField<String>(
                    decoration: textDecoration(
                      'Gender',
                    ),
                    items: <String>[
                      'Male',
                      'Female',
                      'Others',
                    ]
                        .map((String value) => DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(
                                  color: black,
                                  fontFamily: montserrat,
                                  fontSize: 16,
                                ),
                              ),
                            ))
                        .toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _gender = newValue;
                      });
                    },
                    validator: (value) =>
                        value == null ? 'Please select the Gender' : null,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  ButtonTheme(
                    buttonColor: appcolor,
                    minWidth: 400,
                    child: FlatButton(
                      color: appcolor,
                      padding: EdgeInsets.all(8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0.0),
                          side: BorderSide(color: appcolor)),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
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
                          register(
                            mobilenumber.text,
                            fname.text,
                            lname.text,
                            email.text,
                            _gender,
                            password.text,
                          );
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
                    height: 10,
                  ),
                  ButtonTheme(
                    buttonColor: appcolor,
                    minWidth: 400,
                    child: FlatButton(
                      color: appcolor,
                      padding: EdgeInsets.all(8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0.0),
                          side: BorderSide(color: appcolor)),
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "BACK",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
