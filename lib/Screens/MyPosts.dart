import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:services/Constant/Colors.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:services/Constant/api.dart';
import 'package:services/Screens/AdsDetail.dart';
import 'package:services/Screens/Edit_BussinessPost/Screen_1.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:services/Model/userADs_list.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'EditPost.dart';

class MyPosts extends StatefulWidget {
  MyPosts({Key key}) : super(key: key);

  @override
  _MyPostsState createState() => _MyPostsState();
}

class _MyPostsState extends State<MyPosts>
    with AutomaticKeepAliveClientMixin<MyPosts> {
  @override
  void initState() {
    super.initState();
    myADs_list();
  }

  @override
  bool get wantKeepAlive => true;

  bool _isLoading = true;
  int page = 1;

  void myADs_list() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'customer_id': sharedPreferences.getString("user_id"),
      'page': page.toString(),
      'limit': limit,
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

  delete_post(adID) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'customer_id': sharedPreferences.getString("user_id"),
      'ads_id': adID,
    };
    print(data);
    var jsonResponse;
    var response =
        await http.post(Uri.parse(app_api + '/destroy_ads'), body: data);
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
      appBar: AppBar(
        backgroundColor: appcolor,
        title: Text(
          "My Posts",
          style: TextStyle(
            color: white,
          ),
        ),
        centerTitle: true,
        //  leading: IconButton(icon: Icon(Icons.arrow_back),
        //   onPressed: (){
        //     Navigator.pop(context);
        //   }),
      ),
      body: SmartRefresher(
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
                    padding: EdgeInsets.all(10),
                    child: Card(
                      elevation: 5,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(10, 5, 10, 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 30,
                              child: Text(
                                "Posted on: " + ads[index].posted_at,
                                style: TextStyle(color: appcolor, fontSize: 12),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                    flex: 3,
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 5),
                                      child: Container(
                                        height: 120,
                                        decoration: BoxDecoration(
                                            color: Color(0xFFFFFFFF),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    ads[index].ads_image),
                                                fit: BoxFit.contain)),
                                      ),
                                    )),
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                    flex: 5,
                                    child: Container(
                                      color: white,
                                      height: 130,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .push(
                                                CupertinoPageRoute<bool>(
                                                  fullscreenDialog: true,
                                                  builder:
                                                      (BuildContext context) =>
                                                          AdsDetailPage(
                                                              ads_id: ads[index]
                                                                  .id),
                                                ),
                                              );
                                            },
                                            child: Text(
                                              ads[index].ads_name,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  color: black, fontSize: 16),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            ads[index].city_name != null
                                                ? ads[index].city_name
                                                : "",
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: appcolor, fontSize: 12),
                                          ),
                                          SizedBox(
                                            height: 7,
                                          ),
                                          Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  15, 3, 15, 3),
                                              decoration: BoxDecoration(
                                                color: Colors.grey[200],
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: Text(
                                                ads[index].ads_status == "0"
                                                    ? "Pending"
                                                    : ads[index].ads_status ==
                                                            "1"
                                                        ? "Active"
                                                        : "Deactivated",
                                                style: TextStyle(fontSize: 12),
                                              )),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              GestureDetector(
                                                  onTap: () {
                                                    ads[index].service_type ==
                                                            "3"
                                                        ? Navigator.of(context,
                                                                rootNavigator:
                                                                    true)
                                                            .push(
                                                                MaterialPageRoute(
                                                                    builder: (BuildContext
                                                                            context) =>
                                                                        EditPostsPage(
                                                                          id: ads[index]
                                                                              .id,
                                                                          title:
                                                                              ads[index].ads_name,
                                                                        )))
                                                        : Navigator.of(context,
                                                                rootNavigator:
                                                                    true)
                                                            .push(
                                                                MaterialPageRoute(
                                                                    builder: (BuildContext
                                                                            context) =>
                                                                        Edit_Screen_1(
                                                                          id: ads[index]
                                                                              .id,
                                                                          title:
                                                                              ads[index].ads_name,
                                                                        )));
                                                  },
                                                  child: Container(
                                                    height: 30,
                                                    width: 30,
                                                    padding: EdgeInsets.all(0),
                                                    child: Icon(
                                                      Icons.edit_outlined,
                                                      size: 16,
                                                      color: white,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: appcolor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                  )),
                                              SizedBox(
                                                width: 30,
                                              ),
                                              GestureDetector(
                                                  onTap: () async {
                                                    await showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            content: Text(
                                                                "Confirm to delete"),
                                                            //title: Text(),
                                                            actions: <Widget>[
                                                              FlatButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context,
                                                                      "ok");
                                                                },
                                                                child:
                                                                    const Text(
                                                                        "No"),
                                                              ),
                                                              FlatButton(
                                                                onPressed: () {
                                                                  // print("Nandhu");
                                                                  delete_post(
                                                                      ads[index]
                                                                          .id);
                                                                  setState(() {
                                                                    ads.removeAt(
                                                                        index);
                                                                  });
                                                                  Navigator.pop(
                                                                      context,
                                                                      "ok");
                                                                },
                                                                child:
                                                                    const Text(
                                                                        "Yes"),
                                                              ),
                                                            ],
                                                          );
                                                        });
                                                  },
                                                  child: Container(
                                                    height: 30,
                                                    width: 30,
                                                    padding: EdgeInsets.all(0),
                                                    child: Icon(
                                                      Icons.delete_rounded,
                                                      size: 16,
                                                      color: white,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: appcolor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                  )),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )),
                              ],
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
    );
  }

