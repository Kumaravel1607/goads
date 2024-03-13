import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:services/Constant/Colors.dart';
import 'package:http/http.dart' as http;
import 'package:services/Constant/api.dart';
import 'package:services/Model/ads_list.dart';
import 'dart:async';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'dart:convert';
import 'package:services/Screens/AdsDetail.dart';
import 'package:flutter/cupertino.dart';

class FavoritePage extends StatefulWidget {
  FavoritePage({Key key}) : super(key: key);

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  bool _isLoading = true;

  List wordsL = [];
  List<String> savedwords = List<String>();
  String status;

  @override
  void initState() {
    super.initState();
    fav_list();
  }

  int page = 1;

  void fav_list() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'customer_id': sharedPreferences.getString("user_id"),
      'page': page.toString(),
      'limit': limit,
    };
    print(data);
    var jsonResponse;
    var response =
        await http.post(Uri.parse(app_api + '/my_favroite'), body: data);

    if (response.statusCode == 200) {
      setState(() {
        _isLoading = false;
      });
      print(json.decode(response.body));

      if (page == 1) {
        get_adsList(json.decode(response.body)).then((value) {
          setState(() {
            favList = value;
          });
        });
      } else {
        get_adsList(json.decode(response.body)).then((value) {
          setState(() {
            favList.addAll(value);
          });
        });

        print("____nandhu--------");
      }
      // get_adsList(json.decode(response.body)).then((value) {
      //   setState(() {
      //     favList = value;
      //   });
      // });
      // print('---------------NK-----------');
      // print(json.decode(response.body));
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<AdsList> favList = List<AdsList>();

  Future<List<AdsList>> get_adsList(adsJson) async {
    var favList = List<AdsList>();
    for (var adJson in adsJson) {
      favList.add(AdsList.fromJson(adJson));
    }
    return favList;
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
    } else {
      setState(() {
        _isLoading = false;
      });
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
    // _refreshController.refreshCompleted();
    _refreshController.refreshToIdle();
    fav_list();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    // allAPI();
    if (mounted)
      setState(() {
        page++;
        fav_list();
      });
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appcolor,
        title: Text(
          "My Favorites",
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
        child: Padding(
          padding: EdgeInsets.all(13),
          child: favList.length != 0
              ? Container(
                  child: ListView.builder(
                      shrinkWrap: false,
                      scrollDirection: Axis.vertical,
                      itemCount: favList.length,
                      itemBuilder: (context, index) {
                        //  return favoriteList(favList[index]);
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context, rootNavigator: true).push(
                              CupertinoPageRoute<bool>(
                                fullscreenDialog: true,
                                builder: (BuildContext context) =>
                                    AdsDetailPage(ads_id: favList[index].id),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 5.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  height: 200,
                                  // width: 250,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFf8f8f8),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10.0),
                                      topRight: Radius.circular(10.0),
                                      bottomLeft: Radius.circular(10.0),
                                      bottomRight: Radius.circular(10.0),
                                    ),
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            favList[index].ads_image),
                                        fit: BoxFit.contain),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 10, bottom: 10, left: 0, right: 5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      favList[index].service_type == "3"
                                          ? Text(
                                              favList[index].ads_price != null
                                                  ? favList[index].ads_price
                                                  : "",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: black,
                                                  fontWeight: FontWeight.w600),
                                            )
                                          : SizedBox(
                                              height: 2,
                                            ),
                                      Text(
                                        favList[index].ads_name != null
                                            ? "  " + favList[index].ads_name
                                            : "",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: black,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 3,
                                          ),
                                          Icon(
                                            Icons.location_on,
                                            color: appcolor,
                                            size: 20,
                                          ),
                                          Text(
                                            favList[index].city_name != null
                                                ? favList[index].city_name
                                                : "",
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: appcolor,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Spacer(),
                                          IconButton(
                                              icon: Icon(
                                                Icons.favorite,
                                                size: 20,
                                                color: Colors.red,
                                              ),
                                              onPressed: () {
                                                delete_favorite(
                                                    favList[index].id);
                                                setState(() {
                                                  favList.removeAt(index);
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
                        );
                      }),
                )
              : _isLoading == true
                  ? Container(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        backgroundColor: appcolor,
                        valueColor: new AlwaysStoppedAnimation<Color>(white),
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
    );
  }

  // Widget favoriteList(AdsList favList){
  //   return GestureDetector(
  //     onTap: (){
  //     // Navigator.push(
  //     //   context,
  //     //   MaterialPageRoute(
  //     //       builder: (BuildContext context) => newPage() ));
  //     },
  //     child: Card(
  //     elevation: 5.0,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(10.0),
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //           mainAxisAlignment: MainAxisAlignment.start,
  //       children: [
  //         Container(
  //            height: 200,
  //             // width: 250,
  //             decoration: BoxDecoration(
  //               color: appcolor,
  //               borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0),bottomLeft: Radius.circular(10.0),bottomRight: Radius.circular(10.0),),
  //               image: DecorationImage(
  //                   image: NetworkImage(favList.ads_image),
  //                   fit: BoxFit.fill),
  //             ),
  //         ),
  //         Padding(padding: EdgeInsets.only(top:10, bottom: 10, left: 0, right: 5),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           mainAxisAlignment: MainAxisAlignment.start,
  //           children: [
  //            favList.service_type == "3" ? Text(favList.ads_price != null ? favList.ads_price : "",textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: black,fontWeight: FontWeight.w600),)
  //               : SizedBox(height: 2,),
  //             Text("  "+favList.ads_name,textAlign: TextAlign.start, style: TextStyle(fontSize: 18, color: black,fontWeight: FontWeight.w600),),

  //             SizedBox(height: 5,),
  //             Row(
  //               children: [
  //                 SizedBox(width: 3,),
  //                 Icon(Icons.location_on, color: appcolor, size: 20,),
  //                 Text(favList.city_name != null ? favList.city_name : "",textAlign: TextAlign.start, style: TextStyle(fontSize: 14, color: appcolor,fontWeight: FontWeight.w500),),
  //                 Spacer(),
  //                 IconButton(icon: Icon(Icons.favorite, size: 20, color: Colors.red,),
  //                  onPressed: (){
  //                    delete_favorite(favList.id);
  //                                       setState(() {
  //                                         favList.removeAt(favList);
  //                                       });
  //                  })

  //               ],
  //             )
  //           ],
  //         ),
  //         )
  //       ],
  //     ),
  //     ),
  //   );
  // }

}
