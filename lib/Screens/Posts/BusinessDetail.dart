// import 'dart:convert';
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:services/Constant/Colors.dart';
// import 'package:services/Constant/api.dart';
// import 'package:services/Model/bussiness_model.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'package:pull_to_refresh/pull_to_refresh.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:carousel_slider/carousel_options.dart';
// import 'package:photo_view/photo_view.dart';
// import 'package:photo_view/photo_view_gallery.dart';

// class BusinessDetails extends StatefulWidget {
//   final String ads_id;
//   BusinessDetails({Key key, this.ads_id}) : super(key: key);

//   @override
//   _BusinessDetailsState createState() => _BusinessDetailsState();
// }

// class _BusinessDetailsState extends State<BusinessDetails> {
//   List wordsL = [];
//   List<String> savedwords = List<String>();
//   bool _isLoading = true;

//   String adsID;
//   String receiverId;
//   String user_ID;
//   String poster_Id;
//   int _current = 0;

//   String userId;

//   //  PageController _pageController = PageController(initialPage: 1);
//   PageController _pageController;

//   @override
//   void initState() {
//     super.initState();
//     userID();
//     ads_detail();
//     image_api();
//   }

//   void refresh() {
//     setState(() {
//       _pageController = PageController(initialPage: _current);
//     });
//   }

//   Future<BussinessDetailModel> ads_detail() async {
//     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//     Map data = {
//       'id': widget.ads_id,
//       'customer_id': sharedPreferences.getString("user_id"),
//     };
//     print(data);

//     var response =
//         await http.post(Uri.parse(app_api + '/ads_detail'), body: data);
//     // jsonResponse = json.decode(response.body);
//     var jsonResponse;
//     if (response.statusCode == 200) {
//       jsonResponse = json.decode(response.body);
//       print(jsonResponse);
//       poster_Id = jsonResponse['customer_id'].toString();
//       adsID = jsonResponse['id'].toString();
//       receiverId = jsonResponse['customer_id'].toString();
//       userId = sharedPreferences.getString("user_id");

//       return BussinessDetailModel.fromJson(jsonResponse);
//     } else {
//       throw Exception('Failed to load post');
//     }
//   }

//   void image_api() async {
//     Map data = {
//       'id': widget.ads_id,
//     };
//     // var jsonResponse;
//     var response =
//         await http.post(Uri.parse(app_api + '/ads_detail'), body: data);

//     if (response.statusCode == 200) {
//       print("-------NK=---------");
//       print(json.decode(response.body)['images']);
//       get_imageList(json.decode(response.body)['images']).then((value) {
//         setState(() {
//           imageList = value;
//         });
//       });
//       print("-------------------------");
//       print(json.decode(response.body)['images']);
//     }
//   }

//   void userID() async {
//     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//     setState(() {
//       user_ID = sharedPreferences.getString("user_id");
//       //  print("nandhu");
//     });
//   }

//   RefreshController _refreshController =
//       RefreshController(initialRefresh: false);

//   void _onRefresh() async {
//     // monitor network fetch
//     await Future.delayed(Duration(milliseconds: 1000));
//     // if failed,use refreshFailed()

//     // _refreshController.refreshCompleted();
//     _refreshController.refreshToIdle();
//     ads_detail();
//   }

//   void _onLoading() async {
//     // monitor network fetch
//     await Future.delayed(Duration(milliseconds: 1000));
//     // if failed,use loadFailed(),if no data return,use LoadNodata()
//     // allAPI();
//     // if (mounted) setState(() {});
//     _refreshController.loadComplete();
//   }

//   List<AllImage> imageList = List<AllImage>();

//   Future<List<AllImage>> get_imageList(imageListsJson) async {
//     var imageLists = List<AllImage>();
//     for (var imageListJson in imageListsJson) {
//       imageLists.add(AllImage.fromJson(imageListJson));
//     }
//     return imageLists;
//   }

//   save_favorite(adID) async {
//     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//     Map data = {
//       'customer_id': sharedPreferences.getString("user_id"),
//       'ads_id': adID,
//     };
//     print(data);
//     var jsonResponse;
//     var response =
//         await http.post(Uri.parse(app_api + '/save_favorite'), body: data);
//     if (response.statusCode == 200) {
//       jsonResponse = json.decode(response.body);
//     } else {
//       // setState(() {
//       //   _isLoading = false;
//       // });
//     }
//   }

