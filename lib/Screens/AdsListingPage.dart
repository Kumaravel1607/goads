import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:services/Constant/Colors.dart';
import 'package:http/http.dart' as http;
import 'package:services/Constant/api.dart';
import 'package:services/Model/ads_list.dart';
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'AdsDetail.dart';

class ProductType {
  const ProductType(this.name, this.productValue);
  final String name;
  final String productValue;
}

class PriceType {
  const PriceType(this.price, this.priceValue);
  final String price;
  final String priceValue;
}

class AdsListingPage extends StatefulWidget {
  final String categoryID;
  final String subcategoryID;
  final String title;
  AdsListingPage({Key key, this.categoryID, this.subcategoryID, this.title})
      : super(key: key);

  @override
  _AdsListingPageState createState() => _AdsListingPageState();
}

class _AdsListingPageState extends State<AdsListingPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _searchData = new TextEditingController();
  final TextEditingController _location = new TextEditingController();
  PersistentBottomSheetController _controller;

  final TextEditingController minRate = new TextEditingController();
  final TextEditingController maxRate = new TextEditingController();

  bool _changeScreen = true;
  bool _delayLoading = false;
  int indexSelected = -1;
  String sortName = "";

  bool _isLoading = false;
  List wordsL = [];
  List<String> savedwords = List<String>();
  @override
  void initState() {
    super.initState();
    ads_list("", "", "", "", "");
  }

  int page = 1;

  void ads_list(searchdata, priceRange, serviceTyepe, priceType, sortBy) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'main_category': "",
      'page': page.toString(),
      'limit': limit,
      'category_id': widget.categoryID != null ? widget.categoryID : "",
      'sub_category_id':
          widget.subcategoryID != null ? widget.subcategoryID : "",
      'city_id': sharedPreferences.getString("city_ID") != null
          ? sharedPreferences.getString("city_ID")
          : "",
      'search_text': searchdata,
      'price_range': priceRange != "-" ? priceRange : "",
      'service_type': serviceTyepe != null ? serviceTyepe : "",
      'price_type': priceType != null ? priceType : "",
      'sort_by': sortBy != null ? sortBy : "",
    };
    print(json.encode(data));
    var jsonResponse;
    var response = await http.post(Uri.parse(app_api + '/ads'), body: data);
