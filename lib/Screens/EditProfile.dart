import 'dart:io';

import 'package:flutter/material.dart';
import 'package:services/Constant/Colors.dart';
import 'package:http/http.dart' as http;
import 'package:services/Constant/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:services/Model/MyProfile.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilePage extends StatefulWidget {
  EditProfilePage({Key key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController name = new TextEditingController();
  final TextEditingController lastname = new TextEditingController();
  final TextEditingController mobile = new TextEditingController();

  String _gender;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    getUserDetail();
  }

  String image;
  String username;

  Future<UserDetails> getUserDetail() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // var jsonResponse = null;
    Map data = {
      'customer_id': sharedPreferences.getString("user_id"),
      // 'customer_id': sharedPreferences.getString("user_id"),
    };
    print(data);
    var response;
    response = await http.post(Uri.parse(app_api + '/customer'), body: data);

    if (response.statusCode == 200) {
      setState(() {
        _isLoading = false;
      });
      var userDetail = (json.decode(response.body));
      print(userDetail);

      setState(() {
        _gender = (userDetail['gender']);
        image = (userDetail['profile_image']);
      });

      name.text = (userDetail['first_name']);
      lastname.text = (userDetail['last_name']);
      mobile.text = (userDetail['mobile']);

      return UserDetails.fromJson(userDetail);
    } else {
      setState(() {
        _isLoading = false;
      });
      throw Exception('Failed to load post');
    }
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()

    // _refreshController.refreshCompleted();
    _refreshController.refreshToIdle();
    getUserDetail();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    // allAPI();
    // if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  update_user(
    fname,
    lname,
    mnumber,
    gender,
  ) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'customer_id': sharedPreferences.getString("user_id"),
      'first_name': fname,
      'last_name': lname,
      'mobile': mnumber,
      'gender': gender,
    };

    print(data);
    var jsonResponse;
    var response =
        await http.post(Uri.parse(app_api + "/update_customer"), body: data);

    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if (jsonResponse != null) {
        setState(() {
          _isLoading = false;
        });
        Navigator.pop(context);
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      _alerDialog(jsonResponse['message']);
    }
  }

  void upload_image(imgpath) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'customer_id': sharedPreferences.getString("user_id"),
      'profile_image': imgpath,
    };
    print(data);
    var jsonResponse;
    var response =
        await http.post(Uri.parse(app_api + '/update_profile'), body: data);
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      getUserDetail();
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  //  File _image;
  // String _imagefileName;
  final picker = ImagePicker();
  void open_gallery() async {
    var image = await picker.getImage(source: ImageSource.gallery);
    //  var pickedFile = await picker.getImage(source: ImageSource.gallery);
    var _image = File(image.path);
    setState(() {
      _image.readAsBytesSync() != null
          ? upload_image(base64Encode(_image.readAsBytesSync()))
          : '';
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

  Future<void> _alerBox() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text("Please fill Required field"),
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
          "Edit Profile",
          style: TextStyle(color: white, fontSize: 16),
        ),
        centerTitle: true,
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: WaterDropHeader(),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: Container(
          child: _isLoading == true
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
                          Center(
                            child: Text(
                              "Edit Your Profile",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(height: 20),
                          Center(
                            child: Stack(
                              children: [
                                CircleAvatar(
                                  radius: 52,
                                  backgroundColor: appcolor,
                                  child: CircleAvatar(
                                    backgroundColor: white,
                                    radius: 49,
                                    backgroundImage: image != null
                                        ? NetworkImage(image)
                                        : AssetImage(
                                            'assets/images/user.png',
                                          ),
                                  ),
                                ),
                                CircleAvatar(
                                  radius: 53,
                                  backgroundColor: Colors.black12,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 75, top: 55),
                                    child: GestureDetector(
                                      child: CircleAvatar(
                                        radius: 15,
                                        backgroundColor: appcolor,
                                        child: Icon(
                                          Icons.edit,
                                          size: 18,
                                          color: white,
                                        ),
                                      ),
                                      onTap: () {
                                        open_gallery();
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Text(
                            "First Name",
                            style: TextStyle(color: black, fontSize: 16),
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter First Name';
                              }
                              return null;
                            },
                            cursorHeight: 18,
                            onSaved: (String value) {},
                            controller: name,
                            obscureText: false,
                            onTap: () {},
                            style: TextStyle(
                              fontSize: 14.0,
                              color: black,
                            ),
                            keyboardType: TextInputType.text,
                            decoration: textDecoration(
                              'First Name',
                            ),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Text(
                            "Last Name",
                            style: TextStyle(color: black, fontSize: 16),
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter Last Name';
                              }
                              return null;
                            },
                            cursorHeight: 18,
                            onSaved: (String value) {},
                            controller: lastname,
                            obscureText: false,
                            onTap: () {},
                            style: TextStyle(
                              fontSize: 14.0,
                              color: black,
                            ),
                            keyboardType: TextInputType.text,
                            decoration: textDecoration(
                              'Last Name',
                            ),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Text(
                            "Mobile Number",
                            style: TextStyle(color: black, fontSize: 16),
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter Moble number';
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
                              'Mobile Number',
                            ),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Text(
                            "Gender",
                            style: TextStyle(color: black, fontSize: 16),
                          ),
                          DropdownButtonFormField<String>(
                            value: _gender,
                            decoration: textDecoration(
                              "Gender",
                            ),
                            items: <String>[
                              'Male',
                              'Female',
                              'Others',
                            ]
                                .map((String value) => DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                      ),
                                    ))
                                .toList(),
                            onChanged: (newValue) {
                              setState(() {
                                _gender = newValue;
                              });
                            },
                            validator: (value) => value == null
                                ? 'Please select the Gender'
                                : null,
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          ButtonTheme(
                            buttonColor: appcolor,
                            minWidth: 400,
                            child: FlatButton(
                              color: appcolor,
                              padding: EdgeInsets.all(13),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0.0),
                                  side: BorderSide(color: appcolor)),
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  _formKey.currentState.save();
                                  print("-------");
                                  update_user(
                                    name.text,
                                    lastname.text,
                                    mobile.text,
                                    _gender,
                                  );
                                }
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
                        ],
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