//   delete_favorite(adID) async {
//     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//     Map data = {
//       'customer_id': sharedPreferences.getString("user_id"),
//       'ads_id': adID,
//     };
//     print(data);
//     var jsonResponse;
//     var response =
//         await http.post(Uri.parse(app_api + '/delete_favorite'), body: data);
//     if (response.statusCode == 200) {
//       jsonResponse = json.decode(response.body);
//     } else {
//       // setState(() {
//       //   _isLoading = false;
//       // });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Bussiness Detail"),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(15.0),
//           child: FutureBuilder<BussinessDetailModel>(
//               future: ads_detail(),
//               builder: (context, snapshot) {
//                 if (snapshot.hasData) {
//                   String word = snapshot.data.id;
//                   savedwords.remove(word);
//                   if (snapshot.data.favorite_status == "1") {
//                     savedwords.add(word);
//                   }
//                   bool issaved = savedwords.contains(word);
//                   return SafeArea(
//                       child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Container(
//                       //   height: 200,
//                       //   decoration: BoxDecoration(
//                       //       color: color2,
//                       //       borderRadius: BorderRadius.circular(15),
//                       //       image: DecorationImage(
//                       //           image:
//                       //               AssetImage("assets/images/bikerepair1.jpg"),
//                       //           fit: BoxFit.fill)),
//                       // ),
//                       new Container(
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(15),
//                         ),
//                         child: CarouselSlider.builder(
//                             options: CarouselOptions(
//                                 height: 200,
//                                 viewportFraction: 1.0,
//                                 aspectRatio: 2.0,
//                                 autoPlay: false,
//                                 enableInfiniteScroll: false,
//                                 autoPlayInterval: Duration(seconds: 3),
//                                 autoPlayCurve: Curves.easeInCubic,
//                                 enlargeCenterPage: false,
//                                 reverse: false,
//                                 onPageChanged: (index, reason) {
//                                   setState(() {
//                                     _current = index;
//                                     print("${_current}");
//                                   });
//                                 }),
//                             itemCount: imageList.length,
//                             itemBuilder: (context, index) {
//                               return Builder(
//                                 builder: (BuildContext context) {
//                                   return GestureDetector(
//                                     onTap: () {
//                                       setState(() {
//                                         refresh();
//                                       });
//                                       Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                               builder: (BuildContext context) =>
//                                                   photoView()));
//                                     },
//                                     child: Stack(
//                                       children: [
//                                         Container(
//                                           height: 200,
//                                           width:
//                                               MediaQuery.of(context).size.width,
//                                           // margin: EdgeInsets.symmetric(
//                                           //     horizontal: 10.0),
//                                           decoration: BoxDecoration(
//                                             color: white,
//                                             borderRadius:
//                                                 BorderRadius.circular(15),
//                                             image: DecorationImage(
//                                               image: NetworkImage(
//                                                   imageList[index].image_name),
//                                               fit: BoxFit.contain,
//                                             ),
//                                             // shape: BoxShape.rectangle,
//                                           ),
//                                         ),
//                                         Container(
//                                           height: 250,
//                                           // color: const Color(0xBD0E3311)
//                                           //     .withOpacity(0.2),
//                                         ),
//                                       ],
//                                     ),
//                                   );
//                                 },
//                               );
//                             }),
//                       ),
//                       SizedBox(
//                         height: 15,
//                       ),
//                       Row(
//                         children: [
//                           Flexible(
//                             child: Text(
//                               snapshot.data.ads_name,
//                               style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 20,
//                                   color: color2),
//                             ),
//                           ),
//                           SizedBox(
//                             width: 15,
//                           ),
//                           GestureDetector(
//                               child: issaved
//                                   ? Icon(
//                                       Icons.favorite,
//                                       color: Color(0xFFC43434),
//                                       // size: 22,
//                                     )
//                                   : Icon(
//                                       Icons.favorite_border,
//                                       color: Color(0xFFC43434),
//                                       // size: 22,
//                                     ),
//                               onTap: () {
//                                 setState(() {
//                                   print(savedwords.contains(word));
//                                   if (issaved) {
//                                     snapshot.data.favorite_status = "0";
//                                     savedwords.remove(word);

