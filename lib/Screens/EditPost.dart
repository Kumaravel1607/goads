import 'package:flutter/material.dart';
import 'package:services/Constant/Colors.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:services/Constant/api.dart';
import 'package:services/Model/AdsDetail_model.dart';
import 'package:services/Model/Location_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter/services.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';

class EditPostsPage extends StatefulWidget {
  final String id;
  final String title;
  EditPostsPage({Key key, this.id, this.title}) : super(key: key);

  @override
  _EditPostsPageState createState() => _EditPostsPageState();
}

class _EditPostsPageState extends State<EditPostsPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController title = new TextEditingController();
  final TextEditingController description = new TextEditingController();
  final TextEditingController price = new TextEditingController();
  final TextEditingController serviceType = new TextEditingController();
  final TextEditingController location = new TextEditingController();

  bool _isLoading = false;

  File _image;
  String _imagefileName;
  String _imageName;
  String img;

  int doorStep;
  String cityID;
  String _adscondition;
  String category_id;

  int adscondition;
  String service;

  bool _loading = true;
  bool clickload = true;

  @override
  void initState() {
    super.initState();
    ads_detail();
  }

  final picker = ImagePicker();
  // void open_gallery()
  //   async {
  //   var image = await ImagePicker.pickImage(source: ImageSource.gallery);
  //   //  var pickedFile = await picker.getImage(source: ImageSource.gallery);
  //   setState(() {
  //   // _image = File(pickedFile.path);
  //   _image = image;
  //   _imageName = _image.path.split('/').last;
  //   _imagefileName = base64Encode(_image.readAsBytesSync());
  //   });
  //   }

  Future<AdsDetail> ads_detail() async {
    //  await Future.delayed(Duration(seconds: 1));
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
      // setState(() {
      //   _isLoading = false;
      // });
      print(jsonResponse);
      setState(() {
        img = jsonResponse['ads_image'].toString();
        _loading = false;
      });
      title.text = jsonResponse['ads_name'];
      adscondition = jsonResponse['ads_condition'];
      description.text = jsonResponse['ads_description'];
      price.text = jsonResponse['ads_price_int'].toString();
      serviceType.text = jsonResponse['type_of_service'];
      location.text = jsonResponse['city_name'].toString();
      doorStep = int.parse(jsonResponse['door_step']);
      service = jsonResponse['service_type'];
      category_id = jsonResponse['category_id'].toString();
      print(category_id);
      cityID = jsonResponse['city_id'].toString();
      switch (jsonResponse['ads_condition']) {
        case 1:
          _adscondition = "New";
          break;
        case 2:
          _adscondition = "Like New";
          break;
        case 3:
          _adscondition = "Gently Used";
          break;
        case 4:
          _adscondition = "Heavily Used";
          break;
        default:
          _adscondition = "";
      }

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

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  // void _onRefresh() async {
  //   // monitor network fetch
  //   await Future.delayed(Duration(milliseconds: 1000));
  //   // if failed,use refreshFailed()

  //   // _refreshController.refreshCompleted();
  //   _refreshController.refreshToIdle();
  //   ads_detail();

  // }

  // void _onLoading() async {
  //   // monitor network fetch
  //   await Future.delayed(Duration(milliseconds: 1000));
  //   // if failed,use loadFailed(),if no data return,use LoadNodata()
  //   // allAPI();
  //   // if (mounted) setState(() {});
  //   _refreshController.loadComplete();
  // }

  editPostADs(
    adname,
    adDescription,
    type,
    price,
    dstep,
    city,
  ) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'id': widget.id,
      'main_category': service,
      'ads_name': adname,
      'ads_condition': adscondition.toString(),
      'ads_description': adDescription,
      'type_of_service': type,
      'ads_price': price,
      'door_step': dstep,
      'city_id': city,
      'ads_image': files.isNotEmpty ? files : "",
    };

    print(data);
    var jsonResponse;
    var response =
        await http.post(Uri.parse(app_api + "/edit_ads"), body: data);

    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if (jsonResponse != null) {
        setState(() {
          _loading = false;
          _isLoading = false;
        });
        // print("NandhuKrish");
        Navigator.pop(context);
      }
    } else {
      setState(() {
        _isLoading = false;
        _loading = false;
      });
      _alerDialog(jsonResponse['message']);
    }
  }

  // void servicType(){
  //   if (widget.mainCategory == "1") {
  //     service = "Services";
  //   } else if (widget.mainCategory == "2") {
  //     service = "Bussiness";
  //   } else {
  //     service = "Sale";
  //   }
  // }

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

  bool _isUploading = false;
  String _error;

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

  void open_camera() async {
    var image =
        await picker.getImage(source: ImageSource.camera, imageQuality: 50);
    //  var pickedFile = await picker.getImage(source: ImageSource.gallery);
    // print(images);
    setState(() {
      _image = File(image.path);
      // _image = image;
      _imageName = _image.path.split('/').last;
      _imagefileName = base64Encode(_image.readAsBytesSync());
    });
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
            content: Text("Please choose the image"),
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
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: appcolor,
        title: Text(
          widget.title != null ? widget.title : "Edit Post",
          overflow: TextOverflow.ellipsis,
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
      ),
      body:
          // SmartRefresher(
          // enablePullDown: true,
          // enablePullUp: true,
          // header: WaterDropHeader(),
          // controller: _refreshController,
          // onRefresh: _onRefresh,
          // onLoading: _onLoading,
          // child:
          Stack(children: [
        _loading == true
            ? Container(
                alignment: Alignment.center,
                child: CircularProgressIndicator(
                  backgroundColor: appcolor,
                  valueColor: new AlwaysStoppedAnimation<Color>(white),
                ),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            service == "1" ? "Shop Name/Company Name" : "Title",
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
                            controller: title,
                            obscureText: false,
                            // focusNode: AlwaysDisabledFocusNode(),
                            style: TextStyle(
                              fontSize: 14.0,
                              color: black,
                            ),
                            keyboardType: TextInputType.text,
                            decoration: textDecoration(service == "1"
                                ? "Shop Name/Company Name"
                                : 'Title'),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Text(
                            "Condition",
                            style: TextStyle(color: color2, fontSize: 16),
                          ),
                          DropdownButtonFormField<String>(
                            decoration: textDecoration(
                              _adscondition != null
                                  ? _adscondition
                                  : 'Select Condition',
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
                                    adscondition = 5;
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
                            "Description",
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
                            maxLines: 10,
                            minLines: 1,
                            //  onTap: () {
                            //   },
                            style: TextStyle(
                              fontSize: 14.0,
                              color: black,
                            ),
                            keyboardType: TextInputType.multiline,
                            decoration: textDecoration('Description'),
                          ),
                          service == "3"
                              ? SizedBox(
                                  height: 25,
                                )
                              : SizedBox(),
                          service == "3"
                              ? Text(
                                  "Price",
                                  style: TextStyle(color: black, fontSize: 16),
                                )
                              : SizedBox(),
                          service == "3"
                              ? TextFormField(
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please enter Price';
                                    }
                                    return null;
                                  },
                                  cursorHeight: 18,
                                  onSaved: (String value) {},
                                  controller: price,
                                  obscureText: false,
                                  // focusNode: AlwaysDisabledFocusNode(),
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: black,
                                  ),
                                  keyboardType: TextInputType.number,
                                  decoration: textDecoration(
                                    'Price',
                                  ),
                                )
                              : SizedBox(
                                  height: 25,
                                ),
                          SizedBox(
                            height: 25,
                          ),
                          Text(
                            "Location",
                            style: TextStyle(color: black, fontSize: 16),
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
                          category_id == "10"
                              ? Text(
                                  "Doorstep Services",
                                  style: TextStyle(color: black, fontSize: 16),
                                )
                              : SizedBox(),
                          category_id == "10"
                              ? Row(
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
                                )
                              : SizedBox(),
                          category_id == "10"
                              ? SizedBox(
                                  height: 17,
                                )
                              : SizedBox(),
                          service == "3"
                              ? SizedBox()
                              : Text(
                                  "Type of Services",
                                  style: TextStyle(color: black, fontSize: 16),
                                ),
                          service == "3"
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
                                  maxLines: 10,
                                  minLines: 1,
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: black,
                                  ),
                                  keyboardType: TextInputType.multiline,
                                  decoration: textDecoration('Service type'),
                                ),
                          service == "3"
                              ? SizedBox()
                              : SizedBox(
                                  height: 17,
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
                          imgList.length != 0
                              ? Container(
                                  height: 100,
                                  width: MediaQuery.of(context).size.width,
                                  child: ListView.builder(
                                      shrinkWrap: false,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: imgList.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(right: 5),
                                          child: Stack(
                                            children: [
                                              Image.network(
                                                imgList[index].image_name,
                                                height: 100,
                                                width: 100,
                                              ),
                                              GestureDetector(
                                                child: Card(
                                                  elevation: 7,
                                                  color: Color(0xFFf8f8f8),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            13),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Icon(
                                                      Icons.close,
                                                      size: 16,
                                                    ),
                                                  ),
                                                ),
                                                onTap: () async {
                                                  await showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          content: Text(
                                                              "Are you sure confirm to delete"),
                                                          //title: Text(),
                                                          actions: <Widget>[
                                                            FlatButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context,
                                                                    "no");
                                                              },
                                                              child: const Text(
                                                                  "NO"),
                                                            ),
                                                            FlatButton(
                                                              onPressed: () {
                                                                delete_image(
                                                                    imgList[index]
                                                                        .id);
                                                                Navigator.pop(
                                                                    context,
                                                                    "ok");
                                                                setState(() {
                                                                  imgList
                                                                      .removeAt(
                                                                          index);
                                                                  files.isNotEmpty
                                                                      ? files.removeAt(
                                                                          index)
                                                                      : null;
                                                                });
                                                              },
                                                              child: const Text(
                                                                  "YES"),
                                                            ),
                                                          ],
                                                        );
                                                      });
                                                },
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
                              padding: EdgeInsets.fromLTRB(13, 8, 13, 8),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0.0),
                                  side: BorderSide(color: appcolor)),
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  _formKey.currentState.save();
                                  // if (_imagefileName != null) {
                                  editPostADs(
                                    title.text,
                                    description.text,
                                    serviceType.text,
                                    price.text,
                                    "$doorStep",
                                    cityID,
                                  );
                                  // print(_imagefileName);
                                  // print(title.text +
                                  //   description.text+
                                  //   serviceType.text+
                                  //   price.text,);
                                  // } else {
                                  //   _alerBox();
                                  // }

                                }

                                setState(() {
                                  clickload = false;
                                });
                              },
                              child: Text(
                                "SAVE",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: white),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                        ],
                      )),
                ),
              ),
        clickload == false
            ? Container(
                color: Colors.black26,
                alignment: Alignment.center,
                child: CircularProgressIndicator(
                  backgroundColor: appcolor,
                  valueColor: new AlwaysStoppedAnimation<Color>(white),
                ),
              )
            : SizedBox(),
      ]),
    );
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Gallery'),
                      onTap: () {
                        // open_gallery();
                        loadAssets();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      open_camera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}
