// import 'package:flutter/material.dart';
// import 'package:services/Constant/Colors.dart';
// import 'package:services/Widgets/ElevatedButton.dart';

// class PropertyPost extends StatefulWidget {
//   PropertyPost({Key key}) : super(key: key);

//   @override
//   _PropertyPostState createState() => _PropertyPostState();
// }

// class _PropertyPostState extends State<PropertyPost> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

//   final TextEditingController floor = new TextEditingController();
//   final TextEditingController superBuildupArea = new TextEditingController();
//   final TextEditingController carpetArea = new TextEditingController();
//   final TextEditingController rent = new TextEditingController();

//   String propertyType;
//   String roomType;
//   String furnished;
//   String constructionStatus;
//   String addListedBY;
//   String carParkingSpace;
//   String facing;
//   String whom;

//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: white,
//       appBar: AppBar(
//         backgroundColor: appcolor,
//         title: Text(
//           "Property",
//           style: TextStyle(color: white),
//         ),
//         centerTitle: true,
//         iconTheme: IconThemeData(color: white),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Form(
//             child: Column(
//               children: [
//                 DropdownButtonFormField<String>(
//                   decoration: textInputDecoration(
//                       'Type Of Property', "Type Of Property *"),
//                   style: TextStyle(fontSize: 14),
//                   items: <String>[
//                     'House',
//                     'Flate',
//                     'Farm House',
//                     'Villas',
//                   ]
//                       .map((String value) => DropdownMenuItem<String>(
//                             value: value,
//                             child: Text(
//                               value,
//                               style: TextStyle(
//                                 color: color2,
//                                 fontSize: 15,
//                               ),
//                             ),
//                           ))
//                       .toList(),
//                   onChanged: (newValue) {
//                     setState(() {
//                       propertyType = newValue;
//                     });
//                   },
//                   validator: (value) =>
//                       value == null ? 'Select property type ' : null,
//                 ),
//                 SizedBox(
//                   height: 15,
//                 ),
//                 DropdownButtonFormField<String>(
//                   decoration:
//                       textInputDecoration('Type Of Rooms', "Type Of Rooms *"),
//                   style: TextStyle(fontSize: 14),
//                   items: <String>[
//                     '1 BHK',
//                     '2 BHK',
//                     '3 BHK',
//                     '4 BHK',
//                   ]
//                       .map((String value) => DropdownMenuItem<String>(
//                             value: value,
//                             child: Text(
//                               value,
//                               style: TextStyle(
//                                 color: color2,
//                                 fontSize: 15,
//                               ),
//                             ),
//                           ))
//                       .toList(),
//                   onChanged: (newValue) {
//                     setState(() {
//                       roomType = newValue;
//                     });
//                   },
//                   validator: (value) =>
//                       value == null ? 'Select Bedroom type ' : null,
//                 ),
//                 SizedBox(
//                   height: 15,
//                 ),
//                 TextFormField(
//                   validator: (value) {
//                     if (value.isEmpty) {
//                       return 'Please enter floor';
//                     }
//                     return null;
//                   },
//                   onSaved: (String value) {},
//                   controller: floor,
//                   onTap: () {},
//                   style: TextStyle(
//                     fontSize: 14.0,
//                     color: black,
//                   ),
//                   keyboardType: TextInputType.text,
//                   decoration: textInputDecoration(
//                     'Enter floor ',
//                     'Floor *',
//                   ),
//                 ),
//                 SizedBox(
//                   height: 15,
//                 ),
//                 DropdownButtonFormField<String>(
//                   decoration: textInputDecoration('Furnished', "Furnished *"),
//                   style: TextStyle(fontSize: 14),
//                   items: <String>[
//                     'Furnished',
//                     'Self-furnished',
//                     'Unfurnished',
//                   ]
//                       .map((String value) => DropdownMenuItem<String>(
//                             value: value,
//                             child: Text(
//                               value,
//                               style: TextStyle(
//                                 color: color2,
//                                 fontSize: 15,
//                               ),
//                             ),
//                           ))
//                       .toList(),
//                   onChanged: (newValue) {
//                     setState(() {
//                       furnished = newValue;
//                     });
//                   },
//                   validator: (value) =>
//                       value == null ? 'Select furnished ' : null,
//                 ),
//                 SizedBox(
//                   height: 15,
//                 ),
//                 DropdownButtonFormField<String>(
//                   decoration: textInputDecoration(
//                       'Construction Status', "Construction Status *"),
//                   style: TextStyle(fontSize: 14),
//                   items: <String>[
//                     'New Build',
//                     'Ready to move',
//                     'Under Construction',
//                   ]
//                       .map((String value) => DropdownMenuItem<String>(
//                             value: value,
//                             child: Text(
//                               value,
//                               style: TextStyle(
//                                 color: color2,
//                                 fontSize: 15,
//                               ),
//                             ),
//                           ))
//                       .toList(),
//                   onChanged: (newValue) {
//                     setState(() {
//                       constructionStatus = newValue;
//                     });
//                   },
//                   validator: (value) =>
//                       value == null ? 'Select construction status ' : null,
//                 ),
//                 SizedBox(
//                   height: 15,
//                 ),
//                 DropdownButtonFormField<String>(
//                   decoration:
//                       textInputDecoration('Add Listed By', "Add Listed By *"),
//                   style: TextStyle(fontSize: 14),
//                   items: <String>[
//                     'Owner',
//                     'Builder',
//                     'Dealer',
//                   ]
//                       .map((String value) => DropdownMenuItem<String>(
//                             value: value,
//                             child: Text(
//                               value,
//                               style: TextStyle(
//                                 color: color2,
//                                 fontSize: 15,
//                               ),
//                             ),
//                           ))
//                       .toList(),
//                   onChanged: (newValue) {
//                     setState(() {
//                       addListedBY = newValue;
//                     });
//                   },
//                   validator: (value) =>
//                       value == null ? 'Select add listed by ' : null,
//                 ),
//                 SizedBox(
//                   height: 15,
//                 ),
//                 TextFormField(
//                   validator: (value) {
//                     if (value.isEmpty) {
//                       return 'Enter Super Buildup area in Sq ft';
//                     }
//                     return null;
//                   },
//                   onSaved: (String value) {},
//                   controller: superBuildupArea,
//                   onTap: () {},
//                   style: TextStyle(
//                     fontSize: 14.0,
//                     color: black,
//                   ),
//                   keyboardType: TextInputType.number,
//                   decoration: textInputDecoration(
//                     'Enter Super Buildup area in Sq ft ',
//                     'Super Buildup area in Sq ft *',
//                   ),
//                 ),
//                 SizedBox(
//                   height: 15,
//                 ),
//                 TextFormField(
//                   validator: (value) {
//                     if (value.isEmpty) {
//                       return 'Enter Carpet Area in Sq ft ';
//                     }
//                     return null;
//                   },
//                   onSaved: (String value) {},
//                   controller: carpetArea,
//                   onTap: () {},
//                   style: TextStyle(
//                     fontSize: 14.0,
//                     color: black,
//                   ),
//                   keyboardType: TextInputType.text,
//                   decoration: textInputDecoration(
//                     'Enter Carpet Area in Sq ft ',
//                     'Carpet Area in Sq ft *',
//                   ),
//                 ),
//                 SizedBox(
//                   height: 15,
//                 ),
//                 DropdownButtonFormField<String>(
//                   decoration: textInputDecoration(
//                       'Car Parking Space', "Car Parking Space *"),
//                   style: TextStyle(fontSize: 14),
//                   items: <String>[
//                     '1',
//                     '2',
//                     '3+',
//                   ]
//                       .map((String value) => DropdownMenuItem<String>(
//                             value: value,
//                             child: Text(
//                               value,
//                               style: TextStyle(
//                                 color: color2,
//                                 fontSize: 15,
//                               ),
//                             ),
//                           ))
//                       .toList(),
//                   onChanged: (newValue) {
//                     setState(() {
//                       carParkingSpace = newValue;
//                     });
//                   },
//                   validator: (value) =>
//                       value == null ? 'Select car parking space ' : null,
//                 ),
//                 SizedBox(
//                   height: 15,
//                 ),
//                 DropdownButtonFormField<String>(
//                   decoration: textInputDecoration('Facing', "Facing *"),
//                   style: TextStyle(fontSize: 14),
//                   items: <String>[
//                     'North',
//                     'South',
//                     'East',
//                     'West',
//                   ]
//                       .map((String value) => DropdownMenuItem<String>(
//                             value: value,
//                             child: Text(
//                               value,
//                               style: TextStyle(
//                                 color: color2,
//                                 fontSize: 15,
//                               ),
//                             ),
//                           ))
//                       .toList(),
//                   onChanged: (newValue) {
//                     setState(() {
//                       facing = newValue;
//                     });
//                   },
//                   validator: (value) => value == null ? 'Select Facing ' : null,
//                 ),
//                 SizedBox(
//                   height: 15,
//                 ),
//                 TextFormField(
//                   validator: (value) {
//                     if (value.isEmpty) {
//                       return 'Please enter Rent rate';
//                     }
//                     return null;
//                   },
//                   onSaved: (String value) {},
//                   controller: rent,
//                   onTap: () {},
//                   style: TextStyle(
//                     fontSize: 14.0,
//                     color: black,
//                   ),
//                   keyboardType: TextInputType.text,
//                   decoration: textInputDecoration(
//                     'Enter Rent ',
//                     'Rent *',
//                   ),
//                 ),
//                 SizedBox(
//                   height: 15,
//                 ),
//                 DropdownButtonFormField<String>(
//                   decoration: textInputDecoration('For Whom', "For Whom *"),
//                   style: TextStyle(fontSize: 14),
//                   items: <String>[
//                     'Bachelords allowed',
//                     'Only for Family',
//                     'Only for Girls',
//                     'Anyone',
//                   ]
//                       .map((String value) => DropdownMenuItem<String>(
//                             value: value,
//                             child: Text(
//                               value,
//                               style: TextStyle(
//                                 color: color2,
//                                 fontSize: 15,
//                               ),
//                             ),
//                           ))
//                       .toList(),
//                   onChanged: (newValue) {
//                     setState(() {
//                       whom = newValue;
//                     });
//                   },
//                   validator: (value) =>
//                       value == null ? 'Select for whom ' : null,
//                 ),
//                 SizedBox(
//                   height: 30,
//                 ),
//                 Center(
//                   child: Container(
//                       width: MediaQuery.of(context).size.width * 0.90,
//                       child: ElevatedBtn(submitButton, "Next")),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   void submitButton() {}
// }

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:services/Constant/Colors.dart';
import 'package:services/Constant/api.dart';
import 'package:services/Screens/AddPost.dart';
import 'package:services/Widgets/ElevatedButton.dart';
import 'package:services/Widgets/LoadingWidget.dart';