// Widget myAds(UserAdsList ad){
//   return Card(
//     elevation: 5,
//     child:Padding(padding: EdgeInsets.fromLTRB(10,3,10,10),
//     child: Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           height: 25,
//           child: Text("Posted at: " + ad.created_at,style: TextStyle(color: appcolor),),
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Expanded(
//               flex: 3,
//               child: Padding(padding: EdgeInsets.only(right:5),
//               child:Container(

//                 height: 100,
//                 decoration: BoxDecoration(
//                   color: appcolor,
//                   borderRadius: BorderRadius.circular(5),
//                   image: DecorationImage(
//                     image: NetworkImage(ad.ads_image),
//                     fit: BoxFit.cover
//                   )
//                 ),
//               ),
//               )),
//               Expanded(
//               flex: 5,
//               child: Container(
//                 color: white,
//                 height: 100,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(ad.ads_name, textAlign: TextAlign.start, style: TextStyle(color: black),),
//                     Text(ad.city_name != null ? ad.city_name : "",style: TextStyle(color: appcolor, fontSize: 12),),
//                     Container(
//                       padding: EdgeInsets.fromLTRB(13, 2, 13, 2),
//                       decoration: BoxDecoration(
//                       color: Colors.grey[300],
//                         borderRadius: BorderRadius.circular(14),
//                       ),
//                       child: Text(ad.ads_status == "0" ? "Pending" : ad.ads_status == "1" ? "Active" : "Deactivated", style: TextStyle(fontSize: 12),)),

//                      SizedBox(height: 10,),
//                      Row(children: [

//                      GestureDetector(
//                        onTap: (){
//                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => EditPostsPage(id:ad.id)));
//                         },
//                        child: Container(
//                         height: 25,
//                         width: 25,
//                         padding: EdgeInsets.all(0),
//                         child: Icon(Icons.edit_outlined, size: 16, color: white,),
//                         decoration: BoxDecoration(
//                           color: appcolor,
//                           borderRadius: BorderRadius.circular(13),
//                         ),
//                       )
//                      ),
//                      SizedBox(width: 10,),
//                      GestureDetector(
//                        onTap: (){
//                          delete_post(ad.id);
//                          setState(() {
//                             ads.removeAt(ad);
//                           });
//                           //  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => EditPostsPage(id:ad.id)));
//                         },
//                        child: Container(
//                         height: 25,
//                         width: 25,
//                         padding: EdgeInsets.all(0),
//                         child: Icon(Icons.delete_rounded, size: 16, color: white,),
//                         decoration: BoxDecoration(
//                           color: appcolor,
//                           borderRadius: BorderRadius.circular(13),
//                         ),
//                       )
//                      ),
//                     ],),

//                   ],
//                 ),
//               )),

//           ],
//         )
//       ],
//     ),
//     ),
//   );
// }

}
