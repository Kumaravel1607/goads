import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:services/Constant/Colors.dart';
import 'package:services/Constant/Location_controller.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:services/Constant/api.dart';
import 'package:services/Screens/Posts/BusinessPost.dart';
import 'package:services/Widgets/ElevatedButton.dart';
import 'package:http/http.dart' as http;

class RepairesAndServices extends StatefulWidget {
  final String cat_id;
  final String subcat_id;
  final String subcat_type;
  final String cat_name;
  final String mainCategory;
  RepairesAndServices(
      {Key key,
      this.subcat_type,
      this.cat_id,
      this.subcat_id,
      this.cat_name,
      this.mainCategory})
      : super(key: key);

  @override
  _RepairesAndServicesState createState() => _RepairesAndServicesState();
}

class _RepairesAndServicesState extends State<RepairesAndServices> {
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

  String subcat;
  String cityID;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: appcolor,
        title: Text(widget.cat_name),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text(
                //   "SubCategory *",
                //   style: TextStyle(color: color2, fontSize: 16),
                // ),
                // DropdownButtonFormField<String>(
                //   decoration: textDecoration(
                //     'Select category',
                //   ),
                //   items: <String>[
                //     'Electric',
                //     'Electronic',
                //     'Home Repairs',
                //     'Appliance Repairs',
                //   ]
                //       .map((String value) => DropdownMenuItem<String>(
                //             value: value,
                //             child: Text(
                //               value,
                //               style: TextStyle(
                //                 color: black,
                //                 fontFamily: montserrat,
                //                 fontSize: 16,
                //               ),
                //             ),
                //           ))
                //       .toList(),
                //   onChanged: (newValue) {
                //     setState(() {
                //       subcat = newValue;
                //     });
                //   },
                //   validator: (value) =>
                //       value == null ? 'select working hours' : null,
                // ),
                // SizedBox(
                //   height: 25,
                // ),
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
                  maxLength: 10,
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
                  height: 10,
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
      ),
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
          "sub_category_type": "repairs-servicing",
          "category_id": widget.cat_id,
          "sub_category_id": widget.subcat_id != null ? widget.subcat_id : "",
          "main_category": widget.mainCategory,
          "ads_name": shopname.text,
          "owner_name": ownername.text,
          "mobile_number": mobile.text,
          "email": email.text,
          "address1": address1.text,
          "address2": address2.text.isEmpty ? "" : address2.text,
          "company_state_id": "",
          "pincode": pincode.text,
          "city_id": cityID,
          // "city_ids": cityID,
        };

        print(data);
        Navigator.of(context, rootNavigator: true)
            .pushReplacement(CupertinoPageRoute(
                builder: (_) => BusinessPost(
                      mapData: data,
                    )));
      } else {
        _alerBox();
      }
    }
  }
}
