import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:services/Constant/Colors.dart';
import 'package:services/Constant/api.dart';
import 'package:services/Screens/ChatList.dart';

import 'EditProfile.dart';
import 'Favorites.dart';
import 'LoginPage.dart';
import 'MyPosts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';
import 'package:services/Model/MyProfile.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String image;
  String name;
  String lastname;

  @override
  void initState() {
    super.initState();
    getUserDetail();
  }

  Future<UserDetails> getUserDetail() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // var jsonResponse = null;
    Map data = {
      'customer_id': sharedPreferences.getString("user_id"),
      // 'customer_id': sharedPreferences.getString("user_id"),
    };
    var response;
    response = await http.post(Uri.parse(app_api + '/customer'), body: data);

    if (response.statusCode == 200) {
      var userDetail = (json.decode(response.body));

      setState(() {
        name = (userDetail['first_name']);
        // lastname = (userDetail['last_name']);
        image = (userDetail['profile_image']);
      });

      return UserDetails.fromJson(userDetail);
    } else {
      throw Exception('Failed to load post');
    }
  }

  checkLogoutStatus() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
    sharedPreferences.commit();

    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
        (Route<dynamic> route) => false);

    // Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
    //     CupertinoPageRoute<bool>(
    //       fullscreenDialog: true,
    //       builder: (BuildContext context) => LoginPage(),
    //     ),
    //   );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: appcolor,
        title: Text(
          "My Account",
          style: TextStyle(color: white),
        ),
        centerTitle: true,
        //  leading: IconButton(icon: Icon(Icons.arrow_back),
        //   onPressed: (){
        //     // Navigator.pop(context);
        //   }),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Center(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 52,
                    backgroundColor: appcolor,
                    child: InkWell(
                      child: CircleAvatar(
                        backgroundColor: white,
                        radius: 50,
                        backgroundImage: image != null
                            ? NetworkImage(image)
                            : AssetImage(
                                'assets/images/user.png',
                              ),
                      ),
                      onTap: () {
                        Navigator.of(context).push(new PageRouteBuilder(
                            opaque: false,
                            pageBuilder: (BuildContext context, _, __) {
                              return new Material(
                                  color: Colors.black54,
                                  child: new Container(
                                    padding: const EdgeInsets.all(30.0),
                                    child: new InkWell(
                                      child: new Hero(
                                        // tag: null,
                                        child: Center(
                                          child: Container(
                                            height: 350,
                                            width: 350,
                                            child: CircleAvatar(
                                              // radius: 75,
                                              backgroundImage:
                                                  NetworkImage(image),
                                              // backgroundImage:
                                              //     AssetImage('assets/smiley.jpg'),
                                            ),
                                          ),
                                        ),
                                        tag: 'id',
                                      ),
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ));
                            }));
                      },
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    name != null ? name : "",
                    style: TextStyle(
                        color: black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 1,
                    width: 80,
                    color: Colors.grey[300],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ListTile(
                    title: Text(
                      "Edit Profile",
                      style: TextStyle(
                          fontSize: 16,
                          color: black,
                          fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      "Edit your personal information",
                      style: TextStyle(
                          fontSize: 12,
                          color: black,
                          fontWeight: FontWeight.w500),
                    ),
                    leading: Image.asset(
                      "assets/images/settings.png",
                      height: 25,
                      width: 25,
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: black,
                      size: 20,
                    ),
                    onTap: () {
                      Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  EditProfilePage()));
                    },
                  ),
                  divider(),
                  ListTile(
                    title: Text(
                      "My Posts",
                      style: TextStyle(
                          fontSize: 16,
                          color: black,
                          fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      "Sell and Service",
                      style: TextStyle(
                          fontSize: 12,
                          color: black,
                          fontWeight: FontWeight.w500),
                    ),
                    leading: Image.asset(
                      "assets/images/post.png",
                      height: 25,
                      width: 25,
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: black,
                      size: 20,
                    ),
                    onTap: () {
                      Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                              builder: (BuildContext context) => MyPosts()));
                    },
                  ),
                  divider(),
                  ListTile(
                    title: Text(
                      "Message",
                      style: TextStyle(
                          fontSize: 16,
                          color: black,
                          fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      "Your messages",
                      style: TextStyle(
                          fontSize: 12,
                          color: black,
                          fontWeight: FontWeight.w500),
                    ),
                    leading: Image.asset(
                      "assets/images/message.png",
                      height: 25,
                      width: 25,
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: black,
                      size: 20,
                    ),
                    onTap: () {
                      Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  ChatListPage()));
                    },
                  ),
                  divider(),
                  ListTile(
                    title: Text(
                      "Favorites",
                      style: TextStyle(
                          fontSize: 16,
                          color: black,
                          fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      "Your selected favorites",
                      style: TextStyle(
                          fontSize: 12,
                          color: black,
                          fontWeight: FontWeight.w500),
                    ),
                    leading: Image.asset(
                      "assets/images/fav.png",
                      height: 25,
                      width: 25,
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: black,
                      size: 20,
                    ),
                    onTap: () {
                      Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  FavoritePage()));
                    },
                  ),
                  divider(),
                  ListTile(
                    title: Text(
                      "Logout",
                      style: TextStyle(
                          fontSize: 16,
                          color: black,
                          fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      "Logout your account",
                      style: TextStyle(
                          fontSize: 12,
                          color: black,
                          fontWeight: FontWeight.w500),
                    ),
                    leading: Image.asset(
                      "assets/images/logout.png",
                      height: 25,
                      width: 25,
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: black,
                      size: 20,
                    ),
                    onTap: () {
                      checkLogoutStatus();
                    },
                  ),
                  divider(),
                ]),
          ),
        ),
      ),
    );
  }
}
