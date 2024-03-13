import 'package:flutter/material.dart';
import 'package:services/Constant/Colors.dart';
import 'package:services/Constant/api.dart';
import 'package:services/Constant/app_version.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'BottomTab.dart';


class UpdateVersion extends StatefulWidget {
  final String versions;
  UpdateVersion({Key key, this.versions}) : super(key: key);

  @override
  _UpdateVersionState createState() => _UpdateVersionState();
}

class _UpdateVersionState extends State<UpdateVersion> {

  //  String currentVersion;
  // String versionStatus;

 @override
  void initState() {
    super.initState();
    // app_version();
  }

  //   Future<Version> app_version() async {

  //   var response = await http.get(app_api + '/version');

  //   var jsonResponse;
  //   if (response.statusCode == 200) {
  //     jsonResponse = json.decode(response.body);

  //     setState(() {
  //       currentVersion = jsonResponse['current_version'].toString();
  //     versionStatus = jsonResponse['update_status'];
  //     });

  //     print(jsonResponse);

  //     return Version.fromJson(jsonResponse);
  //   } else {
  //     throw Exception('Failed to load post');
  //   }
  // }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(35),
      color: appcolor,
       child: Center(
         child: Container(
           height: 200,
           child: Card(
             color: white,
             child: Padding(
               padding: const EdgeInsets.all(20.0),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.center,
                     mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   Text("New version available click to download",style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
                   SizedBox(height: 40,),
                   Row(
                     crossAxisAlignment: CrossAxisAlignment.center,
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                      widget.versions != "yes" ? FlatButton(
                         color: appcolor,
                         onPressed: (){
                           Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (BuildContext context) => BottomTab()),
                            (Route<dynamic> route) => false);
                         }, 
                         child: Text("Cancel", style: TextStyle(color: white),)) : SizedBox(),

                        //  SizedBox(width:40),
                        Spacer(),

                         FlatButton(
                         color: appcolor,
                         onPressed: (){
                           print("App Link");
                         }, 
                         child: Text("Confirm", style: TextStyle(color: white),)),
                     ],
                   ),
                 ],
               ),
             ),
           ),
         )
       ),
    );
  }
}