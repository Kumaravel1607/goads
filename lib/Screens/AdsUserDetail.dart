import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:services/Constant/Colors.dart';
import 'package:services/Constant/api.dart';
import 'package:services/Model/userADs_list.dart';
import 'LoginPage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:services/Screens/AdsDetail.dart';

class AdsUserProfilePage extends StatefulWidget {
  final String aduserID;
  final String aduserImage;
  final String aduserName;
  final String aduserJoin;
  AdsUserProfilePage(
      {Key key,
      this.aduserID,
      this.aduserImage,
      this.aduserName,
      this.aduserJoin})
      : super(key: key);

  @override
  _AdsUserProfilePageState createState() => _AdsUserProfilePageState();
}

class _AdsUserProfilePageState extends State<AdsUserProfilePage> {
  String image;
  String name;

  @override
  void initState() {
    super.initState();
    myADs_list();
  }

  bool _isLoading = true;
  int page = 1;

  void myADs_list() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'customer_id': widget.aduserID,
      'page': page.toString(),
      'limit': limit,
      'active': "1"
    };
    print(data);
    var jsonResponse;
    var response =
        await http.post(Uri.parse(app_api + '/user_ads'), body: data);

    if (response.statusCode == 200) {
      setState(() {
        _isLoading = false;
      });

      if (page == 1) {
        get_adsList(json.decode(response.body)).then((value) {
          setState(() {
            ads = value;
          });
        });
      } else {
        get_adsList(json.decode(response.body)).then((value) {
          setState(() {
            ads.addAll(value);
          });
        });
      }

      // get_adsList(json.decode(response.body)).then((value) {
      //   setState(() {
      //     ads = value;
      //   });
      // });

      print('---------------NK-----------');
      print(json.decode(response.body));
    } else {
      _isLoading = false;
    }
  }

  List<UserAdsList> ads = List<UserAdsList>();

  Future<List<UserAdsList>> get_adsList(adsJson) async {
    var ads = List<UserAdsList>();
    for (var adJson in adsJson) {
      ads.add(UserAdsList.fromJson(adJson));
    }
    return ads;
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    setState(() {
      page = 1;
    });
    // _refreshController.refreshCompleted();
    _refreshController.refreshToIdle();
    myADs_list();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    // allAPI();
    if (mounted)
      setState(() {
        page++;
        myADs_list();
      });
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      //  appBar: AppBar(
      //    backgroundColor: appcolor,
      //    title: Text("ads user profile", style: TextStyle( color: white,),),
      //    centerTitle: true,
      //  ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  child: FloatingActionButton(
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
                ),
                // SizedBox(height: 5,),
                CircleAvatar(
                  radius: 38,
                  backgroundColor: appcolor,
                  child: CircleAvatar(
                    backgroundColor: white,
                    radius: 35,
                    backgroundImage: NetworkImage(widget.aduserImage),
                  ),
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  widget.aduserName,
                  style: TextStyle(
                      color: black, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Member Since " + widget.aduserJoin,
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                SizedBox(
                  height: 5,
                ),
                divider(),
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(left: 15),
                  child: Text(
                    "Published ads",
                    style: TextStyle(
                        color: black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(
                  height: 3,
                ),
                Expanded(
                  child: SmartRefresher(
                    enablePullDown: true,
                    enablePullUp: true,
                    header: WaterDropHeader(),
                    controller: _refreshController,
                    onRefresh: _onRefresh,
                    onLoading: _onLoading,
                    child: ads.length != 0
                        ? new ListView.builder(
                            shrinkWrap: false,
                            scrollDirection: Axis.vertical,
                            itemCount: ads.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 0, 15, 15),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context, rootNavigator: true)
                                        .push(
                                      CupertinoPageRoute<bool>(
                                        fullscreenDialog: true,
                                        builder: (BuildContext context) =>
                                            AdsDetailPage(
                                                ads_id: ads[index].id),
                                      ),
                                    );
                                  },
                                  child: Card(
                                    elevation: 5.0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(7.0),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 170,
                                          // width: 250,
                                          decoration: BoxDecoration(
                                            color: Color(0xFFf8f8f8),
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(7.0),
                                              topRight: Radius.circular(7.0),
                                            ),
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    ads[index].ads_image),
                                                fit: BoxFit.contain),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                ads[index].ads_name,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: black,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              SizedBox(
                                                height: 2,
                                              ),
                                              ads[index].service_type == "3"
                                                  ? Text(
                                                      ads[index].ads_price !=
                                                              null
                                                          ? ads[index].ads_price
                                                          : "",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: black,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    )
                                                  : SizedBox(
                                                      height: 2,
                                                    ),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.location_on,
                                                    color: appcolor,
                                                    size: 22,
                                                  ),
                                                  Text(
                                                    ads[index].city_name != null
                                                        ? ads[index].city_name
                                                        : "",
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: appcolor,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  // Spacer(),
                                                  // IconButton(
                                                  //   padding: EdgeInsets.all(0),
                                                  //   splashRadius: 15,
                                                  //   iconSize: 22,
                                                  //   icon: issaved
                                                  //       ? Icon(
                                                  //           Icons.favorite,
                                                  //           color: Color(0xFFC43434),
                                                  //         )
                                                  //       : Icon(
                                                  //           Icons.favorite_border,
                                                  //           color: Color(0xFFC43434),
                                                  //         ),
                                                  //   onPressed: () {
                                                  //     setState(() {
                                                  //       print(savedwords
                                                  //           .contains(word));
                                                  //       if (issaved) {
                                                  //         ad.favorite_status = "0";
                                                  //         savedwords
                                                  //             .remove(word);

                                                  //         delete_favorite(
                                                  //             ad.id);
                                                  //       } else {
                                                  //         ad.favorite_status = "1";
                                                  //         savedwords.add(word);

                                                  //         save_favorite(
                                                  //             ad.id);
                                                  //       }
                                                  //     });
                                                  //   }),
                                                ],
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            })
                        : _isLoading == true
                            ? Container(
                                alignment: Alignment.center,
                                child: CircularProgressIndicator(
                                  backgroundColor: appcolor,
                                  valueColor:
                                      new AlwaysStoppedAnimation<Color>(white),
                                ),
                              )
                            : Container(
                                alignment: Alignment.center,
                                child: Text(
                                  "No data found...",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                  ),
                ),
              ]),
          //  ),
        ),
      ),
    );
  }
}