class PropertyPost extends StatefulWidget {
  final String subcat_type;
  final String cat_id;
  final String subcat_id;
  PropertyPost({Key key, this.subcat_type, this.cat_id, this.subcat_id})
      : super(key: key);

  @override
  _PropertyPostState createState() => _PropertyPostState();
}

class _PropertyPostState extends State<PropertyPost> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final TextEditingController floor = new TextEditingController();
  final TextEditingController superBuildupArea = new TextEditingController();
  final TextEditingController carpetArea = new TextEditingController();
  final TextEditingController rent = new TextEditingController();

  bool _isLoading = false;
  String propertyType;
  String roomType;
  String furnished;
  String constructionStatus;
  String addListedBY;
  String carParkingSpace;
  String facing;
  String whom;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDropdownValues();
  }

  List propertyTypeList = List();
  List roomTypeList = List();
  List furnishedList = List();
  List constructionStatusList = List();
  List addListedBYList = List();
  List carParkingSpaceList = List();
  List facingList = List();
  List whomList = List();
  Future<String> getDropdownValues() async {
    Map data = {
      'attribute_id':
          widget.subcat_type != null ? widget.subcat_type : "sale-property",
    };
    print(data);
    var res =
        await http.post(Uri.parse(app_api + "/attribute_mutiple"), body: data);
    if (res.statusCode == 200) {
      var resBody = (json.decode(res.body));
      print("---------------NK-----------------");
      print(resBody);
      setState(() {
        _isLoading = true;
        propertyTypeList = resBody['type-of-property'];
        roomTypeList = resBody['bedrooms-type'];
        furnishedList = resBody['furnished'];
        constructionStatusList = resBody['construction-status'];
        addListedBYList = resBody['listed-by'];
        carParkingSpaceList = resBody['car-parking-space'];
        facingList = resBody['facing'];
        if (resBody['rent_for_whom'] != null) {
          whomList = resBody['rent_for_whom'];
        }
      });
      // print(allBrands);
      return "Success";
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appcolor,
        title: Text(
          "Property (Sale/Rent)",
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
                        decoration: textInputDecoration(
                            'Type Of Property', "Type Of Property *"),
                        style: TextStyle(fontSize: 14),
                        items: propertyTypeList.map((item) {
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
                            propertyType = newValue;
                          });
                        },
                        validator: (value) =>
                            value == null ? 'Select property type ' : null,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      DropdownButtonFormField<String>(
                        decoration: textInputDecoration(
                            'Type Of Rooms', "Type Of Rooms *"),
                        style: TextStyle(fontSize: 14),
                        items: roomTypeList.map((item) {
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
                            roomType = newValue;
                          });
                        },
                        validator: (value) =>
                            value == null ? 'Select Bedroom type ' : null,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter floor';
                          }
                          return null;
                        },
                        onSaved: (String value) {},
                        controller: floor,
                        onTap: () {},
                        style: TextStyle(
                          fontSize: 14.0,
                          color: black,
                        ),
                        keyboardType: TextInputType.text,
                        decoration: textInputDecoration(
                          'Enter floor ',
                          'Floor *',
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      DropdownButtonFormField<String>(
                        decoration:
                            textInputDecoration('Furnished', "Furnished *"),
                        style: TextStyle(fontSize: 14),
                        items: furnishedList.map((item) {
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
                            furnished = newValue;
                          });
                        },
                        validator: (value) =>
                            value == null ? 'Select furnished ' : null,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      DropdownButtonFormField<String>(
                        decoration: textInputDecoration(
                            'Construction Status', "Construction Status *"),
                        style: TextStyle(fontSize: 14),
                        items: constructionStatusList.map((item) {
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
                            constructionStatus = newValue;
                          });
                        },
                        validator: (value) => value == null
                            ? 'Select construction status '
                            : null,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      DropdownButtonFormField<String>(
                        decoration: textInputDecoration(
                            'Add Listed By', "Add Listed By *"),
                        style: TextStyle(fontSize: 14),
                        items: addListedBYList.map((item) {
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
                            addListedBY = newValue;
                          });
                        },
                        validator: (value) =>
                            value == null ? 'Select add listed by ' : null,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Enter Super Buildup area in Sq ft';
                          }
                          return null;
                        },
                        onSaved: (String value) {},
                        controller: superBuildupArea,
                        onTap: () {},
                        style: TextStyle(
                          fontSize: 14.0,
                          color: black,
                        ),
                        keyboardType: TextInputType.number,
                        decoration: textInputDecoration(
                          'Enter Super Buildup area in Sq ft ',
                          'Super Buildup area in Sq ft *',
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Enter Carpet Area in Sq ft ';
                          }
                          return null;
                        },
                        onSaved: (String value) {},
                        controller: carpetArea,
                        onTap: () {},
                        style: TextStyle(
                          fontSize: 14.0,
                          color: black,
                        ),
                        keyboardType: TextInputType.text,
                        decoration: textInputDecoration(
                          'Enter Carpet Area in Sq ft ',
                          'Carpet Area in Sq ft *',
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      DropdownButtonFormField<String>(
                        decoration: textInputDecoration(
                            'Car Parking Space', "Car Parking Space *"),
                        style: TextStyle(fontSize: 14),
                        items: carParkingSpaceList.map((item) {
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
                            carParkingSpace = newValue;
                          });
                        },
                        validator: (value) =>
                            value == null ? 'Select car parking space ' : null,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      DropdownButtonFormField<String>(
                        decoration: textInputDecoration('Facing', "Facing *"),
                        style: TextStyle(fontSize: 14),
                        items: facingList.map((item) {
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
                            facing = newValue;
                          });
                        },
                        validator: (value) =>
                            value == null ? 'Select Facing ' : null,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      // widget.subcat_type == "sale-property"
                      //     ? SizedBox()
                      //     : TextFormField(
                      //         validator: (value) {
                      //           if (value.isEmpty) {
                      //             return 'Please enter Rent rate';
                      //           }
                      //           return null;
                      //         },
                      //         onSaved: (String value) {},
                      //         controller: rent,
                      //         onTap: () {},
                      //         style: TextStyle(
                      //           fontSize: 14.0,
                      //           color: black,
                      //         ),
                      //         keyboardType: TextInputType.text,
                      //         decoration: textInputDecoration(
                      //           'Enter Rent ',
                      //           'Rent *',
                      //         ),
                      //       ),
                      // SizedBox(
                      //   height: 15,
                      // ),

                      // later enable this
                      widget.subcat_type == "sale-property"
                          ? SizedBox()
                          : DropdownButtonFormField<String>(
                              decoration:
                                  textInputDecoration('For Whom', "For Whom *"),
                              style: TextStyle(fontSize: 14),
                              items: whomList.map((item) {
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
                                  whom = newValue;
                                });
                              },
                              validator: (value) =>
                                  value == null ? 'Select for whom ' : null,
                            ),
                      widget.subcat_type == "sale-property"
                          ? SizedBox()
                          : SizedBox(
                              height: 30,
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
      Map propertyData = widget.subcat_type == "sale-property"
          ? {
              'sub_category_type': widget.subcat_type,
              'type_of_property': propertyType,
              'bedrooms_type': roomType,
              'floor': floor.text,
              'furnished': furnished,
              'construction_status': constructionStatus,
              'listed_by': addListedBY,
              'super_buildup_area_sq_ft': superBuildupArea.text,
              'carpet_area_sq_ft': carpetArea.text,
              'car_parking_space': carParkingSpace,
              'facing': facing,
            }
          : {
              'sub_category_type': widget.subcat_type,
              'type_of_property': propertyType,
              'bedrooms_type': roomType,
              'floor': floor.text,
              'furnished': furnished,
              'construction_status': constructionStatus,
              'listed_by': addListedBY,
              'super_buildup_area_sq_ft': superBuildupArea.text,
              'carpet_area_sq_ft': carpetArea.text,
              'car_parking_space': carParkingSpace,
              'facing': facing,
              // 'rent_monthly': rent.text,
              'form_whom': whom,
            };

      print(propertyData);
      Navigator.of(context, rootNavigator: true).pushReplacement(
          CupertinoPageRoute(
              builder: (_) => AddPostsPage(
                  categoryID: widget.cat_id.toString(),
                  subcategoryID: widget.subcat_id,
                  mapdata: propertyData,
                  subcategoryName: widget.subcat_type,
                  productType: widget.subcat_type)));
      // }
    }
  }
}
