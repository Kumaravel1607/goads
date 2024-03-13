import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:services/Constant/Colors.dart';
import 'package:services/Constant/api.dart';
import 'package:services/Model/Location_model.dart';
import 'package:services/Screens/AddPost.dart';
import 'package:services/Screens/PostDonePage.dart';
import 'package:services/Widgets/ElevatedButton.dart';
import 'package:services/Widgets/LoadingWidget.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JobPost extends StatefulWidget {
  final String subcat_type;
  final String cat_id;
  final String subcat_id;
  final String jobCategory;
  final String mainCategory;
  JobPost(
      {Key key,
      this.subcat_type,
      this.cat_id,
      this.subcat_id,
      this.jobCategory,
      this.mainCategory})
      : super(key: key);

  @override
  _JobPostState createState() => _JobPostState();
}

class _JobPostState extends State<JobPost> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  // final TextEditingController title = new TextEditingController();
  final TextEditingController description = new TextEditingController();
  final TextEditingController companyname = new TextEditingController();
  final TextEditingController yearOfRegister = new TextEditingController();
  final TextEditingController minsalary = new TextEditingController();
  final TextEditingController maxsalary = new TextEditingController();
  final TextEditingController expfrom = new TextEditingController();
  final TextEditingController expto = new TextEditingController();
  final TextEditingController price = new TextEditingController();
  final TextEditingController location = new TextEditingController();

  bool enalbleBtn = true;
  bool _isLoading = false;

  String salarytype;
  String jobtype;
  String type;
  String qualification;
  String english;
  String experience;
  String gender;
  String cityID;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDropdownValues();
  }

  List typeList = List();
  List salarytypeList = List();
  List jobtypeList = List();
  List qualificationList = List();
  List englishList = List();
  List experienceList = List();
  List genderList = List();

  Future<String> getDropdownValues() async {
    Map data = {
      'attribute_id': "jobs",
    };
    var res =
        await http.post(Uri.parse(app_api + "/attribute_mutiple"), body: data);
    var resBody = (json.decode(res.body));
    setState(() {
      _isLoading = true;
      typeList = resBody['jobs-category'];
      salarytypeList = resBody['salary-period'];
      jobtypeList = resBody['job_type'];
      qualificationList = resBody['qualification'];
      englishList = resBody['english '];
      experienceList = resBody['experience '];
      genderList = resBody['gender '];
    });
    return "Success";
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
    }
  }

  postADs(Map jobData) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'customer_id': sharedPreferences.getString("user_id"),
      'main_category': "3",
      'category_id': widget.cat_id.toString(),
      'sub_category_id': widget.subcat_id,
      'ads_name': type,
      'ads_description': description.text,
      'city_id': cityID,
      'ads_type': widget.subcat_type,
      'ads_image': files.isNotEmpty ? files.join(", ") : "",
    };
    data.addAll(jobData);
    var jsonResponse;
    var response;
    response = await http.post(Uri.parse(app_api + "/post_ads"), body: data);

    print(response.body.toString());
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if (jsonResponse != null) {
        setState(() {
          _isLoading = false;
        });
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

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: appcolor,
        title: Text(
          "Job Post",
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
                        decoration:
                            textInputDecoration('Job Role', "Job Role *"),
                        style: TextStyle(fontSize: 14),
                        items: typeList.map((item) {
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
                            type = newValue;
                          });
                        },
                        validator: (value) => value == null ? 'Type' : null,
                      ),
                      // SizedBox(
                      //   height: 15,
                      // ),
                      // TextFormField(
                      //   validator: (value) {
                      //     if (value.isEmpty) {
                      //       return 'Please enter job Title';
                      //     }
                      //     return null;
                      //   },
                      //   onSaved: (String value) {},
                      //   controller: title,
                      //   onTap: () {},
                      //   style: TextStyle(
                      //     fontSize: 14.0,
                      //     color: black,
                      //   ),
                      //   keyboardType: TextInputType.text,
                      //   decoration: textInputDecoration(
                      //     'Enter Job Title ',
                      //     'Job Title *',
                      //   ),
                      // ),
                      // SizedBox(
                      //   height: 15,
                      // ),
                      // TextFormField(
                      //   validator: (value) {
                      //     if (value.isEmpty) {
                      //       return 'Please enter job description';
                      //     }
                      //     return null;
                      //   },
                      //   onSaved: (String value) {},
                      //   controller: description,
                      //   minLines: 1,
                      //   maxLines: 4,
                      //   onTap: () {},
                      //   style: TextStyle(
                      //     fontSize: 14.0,
                      //     color: black,
                      //   ),
                      //   keyboardType: TextInputType.multiline,
                      //   decoration: textInputDecoration(
                      //     'Enter Job Description ',
                      //     'Job Description *',
                      //   ),
                      // ),
                      widget.jobCategory == "I need a Job"
                          ? SizedBox()
                          : SizedBox(
                              height: 15,
                            ),
                      widget.jobCategory == "I need a Job"
                          ? SizedBox()
                          : TextFormField(
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter Company name';
                                }
                                return null;
                              },
                              onSaved: (String value) {},
                              controller: companyname,
                              onTap: () {},
                              style: TextStyle(
                                fontSize: 14.0,
                                color: black,
                              ),
                              keyboardType: TextInputType.text,
                              decoration: textInputDecoration(
                                'Enter Company Name ',
                                'Company Name *',
                              ),
                            ),
                      SizedBox(
                        height: 15,
                      ),
                      DropdownButtonFormField<String>(
                        decoration:
                            textInputDecoration('Job Type', "Job Type *"),
                        style: TextStyle(fontSize: 14),
                        items: jobtypeList.map((item) {
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
                            jobtype = newValue;
                          });
                        },
                        validator: (value) => value == null ? 'Job Type' : null,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      DropdownButtonFormField<String>(
                        decoration: widget.jobCategory == "I need a Job"
                            ? textInputDecoration(
                                'Qualification', "Qualification *")
                            : textInputDecoration('Minimum Qualification',
                                "Minimum Qualification *"),
                        style: TextStyle(fontSize: 14),
                        items: qualificationList.map((item) {
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
                            qualification = newValue;
                          });
                        },
                        validator: (value) =>
                            value == null ? 'Job qualification' : null,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      DropdownButtonFormField<String>(
                        decoration: textInputDecoration(
                            'Salary Period *', "Salary Period *"),
                        style: TextStyle(fontSize: 14),
                        items: salarytypeList.map((item) {
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
                            salarytype = newValue;
                          });
                        },
                        validator: (value) =>
                            value == null ? 'Salary Period  ' : null,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Enter Minimum Salary';
                                }
                                return null;
                              },
                              onSaved: (String value) {},
                              controller: minsalary,
                              onTap: () {},
                              style: TextStyle(
                                fontSize: 14.0,
                                color: black,
                              ),
                              keyboardType: TextInputType.text,
                              decoration: textInputDecoration(
                                'Enter minimum salary ',
                                'Min Salary *',
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: TextFormField(
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Enter max salary';
                                }
                                return null;
                              },
                              onSaved: (String value) {},
                              controller: maxsalary,
                              onTap: () {},
                              style: TextStyle(
                                fontSize: 14.0,
                                color: black,
                              ),
                              keyboardType: TextInputType.text,
                              decoration: textInputDecoration(
                                'Enter Max Salary ',
                                'Max Salary *',
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      DropdownButtonFormField<String>(
                        decoration: widget.jobCategory == "I need a Job"
                            ? textInputDecoration('English', "English *")
                            : textInputDecoration(
                                'English Required ', "English Required *"),
                        style: TextStyle(fontSize: 14),
                        items: englishList.map((item) {
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
                            english = newValue;
                          });
                        },
                        validator: (value) =>
                            value == null ? 'English Required  ' : null,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      DropdownButtonFormField<String>(
                        decoration: textInputDecoration(
                            'Work Experience ', "Experience *"),
                        style: TextStyle(fontSize: 14),
                        items: experienceList.map((item) {
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
                            experience = newValue;
                          });
                        },
                        validator: (value) =>
                            value == null ? 'Work Experience  ' : null,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      DropdownButtonFormField<String>(
                        decoration: widget.jobCategory == "I need a Job"
                            ? textInputDecoration('Gender ', "Gender *")
                            : textInputDecoration(
                                'Gender Preference ', "Gender Preference *"),
                        style: TextStyle(fontSize: 14),
                        items: genderList.map((item) {
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
                            gender = newValue;
                          });
                        },
                        validator: (value) =>
                            value == null ? 'Gender Preference  ' : null,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter description';
                          }
                          return null;
                        },
                        onSaved: (String value) {},
                        controller: description,
                        onTap: () {},
                        style: TextStyle(
                          fontSize: 14.0,
                          color: black,
                        ),
                        keyboardType: TextInputType.text,
                        decoration: textInputDecoration(
                          'Enter Description ',
                          'Description *',
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TypeAheadField(
                        textFieldConfiguration: TextFieldConfiguration(
                            // autofocus: true,
                            controller: location,
                            decoration: textDecoration("Choose Location *")),
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
                        height: 15,
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
                                                    image: FileImage(
                                                        fileImg[index]),
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
                                                        const EdgeInsets.all(
                                                            2.0),
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
                        height: 25,
                      ),
                      Center(
                        child: Container(
                            width: MediaQuery.of(context).size.width * 0.90,
                            child: ElevatedBtn(submitButton, "SUBMIT")),
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
      if (files != null && cityID != null) {
        if (enalbleBtn == true) {
          Map jobData = widget.jobCategory == "I need a Job"
              ? {
                  'sub_category_type': widget.subcat_type,
                  'jobs_category': type,
                  'salary_period': salarytype,
                  'job_type': jobtype,
                  'qualification': qualification,
                  'english': english,
                  'experience': experience,
                  'gender': gender,
                  'salary_from': minsalary.text,
                  'salary_to': maxsalary.text,
                }
              : {
                  'sub_category_type': widget.subcat_type,
                  'jobs_category': type,
                  'company_name': companyname.text,
                  'salary_period': salarytype,
                  'job_type': jobtype,
                  'qualification': qualification,
                  'english': english,
                  'experience': experience,
                  'gender': gender,
                  'salary_from': minsalary.text,
                  'salary_to': maxsalary.text,
                };

          postADs(jobData);
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

      // Navigator.of(context, rootNavigator: true).pushReplacement(
      //     CupertinoPageRoute(
      //         builder: (_) => AddPostsPage(
      //             categoryID: widget.cat_id.toString(),
      //             subcategoryID: widget.subcat_id,
      //             subcategoryName: widget.subcat_type,
      //             mapdata: jobData,
      //             productType: widget.subcat_type)));
    }
  }
}