//                                     delete_favorite(snapshot.data.id);
//                                   } else {
//                                     snapshot.data.favorite_status = "1";
//                                     savedwords.add(word);

//                                     save_favorite(snapshot.data.id);
//                                   }
//                                 });
//                               }),
//                         ],
//                       ),
//                       SizedBox(
//                         height: 7,
//                       ),
//                       Row(
//                         children: [
//                           Text(
//                             snapshot.data.city_name,
//                             style: TextStyle(
//                                 fontWeight: FontWeight.w500,
//                                 color: Colors.grey[700]),
//                           ),
//                           Spacer(),
//                           Container(
//                             padding: EdgeInsets.all(5),
//                             decoration: BoxDecoration(
//                                 color: Colors.grey[200],
//                                 borderRadius: BorderRadius.circular(5)),
//                             child: Text(
//                               snapshot.data.ads_condition == "1"
//                                   ? "New"
//                                   : snapshot.data.ads_condition == "2"
//                                       ? "Like New"
//                                       : snapshot.data.ads_condition == "3"
//                                           ? "Gently Used"
//                                           : "Heavily Used",
//                               style: TextStyle(
//                                   fontWeight: FontWeight.w500,
//                                   color: Colors.grey[700]),
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(
//                         height: 20,
//                       ),
//                       Text(
//                         "COMPANY DETAILS",
//                         style: TextStyle(
//                             fontWeight: FontWeight.w600,
//                             fontSize: 16,
//                             color: appcolor),
//                       ),
//                       SizedBox(
//                         height: 5,
//                       ),
//                       // divider2(),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 7),
//                         child: Row(
//                           children: [
//                             Icon(Icons.business),
//                             SizedBox(
//                               width: 15,
//                             ),
//                             Flexible(
//                                 child: Text(
//                                     "Founder:  " + snapshot.data.owner_name)),
//                           ],
//                         ),
//                       ),
//                       divider2(),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 7),
//                         child: Row(
//                           children: [
//                             Icon(Icons.flag_outlined),
//                             SizedBox(
//                               width: 15,
//                             ),
//                             Flexible(
//                                 child: Text("Founded:  " +
//                                     snapshot.data.business_since)),
//                           ],
//                         ),
//                       ),
//                       divider2(),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 7),
//                         child: Row(
//                           children: [
//                             Icon(Icons.map_outlined),
//                             SizedBox(
//                               width: 15,
//                             ),
//                             Flexible(
//                                 child: Text(snapshot.data.address1 +
//                                     "\n" +
//                                     snapshot.data.address2 +
//                                     "\n" +
//                                     "Pincode: " +
//                                     snapshot.data.pincode)),
//                           ],
//                         ),
//                       ),
//                       divider2(),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 7),
//                         child: Row(
//                           children: [
//                             Icon(Icons.report_problem_outlined),
//                             SizedBox(
//                               width: 15,
//                             ),
//                             Flexible(
//                                 child: Text("Hours and Servces may differ")),
//                           ],
//                         ),
//                       ),
//                       divider2(),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 7),
//                         child: Row(
//                           children: [
//                             Icon(Icons.access_time_outlined),
//                             SizedBox(
//                               width: 15,
//                             ),
//                             Flexible(
//                                 child: Text("Time: " +
//                                     snapshot.data.working_hours_from +
//                                     " to " +
//                                     snapshot.data.working_hours_to)),
//                           ],
//                         ),
//                       ),
//                       divider2(),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 7),
//                         child: Row(
//                           children: [
//                             Icon(Icons.date_range_outlined),
//                             SizedBox(
//                               width: 15,
//                             ),
//                             Flexible(
//                                 child: Text(
//                                     "Working Days: Mon, Tus, Wed, Thu, Fri")),
//                           ],
//                         ),
//                       ),
//                       divider2(),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 7),
//                         child: Row(
//                           children: [
//                             // Icon(Icons.date_range_outlined),
//                             Text("Doorstep Services: "),
//                             SizedBox(
//                               width: 15,
//                             ),
//                             Flexible(
//                                 child: Text(
//                               snapshot.data.door_step == "0" ? "No" : "Yes",
//                             )),
//                           ],
//                         ),
//                       ),
//                       divider2(),
//                       SizedBox(
//                         height: 5,
//                       ),
//                       // extraDetail(),
//                       Text(
//                         "DESCRIPTION",
//                         style: TextStyle(color: appcolor, fontSize: 16),
//                       ),
//                       SizedBox(
//                         height: 8,
//                       ),
//                       Text(snapshot.data.ads_description),
//                       SizedBox(
//                         height: 25,
//                       ),
//                       Row(
//                         children: [
//                           Expanded(
//                               flex: 1,
//                               child: Column(
//                                 children: [
//                                   Icon(
//                                     Icons.call,
//                                     color: Colors.green[800],
//                                   ),
//                                   SizedBox(
//                                     height: 7,
//                                   ),
//                                   Text(
//                                     "Phone",
//                                     style: TextStyle(
//                                         fontWeight: FontWeight.w500,
//                                         color: color2),
//                                   )
//                                 ],
//                               )),
//                           Expanded(
//                               flex: 1,
//                               child: Column(
//                                 children: [
//                                   Icon(
//                                     Icons.mail,
//                                     color: Colors.green[800],
//                                   ),
//                                   SizedBox(
//                                     height: 7,
//                                   ),
//                                   Text(
//                                     "Mail",
//                                     style: TextStyle(
//                                         fontWeight: FontWeight.w500,
//                                         color: color2),
//                                   )
//                                 ],
//                               )),
//                           Expanded(
//                               flex: 1,
//                               child: Column(
//                                 children: [
//                                   Icon(
//                                     Icons.chat_rounded,
//                                     color: Colors.green[800],
//                                   ),
//                                   SizedBox(
//                                     height: 7,
//                                   ),
//                                   Text(
//                                     "Chat",
//                                     style: TextStyle(
//                                         fontWeight: FontWeight.w500,
//                                         color: color2),
//                                   )
//                                 ],
//                               )),
//                           Expanded(
//                               flex: 1,
//                               child: Column(
//                                 children: [
//                                   Icon(
//                                     Icons.share,
//                                     color: Colors.green[800],
//                                   ),
//                                   SizedBox(
//                                     height: 7,
//                                   ),
//                                   Text(
//                                     "Share",
//                                     style: TextStyle(
//                                         fontWeight: FontWeight.w500,
//                                         color: color2),
//                                   )
//                                 ],
//                               )),
//                         ],
//                       )
//                     ],
//                   ));
//                 } else {
//                   return Container(
//                     alignment: Alignment.center,
//                     child: CircularProgressIndicator(
//                       backgroundColor: appcolor,
//                       valueColor: new AlwaysStoppedAnimation<Color>(white),
//                     ),
//                   );
//                 }
//               }),
//         ),
//       ),
//     );
//   }

//   Widget photoView() => Container(
//         child: Stack(children: [
//           PhotoViewGallery.builder(
//             itemCount: imageList.length,
//             pageController: _pageController,
//             builder: (context, index) {
//               return PhotoViewGalleryPageOptions(
//                 imageProvider: NetworkImage(imageList[index].image_name),
//                 minScale: PhotoViewComputedScale.contained * 0.8,
//                 maxScale: PhotoViewComputedScale.covered * 2,
//               );
//             },
//             scrollPhysics: BouncingScrollPhysics(),
//             onPageChanged: (int index) {
//               setState(() {
//                 _current = index;
//                 print(_current);
//               });
//             },
//             backgroundDecoration: BoxDecoration(
//               color: black,
//             ),
//             loadFailedChild: Center(
//               child: CircularProgressIndicator(),
//             ),
//           ),
//           Container(
//               alignment: Alignment.topRight,
//               padding: const EdgeInsets.only(top: 100, right: 25),
//               child: FloatingActionButton(
//                 elevation: 10,
//                 mini: true,
//                 foregroundColor: black,
//                 backgroundColor: white,
//                 child: Icon(
//                   Icons.close,
//                   color: black,
//                   size: 25,
//                 ),
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//               )),
//         ]),
//       );
// }
