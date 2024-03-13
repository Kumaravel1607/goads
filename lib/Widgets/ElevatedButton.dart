import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:services/Constant/Colors.dart';

class ElevatedBtn extends StatelessWidget {
  final Function selcetedBtn;
  final String btnName;
  ElevatedBtn(
    this.selcetedBtn,
    this.btnName,
  );

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: selcetedBtn,
      child: Text(
        btnName,
        style: TextStyle(fontSize: 18, color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
          elevation: 7,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          primary: appcolor,
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
    ); //Container
  }
}