print(response.body.toString());
    _isLoading == false ? isLoad() : null;
    if (response.statusCode == 200) {
      setState(() {
        _isLoading = true;
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
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<AdsList> ads = List<AdsList>();

  Future<List<AdsList>> get_adsList(adsJson) async {
    // await Future.delayed(Duration(seconds: 1));
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
    } else {
      // setState(() {
      //   _isLoading = false;
      // });
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
        ads_list(_searchData.text ?? "", ((minRate.text) + ("-" + maxRate.text)) ?? "", '${_productfilters.join(', ')}'??"", '${_pricefilters.join(', ')}'??"", sortName??"");
    // ads_list("", "", "", "", "");
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    // allAPI();
    if (mounted)
      setState(() {
        page++;
        ads_list(_searchData.text ?? "", ((minRate.text) + ("-" + maxRate.text)) ?? "", '${_productfilters.join(', ')}'??"", '${_pricefilters.join(', ')}'??"", sortName??"");
      });
    _refreshController.loadComplete();
  }

  void isLoad() {
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _delayLoading = true;
      });
    });
  }

  final List<ProductType> _cast = <ProductType>[
    const ProductType('NEW', '1'),
    const ProductType('Old', '2'),
    const ProductType('Services', '3'),
  ];
  List<String> _productfilters = <String>[];

  Iterable<Widget> get productWidgets sync* {
    for (final ProductType product in _cast) {
      yield Padding(
        padding: const EdgeInsets.all(4.0),
        child: FilterChip(
          // avatar: CircleAvatar(child: Text(actor.productValue)),
          label: Text(product.name),
          selected: _productfilters.contains(product.productValue),
          onSelected: (bool value) {
            setState(() {
              if (value) {
                _productfilters.add(product.productValue);
              } else {
                _productfilters.removeWhere((String productValue) {
                  return productValue == product.productValue;
                });
              }
            });
          },
        ),
      );
    }
  }

  final List<PriceType> _pricecast = <PriceType>[
    const PriceType('Negotiable', '1'),
    const PriceType('Fixed', '2'),
  ];
  List<String> _pricefilters = <String>[];

  Iterable<Widget> get priceWidgets sync* {
    for (final PriceType price in _pricecast) {
      yield Padding(
        padding: const EdgeInsets.all(4.0),
        child: FilterChip(
          // avatar: CircleAvatar(child: Text(actor.productValue)),
          label: Text(price.price),
          selected: _pricefilters.contains(price.priceValue),
          onSelected: (bool value) {
            setState(() {
              if (value) {
                _pricefilters.add(price.priceValue);
              } else {
                _pricefilters.removeWhere((String priceValue) {
                  return priceValue == price.priceValue;
                });
              }
            });
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return _changeScreen
        ? Scaffold(
            backgroundColor: white,
            appBar: AppBar(
              centerTitle: true,
              elevation: 0,
              backgroundColor: appcolor,
              automaticallyImplyLeading: false,
              title: Container(
                height: 40.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: white,
                ),
                // width: 355,
                child: CupertinoTextField(
                  enableSuggestions: true,
                  onSubmitted: (value) {
                    setState(() {
                      _isLoading = false;
                      _delayLoading = true;
                    });
                    ads_list(_searchData.text, "", "", "", "");
                  },
                  cursorColor: color2,
                  // autofocus: true,
                  keyboardType: TextInputType.text,
                  controller: _searchData,
                  placeholder: 'Search',
                  placeholderStyle: TextStyle(
                    fontSize: 15,
                    height: 1.4,
                    color: Colors.grey,
                  ),
                  prefix: Padding(
                    padding: const EdgeInsets.fromLTRB(9.0, 7.0, 9.0, 8.0),
                    child: InkWell(
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.grey,
                          size: 23,
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                        }),
                  ),
                  suffix: Padding(
                    padding: const EdgeInsets.fromLTRB(9.0, 7.0, 9.0, 8.0),
                    child: InkWell(
                        child: Icon(
                          Icons.search_sharp,
                          color: Colors.grey,
                          size: 23,
                        ),
                        onTap: () {
                          setState(() {
                            _isLoading = false;
                            _delayLoading = true;
                          });
                          ads_list(_searchData.text, "", "", "", "");
                        }),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3.0),
                    color: Color(0xffffffff),
                  ),
                ),
              ),
              actions: [
                IconButton(
                    icon: Icon(Icons.tune, color: white),
                    onPressed: () {
                      // _filter();
                      setState(() {
                        _changeScreen = false;
                      });
                    }),
              ],
            ),
            body: SmartRefresher(
              enablePullDown: true,
              enablePullUp: true,
              header: WaterDropHeader(),
              controller: _refreshController,
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              child: _isLoading
                  ? ads.length != 0
                      ? new ListView.builder(
                          shrinkWrap: false,
                          scrollDirection: Axis.vertical,
                          itemCount: ads.length,
                          itemBuilder: (context, index) {
                            return Padding(
                                padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
                                child: trendingList(ads[index]));
                          })
                      : Container(
                          alignment: Alignment.center,
                          child: Text(
                            "No data found...",
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                  : Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      alignment: Alignment.bottomCenter,
                      child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(appcolor),
                      ),
                    ),
            ),
          )
        : Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          "Filter and sort",
                          style: TextStyle(
                              color: appcolor,
                              fontWeight: FontWeight.w600,
                              fontSize: 18),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Choose the price range",
                          style: TextStyle(
                              color: color2,
                              fontWeight: FontWeight.w600,
                              fontSize: 14),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.start,
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 7,
                            ),
                            Expanded(
                              child: TextFormField(
                                cursorHeight: 18,
                                onSaved: (String value) {},
                                controller: minRate,
                                obscureText: false,
                                onTap: () {},
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: black,
                                ),
                                keyboardType: TextInputType.text,
                                decoration: textDecoration(
                                  'min',
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Text("to"),
                            SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              child: TextFormField(
                                cursorHeight: 18,
                                onSaved: (String value) {},
                                controller: maxRate,
                                obscureText: false,
                                onTap: () {},
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: black,
                                ),
                                keyboardType: TextInputType.text,
                                decoration: textDecoration(
                                  'max',
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 7,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Choose the product type",
                          style: TextStyle(
                              color: color2,
                              fontWeight: FontWeight.w600,
                              fontSize: 14),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Wrap(
                          children: productWidgets.toList(),
                        ),
                        Text('Look for: ${_productfilters.join(', ')}'),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Choose the price type",
                          style: TextStyle(
                              color: color2,
                              fontWeight: FontWeight.w600,
                              fontSize: 14),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Wrap(
                          children: priceWidgets.toList(),
                        ),
                        Text('Look for: ${_pricefilters.join(', ')}'),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Change sort",
                          style: TextStyle(
                              color: color2,
                              fontWeight: FontWeight.w600,
                              fontSize: 14),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Wrap(
                          children: [
                            ChoiceChip(
                              label: Text("Date Published"),
                              selected: indexSelected == 1,
                              onSelected: (value) {
                                setState(() {
                                  indexSelected = value ? 1 : -1;
                                  sortName = "date_publish";
                                  print(sortName);
                                });
                              },
                            ),
                            const SizedBox(width: 8),
                            ChoiceChip(
                              label: Text("Relevance"),
                              selected: indexSelected == 2,
                              onSelected: (value) {
                                setState(() {
                                  indexSelected = value ? 2 : -1;
                                  sortName = "relevance";
                                  print(sortName);
                                });
                              },
                            ),
                            const SizedBox(width: 8),
                            ChoiceChip(
                              label: Text("Price Low to High"),
                              selected: indexSelected == 3,
                              onSelected: (value) {
                                setState(() {
                                  indexSelected = value ? 3 : -1;
                                  sortName = "price_low";
                                  print(sortName);
                                });
                              },
                            ),
                            const SizedBox(width: 8),
                            ChoiceChip(
                              label: Text("Price High to Low"),
                              selected: indexSelected == 4,
                              onSelected: (value) {
                                setState(() {
                                  indexSelected = value ? 4 : -1;
                                  sortName = "price_high";
                                  print(sortName);
                                });
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: button(),
                        )
                      ],
                    ),
                  ),
                ),
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
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    AdsDetailPage(ads_id: ad.id)));
      },
      child: Card(
        elevation: 1.0,
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
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: black,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 7,
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
    );
  }

  void _closeModal(void value) {
    print('modal closed');
    // Navigator.pop(context);
  }

  void selectBtn() {
    // Navigator.push(context, MaterialPageRoute(builder: (_) => OtpPage()));
  }

  Widget button() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              print(((minRate.text) + "-" + (maxRate.text)));
              setState(() {
                _changeScreen = true;
              });
            },
            style: ButtonStyle(
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0))),
            ),
            child: const Text(
              "Cancel",
              style: TextStyle(color: color2),
            ),
          ),
        ),
        SizedBox(
          width: 15,
        ),
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              setState(() {
                _changeScreen = true;
                _isLoading = false;
              });
              ads_list(
                  "",
                  ((minRate.text) + ("-" + maxRate.text)),
                  '${_productfilters.join(', ')}',
                  '${_pricefilters.join(', ')}',
                  sortName);
            },
            style: ButtonStyle(
              // backgroundColor: #,
              backgroundColor: MaterialStateProperty.all(color2),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0))),
            ),
            child: const Text(
              "Apply",
              style: TextStyle(color: white),
            ),
          ),
        ),
      ],
    );
  }

  Widget list() {
    return SingleChildScrollView(
      child: ListTile(
        title: Text("Palacode"),
        // subtitle: Text(location.id),
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
                    suggestionsCallback: (pattern) async {},
                    itemBuilder: (context, item) {
                      return list();
                    },
                    onSuggestionSelected: (item) async {},
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
}
