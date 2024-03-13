import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

const black = Color(0xFF000000);
const white = Color(0xFFFFFFFF);
const appcolor = Color(0xFF17C5CC);
const menuColor = Color(0xFFA4A4A4);
const color2 = Color(0xFF000040);
const montserrat = 'Poppins';

divider() => Divider(
      color: Colors.grey,
      thickness: 0.5,
    );
divider2() => Divider(
      color: Colors.grey,
      thickness: 0.3,
    );
divider3() => Divider(
      color: Colors.grey,
      height: 0,
      thickness: 0.5,
    );

textDecoration(hint) => InputDecoration(
      fillColor: white,
      // prefixIcon: Icon(icon, color: black,),
      filled: true,
      contentPadding: EdgeInsets.only(left: 0),
      // contentPadding: EdgeInsets.fromLTRB(5.0, 15.0, 5.0, 0.0),
      hintText: (hint),
      hintStyle: TextStyle(
        color: Colors.grey,
        fontSize: 14.0,
      ),
      border: new UnderlineInputBorder(
        borderSide: new BorderSide(color: appcolor, width: 1.5),
        borderRadius: BorderRadius.circular(3.0),
      ),
      focusedErrorBorder: new UnderlineInputBorder(
        borderSide: BorderSide(color: appcolor, width: 1.5),
        borderRadius: BorderRadius.circular(3.0),
      ),
      errorBorder: new UnderlineInputBorder(
        borderSide: new BorderSide(color: appcolor, width: 1.5),
        borderRadius: BorderRadius.circular(3.0),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: appcolor, width: 1.5),
        borderRadius: BorderRadius.circular(3.0),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: appcolor, width: 1.5),
        borderRadius: BorderRadius.circular(3.0),
      ),
    );

textDecoration2(hint) => InputDecoration(
      // suffixIcon: IconButton(
      //   icon: Icon(Icons.search_sharp, color: Colors.grey,),
      //   splashRadius: 25,
      //   splashColor: appcolor,
      //  onPressed: (){}),
      fillColor: white,
      filled: true,
      contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
      hintText: (hint),
      hintStyle: TextStyle(
        color: Colors.grey,
        fontSize: 16.0,
      ),
      border: new OutlineInputBorder(
        borderSide: new BorderSide(color: white, width: 1.0),
        borderRadius: BorderRadius.circular(5.0),
      ),
      focusedErrorBorder: new OutlineInputBorder(
        borderSide: BorderSide(color: white, width: 1.0),
        borderRadius: BorderRadius.circular(5.0),
      ),
      errorBorder: new OutlineInputBorder(
        borderSide: new BorderSide(color: appcolor, width: 1.5),
        borderRadius: BorderRadius.circular(5.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: white, width: 1.0),
        borderRadius: BorderRadius.circular(5.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: white, width: 1.0),
        borderRadius: BorderRadius.circular(5.0),
      ),
    );

textDecoration3(hint, icon) => InputDecoration(
      fillColor: white,
      prefixIcon: Icon(
        icon,
        color: appcolor,
        size: 22,
      ),
      filled: true,
      contentPadding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      hintText: (hint),
      hintStyle: TextStyle(
        color: Colors.grey,
        fontSize: 16.0,
      ),
      border: new UnderlineInputBorder(
        borderSide: new BorderSide(color: appcolor, width: 1.5),
        borderRadius: BorderRadius.circular(3.0),
      ),
      focusedErrorBorder: new UnderlineInputBorder(
        borderSide: BorderSide(color: appcolor, width: 1.5),
        borderRadius: BorderRadius.circular(3.0),
      ),
      errorBorder: new UnderlineInputBorder(
        borderSide: new BorderSide(color: appcolor, width: 1.5),
        borderRadius: BorderRadius.circular(3.0),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: appcolor, width: 1.5),
        borderRadius: BorderRadius.circular(3.0),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: appcolor, width: 1.5),
        borderRadius: BorderRadius.circular(3.0),
      ),
    );

message_input(hint) => InputDecoration(
      fillColor: white,
      filled: true,
      contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
      prefixIcon: Icon(
        Icons.keyboard,
        color: appcolor,
      ),
      suffixIcon: IconButton(
          icon: Icon(
            Icons.send,
            color: appcolor,
          ),
          padding: EdgeInsets.all(0),
          onPressed: () {}),
      hintText: (hint),
      hintStyle: TextStyle(
        color: Colors.grey,
        fontSize: 16.0,
      ),
      border: new OutlineInputBorder(
        borderSide: new BorderSide(color: appcolor, width: 0.5),
        borderRadius: BorderRadius.circular(25.0),
      ),
      focusedErrorBorder: new OutlineInputBorder(
        borderSide: BorderSide(color: appcolor, width: 0.5),
        borderRadius: BorderRadius.circular(25.0),
      ),
      errorBorder: new OutlineInputBorder(
        borderSide: new BorderSide(color: appcolor, width: 1.5),
        borderRadius: BorderRadius.circular(25.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: appcolor, width: 0.5),
        borderRadius: BorderRadius.circular(25.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: appcolor, width: 0.5),
        borderRadius: BorderRadius.circular(25.0),
      ),
    );

textInputDecoration(hint, lable) => InputDecoration(
      fillColor: white,
      // prefixIcon: Icon(icon, color: black,),
      filled: true,
      contentPadding: EdgeInsets.only(left: 0),
      labelText: lable,
      labelStyle: TextStyle(
        fontSize: 14,
      ),
      hintText: hint,
      hintStyle: TextStyle(
        color: Colors.grey,
        fontSize: 14.0,
      ),
      border: new UnderlineInputBorder(
        borderSide: new BorderSide(color: appcolor, width: 1.5),
        borderRadius: BorderRadius.circular(3.0),
      ),
      focusedErrorBorder: new UnderlineInputBorder(
        borderSide: BorderSide(color: appcolor, width: 1.5),
        borderRadius: BorderRadius.circular(3.0),
      ),
      errorBorder: new UnderlineInputBorder(
        borderSide: new BorderSide(color: appcolor, width: 1.5),
        borderRadius: BorderRadius.circular(3.0),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: appcolor, width: 1.5),
        borderRadius: BorderRadius.circular(3.0),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: appcolor, width: 1.5),
        borderRadius: BorderRadius.circular(3.0),
      ),
    );
