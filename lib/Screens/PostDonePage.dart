import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:services/Constant/Colors.dart';
import 'package:services/Screens/BottomTab.dart';
import 'package:services/Screens/MyPosts.dart';

class PostDone extends StatefulWidget {
  @override
  _PostDoneState createState() => _PostDoneState();
}

class _PostDoneState extends State<PostDone> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/checked.png",
              height: 70,
              width: 70,
            ),
            SizedBox(
              height: 50,
            ),
            Text(
              "CONGRATULATIONS !",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: appcolor,
                fontSize: 22,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Your ad will go live shortly ",
              style: TextStyle(
                  fontSize: 16, color: color2, fontWeight: FontWeight.w700),
            ),
            SizedBox(
              height: 80,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  width: MediaQuery.of(context).size.width * 0.90,
                  child: Row(
                    children: [
                      Expanded(
                          child: ElevatedButton(
                              onPressed: detailButton,
                              child: Text("Preview Ad"))),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                          child: ElevatedButton(
                              onPressed: homeButton,
                              child: Text("Go to Home"))),
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }

  void homeButton() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => BottomTab()),
        (Route<dynamic> route) => false);
  }

  void detailButton() {
    Navigator.of(context, rootNavigator: true).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => MyPosts()));
  }
}
