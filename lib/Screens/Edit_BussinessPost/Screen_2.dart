import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:services/Constant/Colors.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:services/Constant/Location_controller.dart';
import 'package:services/Constant/api.dart';
import 'package:services/Model/AdsDetail_model.dart';
import 'package:services/Screens/MyPosts.dart';
import 'package:services/Widgets/ElevatedButton.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:services/Widgets/LoadingWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_native_image/flutter_native_image.dart';

class WorkingDays {
  const WorkingDays(this.name, this.workingValue);
  final String name;
  final String workingValue;
}

class Edit_Screen_2 extends StatefulWidget {
  final Map mapData;
  final String id;
  Edit_Screen_2({Key key, this.mapData, this.id}) : super(key: key);

  @override
  _Edit_Screen_2State createState() => _Edit_Screen_2State();
}

class _Edit_Screen_2State extends State<Edit_Screen_2> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController businessSince = new TextEditingController();
  final TextEditingController about = new TextEditingController();
  final TextEditingController location = new TextEditingController();
  final TextEditingController serviceDetail = new TextEditingController();
  final TextEditingController workFrom = new TextEditingController();
  final TextEditingController workTo = new TextEditingController();

  List _bussinessCityId = [];
  List<String> _bussinessCityName = <String>[];

  bool _isLoading = false;
  int doorStep = 0;
  String imageFile;
  String adscondition;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ads_detail();
  }

  String subcat;
  String cityID;
  String category_id;
  String service;
  String _adscondition;

  bool _loading = false;
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
        _loading = true;
      });
      businessSince.text = jsonResponse['extra']['business_since'];
      about.text = jsonResponse['ads_description'];
      // adscondition = jsonResponse['ads_condition'];
      // List _working_filters = jsonResponse['extra']['working_days'];
      // _workingfilters = _working_filters.map((s) => s as String).toList();
      String workingdays_number = jsonResponse['extra']['working_days_number'];
      List workDays = workingdays_number.split(',');
      _workingfilters = workDays.map((s) => s as String).toList();
      workFrom.text = jsonResponse['extra']['working_hours_from'];
      workTo.text = jsonResponse['extra']['working_hours_to'];
      List _business_Cityname = jsonResponse['extra']['business_city_names'];
      _bussinessCityName = _business_Cityname.map((s) => s as String).toList();
      doorStep = int.parse(jsonResponse['door_step']);
      serviceDetail.text = jsonResponse['type_of_service'];
      service = jsonResponse['service_type'];
      category_id = jsonResponse['category_id'].toString();
      String val = jsonResponse['extra']['business_city_id'].toString();
      print(val);
      _bussinessCityId = val.split(',');
      // print("--------------NK city id-------------------");
      // print(_bussinessCityId);
      // print(_bussinessCityName);

      get_imageList(json.decode(response.body)['images']).then((value) {
        setState(() {
          imgList = value;
        });
      });

      return AdsDetail.fromJson(jsonResponse);
    } else {
      setState(() {
        _loading = false;
      });
      throw Exception('Failed to load post');
    }
  }

  List<AllImage> imgList = List<AllImage>();

  Future<List<AllImage>> get_imageList(imageListsJson) async {
    var imageLists = List<AllImage>();
    for (var imageListJson in imageListsJson) {
      imageLists.add(AllImage.fromJson(imageListJson));
    }
    return imageLists;
  }

  editADs(b_since, description, work_days, whf, wht, doorstep,
      service_detail) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      // 'customer_id': sharedPreferences.getString("user_id"),
      // 'ads_condition': adscondition,
      "business_since": b_since,
      "ads_description": description,
      "working_days": "${_workingfilters.join(',')}",
      "working_hours_from": whf,
      "working_hours_to": wht,
      "door_step": doorstep,
      "type_of_service": service_detail,
      'city_ids': _bussinessCityId != null ? _bussinessCityId.join(",") : "",
      'ads_image': files.isNotEmpty ? files.join(", ") : "",
    };

    print(data);
    var jsonResponse;
    var response;
    data.addAll(widget.mapData);
    print(jsonEncode(data));
    response = await http.post(Uri.parse(app_api + "/edit_ads"), body: data);

    print(response.body.toString());
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if (jsonResponse != null) {
        setState(() {
          _isLoading = false;
        });
        print("NandhuKrish");
        // Navigator.of(context, rootNavigator: false).pushAndRemoveUntil(
        //     MaterialPageRoute(builder: (BuildContext context) => MyPosts()),
        //     (Route<dynamic> route) => false);
        Navigator.of(context, rootNavigator: true).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) => MyPosts()));
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      print(jsonResponse);
      print(response.body.toString());
      // _alerDialog(jsonResponse['message']);
    }
  }

  final List<WorkingDays> _cast = <WorkingDays>[
    const WorkingDays('SUN', '1'),
    const WorkingDays('MON', '2'),
    const WorkingDays('TUE', '3'),
    const WorkingDays('WED', '4'),
    const WorkingDays('THU', '5'),
    const WorkingDays('FRI', '6'),
    const WorkingDays('SAT', '7'),
  ];
  List<String> _workingfilters = <String>[];

  Iterable<Widget> get workingWidgets sync* {
    for (final WorkingDays working in _cast) {
      yield Padding(
        padding: const EdgeInsets.all(4.0),
        child: FilterChip(
          // avatar: CircleAvatar(child: Text(actor.workingValue)),
          label: Text(working.name),
          selected: _workingfilters.contains(working.workingValue),
          onSelected: (bool value) {
            setState(() {
              if (value) {
                _workingfilters.add(working.workingValue);
              } else {
                _workingfilters.removeWhere((String workingValue) {
                  return workingValue == working.workingValue;
                });
              }
            });
          },
        ),
      );
    }
  }

  List<Asset> images = List<Asset>();

  List files = [];

  List<Asset> resultList;

  Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];
    String error = 'No Error Detected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 5,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Dev by NK",
          allViewTitle: "All Photos",
          useDetailsView: true,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    if (!mounted) return;

    setState(() {
      images = resultList;
      // _error = error;
    });
    _submit();
  }

  getImageFileFromAsset(String path) async {
    var file = File(path);
    File compressedFile;

    print("-------------NASA-----------");
    final bytes = (await file.readAsBytesSync()).lengthInBytes;
    final kb = bytes / 1024;
    // final mb = kb / 1024;
    final imgSize = kb.round();
    // print(imgSize);
    final hw = await decodeImageFromList(file.readAsBytesSync());
    // print(hw.height / 2);
    // print(hw.width / 2);

    if (imgSize < 500) {
      compressedFile = await FlutterNativeImage.compressImage(
        file.path,
        quality: 90,
        targetWidth: (hw.width / 2).round(),
        targetHeight: (hw.height / 2).round(),
      );
      print("image less 500kb");
    } else if (imgSize >= 501 && imgSize <= 3000) {
      compressedFile = await FlutterNativeImage.compressImage(
        file.path,
        quality: 45,
        targetWidth: (hw.width / 2).round(),
        targetHeight: (hw.height / 2).round(),
      );
      print("image less 501 to 3000kb");
    } else if (imgSize >= 3001 && imgSize <= 5000) {
      compressedFile = await FlutterNativeImage.compressImage(
        file.path,
        quality: 30,
        targetWidth: (hw.width / 2).round(),
        targetHeight: (hw.height / 2).round(),
      );
      print("image less 3001 to 5000kb");
    } else if (imgSize >= 5001 && imgSize <= 10000) {
      compressedFile = await FlutterNativeImage.compressImage(
        file.path,
        quality: 10,
        targetWidth: (hw.width / 2).round(),
        targetHeight: (hw.height / 2).round(),
      );
      print("image less 5001 to 10000kb");
    } else {
      compressedFile = await FlutterNativeImage.compressImage(
        file.path,
        quality: 7,
        targetWidth: (hw.width / 2).round(),
        targetHeight: (hw.height / 2).round(),
      );
    }
    // print("-------------NASA-----------");
    // print(compressedFile);
    return compressedFile;
  }

  List fileImg = [];

  _submit() async {
    for (int i = 0; i < images.length; i++) {
      // print("==============NK==========");

      var path2 =
          await FlutterAbsolutePath.getAbsolutePath(images[i].identifier);
      // print(File(path2));
      var file = await getImageFileFromAsset(path2);
      // fileImg.add(file);

      var base64Image = base64Encode(file.readAsBytesSync());
      setState(() {
        fileImg.add(File(path2));
        files.add(base64Image);
      });
      // files.add(base64Image);

      // setState(() {
      //   _imagefileName = files.join(", ");
      // });
    }
  }

  delete_image(imgID) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'ads_id': widget.id,
      'image_id': imgID,
    };
    print(data);
    var jsonResponse;
    var response =
        await http.post(Uri.parse(app_api + '/delete_image'), body: data);
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      // Navigator.pop(context);
      print("Image Deleted");
    } else {
      print("Error for Image Delete");
      setState(() {
        _isLoading = false;
      });
    }
  }

  TimeOfDay _timeFrom = TimeOfDay.now();

  void _selectTimeFrom() async {
    final TimeOfDay newTime = await showTimePicker(
      context: context,
      initialTime: _timeFrom,
    );
    // print("-----NK-------");
    // print(newTime);
    if (newTime != null) {
      setState(() {
        _timeFrom = newTime;
        workFrom.text = '${_timeFrom.format(context)}';
      });
      // print(newTime);
    }
  }

  TimeOfDay _timeTo = TimeOfDay.now();

  void _selectTimeTo() async {
    final TimeOfDay newTime = await showTimePicker(
      context: context,
      initialTime: _timeTo,
    );
    if (newTime != null) {
      setState(() {
        _timeTo = newTime;
        workTo.text = '${_timeTo.format(context)}';
        print(workTo.text);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: appcolor,
        title: Text("Edit post"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          _loading
              ? SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "In Business Since *",
                            style: TextStyle(color: color2, fontSize: 16),
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter Business Since *';
                              }
                              return null;
                            },
                            cursorHeight: 18,
                            onSaved: (String value) {},
                            controller: businessSince,
                            obscureText: false,
                            onTap: () {},
                            style: TextStyle(
                              fontSize: 14.0,
                              color: black,
                            ),
                            keyboardType: TextInputType.text,
                            decoration: textDecoration(
                              'In Business Since ',
                            ),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Text(
                            "About Company *",
                            style: TextStyle(color: color2, fontSize: 16),
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Enter about company';
                              }
                              return null;
                            },
                            onSaved: (String value) {},
                            controller: about,
                            maxLines: 4,
                            minLines: 1,
                            onTap: () {},
                            style: TextStyle(
                              fontSize: 14.0,
                              color: black,
                            ),
                            keyboardType: TextInputType.multiline,
                            decoration: textDecoration(
                              'Enter About Company ',
                            ),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          // Text(
                          //   "Service Type *",
                          //   style: TextStyle(color: color2, fontSize: 16),
                          // ),
                          // DropdownButtonFormField<String>(
                          //   decoration: textDecoration(
                          //     _adscondition != null
                          //         ? _adscondition
                          //         : 'Select Service Type',
                          //   ),
                          //   items: <String>[
                          //     'New',
                          //     'Like New',
                          //     'Gently Used',
                          //     'Heavily Used',
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
                          //       switch (newValue) {
                          //         case "New":
                          //           adscondition = "1";
                          //           break;
                          //         case "Like New":
                          //           adscondition = "2";
                          //           break;
                          //         case "Gently Used":
                          //           adscondition = "3";
                          //           break;
                          //         case "Heavily Used":
                          //           adscondition = "4";
                          //           break;
                          //         default:
                          //           adscondition = "0";
                          //       }
                          //     });
                          //     print(adscondition);
                          //   },
                          //   validator: (value) =>
                          //       value == null ? 'Select Service Type ' : null,
                          // ),
                          // SizedBox(
                          //   height: 25,
                          // ),
                          Text(
                            "Working Days *",
                            style: TextStyle(color: color2, fontSize: 16),
                          ),
                          Wrap(
                            children: workingWidgets.toList(),
                          ),

                          // Text('Look for: ${_workingfilters.join(', ')}'),
                          SizedBox(
                            height: 25,
                          ),
                          Text(
                            "Working Hours *",
                            style: TextStyle(color: color2, fontSize: 16),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'select working hours';
                                      }
                                      return null;
                                    },
                                    focusNode: AlwaysDisabledFocusNode(),
                                    controller: workFrom,
                                    decoration: textDecoration(
                                      'From :',
                                    ),
                                    onTap: () {
                                      _selectTimeFrom();
                                    }),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: TextFormField(
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'select working hours';
                                      }
                                      return null;
                                    },
                                    focusNode: AlwaysDisabledFocusNode(),
                                    controller: workTo,
                                    decoration: textDecoration(
                                      'To :',
                                    ),
                                    onTap: () {
                                      _selectTimeTo();
                                    }),
                              ),
                            ],
                          ),
                          // SizedBox(
                          //   height: 25,
                          // ),
                          // Text(
                          //   "Working Hours To *",
                          //   style: TextStyle(color: color2, fontSize: 16),
                          // ),

                          SizedBox(
                            height: 25,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Door Step Services",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: color2,
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Radio(
                                value: 1,
                                groupValue: doorStep,
                                activeColor: appcolor,
                                onChanged: (value) {
                                  setState(() {
                                    doorStep = value;
                                    print(doorStep);
                                  });
                                },
                              ),
                              Text(
                                "Yes",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 16,
                                    color: black,
                                    fontWeight: FontWeight.w400),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Radio(
                                value: 0,
                                groupValue: doorStep,
                                activeColor: appcolor,
                                onChanged: (value) {
                                  setState(() {
                                    doorStep = value;
                                    print(doorStep);
                                  });
                                },
                              ),
                              Text(
                                "NO",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 16,
                                    color: black,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Text(
                            "Service Details *",
                            style: TextStyle(color: color2, fontSize: 16),
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter Service Details *';
                              }
                              return null;
                            },
                            cursorHeight: 18,
                            onSaved: (String value) {},
                            controller: serviceDetail,
                            obscureText: false,
                            minLines: 1,
                            maxLines: 4,
                            onTap: () {},
                            style: TextStyle(
                              fontSize: 14.0,
                              color: black,
                            ),
                            keyboardType: TextInputType.text,
                            decoration: textDecoration(
                              'Service Details ',
                            ),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Text(
                            "Bussiness City *",
                            style: TextStyle(color: color2, fontSize: 16),
                          ),
                          _bussinessCityName.isNotEmpty
                              ? Wrap(
                                  children: _bussinessCityName
                                      .asMap()
                                      .entries
                                      .map((entry) {
                                  int index = entry.key;
                                  String val = entry.value;
                                  return Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 5),
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Stack(
                                      children: [
                                        Text(
                                          "       " + val,
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey[700]),
                                        ),
                                        InkWell(
                                          child: Icon(
                                            Icons.close,
                                            size: 16,
                                          ),
                                          onTap: () {
                                            setState(() {
                                              _bussinessCityName
                                                  .removeAt(index);
                                              _bussinessCityId.removeAt(index);
                                            });
                                            print("------NK------");
                                          },
                                        )
                                      ],
                                    ),
                                  );
                                }).toList())
                              : SizedBox(),

                          TypeAheadField(
                            textFieldConfiguration: TextFieldConfiguration(
                                // autofocus: true,
                                controller: location,
                                decoration:
                                    textDecoration("Select bussiness city")),
                            suggestionsCallback: (pattern) async {
                              return await get_locationData(pattern);
                            },
                            itemBuilder: (context, item) {
                              return list(item);
                            },
                            onSuggestionSelected: (item) async {
                              setState(() {
                                _bussinessCityName.add(item.city_name);
                                _bussinessCityName.join(",");
                                _bussinessCityId.add(item.id);
                                // _bussinessCityId.join(",");
                                print(_bussinessCityId);
                                print(_bussinessCityName);
                              });
                            },
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          InkWell(
                            onTap: () {
                              print("NK");
                              loadAssets();
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: double.infinity,
                              height: 50,
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: appcolor, width: 1.5),
                                  borderRadius: BorderRadius.circular(8)),
                              child: Text(
                                "Browse Image",
                                style: TextStyle(
                                    color: appcolor,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 13,
                          ),
                          imgList.length != 0
                              ? Container(
                                  height: 60,
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: ScrollPhysics(),
                                      scrollDirection: Axis.horizontal,
                                      itemCount: imgList.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: Stack(
                                            children: [
                                              Container(
                                                height: 58,
                                                width: 55,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            7),
                                                    image: DecorationImage(
                                                        image: NetworkImage(
                                                          imgList[index]
                                                              .image_name,
                                                        ),
                                                        fit: BoxFit.fill)),
                                              ),
                                              Container(
                                                height: 60,
                                                width: 55,
                                                child: Align(
                                                  alignment: Alignment.topRight,
                                                  child: InkWell(
                                                    onTap: () {
                                                      delete_image(
                                                          imgList[index].id);
                                                      setState(() {
                                                        imgList.removeAt(index);
                                                        files.isNotEmpty
                                                            ? files
                                                                .removeAt(index)
                                                            : null;
                                                      });
                                                    },
                                                    child: Card(
                                                      elevation: 4,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(2.0),
                                                        child: Icon(
                                                          Icons.close,
                                                          size: 13,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      }),
                                )
                              : SizedBox(),
                          SizedBox(
                            height: 40,
                          ),
                          Center(
                            child: Container(
                                width: MediaQuery.of(context).size.width * 0.90,
                                child: ElevatedBtn(submitButton, "Submit")),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              : FullScreenLoading(),
          _isLoading ? FullScreenLoading() : SizedBox(),
        ],
      ),
    );
  }

  void submitButton() {
    // if (_formKey.currentState.validate()) {
    //   _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    editADs(businessSince.text, about.text, "${_workingfilters.join(',')}",
        workFrom.text, workTo.text, "$doorStep", serviceDetail.text);
    // }
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
