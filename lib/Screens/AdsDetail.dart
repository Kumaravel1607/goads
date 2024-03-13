import 'package:flutter/material.dart';
import 'package:services/Constant/Colors.dart';
import 'package:services/Model/AdsDetail_model.dart';
import 'dart:ui';
import 'package:pull_to_refresh/pull_to_refresh.dart';
// import 'package:services/Model/bussiness_model.dart';
import 'AdsUserDetail.dart';
import 'ChatScreen.dart';
import 'package:http/http.dart' as http;
import 'package:services/Constant/api.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'dart:math';
import 'package:dots_indicator/dots_indicator.dart';
import 'dart:core';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';

class AdsDetailPage extends StatefulWidget {
  final String ads_id;
  AdsDetailPage({Key key, this.ads_id}) : super(key: key);

  @override
  _AdsDetailPageState createState() => _AdsDetailPageState();
}

class _AdsDetailPageState extends State<AdsDetailPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<String> _bussinessCityName = <String>[];
  List wordsL = [];
  List<String> savedwords = List<String>();
  bool _isLoading = true;

  String adsID;
  String receiverId;
  String user_ID;
  String poster_Id;
  int _current = 0;

  String userId;

  //  PageController _pageController = PageController(initialPage: 1);
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    userID();
    ads_detail();
    image_api();
  }

  void refresh() {
    setState(() {
      _pageController = PageController(initialPage: _current);
    });
  }

  Future<AdsDetail> ads_detail() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'id': widget.ads_id,
      'customer_id': sharedPreferences.getString("user_id"),
    };
    print(data);
    var response =
        await http.post(Uri.parse(app_api + '/ads_detail'), body: data);
    var jsonResponse;
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      print(jsonResponse);
      poster_Id = jsonResponse['customer_id'].toString();
      adsID = jsonResponse['id'].toString();
      receiverId = jsonResponse['customer_id'].toString();
      userId = sharedPreferences.getString("user_id");

      if (jsonResponse['extra']['business_city_names'] != null) {
        List _business_Cityname = jsonResponse['extra']['business_city_names'];
        _bussinessCityName =
            _business_Cityname.map((s) => s as String).toList();
      }

      return AdsDetail.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load post');
    }
  }

  void image_api() async {
    Map data = {
      'id': widget.ads_id,
    };
    var response =
        await http.post(Uri.parse(app_api + '/ads_detail'), body: data);

    if (response.statusCode == 200) {
      print(json.decode(response.body)['images']);
      get_imageList(json.decode(response.body)['images']).then((value) {
        setState(() {
          imageList = value;
        });
      });
      // print(json.decode(response.body)['images']);
    }
  }

  List<AllImage> imageList = List<AllImage>();

  Future<List<AllImage>> get_imageList(imageListsJson) async {
    var imageLists = List<AllImage>();
    for (var imageListJson in imageListsJson) {
      imageLists.add(AllImage.fromJson(imageListJson));
    }
    return imageLists;
  }

  void userID() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      user_ID = sharedPreferences.getString("user_id");
    });
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()

    // _refreshController.refreshCompleted();
    _refreshController.refreshToIdle();
    ads_detail();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    // allAPI();
    // if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  save_favorite(adID) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'customer_id': sharedPreferences.getString("user_id"),
      'ads_id': adID,
    };
    print(data);
    var jsonResponse;
    var response =
        await http.post(Uri.parse(app_api + '/save_favorite'), body: data);
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: const Text('Added your favorite list'),
        ),
      );
    } else {
      // setState(() {
      //   _isLoading = false;
      // });
    }
  }

  delete_favorite(adID) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'customer_id': sharedPreferences.getString("user_id"),
      'ads_id': adID,
    };
    print(data);
    var jsonResponse;
    var response =
        await http.post(Uri.parse(app_api + '/delete_favorite'), body: data);
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: const Text('Removed from your favorite list'),
        ),
      );
    } else {
      // setState(() {
      //   _isLoading = false;
      // });
    }
  }

  Widget extraDetails(value, AdsDetail data) {
    switch (value) {
      case "bike":
        return extraBikeDetail(data);
        break;

      case "cars":
        return extraCarDetail(data);
        break;

      case "sale-property":
      case "rent-property":
        return extraPropertyDetail(data);
        break;

      case "rent-shop":
      case "sale-shop":
        return extraShopDetail(data);
        break;

      case "lands-plots":
        return extraLandDetail(data);
        break;

      case "pg":
        return extraPGDetail(data);
        break;

      case "jobs":
        return jobsDetail(data);
        break;
      case "mobile":
      case "electronics-appliances":
        return mobileAndElectronicDetails(data);
        break;
      case "commercial-vehicles":
        return extraVehicleDetail(data);
        break;
      default:
        return SizedBox(
            // child: Text("Getting Result..."),
            );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: white,
      body: SafeArea(
        child: FutureBuilder<AdsDetail>(
            future: ads_detail(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                String word = snapshot.data.id;
                savedwords.remove(word);
                if (snapshot.data.favorite_status == "1") {
                  savedwords.add(word);
                }
                bool issaved = savedwords.contains(word);
                return snapshot.data.ads_type == "repairs-servicing"
                    ? _bussinessdetailPage(snapshot)
                    : Stack(children: [
                        SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (imageList.length != 0)
                                Stack(
                                  children: [
                                    new Container(
                                      child: CarouselSlider.builder(
                                          options: CarouselOptions(
                                              height: 250,
                                              viewportFraction: 1.0,
                                              aspectRatio: 2.0,
                                              autoPlay: false,
                                              enableInfiniteScroll: false,
                                              autoPlayInterval:
                                                  Duration(seconds: 3),
                                              autoPlayCurve: Curves.easeInCubic,
                                              enlargeCenterPage: false,
                                              reverse: false,
                                              onPageChanged: (index, reason) {
                                                setState(() {
                                                  _current = index;
                                                  print("${_current}");
                                                });
                                              }),
                                          itemCount: imageList.length,
                                          itemBuilder: (context, index) {
                                            return Builder(
                                              builder: (BuildContext context) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    //  photoView();
                                                    setState(() {
                                                      refresh();
                                                    });
                                                    // print("new");
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (BuildContext
                                                                    context) =>
                                                                photoView()));
                                                  },
                                                  child: Stack(
                                                    children: [
                                                      Container(
                                                        height: 250,
                                                        padding:
                                                            EdgeInsets.all(0),
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        // height: MediaQuery.of(context).size.height,
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    10.0),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                          image:
                                                              DecorationImage(
                                                            image: NetworkImage(
                                                                imageList[index]
                                                                    .image_name),
                                                            // fit: BoxFit.fill,
                                                          ),
                                                          shape: BoxShape
                                                              .rectangle,
                                                          boxShadow: <
                                                              BoxShadow>[
                                                            // BoxShadow(
                                                            //     color: Colors.black54,
                                                            //     blurRadius: 10.0,
                                                            //     offset: Offset(0.0, 0.0)
                                                            // )
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        height: 250,
                                                        color: const Color(
                                                                0xBD0E3311)
                                                            .withOpacity(0.2),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                          }),
                                    ),
                                    Container(
                                        // alignment: Alignment.topRight,
                                        // width: MediaQuery.of(context).size.width,
                                        // color: const Color(0xFF0E3311).withOpacity(0.5),
                                        height: 250,
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 10, 20, 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                FloatingActionButton(
                                                  elevation: 10,
                                                  mini: true,
                                                  foregroundColor: black,
                                                  backgroundColor: white,
                                                  child: Icon(
                                                    Icons.arrow_back,
                                                    color: black,
                                                    size: 25,
                                                  ),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                                Spacer(),
                                                Card(
                                                  elevation: 5,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            17.0),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: GestureDetector(
                                                        child: issaved
                                                            ? Icon(
                                                                Icons.favorite,
                                                                color: Color(
                                                                    0xFFC43434),
                                                                // size: 22,
                                                              )
                                                            : Icon(
                                                                Icons
                                                                    .favorite_border,
                                                                color: Color(
                                                                    0xFFC43434),
                                                                // size: 22,
                                                              ),
                                                        onTap: () {
                                                          setState(() {
                                                            print(savedwords
                                                                .contains(
                                                                    word));
                                                            if (issaved) {
                                                              snapshot.data
                                                                      .favorite_status =
                                                                  "0";
                                                              savedwords
                                                                  .remove(word);

                                                              delete_favorite(
                                                                  snapshot
                                                                      .data.id);
                                                            } else {
                                                              snapshot.data
                                                                      .favorite_status =
                                                                  "1";
                                                              savedwords
                                                                  .add(word);

                                                              save_favorite(
                                                                  snapshot
                                                                      .data.id);
                                                            }
                                                          });
                                                        }),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Spacer(),
                                            imageList.length == 1
                                                ? SizedBox()
                                                : Center(
                                                    child: new DotsIndicator(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      dotsCount:
                                                          imageList.length,
                                                      position:
                                                          _current.toDouble(),
                                                      decorator: DotsDecorator(
                                                        color: Colors.grey[
                                                            200], // Inactive color
                                                        activeColor: appcolor,
                                                        spacing:
                                                            const EdgeInsets
                                                                .all(2.0),
                                                        size: const Size.square(
                                                            7.0),
                                                        activeSize: const Size(
                                                            16.0, 9.0),
                                                        activeShape:
                                                            RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5.0)),
                                                      ),
                                                      // decorator: DotsDecorator(
                                                      //   color: Colors.grey[300], // Inactive color
                                                      //   activeColor: appcolor,
                                                      // ),
                                                    ),
                                                  ),
                                          ],
                                        )),
                                  ],
                                )
                              else
                                Container(),
                              Container(
                                decoration: BoxDecoration(
                                  // color: white,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(40.0),
                                      topRight: Radius.circular(40.0)),
                                ),
                                padding: EdgeInsets.fromLTRB(17, 0, 15, 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    trendingList(snapshot.data),
                                    Divider(
                                      color: Colors.grey,
                                      thickness: .5,
                                    ),
                                    // SizedBox(
                                    //   height: 10,
                                    // ),
                                    Container(
                                        child: extraDetails(
                                            snapshot.data.ads_type,
                                            snapshot.data)),
                                    SizedBox(
                                      height: 7,
                                    ),

                                    Text(
                                      "Description",
                                      style: TextStyle(
                                          color: appcolor, fontSize: 18),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    // HtmlWidget(
                                    //     snapshot.data.ads_description != null ? snapshot.data.ads_description + '\n': "",
                                    //     // textStyle: TextStyle(),
                                    //   ),
                                    Text(
                                      snapshot.data.ads_description != null
                                          ? snapshot.data.ads_description + '\n'
                                          : "",
                                      // textStyle: TextStyle(),
                                    ),
                                    // SizedBox(height: 5,),
                                    Divider(
                                      color: Colors.grey,
                                      thickness: .5,
                                      height: 0.5,
                                    ),
                                    SizedBox(
                                        height: snapshot.data.type_of_service !=
                                                null
                                            ? 5
                                            : 0),
                                    snapshot.data.type_of_service != null
                                        ? Text(
                                            "Service Details",
                                            style: TextStyle(
                                                color: appcolor, fontSize: 18),
                                          )
                                        : SizedBox(),
                                    SizedBox(
                                        height: snapshot.data.type_of_service !=
                                                null
                                            ? 5
                                            : 0),
                                    // HtmlWidget(
                                    //   snapshot.data.type_of_service != null ? snapshot.data.type_of_service + '\n': "",
                                    // ),
                                    Text(
                                      snapshot.data.type_of_service != null
                                          ? snapshot.data.type_of_service + '\n'
                                          : "",
                                      // textStyle: TextStyle(),
                                    ),
                                    snapshot.data.type_of_service != null
                                        ? Divider(
                                            color: Colors.grey,
                                            thickness: .5,
                                            height: 0.5,
                                          )
                                        : SizedBox(),
                                    SizedBox(
                                        height: snapshot.data.type_of_service !=
                                                null
                                            ? 5
                                            : 0),
                                    if (snapshot.data.category_id != "10")
                                      Text(
                                        "Doorstep Services",
                                        style: TextStyle(
                                            color: appcolor, fontSize: 18),
                                      ),

                                    if (snapshot.data.category_id != "10")
                                      SizedBox(
                                        height: 5,
                                      ),

                                    if (snapshot.data.category_id != "10")
                                      Row(
                                        children: [
                                          snapshot.data.door_step == "1"
                                              ? Container(
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: appcolor),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Icon(
                                                      Icons.check,
                                                      size: 10.0,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                )
                                              : Container(
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.red),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Icon(
                                                      Icons.close,
                                                      size: 10.0,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                          snapshot.data.door_step == "1"
                                              ? Text(" Yes")
                                              : Text(" No"),
                                        ],
                                      ),

                                    if (snapshot.data.category_id != "10")
                                      SizedBox(
                                        height: 5,
                                      ),
                                    if (snapshot.data.category_id != "10")
                                      Divider(
                                        color: Colors.grey,
                                        thickness: .5,
                                      ),
                                    profile(snapshot.data),
                                    SizedBox(
                                      height: 50,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // ),

                        Container(
                          alignment: Alignment.bottomCenter,
                          padding: const EdgeInsets.symmetric(vertical: 0),
                          child: button(snapshot.data),
                        ),
                      ]);
              } else {
                return Container(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(
                    backgroundColor: appcolor,
                    valueColor: new AlwaysStoppedAnimation<Color>(white),
                  ),
                );
              }
            }),
      ),
    );
  }

  Widget trendingList(AdsDetail data) {
    return GestureDetector(
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //       builder: (BuildContext context) => newPage() ));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 10, bottom: 7, left: 0, right: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                data.service_type == "3"
                    ? Text(
                        data.ads_price != null ? data.ads_price : "",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 18,
                            color: black,
                            fontWeight: FontWeight.w500),
                      )
                    : SizedBox(),
                SizedBox(
                  height: 5,
                ),
                Text(
                  data.ads_name != null ? data.ads_name : "",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontSize: 18, color: color2, fontWeight: FontWeight.w600),
                ),
                // Row(
                //   children: [
                //     Container(
                //       width: 300,
                //       // color: appcolor,
                //       child:
                //        Text(data.ads_name != null ? data.ads_name : "",textAlign: TextAlign.start, overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 18, color: black,fontWeight: FontWeight.w600),)),
                //     Spacer(),
                //     IconButton(
                //         padding: EdgeInsets.all(0),
                //         splashRadius: 15,
                //         iconSize: 22,
                //         icon: issaved
                //             ? Icon(
                //                 Icons.favorite,
                //                 color: Color(0xFFC43434),
                //               )
                //             : Icon(
                //                 Icons.favorite_border,
                //                 color: Color(0xFFC43434),
                //               ),

                //           });
                //         }),
                //   ],
                // ),

                // SizedBox(height: 5,),
                // Row(
                //   children: [
                //     // Text("Posted on: ",textAlign: TextAlign.start, style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500),),
                //     Text(data.posted_at != null ? data.posted_at : "",textAlign: TextAlign.start, style: TextStyle(fontSize: 14, color: appcolor,fontWeight: FontWeight.w500),),
                //   ],
                // ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Colors.green,
                      size: 18,
                    ),
                    Text(
                      data.city_name != null ? data.city_name : "",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 12,
                          color: appcolor,
                          fontWeight: FontWeight.w500),
                    ),
                    Spacer(),
                    Text(
                      data.posted_at != null ? data.posted_at : "",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                SizedBox(
                  height: 7,
                ),
                data.ads_condition != null
                    ? Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(5)),
                        child: Text(
                          data.ads_condition == 1
                              ? "New"
                              : data.ads_condition == 2
                                  ? "Like New"
                                  : data.ads_condition == 3
                                      ? "Gently used"
                                      : data.ads_condition == 4
                                          ? "Heavily used"
                                          : "",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[700]),
                        ),
                      )
                    : SizedBox(),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget profile(AdsDetail data) {
    return Container(
      // elevation: 1,
      decoration: BoxDecoration(color: Colors.grey[50]),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Posted By",
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontWeight: FontWeight.w600, fontSize: 18, color: appcolor),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    flex: 2,
                    child: Container(
                      height: 70,
                      alignment: Alignment.topLeft,
                      child: CircleAvatar(
                        radius: 29,
                        // foregroundColor: appcolor,
                        backgroundColor: Colors.grey[200],
                        // backgroundImage: AssetImage('assets/images/user.png'),
                        backgroundImage: data.profile_image != null
                            ? NetworkImage(data.profile_image)
                            : AssetImage('assets/images/user.png'),
                      ),
                    )),
                Expanded(
                    flex: 6,
                    child: Container(
                        height: 70,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data.first_name != null ? data.first_name : "",
                              style: TextStyle(color: color2, fontSize: 16),
                            ),
                            Text(
                              "Member Since " + data.join_year,
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                            InkWell(
                              child: Text(
                                "See Profile",
                                style: TextStyle(
                                    color: Colors.grey[800], fontSize: 14),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            AdsUserProfilePage(
                                              aduserID: data.customer_id,
                                              aduserImage: data.profile_image,
                                              aduserName: data.first_name,
                                              aduserJoin: data.join_year,
                                            )));
                              },
                            )
                          ],
                        ))),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget button(AdsDetail data) {
    print(poster_Id + user_ID);
    if (poster_Id != user_ID) {
      // print(poster_Id + user_ID);
      return Container(
        padding: EdgeInsets.only(left: 20, right: 20, top: 7, bottom: 10),
        height: 60,
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        child: RaisedButton(
          //  padding: EdgeInsets.only(left: 35, right: 35),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          color: appcolor,
          onPressed: () {
            Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
                builder: (BuildContext context) => ChatScreen(
                      adsId: adsID,
                      // receiverID: receiverId,
                      user_name: data.first_name,
                      sendID: userId,
                      receiveID: receiverId,
                    )));
          },

          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.chat,
                color: white,
                size: 22,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                " Chat",
                style: TextStyle(color: white, fontSize: 18),
              ),
            ],
          ),
        ),
      );
    } else {
      print("-------------Nandhu1--------------------");
    }
  }

  Widget photoView() => Container(
        child: Stack(children: [
          PhotoViewGallery.builder(
            itemCount: imageList.length,
            pageController: _pageController,
            builder: (context, index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: NetworkImage(imageList[index].image_name),
                minScale: PhotoViewComputedScale.contained * 0.8,
                maxScale: PhotoViewComputedScale.covered * 2,
              );
            },
            scrollPhysics: BouncingScrollPhysics(),
            onPageChanged: (int index) {
              setState(() {
                _current = index;
                print(_current);
              });
            },
            backgroundDecoration: BoxDecoration(
              color: black,
            ),
            loadFailedChild: Center(
              child: CircularProgressIndicator(),
            ),
          ),
          Container(
              alignment: Alignment.topRight,
              padding: const EdgeInsets.only(top: 100, right: 25),
              child: FloatingActionButton(
                elevation: 10,
                mini: true,
                foregroundColor: black,
                backgroundColor: white,
                child: Icon(
                  Icons.close,
                  color: black,
                  size: 25,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )),
        ]),
      );

  Widget extraBikeDetail(AdsDetail data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Details",
          style: TextStyle(
              color: appcolor, fontSize: 16, fontWeight: FontWeight.w600),
        ),
        SizedBox(
          height: 7,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text("BRAND"),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text("MODEL"),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text("FUEL TYPE"),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text("KM DRIVEN"),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text("REGISTER YEAR"),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text("INSURANCE DATE"),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text("NO OF OWNER"),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text("SELLER BY"),
                    ),
                  ],
                )),
            Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text(data.brand_name ?? "-"),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text(data.model ?? "-"),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text(data.fuel_type ?? "-"),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text(data.km_driven ?? "-"),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text(data.registration_date ?? "-"),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text(data.insurance_valid ?? "-"),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text(data.no_of_owner ?? "-"),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text(data.seller_by ?? "-"),
                    ),
                  ],
                )),
          ],
        ),
        Divider(
          color: Colors.grey,
          thickness: .5,
        ),
      ],
    );
  }

  Widget extraCarDetail(AdsDetail data) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 7),
      color: Colors.grey[100],
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Icon(
                        Icons.ev_station_outlined,
                        size: 20,
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Flexible(child: Text(data.fuel_type)),
                    ],
                  )),
              Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Icon(
                        Icons.speed,
                        size: 20,
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Flexible(child: Text(data.km_driven)),
                    ],
                  )),
              Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Icon(
                        Icons.grain_outlined,
                        size: 20,
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Flexible(
                          child: Text(data.transmission != null
                              ? data.transmission
                              : "Manual")),
                    ],
                  )),
            ],
          ),
          Divider(
            color: Colors.grey,
            thickness: .5,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    flex: 1,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.person_add_outlined,
                          size: 18,
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        Flexible(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Owner",
                                style: TextStyle(
                                  fontSize: 11,
                                )),
                            Text(
                              data.no_of_owner,
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ],
                        )),
                      ],
                    )),
                Expanded(
                    flex: 1,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.card_giftcard_outlined,
                          size: 18,
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        Flexible(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("SELLER BY",
                                style: TextStyle(
                                  fontSize: 11,
                                )),
                            Text(
                              data.seller_by,
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ],
                        )),
                      ],
                    )),
                Expanded(
                    flex: 1,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.directions_car_outlined,
                          size: 18,
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        Flexible(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("INSURANCE",
                                style: TextStyle(
                                  fontSize: 11,
                                )),
                            Text(
                              data.insurance_valid ?? "-",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ],
                        )),
                      ],
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget extraPropertyDetail(AdsDetail data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Details",
          style: TextStyle(
              color: appcolor, fontSize: 16, fontWeight: FontWeight.w600),
        ),
        SizedBox(
          height: 7,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text("TYPE"),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text("BEDROOMS"),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text("FLOOR"),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text("FURNISHING"),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text("CONSTRUCTION STATUS"),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text("LISTED BY"),
                    ),
                    // data.rent_monthly != null
                    //     ? Padding(
                    //         padding:
                    //             const EdgeInsets.symmetric(vertical: 5),
                    //         child: Text("MONTHLY RENT"),
                    //       )
                    //     : SizedBox(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text("CAR PARKING"),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text("SUPER BUILDUP AREA Sq Ft"),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text("CARPET AREA Sq Ft"),
                    ),
                    data.form_whom != null
                        ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Text("FOR WHOM"),
                          )
                        : SizedBox(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text("FACING"),
                    ),
                  ],
                )),
            SizedBox(
              width: 15,
            ),
            Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 7),
                      child: Text(data.type_of_property),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 7),
                      child: Text(data.bedrooms_type),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 7),
                      child: Text(data.floor),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 7),
                      child: Text(data.furnished),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 7),
                      child: Text(data.construction_status),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 7),
                      child: Text(data.listed_by),
                    ),
                    // data.rent_monthly != null
                    //     ? Padding(
                    //         padding:
                    //             const EdgeInsets.symmetric(vertical: 7),
                    //         child: Text(data.rent_monthly),
                    //       )
                    //     : SizedBox(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 7),
                      child: Text(data.car_parking_space),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 7),
                      child: Text(data.super_buildup_area_sq_ft),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 7),
                      child: Text(data.carpet_area_sq_ft),
                    ),
                    data.form_whom != null
                        ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 7),
                            child: Text(data.form_whom),
                          )
                        : SizedBox(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 7),
                      child: Text(data.facing),
                    ),
                  ],
                )),
          ],
        ),
        Divider(
          color: Colors.grey,
          thickness: .5,
        ),
      ],
    );
  }

  Widget extraShopDetail([AdsDetail data]) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Details",
          style: TextStyle(
              color: appcolor, fontSize: 16, fontWeight: FontWeight.w600),
        ),
        SizedBox(
          height: 7,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text("FURNISHED"),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text("LISTED BY"),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text("SUPER BUILDUP AREA (FT)"),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text("CARPET AREA (FT)"),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text("WASHROOMS"),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text("CAR PARKING"),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(vertical: 5),
                    //   child: Text("RENT MONTHLY"),
                    // ),
                    data.construction_status != null
                        ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Text("CONTRUCTION STATUS"),
                          )
                        : SizedBox(),
                  ],
                )),
            SizedBox(
              width: 13,
            ),
            Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 7),
                      child: Text(data.furnished),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 7),
                      child: Text(data.listed_by),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 7),
                      child: Text(data.super_buildup_area_sq_ft),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 7),
                      child: Text(data.carpet_area_sq_ft),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 7),
                      child: Text(data.washrooms),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 7),
                      child: Text(data.car_parking_space),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(vertical: 7),
                    //   child: Text(data.rent_monthly != null
                    //       ? data.rent_monthly
                    //       : "-"),
                    // ),
                    data.construction_status != null
                        ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 7),
                            child: Text(data.construction_status != null
                                ? data.construction_status
                                : "-"),
                          )
                        : SizedBox(),
                  ],
                )),
          ],
        ),
        Divider(
          color: Colors.grey,
          thickness: .5,
        ),
      ],
    );
  }

  Widget extraLandDetail(AdsDetail data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Details",
          style: TextStyle(
              color: appcolor, fontSize: 16, fontWeight: FontWeight.w600),
        ),
        SizedBox(
          height: 7,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text("TYPE"),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text("LISTED BY"),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text("PLOT AREA"),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text("LENGTH"),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text("BREADTH"),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text("FACING"),
                    ),
                  ],
                )),
            Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text(data.property_type),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text(data.listed_by),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text(data.plot_area),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text(data.length),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text(data.breadth),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text(data.facing),
                    ),
                  ],
                )),
          ],
        ),
        Divider(
          color: Colors.grey,
          thickness: .5,
        ),
      ],
    );
  }

  Widget extraPGDetail(AdsDetail data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Details",
          style: TextStyle(
              color: appcolor, fontSize: 16, fontWeight: FontWeight.w600),
        ),
        SizedBox(
          height: 7,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text("SUBTYPE"),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text("LISTED BY"),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text("FURNISHED"),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text("CAR PARKING"),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text("MEALS INCLUDED"),
                    ),
                  ],
                )),
            Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text(data.pg_sub_type),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text(data.listed_by),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text(data.furnished),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text(data.car_parking_space),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text(data.meal_included),
                    ),
                  ],
                )),
          ],
        ),
        Divider(
          color: Colors.grey,
          thickness: .5,
        ),
      ],
    );
  }

  Widget jobsDetail(AdsDetail data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Details",
          style: TextStyle(
              color: appcolor, fontSize: 16, fontWeight: FontWeight.w600),
        ),
        SizedBox(
          height: 7,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    data.company_name != null
                        ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Text("COMPANY NAME"),
                          )
                        : SizedBox(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text("POSITION TYPE"),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text("QUALIFICATION"),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text("SALARY PERIOD"),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text("SALARY FROM"),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text("SALARY TO"),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text("ENGLISH REQUIRED"),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text("EXPERIENCE"),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text("GENDER"),
                    ),
                  ],
                )),
            Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    data.company_name != null
                        ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Text(data.company_name),
                          )
                        : SizedBox(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text(data.job_type),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text(data.qualification),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text(data.salary_period),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        data.salary_from,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        data.salary_to,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        data.english,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        data.experience != null ? data.experience : "-",
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        data.gender,
                      ),
                    ),
                  ],
                )),
          ],
        ),
        Divider(
          color: Colors.grey,
          thickness: .5,
        ),
      ],
    );
  }

  Widget mobileAndElectronicDetails(AdsDetail data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Details",
          style: TextStyle(
              color: appcolor, fontSize: 16, fontWeight: FontWeight.w600),
        ),
        SizedBox(
          height: 7,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text("BRAND"),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text("MODEL"),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text("REGISTER YEAR"),
                    ),
                  ],
                )),
            Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text(data.brand ?? "-"),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text(data.model ?? "-"),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text(data.purchased_year ?? "-"),
                    ),
                  ],
                )),
          ],
        ),
        Divider(
          color: Colors.grey,
          thickness: .5,
        ),
      ],
    );
  }

  Widget extraVehicleDetail(AdsDetail data) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 7),
      color: Colors.grey[100],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(data.vehicle_type + " : " + data.brand_name ?? ""),
          Divider(
            color: Colors.grey,
            thickness: .5,
          ),
          Row(
            children: [
              Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Icon(
                        Icons.ev_station_outlined,
                        size: 20,
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Flexible(child: Text(data.fuel_type ?? "-")),
                    ],
                  )),
              Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Icon(
                        Icons.speed,
                        size: 20,
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Flexible(child: Text(data.km_driven ?? "-")),
                    ],
                  )),
              Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Icon(
                        Icons.grain_outlined,
                        size: 20,
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Flexible(
                          child: Text(data.transmission != null
                              ? data.transmission
                              : "Manual")),
                    ],
                  )),
            ],
          ),
          Divider(
            color: Colors.grey,
            thickness: .5,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    flex: 1,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.person_add_outlined,
                          size: 18,
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        Flexible(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Owner",
                                style: TextStyle(
                                  fontSize: 11,
                                )),
                            Text(
                              data.no_of_owner ?? "-",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ],
                        )),
                      ],
                    )),
                Expanded(
                    flex: 1,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.card_giftcard_outlined,
                          size: 18,
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        Flexible(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("SELLER BY",
                                style: TextStyle(
                                  fontSize: 11,
                                )),
                            Text(
                              data.seller_by ?? "-",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ],
                        )),
                      ],
                    )),
                Expanded(
                    flex: 1,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.directions_car_outlined,
                          size: 18,
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        Flexible(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("INSURANCE",
                                style: TextStyle(
                                  fontSize: 11,
                                )),
                            Text(
                              data.insurance_valid ?? "-",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ],
                        )),
                      ],
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bussinessdetailPage(AsyncSnapshot<AdsDetail> snapshot) {
    // print("-----NK-----");
    List work_days = snapshot.data.working_days;
    // print(snapshot.data.working_days);
    String word = snapshot.data.id;
    savedwords.remove(word);
    if (snapshot.data.favorite_status == "1") {
      savedwords.add(word);
    }
    bool issaved = savedwords.contains(word);
    return Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      CarouselSlider.builder(
                          options: CarouselOptions(
                              height: 250,
                              viewportFraction: 1.0,
                              aspectRatio: 2.0,
                              autoPlay: false,
                              enableInfiniteScroll: false,
                              autoPlayInterval: Duration(seconds: 3),
                              autoPlayCurve: Curves.easeInCubic,
                              enlargeCenterPage: false,
                              reverse: false,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  _current = index;
                                  print("${_current}");
                                });
                              }),
                          itemCount: imageList.length,
                          itemBuilder: (context, index) {
                            return Builder(
                              builder: (BuildContext context) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      refresh();
                                    });
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                photoView()));
                                  },
                                  child: Container(
                                    height: 250,
                                    width: MediaQuery.of(context).size.width,
                                    // margin: EdgeInsets.symmetric(
                                    //     horizontal: 10.0),
                                    decoration: BoxDecoration(
                                      color: white,
                                      borderRadius: BorderRadius.circular(15),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            imageList[index].image_name),
                                        // fit: BoxFit.fill,
                                      ),
                                      // shape: BoxShape.rectangle,
                                    ),
                                  ),
                                );
                              },
                            );
                          }),
                      Container(
                        alignment: Alignment.topLeft,
                        height: 250,
                        // color:
                        //     const Color(0xBD0E3311).withOpacity(0.2),
                        child: FloatingActionButton(
                          mini: true,
                          backgroundColor: appcolor,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.arrow_back),
                        ),
                      ),
                      imageList.length == 1
                          ? SizedBox()
                          : Container(
                              alignment: Alignment.bottomCenter,
                              padding: EdgeInsets.all(10),
                              height: 250,
                              child: new DotsIndicator(
                                mainAxisAlignment: MainAxisAlignment.center,
                                dotsCount: imageList.length,
                                position: _current.toDouble(),
                                decorator: DotsDecorator(
                                  color: Colors.grey[200], // Inactive color
                                  activeColor: appcolor,
                                  spacing: const EdgeInsets.all(2.0),
                                  size: const Size.square(5.0),
                                  activeSize: const Size(16.0, 9.0),
                                  activeShape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0)),
                                ),
                              ),
                            ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          snapshot.data.ads_name,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: color2),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      GestureDetector(
                          child: issaved
                              ? Icon(
                                  Icons.favorite,
                                  color: Color(0xFFC43434),
                                  // size: 22,
                                )
                              : Icon(
                                  Icons.favorite_border,
                                  color: Color(0xFFC43434),
                                  // size: 22,
                                ),
                          onTap: () {
                            setState(() {
                              print(savedwords.contains(word));
                              if (issaved) {
                                snapshot.data.favorite_status = "0";
                                savedwords.remove(word);

                                delete_favorite(snapshot.data.id);
                              } else {
                                snapshot.data.favorite_status = "1";
                                savedwords.add(word);

                                save_favorite(snapshot.data.id);
                              }
                            });
                          }),
                    ],
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  Text(
                    snapshot.data.city_name,
                    style: TextStyle(
                        fontWeight: FontWeight.w500, color: Colors.grey[700]),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "COMPANY DETAILS",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: appcolor),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  // divider2(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    child: Row(
                      children: [
                        Icon(Icons.business),
                        SizedBox(
                          width: 15,
                        ),
                        Flexible(
                            child:
                                Text("Founder:  " + snapshot.data.owner_name)),
                      ],
                    ),
                  ),
                  divider2(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    child: Row(
                      children: [
                        Icon(Icons.flag_outlined),
                        SizedBox(
                          width: 15,
                        ),
                        Flexible(
                            child: Text(
                                "Founded:  " + snapshot.data.business_since)),
                      ],
                    ),
                  ),
                  divider2(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    child: Row(
                      children: [
                        Icon(Icons.map_outlined),
                        SizedBox(
                          width: 15,
                        ),
                        Flexible(
                            child: Text(snapshot.data.address1 +
                                "\n" +
                                // snapshot.data.address2 +
                                // "\n" +
                                "Pincode: " +
                                snapshot.data.pincode)),
                      ],
                    ),
                  ),
                  divider2(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    child: Row(
                      children: [
                        Icon(Icons.report_problem_outlined),
                        SizedBox(
                          width: 15,
                        ),
                        Flexible(child: Text("Hours and Services may differ")),
                      ],
                    ),
                  ),
                  divider2(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    child: Row(
                      children: [
                        Icon(Icons.access_time_outlined),
                        SizedBox(
                          width: 15,
                        ),
                        Flexible(
                            child: Text("Open: " +
                                "( " +
                                snapshot.data.working_hours_from +
                                " ) - " +
                                "Close: ( " +
                                snapshot.data.working_hours_to +
                                " )")),
                      ],
                    ),
                  ),
                  divider2(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    child: Row(
                      children: [
                        Icon(Icons.date_range_outlined),
                        SizedBox(
                          width: 15,
                        ),
                        Flexible(child: Text("Working Days: ")),
                        Wrap(
                          children: work_days
                              .map((e) => Container(
                                  margin: EdgeInsets.symmetric(horizontal: 2),
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(4)),
                                  child:
                                      Text(e, style: TextStyle(fontSize: 14))))
                              .toList(),
                        )
                      ],
                    ),
                  ),
                  divider2(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    child: Row(
                      children: [
                        Icon(Icons.sensor_door_outlined),
                        SizedBox(
                          width: 15,
                        ),
                        Text("Doorstep Services: "),
                        SizedBox(
                          width: 13,
                        ),
                        Flexible(
                            child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 7, vertical: 5),
                                decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(4)),
                                child: Text(
                                  snapshot.data.door_step == "0" ? "No" : "Yes",
                                ))),
                      ],
                    ),
                  ),
                  divider2(),
                  _bussinessCityName.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 7),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.merge_type_outlined),
                              SizedBox(
                                width: 15,
                              ),
                              Container(width: 60, child: Text("Branch: ")),
                              Flexible(
                                child: Wrap(
                                  children: _bussinessCityName
                                      .asMap()
                                      .entries
                                      .map((entry) {
                                    int index = entry.key;
                                    String val = entry.value;
                                    return Container(
                                      margin:
                                          EdgeInsets.only(right: 5, bottom: 7),
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          color: Colors.grey[100],
                                          borderRadius:
                                              BorderRadius.circular(4)),
                                      child: Text(
                                        val,
                                        style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey[700]),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                              // ),
                            ],
                          ),
                        )
                      : SizedBox(),
                  _bussinessCityName.isNotEmpty ? divider2() : SizedBox(),
                  SizedBox(
                    height: 5,
                  ),
                  // extraDetail(),
                  Text(
                    "ABOUT US",
                    style: TextStyle(color: appcolor, fontSize: 16),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(snapshot.data.ads_description),
                  SizedBox(
                    height: 10,
                  ),
                  divider2(),
                  Text(
                    "SERVICE DETAILS",
                    style: TextStyle(color: appcolor, fontSize: 16),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    snapshot.data.type_of_service != null
                        ? snapshot.data.type_of_service + '\n'
                        : "",
                  ),
                  profile(snapshot.data),
                  SizedBox(
                    height: 70,
                  ),
                ],
              )),
        ),
        Container(
          alignment: Alignment.bottomCenter,
          child: Container(
            color: Colors.grey[200],
            height: 60,
            child: Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 1,
                  child: InkWell(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 7.0),
                      child: Column(
                        children: [
                          Icon(
                            Icons.call,
                            // size: 22,
                            color: Colors.green[800],
                          ),
                          SizedBox(
                            height: 7,
                          ),
                          Text(
                            "Phone",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.green[800],
                            ),
                          )
                        ],
                      ),
                    ),
                    onTap: () {
                      launch("tel:" + snapshot.data.mobile_number);
                    },
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  flex: 1,
                  child: InkWell(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 7.0),
                      child: Column(
                        children: [
                          Icon(
                            Icons.mail,
                            // size: 22,
                            color: Colors.green[800],
                          ),
                          SizedBox(
                            height: 7,
                          ),
                          Text(
                            "Mail",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.green[800],
                            ),
                          )
                        ],
                      ),
                    ),
                    onTap: () {
                      launch("mailto:" + snapshot.data.email);
                    },
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                // poster_Id != user_ID
                //     ?
                Expanded(
                  flex: 1,
                  child: InkWell(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 7.0),
                      child: Column(
                        children: [
                          Icon(
                            Icons.chat_rounded,
                            // size: 22,
                            color: Colors.green[800],
                          ),
                          SizedBox(
                            height: 7,
                          ),
                          Text(
                            "Chat",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.green[800],
                            ),
                          )
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context, rootNavigator: true)
                          .push(MaterialPageRoute(
                              builder: (BuildContext context) => ChatScreen(
                                    adsId: adsID,
                                    // receiverID: receiverId,
                                    user_name: snapshot.data.first_name,
                                    sendID: userId,
                                    receiveID: receiverId,
                                  )));
                    },
                  ),
                ),
                // : SizedBox(),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  flex: 1,
                  child: InkWell(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 7.0),
                      child: Column(
                        children: [
                          Icon(
                            Icons.share,
                            // size: 22,
                            color: Colors.green[800],
                          ),
                          SizedBox(
                            height: 7,
                          ),
                          Text(
                            "Share",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.green[800],
                            ),
                          )
                        ],
                      ),
                    ),
                    onTap: () {
                      Share.share(snapshot.data.share_link);
                    },
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
