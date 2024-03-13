import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:services/Constant/Colors.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:services/Constant/api.dart';
import 'package:services/Model/Location_model.dart';
import 'package:services/Screens/PostDonePage.dart';
import 'package:services/Widgets/LoadingWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'MyPosts.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';

class AddPostsPage extends StatefulWidget {
  final String categoryID;
  final String subcategoryID;
  final String mainCategory;
  final String categoryName;
  final String subcategoryName;
  final Map mapdata;
  final String productType;
  final String subcat_type;
  AddPostsPage(
      {Key key,
      this.subcategoryID,
      this.categoryID,
      this.mainCategory,
      this.categoryName,
      this.subcategoryName,
      this.mapdata,
      this.productType,
      this.subcat_type})
      : super(key: key);

  @override
  _AddPostsPageState createState() => _AddPostsPageState();
}

class _AddPostsPageState extends State<AddPostsPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController title = new TextEditingController();
  final TextEditingController description = new TextEditingController();
  final TextEditingController price = new TextEditingController();
  final TextEditingController serviceType = new TextEditingController();
  final TextEditingController location = new TextEditingController();

  bool _isLoading = false;
  bool enalbleBtn = true;

  // File _image;
  // String _imagefileName;
  // String _imageName;

  // mobile and aplience post field values
  String brand;
  List allBrands = List();
  final TextEditingController product_brand = new TextEditingController();
  final TextEditingController purchase_year = new TextEditingController();
  final TextEditingController product_model = new TextEditingController();
  int doorStep = 2;
  int adscondition;

  String service;
  String cityID;

  @override
  void initState() {
    super.initState();
    servicType();
    widget.subcat_type == "mobile" ? getDropdownValues() : null;
    print(widget.mainCategory);
  }

  bool _isUploading = false;
  String _error;

  postADs(
    adname,
    adDescription,
    type,
    price,
    dstep,
    city,
  ) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'customer_id': sharedPreferences.getString("user_id"),
      'main_category': widget.mainCategory != null ? widget.mainCategory : "3",
      'category_id': widget.categoryID != null ? widget.categoryID : "",
      'sub_category_id':
          widget.subcategoryID != null ? widget.subcategoryID : "",
      'ads_name': adname,
      'ads_condition': adscondition.toString(),
      'ads_description': adDescription,
      'type_of_service': type,
      'ads_price': price,
      'door_step': dstep,
      'city_id': city,
      'ads_type': widget.subcategoryName != null ? widget.subcategoryName : "",
      'ads_image': files.isNotEmpty ? files.join(", ") : "",
    };

    // print(data);
    var jsonResponse;
    var response;
    if (widget.mapdata != null) {
      data.addAll(widget.mapdata);
      print(widget.mapdata);
      response = await http.post(Uri.parse(app_api + "/post_ads"), body: data);
    } else if (widget.subcat_type == "mobile" ||
        widget.subcat_type == "electronics-appliances") {
      Map extraFields = {
        'sub_category_type': widget.subcat_type,
        'brand': brand ?? product_brand.text,
        'model': product_model.text,
        'purchased_year': purchase_year.text,
      };
      data.addAll(extraFields);
      print(extraFields);
      response = await http.post(Uri.parse(app_api + "/post_ads"), body: data);
    } else {
      print(data);
      response = await http.post(Uri.parse(app_api + "/post_ads"), body: data);
    }
    // await http.post(Uri.parse(app_api + "/post_ads"), body: data);

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

        // _alerDialog(jsonResponse['message']);

        Navigator.of(context, rootNavigator: true).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) => PostDone()));
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      print(jsonResponse);
      _alerDialog(jsonResponse['message']);
    }
  }

  String titles;

  void servicType() {
    if (widget.mainCategory == "1") {
      service = "Services";
      titles = "Shop Name/Company Name *";
    } else if (widget.mainCategory == "2") {
      titles = "Company Name";
      service = "Bussiness";
    } else {
      service = "Sell";
    }
    print(widget.categoryName);
    if (widget.categoryName == "Jobs") {
      titles = "Job Type";
    }
  }

  Future<String> getDropdownValues() async {
    Map data = {
      'attribute_id': "mobile",
    };
    var res =
        await http.post(Uri.parse(app_api + "/attribute_mutiple"), body: data);
    if (res.statusCode == 200) {
      var resBody = (json.decode(res.body));
      setState(() {
        _isLoading = true;
        allBrands = resBody['mobile-brand'];
      });
      print(allBrands);
      return "Success";
    } else {
      _isLoading = false;
      print("error");
      print(res.body.toString());
    }
  }

  Future<List<Location>> get_locationData(city) async {
    try {
      Map data = {
        'city_name': city,
      };
      print(data);
      var response = await http.post(Uri.parse(app_api + '/city'), body: data);
      var locationDatas = List<Location>();

      if (response.statusCode == 200) {
        var locationDatasJson = (json.decode(response.body));

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

  Future<void> _alerBox() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text("Please check image and location"),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: appcolor,
        title: Text(
          "Create Post",
          style: TextStyle(
            color: white,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
        // actions: [
        //   IconButton(icon: Icon(Icons.ac_unit_outlined),
        // onPressed: (){
        //   loadAssets();
        // }),
        // ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
              child: Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    children: [
                      Text(
                        "Selected Category:",
                        style: TextStyle(color: appcolor, fontSize: 16),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Card(
                        color: Colors.grey[300],
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(7, 5, 7, 5),
                            child: Text(service != null ? service : "")),
                      ),
                      // SizedBox(width: 5,),
                      widget.categoryName != null
                          ? Card(
                              color: Colors.grey[300],
                              child: Padding(
                                  padding: EdgeInsets.fromLTRB(7, 5, 7, 5),
                                  child: Text(widget.categoryName != null
                                      ? widget.categoryName
                                      : "")),
                            )
                          : SizedBox(),

                      widget.subcategoryName == null ||
                              widget.subcategoryName == ""
                          ? SizedBox()
                          : Card(
                              color: Colors.grey[300],
                              child: Padding(
                                  padding: EdgeInsets.fromLTRB(7, 5, 7, 5),
                                  child: Text(widget.subcategoryName != null
                                      ? widget.subcategoryName
                                      : "")),
                            ),
                      //  SizedBox(width: 10,),
                      //  InkWell(
                      //    onTap: (){
                      //      Navigator.pop(context);
                      //    },
                      //    child: Text("change", style: TextStyle(color:appcolor, fontSize: 14),),
                      //  )
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Text(
                    titles != null ? titles : "Title",
                    style: TextStyle(color: black, fontSize: 16),
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please fill the Title';
                      }
                      return null;
                    },
                    cursorHeight: 18,
                    onSaved: (String value) {},
                    controller: title,
                    obscureText: false,
                    // focusNode: AlwaysDisabledFocusNode(),
                    onTap: () {},
                    style: TextStyle(
                      fontSize: 14.0,
                      color: black,
                    ),
                    keyboardType: TextInputType.text,
                    decoration:
                        textDecoration(titles != null ? titles : "Title"),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  widget.subcat_type == "mobile" ||
                          widget.subcat_type == "electronics-appliances"
                      ? _mobileFields()
                      : SizedBox(),
                  Text(
                    "Condition *",
                    style: TextStyle(color: color2, fontSize: 16),
                  ),
                  DropdownButtonFormField<String>(
                    decoration: textDecoration(
                      'Select Condition',
                    ),
                    items: <String>[
                      'New',
                      'Like New',
                      'Gently Used',
                      'Heavily Used',
                    ]
                        .map((String value) => DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(
                                  color: black,
                                  fontFamily: montserrat,
                                  fontSize: 16,
                                ),
                              ),
                            ))
                        .toList(),
                    onChanged: (newValue) {
                      setState(() {
                        switch (newValue) {
                          case "New":
                            adscondition = 1;
                            break;
                          case "Like New":
                            adscondition = 2;
                            break;
                          case "Gently Used":
                            adscondition = 3;
                            break;
                          case "Heavily Used":
                            adscondition = 4;
                            break;
                          default:
                            adscondition = 0;
                        }
                      });
                      print(adscondition);
                    },
                    validator: (value) =>
                        value == null ? 'Select Condition ' : null,
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Text(
                    "Description *",
                    style: TextStyle(color: black, fontSize: 16),
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please fill the detail';
                      }
                      return null;
                    },
                    cursorHeight: 18,
                    onSaved: (String value) {},
                    controller: description,
                    obscureText: false,
                    // focusNode: AlwaysDisabledFocusNode(),
                    maxLines: 10,
                    minLines: 1,
                    onTap: () {},
                    style: TextStyle(
                      fontSize: 14.0,
                      color: black,
                    ),
                    keyboardType: TextInputType.multiline,
                    decoration: textDecoration('Description'),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  // widget.mainCategory == "3"
                  //     ?
                  Text(
                    widget.categoryName == "Jobs" ? "Salary *" : "Price *",
                    style: TextStyle(color: black, fontSize: 16),
                  ),
                  // : SizedBox(),
                  // widget.mainCategory == "3"
                  //     ?
                  TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter ' + widget.categoryName == "Jobs"
                            ? "Salary *"
                            : "Price *";
                      }
                      return null;
                    },
                    cursorHeight: 18,
                    onSaved: (String value) {},
                    controller: price,
                    obscureText: false,
                    // focusNode: AlwaysDisabledFocusNode(),
                    onTap: () {},
                    style: TextStyle(
                      fontSize: 14.0,
                      color: black,
                    ),
                    keyboardType: TextInputType.number,
                    decoration: textDecoration(
                      widget.categoryName == "Jobs" ? "Salary *" : "Price *",
                    ),
                  ),
                  // : SizedBox(),
                  // widget.mainCategory == "3"
                  //     ? SizedBox(
                  //         height: 25,
                  //       )
                  //     : SizedBox(),
                  SizedBox(
                    height: 25,
                  ),
                  Text(
                    "Location *",
                    style: TextStyle(color: black, fontSize: 16),
                  ),
                  TypeAheadField(
                    // validator: (value) {
                    //   if (value.isEmpty) {
                    //     return 'Please choose location';
                    //   }
                    //   return null;
                    // },
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
                      SharedPreferences sharedPreferences =
                          await SharedPreferences.getInstance();
                      setState(() {
                        location.text = item.city_name;
                        cityID = item.id;
                      });
                      // Navigator.of(context).push(MaterialPageRoute(
                      //     builder: (context) =>
                      //         (product: item)));
                    },
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  if (widget.categoryName != "Jobs")
                    Text(
                      "Doorstep Services",
                      style: TextStyle(color: black, fontSize: 16),
                    ),
                  if (widget.categoryName != "Jobs")
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
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
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Radio(
                          value: 2,
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
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),

                  SizedBox(
                    height: 17,
                  ),
                  widget.mainCategory == "3"
                      ? SizedBox()
                      : Text(
                          "Type of Services *",
                          style: TextStyle(color: black, fontSize: 16),
                        ),
                  widget.mainCategory == "3"
                      ? SizedBox()
                      : TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter Service Type';
                            }
                            return null;
                          },
                          cursorHeight: 18,
                          onSaved: (String value) {},
                          controller: serviceType,
                          obscureText: false,
                          // focusNode: AlwaysDisabledFocusNode(),
                          maxLines: 10,
                          minLines: 1,
                          onTap: () {},
                          style: TextStyle(
                            fontSize: 14.0,
                            color: black,
                          ),
                          keyboardType: TextInputType.multiline,
                          decoration: textDecoration('Service type'),
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
                          border: Border.all(color: appcolor, width: 1.5),
                          borderRadius: BorderRadius.circular(8)),
                      child: Text(
                        "Browse Image",
                        style: TextStyle(
                            color: appcolor, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 13,
                  ),
                  fileImg.length != 0
                      ? Container(
                          height: 60,
                          child: ListView.builder(
                              shrinkWrap: true,
                              physics: ScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemCount: fileImg.length,
                              itemBuilder: (context, index) {
                                // print("------------NK----------");
                                // print(fileImg[index]);
                                return Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Stack(
                                    children: [
                                      Container(
                                        height: 58,
                                        width: 55,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(7),
                                            image: DecorationImage(
                                                image:
                                                    FileImage(fileImg[index]),
                                                fit: BoxFit.fill)),
                                      ),
                                      Container(
                                        height: 60,
                                        width: 55,
                                        child: Align(
                                          alignment: Alignment.topRight,
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                fileImg.removeAt(index);
                                                files.removeAt(index);
                                              });
                                              print(files);
                                            },
                                            child: Card(
                                              elevation: 4,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(2.0),
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
                    height: 20,
                  ),
                  ButtonTheme(
                    buttonColor: appcolor,
                    minWidth: 400,
                    child: FlatButton(
                      color: appcolor,
                      padding: EdgeInsets.fromLTRB(13, 13, 13, 13),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7.0),
                          side: BorderSide(color: appcolor)),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          if (files != null && cityID != null) {
                            if (enalbleBtn == true) {
                              postADs(
                                title.text,
                                description.text,
                                serviceType.text,
                                price.text,
                                "$doorStep",
                                cityID,
                              );
                              setState(() {
                                enalbleBtn = false;
                              });

                              print("ads added");
                            } else {
                              setState(() {
                                enalbleBtn = false;
                              });
                              Navigator.pop(context);
                              print("error");
                            }
                          } else {
                            _alerBox();
                          }
                        }
                      },
                      // child: enalbleBtn == true
                      //     ?
                      child: Text(
                        "NEXT",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: white),
                      ),
                      // : CircularProgressIndicator(
                      //     backgroundColor: white,
                      //     valueColor:
                      //         new AlwaysStoppedAnimation<Color>(appcolor),
                      //   ),
                    ),
                  ),

                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          )),
          enalbleBtn ? SizedBox() : FullScreenLoading(),
        ],
      ),
    );
  }

  Widget _mobileFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Brand *",
          style: TextStyle(color: color2, fontSize: 16),
        ),
        widget.subcat_type == "mobile"
            ? DropdownButtonFormField<String>(
                decoration: textDecoration("Brand"),
                style: TextStyle(fontSize: 14),
                items: allBrands.map((item) {
                  return DropdownMenuItem<String>(
                    value: item["attribute_list_name"].toString(),
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
                },
                validator: (value) => value == null ? 'Select brand ' : null,
              )
            : TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter brand';
                  }
                  return null;
                },
                cursorHeight: 18,
                onSaved: (String value) {},
                controller: product_brand,
                obscureText: false,
                onTap: () {},
                style: TextStyle(
                  fontSize: 14.0,
                  color: black,
                ),
                keyboardType: TextInputType.text,
                decoration:
                    textDecoration(titles != null ? titles : "Enter brand"),
              ),
        SizedBox(
          height: 25,
        ),
        Text(
          "Model *",
          style: TextStyle(color: color2, fontSize: 16),
        ),
        TextFormField(
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter model';
            }
            return null;
          },
          cursorHeight: 18,
          onSaved: (String value) {},
          controller: product_model,
          obscureText: false,
          onTap: () {},
          style: TextStyle(
            fontSize: 14.0,
            color: black,
          ),
          keyboardType: TextInputType.text,
          decoration: textDecoration(titles != null ? titles : "Enter model"),
        ),
        SizedBox(
          height: 25,
        ),
        Text(
          "Purchase Year *",
          style: TextStyle(color: color2, fontSize: 16),
        ),
        TextFormField(
          validator: (value) {
            if (value.isEmpty) {
              return 'Please fill the Purchase year';
            }
            return null;
          },
          cursorHeight: 18,
          onSaved: (String value) {},
          controller: purchase_year,
          obscureText: false,
          onTap: () {},
          style: TextStyle(
            fontSize: 14.0,
            color: black,
          ),
          keyboardType: TextInputType.text,
          decoration: textDecoration(titles != null ? titles : "Purchase Year"),
        ),
        SizedBox(
          height: 25,
        ),
      ],
    );
  }
}
