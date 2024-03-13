import 'package:flutter/material.dart';
import 'package:services/Constant/Colors.dart';
import 'package:services/Constant/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'LoginPage.dart';

class NewPass extends StatefulWidget {
  final String useremail;
  NewPass({
    Key key,
    this.useremail,
  }) : super(key: key);

  @override
  _NewPassState createState() => _NewPassState();
}

final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
final TextEditingController email = new TextEditingController();
final TextEditingController newpass = new TextEditingController();
final TextEditingController confirmpass = new TextEditingController();

class _NewPassState extends State<NewPass> {
  bool _isLoading = false;
  SharedPreferences sharedPreferences;

  @override
  void initState() {}

  password_change(
    newPass,
    confirmPass,
  ) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'email': widget.useremail,
      'new_password': newPass,
      'confirm_password': confirmPass,
    };

    print(data);
    var jsonResponse = null;
    var response =
        await http.post(Uri.parse(app_api + "/new_password"), body: data);
    // jsonResponse = json.decode(response.body);

    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        setState(() {
          _isLoading = false;
        });
        _alerDialog(jsonResponse['message']);

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
            (Route<dynamic> route) => false);
      }
    } else if (response.statusCode == 422) {
      jsonResponse = json.decode(response.body);
      setState(() {
        _isLoading = false;
      });
      _alerDialog(jsonResponse['message']);
      print("object");
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
            content: Text("Password is not match"),
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
                "New Password",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 24, fontWeight: FontWeight.bold, color: black),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                padding: EdgeInsets.only(left: 40, right: 40),
                alignment: Alignment.bottomCenter,
                height: 440,
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
                        SizedBox(
                          height: 25,
                        ),
                        Text(
                          "New Password",
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
                              return 'Please enter new password';
                            }
                            return null;
                          },
                          onSaved: (String value) {},
                          controller: newpass,
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
                            hintText: ('Enter New Password'),
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
                          "Confirm Password",
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
                              return 'Please enter Confirm password';
                            }
                            return null;
                          },
                          onSaved: (String value) {},
                          controller: confirmpass,
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
                            hintText: ('Enter Confirm Password'),
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
                              if (_formKey.currentState.validate()) {
                                _formKey.currentState.save();
                                if (newpass.text == confirmpass.text) {
                                  password_change(
                                    newpass.text,
                                    confirmpass.text,
                                  );
                                } else {
                                  _alerBox();
                                }
                              }
                            },
                            child: Text(
                              "Change Password",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: white),
                            ),
                          ),
                        ),
                      ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
