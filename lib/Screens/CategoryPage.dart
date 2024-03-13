import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:services/Constant/Colors.dart';
import 'package:http/http.dart' as http;
import 'package:services/Constant/api.dart';
import 'package:services/Model/category_model.dart';
import 'package:services/Screens/AddBusinessPost.dart';
import 'package:services/Screens/Posts/JobPost.dart';
import 'package:services/Screens/Posts/Repaires&Services.dart';
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'AddPost.dart';
import 'AdsListingPage.dart';
import 'Posts/CommercialVehicle.dart';
import 'SubCategory.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CategoryPage extends StatefulWidget {
  final String main_catergory;
  final String addpost;
  final String title;
  CategoryPage({Key key, this.main_catergory, this.addpost, this.title})
      : super(key: key);

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    category_list();
  }

  void category_list() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'main_category': widget.main_catergory,
    };
    var jsonResponse;
    var response =
        await http.post(Uri.parse(app_api + '/category'), body: data);

    if (response.statusCode == 200) {
      setState(() {
        _isLoading = false;
      });
      get_categoryList(json.decode(response.body)).then((value) {
        setState(() {
          categoryList = value;
        });
      });
      // print('---------------NK-----------');
      print(json.decode(response.body));
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<CategoryList> categoryList = List<CategoryList>();

  Future<List<CategoryList>> get_categoryList(categorysJson) async {
    var categorys = List<CategoryList>();
    for (var categoryJson in categorysJson) {
      categorys.add(CategoryList.fromJson(categoryJson));
    }
    return categorys;
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()

    // _refreshController.refreshCompleted();
    _refreshController.refreshToIdle();
    category_list();
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
        backgroundColor: appcolor,
        title: Text(
          widget.title != null ? widget.title : "Choose a Category",
          style: TextStyle(color: white),
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
        child: categoryList.length != 0
            ? new ListView.builder(
                shrinkWrap: false,
                scrollDirection: Axis.vertical,
                itemCount: categoryList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          title: Text(
                            categoryList[index].category_name,
                            style: TextStyle(
                                fontSize: 16,
                                color: black,
                                fontWeight: FontWeight.w500),
                          ),
                          leading: Image.network(
                            categoryList[index].category_image,
                            height: 35,
                            width: 35,
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey[400],
                            size: 20,
                          ),
                          onTap: () {
                            print(categoryList[index].category_type);
                            if (widget.addpost == "1") {
                              print(
                                  "------------------NK---------------ff-------");
                              switch (categoryList[index].category_type) {
                                case "jobs":
                                  {
                                    print(categoryList[index].category_type);
                                    print(categoryList[index].id);
                                    Navigator.of(context, rootNavigator: true)
                                        .push(CupertinoPageRoute(
                                            builder: (_) => JobPost(
                                                  subcat_type: "jobs",
                                                  cat_id: "10",
                                                  // subcat_id: subcategoryList[index]
                                                  //     .id
                                                  //     .toString()
                                                )));
                                  }
                                  break;
                                case "commercial-vehicles":
                                  {
                                    Navigator.of(context, rootNavigator: true)
                                        .pushReplacement(CupertinoPageRoute(
                                      builder: (_) => CommercialVehiclePost(
                                        subcat_type:
                                            categoryList[index].category_type,
                                        cat_id:
                                            categoryList[index].id.toString(),
                                        // subcat_id:
                                        //     subcategoryList[index]
                                        //         .id
                                        //         .toString())));
                                      ),
                                    ));
                                  }
                                  break;
                                default:
                                  {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                SubCategoryPage(
                                                  categoryID:
                                                      categoryList[index].id,
                                                  categoryName:
                                                      categoryList[index]
                                                          .category_name,
                                                  addpost: "1",
                                                  mainCategory:
                                                      widget.main_catergory,
                                                  title: categoryList[index]
                                                      .category_name,
                                                )));
                                  }
                                  break;
                              }
                              // } else if (widget.addpost == "3") {
                              //   print(
                              //       "------------------NK!----------------------");
                              //   categoryList[index].subcategory != 0
                              //       ? Navigator.pushReplacement(
                              //           context,
                              //           MaterialPageRoute(
                              //               builder: (BuildContext context) =>
                              //                   SubCategoryPage(
                              //                     categoryID:
                              //                         categoryList[index].id,
                              //                     categoryName:
                              //                         categoryList[index]
                              //                             .category_name,
                              //                     addpost: "1",
                              //                     mainCategory:
                              //                         widget.main_catergory,
                              //                     title: categoryList[index]
                              //                         .category_name,
                              //                   )))
                              //       : Navigator.pushReplacement(
                              //           context,
                              //           MaterialPageRoute(
                              //               builder: (BuildContext context) =>
                              //                   AddPostsPage(
                              //                     categoryID:
                              //                         categoryList[index].id,
                              //                     mainCategory:
                              //                         widget.main_catergory,
                              //                     categoryName:
                              //                         categoryList[index]
                              //                             .category_name,
                              //                   )));
                            } else if (widget.addpost == "0") {
                              print("repair & business");
                              categoryList[index].subcategory != 0
                                  ? Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              SubCategoryPage(
                                                categoryID:
                                                    categoryList[index].id,
                                                title: categoryList[index]
                                                    .category_name,
                                                addpost: widget.addpost,
                                                mainCategory:
                                                    widget.main_catergory,
                                              )))
                                  : Navigator.of(context, rootNavigator: true)
                                      .push(CupertinoPageRoute(
                                          builder: (_) => RepairesAndServices(
                                                subcat_type: categoryList[index]
                                                    .category_type,
                                                cat_id: categoryList[index]
                                                    .id
                                                    .toString(),
                                                cat_name: categoryList[index]
                                                    .category_name,
                                                mainCategory:
                                                    widget.main_catergory,
                                                // subcat_id: subcategoryList[index]
                                                //     .id
                                                //     .toString()
                                              )));
                            } else {
                              print(
                                  "------------------NK2----------------------");
                              categoryList[index].subcategory != 0
                                  ? Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              SubCategoryPage(
                                                categoryID:
                                                    categoryList[index].id,
                                                title: categoryList[index]
                                                    .category_name,
                                              )))
                                  : Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              AdsListingPage(
                                                categoryID:
                                                    categoryList[index].id,
                                                title: categoryList[index]
                                                    .category_name,
                                              )));
                            }
                          },
                        ),
                        divider(),
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
                      "No data found",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
      ),
    );
  }
}
