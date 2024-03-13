import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:services/Constant/Colors.dart';
import 'package:http/http.dart' as http;
import 'package:services/Constant/api.dart';
import 'package:services/Constant/app_version.dart';
import 'package:services/Model/Location_model.dart';
import 'package:services/Model/ads_list.dart';
import 'package:services/Screens/UpdateVersion.dart';
import 'dart:async';
import 'dart:convert';
import 'AdsListingPage.dart';
import 'CategoryPage.dart';
import 'NotificationPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'AdsDetail.dart';
import 'dart:ui';
import 'package:pull_to_refresh/pull_to_refresh.dart';

// import 'Posts/ListAdPost.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _searchData = new TextEditingController();
  final TextEditingController _location = new TextEditingController();

  String main_catergory = "";
  bool _isLoading = true;
  String cityName;

  List wordsL = [];
  List<String> savedwords = List<String>();
  String status;

  bool isloading = false;
  int page = 1;
  String currentVersion;
  String versionStatus;

  @override
  void initState() {
    super.initState();
    // category_list.addAll(category_list);
    // app_version();
    ads_list();
  }

  // updateStatus() async {
  //  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   if (sharedPreferences.getString("user_id") != null) {
  //     Navigator.of(context).pushAndRemoveUntil(
  //         MaterialPageRoute(builder: (BuildContext context) => BottomTab()),
  //         (Route<dynamic> route) => false);
  //   } else {
  //     Navigator.of(context).pushReplacement(
  //         MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
  //   }
  // }

  Future<Version> app_version() async {
    var response = await http.post(Uri.parse(app_api + '/version'));

    var jsonResponse;
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);

      currentVersion = jsonResponse['current_version'].toString();
      versionStatus = jsonResponse['update_status'];

      return Version.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load post');
    }
  }

  //  Future _loadData() async {
  //   // perform fetching data delay
  //   await new Future.delayed(new Duration(seconds: 2));
  //   // update data and loading status
  //   setState(() {
  //     page++;
  //      get_notificationData().then((value) {
  //       setState(() {
  //         notificationData.addAll(value);
  //       });
  //     });
  //   });
  // }

  void ads_list() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'main_category': "1",
      'page': page.toString(),
      'limit': limit,
      'category_id': "",
      'sub_category_id': "",
      'city_id': sharedPreferences.getString("city_ID") != null
          ? sharedPreferences.getString("city_ID")
          : "",
      'customer_id': sharedPreferences.getString("user_id"),
    };

    cityName = sharedPreferences.getString("city_Name");
    print(data);
    var jsonResponse;
    var response = await http.post(Uri.parse(app_api + '/ads'), body: data);

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

        print("____nandhu--------");
      }

      print('---------------NK-----------');
      print(json.decode(response.body));
    } else {
      _isLoading = false;
    }
  }

  List<AdsList> ads = List<AdsList>();

  Future<List<AdsList>> get_adsList(adsJson) async {
    var ads = List<AdsList>();
    for (var adJson in adsJson) {
      ads.add(AdsList.fromJson(adJson));
    }
    return ads;
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

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    setState(() {
      page = 1;
    });
    _refreshController.refreshCompleted();
    return ads_list();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    // allAPI();
    if (mounted)
      setState(() {
        page++;
        ads_list();
      });
    _refreshController.loadComplete();
  }

  Widget list(Location location) {
    return SingleChildScrollView(
      child: ListTile(
        title: Text(location.city_name),
        // subtitle: Text(location.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: appcolor,
        automaticallyImplyLeading: false,
        title: Row(
          //  crossAxisAlignment: CrossAxisAlignment.center,
          //  mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/logo-black.png",
              height: 40,
              width: 120,
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          // IconButton(
          //     icon: Icon(Icons.business),
          //     onPressed: () {
          //       Navigator.of(context, rootNavigator: true)
          //           .push(CupertinoPageRoute(builder: (_) => ListOfPosts()));
          //     }),
          Stack(
            children: [
              IconButton(
                  icon: Icon(Icons.notifications),
                  onPressed: () {
                    //  Navigator.of(context, rootNavigator: true).push(
                    //   MaterialPageRoute(
                    //   builder: (BuildContext context) => NotificationPage() ));
                    Navigator.of(context, rootNavigator: true).push(
                      PageRouteBuilder(
                        pageBuilder: (c, a1, a2) => NotificationPage(),
                        transitionsBuilder: (c, anim, a2, child) =>
                            FadeTransition(opacity: anim, child: child),
                        transitionDuration: Duration(milliseconds: 1000),
                      ),
                    );
                  }),
            ],
          ),

          //  IconButton(icon: Icon(Icons.update),
          //      onPressed: (){
          //        Navigator.of(context, rootNavigator: true).push(
          //         MaterialPageRoute(
          //         builder: (BuildContext context) => UpdateVersion() ));
          //      }),
        ],
      ),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: WaterDropMaterialHeader(
          color: white,
          backgroundColor: appcolor,
        ),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: CustomScrollView(slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                //  mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  GestureDetector(
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: appcolor,
                          size: 22,
                        ),
                        Text(cityName != null ? cityName : "All India"),
                        Icon(
                          Icons.arrow_drop_down_outlined,
                          color: appcolor,
                          size: 24,
                        ),
                      ],
                    ),
                    onTap: () {
                      _showLocation();
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 45,
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                        color: Colors.grey[300],
                        blurRadius: 5.0,
                        spreadRadius: 3.0,
                      ),
                    ]),
                    child: TextField(
                      readOnly: true,
                      onTap: () {
                        Navigator.of(context, rootNavigator: true).push(
                          PageRouteBuilder(
                            pageBuilder: (c, a1, a2) => AdsListingPage(),
                            transitionsBuilder: (c, anim, a2, child) =>
                                FadeTransition(opacity: anim, child: child),
                            transitionDuration: Duration(milliseconds: 100),
                          ),
                        );
                      },
                      // onSubmitted: (value) {
                      //   _searchData.text.isEmpty
                      //       ? null
                      //       : Navigator.of(context, rootNavigator: true).push(
                      //           MaterialPageRoute(
                      //               builder: (context) => AdsListingPage(
                      //                   seachData: _searchData.text)));
                      // },
                      controller: _searchData,
                      style: new TextStyle(
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                            icon: Icon(
                              Icons.search_sharp,
                              color: Colors.grey,
                            ),
                            splashRadius: 25,
                            splashColor: appcolor,
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true).push(
                                PageRouteBuilder(
                                  pageBuilder: (c, a1, a2) => AdsListingPage(),
                                  transitionsBuilder: (c, anim, a2, child) =>
                                      FadeTransition(
                                          opacity: anim, child: child),
                                  transitionDuration:
                                      Duration(milliseconds: 100),
                                ),
                              );
                              // _searchData.text.isEmpty
                              //     ? null
                              //     : Navigator.of(context, rootNavigator: true)
                              //         .push(MaterialPageRoute(
                              //             builder: (context) => AdsListingPage(
                              //                 seachData: _searchData.text)));
                            }),
                        fillColor: white,
                        filled: true,
                        contentPadding:
                            EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                        hintText: ("Search..."),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 16.0,
                        ),
                        border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: white, width: 1.0),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        focusedErrorBorder: new OutlineInputBorder(
                          borderSide: BorderSide(color: white, width: 1.0),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        errorBorder: new OutlineInputBorder(
                          borderSide:
                              new BorderSide(color: appcolor, width: 1.5),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: white, width: 1.0),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: white, width: 1.0),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Text(
                        "Our Services",
                        style: TextStyle(color: black, fontSize: 18),
                      ),
                      //  Spacer(),
                      //  Text("View all", style: TextStyle( color: appcolor, fontSize: 12),),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(flex: 1, child: category()),
                      Expanded(flex: 1, child: category2()),
                      Expanded(flex: 1, child: category3()),
                      Expanded(flex: 1, child: category4()),
                    ],
                  ),
                  Text(
                    "Ads",
                    style: TextStyle(color: black, fontSize: 18),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
          ads.length != 0
              ? SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      final item = ads[index];
                      itemCount:
                      ads.length;
                      if (index > ads.length) return null;
                      return trendingList(ads[index]);
                    },
                    childCount: ads.length,
                  ),
                )
              : _isLoading == true
                  ? SliverToBoxAdapter(
                      child: Container(
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          backgroundColor: appcolor,
                          valueColor: new AlwaysStoppedAnimation<Color>(white),
                        ),
                      ),
                    )
                  : SliverToBoxAdapter(
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          "No data found...",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
        ]),
      ),
    );
  }

  Widget category() {
    // return  ListView.builder(
    //             itemBuilder: (BuildContext context, int index) {
    return Padding(
      padding: EdgeInsets.only(
        top: 15,
        bottom: 15,
      ),
      child: GestureDetector(
        onTap: () {
          // setState(() {
          //   main_catergory = "1";
          // });
          Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
              builder: (BuildContext context) => CategoryPage(
                  main_catergory: "1", title: "Repairs & Servicing")));
        },
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(13),
              height: 70,
              width: 75,
              decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(23)),
              child: Image.asset(
                "assets/images/services.png",
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              'Repairs & Servicing',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(color: black, fontSize: 12),
            )
          ],
        ),
      ),
    );
    //    },
    //    itemCount: category_list == null ? 0 : category_list.length,
    // );
  }

  Widget category2() {
    return Padding(
      padding: EdgeInsets.only(
        top: 15,
        bottom: 15,
      ),
      child: GestureDetector(
        onTap: () {
          setState(() {
            main_catergory = "2";
          });
          Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
              builder: (BuildContext context) =>
                  CategoryPage(main_catergory: "2", title: "Business")));
        },
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(13),
              height: 70,
              width: 75,
              decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(23)),
              child: Image.asset(
                "assets/images/business.png",
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              'Business',
              style: TextStyle(color: black, fontSize: 12),
            )
          ],
        ),
      ),
    );
  }

  Widget category3() {
    return Padding(
      padding: EdgeInsets.only(
        top: 15,
        bottom: 15,
      ),
      child: GestureDetector(
        onTap: () {
          setState(() {
            main_catergory = "3";
          });
          Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
              builder: (BuildContext context) =>
                  CategoryPage(main_catergory: "3", title: "Buy")));
        },
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(13),
              height: 70,
              width: 75,
              decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(23)),
              child: Image.asset(
                "assets/images/buy.png",
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              'Buy',
              style: TextStyle(color: black, fontSize: 12),
            )
          ],
        ),
      ),
    );
  }

  Widget category4() {
    return Padding(
      padding: EdgeInsets.only(
        top: 15,
        bottom: 15,
      ),
      child: GestureDetector(
        onTap: () {
          setState(() {
            main_catergory = "4";
          });
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => AdsListingPage(
                        categoryID: "10",
                        title: "Jobs",
                      )));
        },
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(13),
              height: 70,
              width: 75,
              decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(23)),
              child: Image.asset(
                "assets/images/jobs.png",
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              'Jobs',
              style: TextStyle(color: black, fontSize: 12),
            )
          ],
        ),
      ),
    );
  }

  Widget trendingList(AdsList ad) {
    String word = ad.id;
    savedwords.remove(word);
    if (ad.favorite_status == "1") {
      savedwords.add(word);
    }
    bool issaved = savedwords.contains(word);

    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context, rootNavigator: true).push(
            CupertinoPageRoute<bool>(
              fullscreenDialog: true,
              builder: (BuildContext context) => AdsDetailPage(ads_id: ad.id),
            ),
          );
        },
        child: Card(
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
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
                      image: NetworkImage(ad.ads_image), fit: BoxFit.contain),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      ad.ads_name,
                      textAlign: TextAlign.start,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 18,
                          color: black,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      ad.service_type == "1"
                          ? "Repairs & Services"
                          : ad.service_type == "2"
                              ? "Business"
                              : "",
                      textAlign: TextAlign.start,
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                    // SizedBox(
                    //   height: 2,
                    // ),
                    ad.service_type == "3"
                        ? Text(
                            ad.ads_price != null ? ad.ads_price : "",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 16,
                                color: black,
                                fontWeight: FontWeight.w600),
                          )
                        : SizedBox(
                            height: 0,
                          ),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: appcolor,
                          size: 22,
                        ),
                        Text(
                          ad.city_name != null ? ad.city_name : "",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 14,
                              color: appcolor,
                              fontWeight: FontWeight.w500),
                        ),
                        Spacer(),
                        IconButton(
                            padding: EdgeInsets.all(0),
                            splashRadius: 15,
                            iconSize: 22,
                            icon: issaved
                                ? Icon(
                                    Icons.favorite,
                                    color: Color(0xFFC43434),
                                  )
                                : Icon(
                                    Icons.favorite_border,
                                    color: Color(0xFFC43434),
                                  ),
                            onPressed: () {
                              setState(() {
                                print(savedwords.contains(word));
                                if (issaved) {
                                  ad.favorite_status = "0";
                                  savedwords.remove(word);

                                  delete_favorite(ad.id);
                                } else {
                                  ad.favorite_status = "1";
                                  savedwords.add(word);

                                  save_favorite(ad.id);
                                }
                              });
                            }),
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
  }

  void _showLocation() {
    Future<void> future = showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SafeArea(
          child: Container(
            padding: EdgeInsets.fromLTRB(20, 100, 20, 20),
            height: MediaQuery.of(context).size.height,
            color: white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Search Your Location",
                  style: TextStyle(
                    fontSize: 16.0,
                    color: appcolor,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 45,
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                      color: Colors.grey[200],
                      blurRadius: 5.0,
                      spreadRadius: 3.0,
                    ),
                  ]),
                  child: TypeAheadField(
                    textFieldConfiguration: TextFieldConfiguration(
                        autofocus: true,
                        controller: _location,
                        decoration: textDecoration2("Search Location")),
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
                        _location.text = item.city_name;
                        cityName = item.city_name;

                        sharedPreferences.setString(
                            "city_Name", item.city_name);
                        sharedPreferences.setString("city_ID", item.id);
                      });
                      Navigator.pop(context);
                      ads_list();
                      page = 1;
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
    future.then((void value) => _closeModal(value));
  }

  void _closeModal(void value) {
    print('modal closed');
    // Navigator.pop(context);
  }
}
