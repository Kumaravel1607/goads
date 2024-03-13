import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/widgets.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:services/Constant/Colors.dart';
import 'BottomTab.dart';
import 'LoginPage.dart';
import 'package:services/Constant/api.dart';
import 'package:services/Constant/app_version.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'UpdateVersion.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SharedPreferences sharedPreferences;

  // String currentVersion;
  // String versionStatus;

  @override
  void initState() {
    Timer(
      Duration(seconds: 2),
      () => checkLoginStatus(),
      //  app_version(),
    );
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future<Version> app_version() async {
    var response = await http.get(Uri.parse(app_api + '/version'));
    var jsonResponse;
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);

      if (jsonResponse['current_version'] == "1.0") {
        checkLoginStatus();
      } else {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    UpdateVersion(versions: jsonResponse['update_status'])),
            (Route<dynamic> route) => false);
      }

      // setState(() {
      //   currentVersion = jsonResponse['current_version'].toString();
      // versionStatus = jsonResponse['update_status'];
      // });

      print(jsonResponse);

      return Version.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load post');
    }
  }

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("user_id") != null) {
      // if (currentVersion == "1") {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => BottomTab()),
          (Route<dynamic> route) => false);
      // } else {
      //   Navigator.of(context).pushAndRemoveUntil(
      //   MaterialPageRoute(builder: (BuildContext context) => UpdateVersion()),
      //   (Route<dynamic> route) => false);
      // }

    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Image.asset(
              "assets/images/logo-gooads.png",
              // height: 230,
              width: 300,
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
