import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:services/Constant/Colors.dart';
import 'package:services/Constant/Location_controller.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:services/Constant/api.dart';
import 'package:services/Model/AdsDetail_model.dart';
import 'package:services/Model/Location_model.dart';
import 'package:services/Screens/Edit_BussinessPost/Screen_2.dart';
import 'package:services/Widgets/ElevatedButton.dart';
import 'package:http/http.dart' as http;
import 'package:services/Widgets/LoadingWidget.dart';

class Edit_Screen_1 extends StatefulWidget {
  final String id;
  final String title;
  Edit_Screen_1({
    Key key,
    this.id,
    this.title,
  }) : super(key: key);

  @override
  _Edit_Screen_1State createState() => _Edit_Screen_1State();
}

class _Edit_Screen_1State extends State<Edit_Screen_1> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController shopname = new TextEditingController();
  final TextEditingController ownername = new TextEditingController();
  final TextEditingController location = new TextEditingController();
  final TextEditingController pincode = new TextEditingController();
  final TextEditingController mobile = new TextEditingController();
  final TextEditingController email = new TextEditingController();
  final TextEditingController address1 = new TextEditingController();
  final TextEditingController address2 = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ads_detail();
  }

  bool _isLoading = false;
  int doorStep;
  String subcat;
  String cityID;
  String cityIDs;
  String category_id;
  String service;

  bool _loading = true;
  bool clickload = true;

  Future<AdsDetail> ads_detail() async {
    Map data = {
      'id': widget.id,
    };
    print("data");
    print(data);
    var response =
        await http.post(Uri.parse(app_api + '/ads_detail'), body: data);
    var jsonResponse;
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      print(jsonResponse);
      setState(() {
        _isLoading = true;
      });
      shopname.text = jsonResponse['ads_name'];
      ownername.text = jsonResponse['extra']['owner_name'];
      mobile.text = jsonResponse['extra']['mobile_number'];
      email.text = jsonResponse['extra']['email'];
      address1.text = jsonResponse['extra']['address1'];
      address2.text = jsonResponse['extra']['address2'];
      pincode.text = jsonResponse['extra']['pincode'];
      location.text = jsonResponse['city_name'].toString();
      service = jsonResponse['service_type'];
      category_id = jsonResponse['category_id'].toString();
      print(category_id);
      cityID = jsonResponse['city_id'].toString();

      return AdsDetail.fromJson(jsonResponse);
    } else {
      setState(() {
        _isLoading = false;
      });
      throw Exception('Failed to load post');
    }
  }

  Future<List<Location>> get_locationData(city) async {
    try {
      Map data = {
        'city_name': city,
      };
      // print(data);
      var response = await http.post(Uri.parse(app_api + '/city'), body: data);
      var locationDatas = List<Location>();

      if (response.statusCode == 200) {
        var locationDatasJson = (json.decode(response.body));
        setState(() {
          _loading = false;
        });
        print(locationDatasJson);

        for (var locationDataJson in locationDatasJson) {
          locationDatas.add(Location.fromJson(locationDataJson));
        }
      }
      return locationDatas;
    } catch (e) {
      print("Error getting location.");
    }
  }

  Widget list(Location location) {
    return SingleChildScrollView(
      child: ListTile(
        title: Text(location.city_name),
        // subtitle: Text(location.id),
      ),
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: appcolor,
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: _isLoading
          ? SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Company/Shop Name *",
                        style: TextStyle(color: color2, fontSize: 16),
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter Company/Shop name *';
                          }
                          return null;
                        },
                        cursorHeight: 18,
                        onSaved: (String value) {},
                        controller: shopname,
                        obscureText: false,
                        onTap: () {},
                        style: TextStyle(
                          fontSize: 14.0,
                          color: black,
                        ),
                        keyboardType: TextInputType.text,
                        decoration: textDecoration(
                          'Shop Name ',
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Text(
                        "Owner Name *",
                        style: TextStyle(color: color2, fontSize: 16),
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter Owner name';
                          }
                          return null;
                        },
                        cursorHeight: 18,
                        onSaved: (String value) {},
                        controller: ownername,
                        obscureText: false,
                        onTap: () {},
                        style: TextStyle(
                          fontSize: 14.0,
                          color: black,
                        ),
                        keyboardType: TextInputType.text,
                        decoration: textDecoration(
                          'Owner Name ',
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Text(
                        "Mobile Number *",
                        style: TextStyle(color: color2, fontSize: 16),
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter mobile number';
                          }
                          return null;
                        },
                        cursorHeight: 18,
                        onSaved: (String value) {},
                        controller: mobile,
                        obscureText: false,
                        onTap: () {},
                        style: TextStyle(
                          fontSize: 14.0,
                          color: black,
                        ),
                        keyboardType: TextInputType.text,
                        decoration: textDecoration(
                          'Mobile ',
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Text(
                        "Email *",
                        style: TextStyle(color: color2, fontSize: 16),
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter valid email';
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
                        keyboardType: TextInputType.emailAddress,
                        decoration: textDecoration(
                          'Email ',
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Text(
                        "Address 1 *",
                        style: TextStyle(color: color2, fontSize: 16),
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Enter address';
                          }
                          return null;
                        },
                        onSaved: (String value) {},
                        controller: address1,
                        maxLines: 3,
                        minLines: 1,
                        onTap: () {},
                        style: TextStyle(
                          fontSize: 14.0,
                          color: black,
                        ),
                        keyboardType: TextInputType.multiline,
                        decoration: textDecoration(
                          'Enter address ',
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Text(
                        "Address 2",
                        style: TextStyle(color: color2, fontSize: 16),
                      ),
                      TextFormField(
                        // validator: (value) {
                        //   if (value.isEmpty) {
                        //     return 'Enter address';
                        //   }
                        //   return null;
                        // },
                        onSaved: (String value) {},
                        controller: address2,
                        maxLines: 3,
                        minLines: 1,
                        onTap: () {},
                        style: TextStyle(
                          fontSize: 14.0,
                          color: black,
                        ),
                        keyboardType: TextInputType.multiline,
                        decoration: textDecoration(
                          'Enter address ',
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Text(
                        "Pincode *",
                        style: TextStyle(color: color2, fontSize: 16),
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter pincode';
                          }
                          return null;
                        },
                        cursorHeight: 18,
                        onSaved: (String value) {},
                        controller: pincode,
                        obscureText: false,
                        onTap: () {},
                        style: TextStyle(
                          fontSize: 14.0,
                          color: black,
                        ),
                        keyboardType: TextInputType.text,
                        decoration: textDecoration(
                          'Pincode ',
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Text(
                        "Location *",
                        style: TextStyle(color: color2, fontSize: 16),
                      ),
                      TypeAheadField(
                        textFieldConfiguration: TextFieldConfiguration(
                            // autofocus: true,
                            controller: location,
                            decoration: textDecoration("Select Location")),
                        suggestionsCallback: (pattern) async {
                          return await get_locationData(pattern);
                        },
                        itemBuilder: (context, item) {
                          return list(item);
                        },
                        onSuggestionSelected: (item) async {
                          setState(() {
                            location.text = item.city_name;
                            cityID = item.id;
                          });
                        },
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Center(
                        child: Container(
                            width: MediaQuery.of(context).size.width * 0.90,
                            child: ElevatedBtn(submitButton, "Next")),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : FullScreenLoading(),
    );
  }

  Future<void> _alerBox() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text("Please select location"),
            //title: Text(),
            actions: <Widget>[
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(context, "ok");
                },
                child: const Text("OK"),
              )
            ],
          );
        });
  }

  void submitButton() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      if (cityID != null) {
        Map data = {
          'id': widget.id,
          "sub_category_type": "repairs-servicing",
          // "category_id": widget.cat_id,
          // "sub_category_id": "",
          // "main_category": widget.mainCategory,
          "ads_name": shopname.text,
          "owner_name": ownername.text,
          "mobile_number": mobile.text,
          "email": email.text,
          "address1": address1.text,
          "address2": address2.text.isEmpty ? "" : address2.text,
          "company_state_id": "",
          "pincode": pincode.text,
          "city_id": cityID,
          // "city_ids": cityIDs,
        };

        print(data);
        Navigator.of(context, rootNavigator: true)
            .pushReplacement(CupertinoPageRoute(
                builder: (_) => Edit_Screen_2(
                      mapData: data,
                      id: widget.id,
                    )));
      } else {
        _alerBox();
      }
    }
  }
}
