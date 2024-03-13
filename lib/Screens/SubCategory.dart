import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:services/Constant/Colors.dart';
import 'package:http/http.dart' as http;
import 'package:services/Constant/api.dart';
import 'package:services/Model/category_model.dart';
import 'package:services/Screens/Posts/BikePost.dart';
import 'package:services/Screens/Posts/CarPost.dart';
import 'package:services/Screens/Posts/JobPost.dart';
import 'package:services/Screens/Posts/Lands&PlotPost.dart';
import 'package:services/Screens/Posts/Office&ShopRentSell.dart';
import 'package:services/Screens/Posts/PG&GuestHouse.dart';
import 'package:services/Screens/Posts/PropertyPost.dart';
import 'package:services/Screens/Posts/Repaires&Services.dart';
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'AddPost.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'AdsListingPage.dart';

class SubCategoryPage extends StatefulWidget {
  final String categoryID;
  final String addpost;
  final String mainCategory;
  final String categoryName;
  final String title;
  SubCategoryPage(
      {Key key,
      this.categoryID,
      this.addpost,
      this.mainCategory,
      this.categoryName,
      this.title})
      : super(key: key);

  @override
  _SubCategoryPageState createState() => _SubCategoryPageState();
}

class _SubCategoryPageState extends State<SubCategoryPage> {
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    subcategory_list();
  }

  void subcategory_list() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'category_id': widget.categoryID,
    };
    var jsonResponse;
    var response = await http.post(
        Uri.parse('https://hashref.org/service/api/subcategory'),
        body: data);
    print("https://hashref.org/service/api/subcategory");

    if (response.statusCode == 200) {
      setState(() {
        _isLoading = false;
      });
      get_subcategoryList(json.decode(response.body)).then((value) {
        setState(() {
          subcategoryList = value;
        });
      });
      print('---------------NK-----------');
      print(json.decode(response.body));
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<SubCategoryList> subcategoryList = List<SubCategoryList>();

  Future<List<SubCategoryList>> get_subcategoryList(subcategorysJson) async {
    var subcategorys = List<SubCategoryList>();
    for (var subcategoryJson in subcategorysJson) {
      subcategorys.add(SubCategoryList.fromJson(subcategoryJson));
    }
    return subcategorys;
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()

    // _refreshController.refreshCompleted();
    _refreshController.refreshToIdle();
    subcategory_list();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    // allAPI();
    // if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: appcolor,
        title: Text(
          widget.title != null ? widget.title : "Choose a Sub Category",
          style: TextStyle(color: white),
        ),
        centerTitle: true,
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
        //  actions: [
        //    Stack(
        //      children: [
        //        IconButton(icon: Icon(Icons.notifications), onPressed: (){}),

        //      ],
        //    ),
        //  ],
      ),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: WaterDropHeader(),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: subcategoryList.length != 0
            ? new ListView.builder(
                shrinkWrap: false,
                scrollDirection: Axis.vertical,
                itemCount: subcategoryList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          title: Text(
                            subcategoryList[index].sub_category_name,
                            style: TextStyle(
                                fontSize: 16,
                                color: black,
                                fontWeight: FontWeight.w500),
                          ),
                          // leading: Image.network(subcategoryList[index].category_image, height: 35, width: 35,),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey[400],
                            size: 20,
                          ),
                          onTap: () {
                            if (widget.addpost == "1") {
                              // if (subcategoryList[index].sub_category_type ==
                              //     "cars") {
                              //   Navigator.of(context, rootNavigator: true)
                              //       .pushReplacement(CupertinoPageRoute(
                              //           builder: (_) => CarPost(
                              //               subcat_type: subcategoryList[index]
                              //                   .sub_category_type,
                              //               cat_id:
                              //                   widget.categoryID.toString(),
                              //               subcat_id: subcategoryList[index]
                              //                   .id
                              //                   .toString())));
                              // } else if (subcategoryList[index]
                              //         .sub_category_type ==
                              //     "bike") {
                              //   Navigator.of(context, rootNavigator: true)
                              //       .pushReplacement(CupertinoPageRoute(
                              //           builder: (_) => BikePost(
                              //               subcat_type: subcategoryList[index]
                              //                   .sub_category_type,
                              //               cat_id:
                              //                   widget.categoryID.toString(),
                              //               subcat_id: subcategoryList[index]
                              //                   .id
                              //                   .toString())));
                              //   // }
                              //   //  else if (subcategoryList[index]
                              //   //             .sub_category_type ==
                              //   //         "sale-property" ||
                              //   //     subcategoryList[index].sub_category_type ==
                              //   //         "rent-property") {
                              //   //   Navigator.of(context, rootNavigator: true)
                              //   //       .pushReplacement(CupertinoPageRoute(
                              //   //           builder: (_) => PropertyPost(
                              //   //               subcat_type: subcategoryList[index]
                              //   //                   .sub_category_type,
                              //   //               cat_id:
                              //   //                   widget.categoryID.toString(),
                              //   //               subcat_id: subcategoryList[index]
                              //   //                   .id
                              //   //                   .toString())));

                              print(subcategoryList[index].sub_category_type);
                              print("nandhu");
                              switch (
                                  subcategoryList[index].sub_category_type) {
                                case "cars":
                                  {
                                    Navigator.of(context, rootNavigator: true)
                                        .pushReplacement(CupertinoPageRoute(
                                            builder: (_) => CarPost(
                                                subcat_type:
                                                    subcategoryList[index]
                                                        .sub_category_type,
                                                cat_id: widget.categoryID
                                                    .toString(),
                                                subcat_id:
                                                    subcategoryList[index]
                                                        .id
                                                        .toString())));
                                  }
                                  break;
                                case "bike":
                                  {
                                    Navigator.of(context, rootNavigator: true)
                                        .pushReplacement(CupertinoPageRoute(
                                            builder: (_) => BikePost(
                                                subcat_type:
                                                    subcategoryList[index]
                                                        .sub_category_type,
                                                cat_id: widget.categoryID
                                                    .toString(),
                                                subcat_id:
                                                    subcategoryList[index]
                                                        .id
                                                        .toString())));
                                  }
                                  break;
                                case "sale-property":
                                case "rent-property":
                                  {
                                    Navigator.of(context, rootNavigator: true)
                                        .pushReplacement(CupertinoPageRoute(
                                            builder: (_) => PropertyPost(
                                                subcat_type:
                                                    subcategoryList[index]
                                                        .sub_category_type,
                                                cat_id: widget.categoryID
                                                    .toString(),
                                                subcat_id:
                                                    subcategoryList[index]
                                                        .id
                                                        .toString())));
                                  }
                                  break;
                                case "rent-shop":
                                case "sale-shop":
                                  {
                                    Navigator.of(context, rootNavigator: true)
                                        .pushReplacement(CupertinoPageRoute(
                                            builder: (_) =>
                                                OfficeAndShopRentAndSell(
                                                    subcat_type:
                                                        subcategoryList[index]
                                                            .sub_category_type,
                                                    cat_id: widget.categoryID
                                                        .toString(),
                                                    subcat_id:
                                                        subcategoryList[index]
                                                            .id
                                                            .toString())));
                                  }
                                  break;
                                case "lands-plots":
                                  {
                                    print(subcategoryList[index]
                                        .sub_category_type);
                                    Navigator.of(context, rootNavigator: true)
                                        .pushReplacement(CupertinoPageRoute(
                                            builder: (_) => LandsAndPlot(
                                                subcat_type:
                                                    subcategoryList[index]
                                                        .sub_category_type,
                                                cat_id: widget.categoryID
                                                    .toString(),
                                                subcat_id:
                                                    subcategoryList[index]
                                                        .id
                                                        .toString())));
                                  }
                                  break;
                                case "pg":
                                  {
                                    Navigator.of(context, rootNavigator: true)
                                        .pushReplacement(CupertinoPageRoute(
                                            builder: (_) => PGandGustHouse(
                                                subcat_type:
                                                    subcategoryList[index]
                                                        .sub_category_type,
                                                cat_id: widget.categoryID
                                                    .toString(),
                                                subcat_id:
                                                    subcategoryList[index]
                                                        .id
                                                        .toString())));
                                  }
                                  break;
                                case "jobs":
                                  {
                                    Navigator.of(context, rootNavigator: true)
                                        .pushReplacement(CupertinoPageRoute(
                                            builder: (_) => JobPost(
                                                subcat_type:
                                                    subcategoryList[index]
                                                        .sub_category_type,
                                                cat_id: widget.categoryID
                                                    .toString(),
                                                subcat_id:
                                                    subcategoryList[index]
                                                        .id
                                                        .toString(),
                                                jobCategory:
                                                    subcategoryList[index]
                                                        .sub_category_name)));
                                  }
                                  break;
                                default:
                                  {
                                    Navigator.of(context, rootNavigator: true)
                                        .push(CupertinoPageRoute(
                                            builder: (_) => AddPostsPage(
                                                  categoryID: widget.categoryID
                                                      .toString(),
                                                  subcategoryID:
                                                      subcategoryList[index]
                                                          .id
                                                          .toString(),
                                                  subcat_type: subcategoryList[
                                                              index]
                                                          .sub_category_type ??
                                                      "",
                                                  mainCategory:
                                                      widget.mainCategory,
                                                )));
                                  }
                                  break;
                              }
                              // Navigator.pushReplacement(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (BuildContext context) =>
                              //             AddPostsPage(
                              //               subcategoryID:
                              //                   subcategoryList[index].id,
                              //               categoryID: widget.categoryID,
                              //               mainCategory: widget.mainCategory,
                              //               categoryName: widget.categoryName,
                              //               subcategoryName:
                              //                   subcategoryList[index]
                              //                       .sub_category_name,
                              //             )));
                            } else if (widget.addpost == "0") {
                              Navigator.of(context, rootNavigator: true).push(
                                  CupertinoPageRoute(
                                      builder: (_) => RepairesAndServices(
                                          subcat_type: subcategoryList[index]
                                              .sub_category_type,
                                          cat_id: widget.categoryID.toString(),
                                          cat_name: subcategoryList[index]
                                              .sub_category_name,
                                          mainCategory: widget.mainCategory,
                                          subcat_id: subcategoryList[index]
                                              .id
                                              .toString())));
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          AdsListingPage(
                                            subcategoryID:
                                                subcategoryList[index]
                                                    .id
                                                    .toString(),
                                            title: subcategoryList[index]
                                                .sub_category_name,
                                          )));
                            }
                          },
                        ),
                        divider3(),
                      ],
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
}
