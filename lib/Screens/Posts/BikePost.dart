import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:services/Constant/Colors.dart';
import 'package:services/Constant/api.dart';
import 'package:services/Screens/AddPost.dart';
import 'package:services/Widgets/ElevatedButton.dart';
import 'package:http/http.dart' as http;
import 'package:services/Widgets/LoadingWidget.dart';

class BikePost extends StatefulWidget {
  final String subcat_type;
  final String cat_id;
  final String subcat_id;
  BikePost({Key key, this.subcat_type, this.cat_id, this.subcat_id})
      : super(key: key);

  @override
  _BikePostState createState() => _BikePostState();
}

class _BikePostState extends State<BikePost> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  // final TextEditingController model = new TextEditingController();
  final TextEditingController yearOfRegister = new TextEditingController();
  // final TextEditingController fueltype = new TextEditingController();
  final TextEditingController insurance = new TextEditingController();
  final TextEditingController kmDriven = new TextEditingController();

  String seller;
  String brand;
  String model;
  String noOfOwner;
  String fueltype;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDropdownValues();
  }

  List allBrands = List();
  List allModels = List();
  List typeoffuels = List();
  List ownersList = List();
  List sellersList = List();
  Future<String> getDropdownValues() async {
    Map data = {
      'attribute_id': widget.subcat_type != null ? widget.subcat_type : 'bike',
    };
    var res =
        await http.post(Uri.parse(app_api + "/attribute_mutiple"), body: data);
    if (res.statusCode == 200) {
      var resBody = (json.decode(res.body));
      print("---------------NK-----------");
      print(resBody);
      setState(() {
        _isLoading = true;
        allBrands = resBody['bike_brand'];
        typeoffuels = resBody['fuel-type'];
        ownersList = resBody['owners'];
        sellersList = resBody['seller_by'];
      });
      print(allBrands);
      return "Success";
    } else {
      _isLoading = false;
      print("error");
      print(res.body.toString());
    }
  }

  Future<String> get_model(id) async {
    Map data = {
      'attribute_list_id': id,
    };
    var res =
        await http.post(Uri.parse(app_api + "/attribute_model"), body: data);
    if (res.statusCode == 200) {
      var resBody = (json.decode(res.body));
      print("---------------NK-----------");
      print(resBody);
      setState(() {
        // _isLoading = true;
        allModels = resBody;
      });
      print(allModels);
      return "Success";
    } else {
      // _isLoading = false;
    }
  }

  // Map carsData = {
  //   'sub_category_type': 'bike',
  // };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: appcolor,
        title: Text(
          "Post Bike, Scooty and Cycle",
          style: TextStyle(color: white),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: white),
      ),
      body: _isLoading
          ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      DropdownButtonFormField<String>(
                        decoration: textInputDecoration('brand *', "Brand *"),
                        style: TextStyle(fontSize: 14),
                        items: allBrands.map((item) {
                          return DropdownMenuItem<String>(
                            value: item["id"].toString(),
                            child: new Text(
                              item['attribute_list_name'],
                              style: TextStyle(
                                color: color2,
                                fontSize: 15,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            brand = newValue;
                          });
                          get_model(brand);
                        },
                        validator: (value) =>
                            value == null ? 'Select brand ' : null,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      DropdownButtonFormField<String>(
                        decoration: textInputDecoration('model *', "Model"),
                        style: TextStyle(fontSize: 14),
                        items: allModels.map((item) {
                          return DropdownMenuItem<String>(
                            value: item["id"].toString(),
                            child: new Text(
                              item['attribute_list_name'],
                              style: TextStyle(
                                color: color2,
                                fontSize: 15,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            model = newValue;
                          });
                        },
                        // validator: (value) =>
                        //     value == null ? 'Select model ' : null,
                      ),
                      /* TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter bike model';
                          }
                          return null;
                        },
                        onSaved: (String value) {},
                        controller: model,
                        onTap: () {},
                        style: TextStyle(
                          fontSize: 14.0,
                          color: black,
                        ),
                        keyboardType: TextInputType.text,
                        decoration: textInputDecoration(
                          'Enter Bike Model ',
                          'Bike Model *',
                        ),
                      ), */
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Enter Bike Registration year';
                          }
                          return null;
                        },
                        onSaved: (String value) {},
                        controller: yearOfRegister,
                        onTap: () {},
                        style: TextStyle(
                          fontSize: 14.0,
                          color: black,
                        ),
                        keyboardType: TextInputType.number,
                        decoration: textInputDecoration(
                          'Enter Bike Registration Year ',
                          'Registration Year *',
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      DropdownButtonFormField<String>(
                        decoration:
                            textInputDecoration('Fuel type *', "Fuel Type *"),
                        style: TextStyle(fontSize: 14),
                        items: typeoffuels.map((item) {
                          return DropdownMenuItem<String>(
                            value: item["id"].toString(),
                            child: new Text(
                              item['attribute_list_name'],
                              style: TextStyle(
                                color: color2,
                                fontSize: 15,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            fueltype = newValue;
                          });
                        },
                        validator: (value) =>
                            value == null ? 'Select fuel type ' : null,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Enter Insurance Valid';
                          }
                          return null;
                        },
                        onSaved: (String value) {},
                        controller: insurance,
                        onTap: () {},
                        style: TextStyle(
                          fontSize: 14.0,
                          color: black,
                        ),
                        keyboardType: TextInputType.datetime,
                        decoration: textInputDecoration(
                          'Enter Insurance Valid',
                          'Insurance Valid *',
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Enter KM driven';
                          }
                          return null;
                        },
                        onSaved: (String value) {},
                        controller: kmDriven,
                        onTap: () {},
                        style: TextStyle(
                          fontSize: 14.0,
                          color: black,
                        ),
                        keyboardType: TextInputType.text,
                        decoration: textInputDecoration(
                          'Enter Bike KM driven ',
                          'KM driven *',
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      DropdownButtonFormField<String>(
                        decoration:
                            textInputDecoration('No Of Owner', "No Of Owner *"),
                        style: TextStyle(fontSize: 14),
                        items: ownersList.map((item) {
                          return DropdownMenuItem<String>(
                            value: item["id"].toString(),
                            child: new Text(
                              item['attribute_list_name'],
                              style: TextStyle(
                                color: color2,
                                fontSize: 15,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            noOfOwner = newValue;
                          });
                        },
                        validator: (value) =>
                            value == null ? 'Select No Of Owner ' : null,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      DropdownButtonFormField<String>(
                        decoration: textInputDecoration('Seller', "Seller *"),
                        style: TextStyle(fontSize: 14),
                        items: sellersList.map((item) {
                          return DropdownMenuItem<String>(
                            value: item["id"].toString(),
                            child: new Text(
                              item['attribute_list_name'],
                              style: TextStyle(
                                color: color2,
                                fontSize: 15,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            seller = newValue;
                          });
                        },
                        validator: (value) =>
                            value == null ? 'Select Seller ' : null,
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Center(
                        child: Container(
                            width: MediaQuery.of(context).size.width * 0.90,
                            child: ElevatedBtn(submitButton, "Next")),
                      )
                    ],
                  ),
                ),
              ),
            )
          : FullScreenLoading(),
    );
  }

  void submitButton() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      Map bikeData = {
        'sub_category_type': widget.subcat_type,
        'brand_id': brand,
        'model': model,
        'registration_date': yearOfRegister.text,
        'engine_size': "",
        'fuel_type': fueltype,
        'insurance_valid': insurance.text,
        'km_driven': kmDriven.text,
        'no_of_owner': noOfOwner,
        'seller_by': seller,
      };

      print(bikeData);
      print(widget.subcat_id);
      print(widget.cat_id);
      Navigator.of(context, rootNavigator: true).pushReplacement(
          CupertinoPageRoute(
              builder: (_) => AddPostsPage(
                  categoryID: widget.cat_id.toString(),
                  subcategoryID: widget.subcat_id,
                  subcategoryName: widget.subcat_type,
                  mapdata: bikeData)));
    }
  }
}
