// import 'dart:convert';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:services/Screens/Posts/JobPost.dart';
// import 'package:services/Screens/Posts/Lands&PlotPost.dart';

// import 'BikePost.dart';
// import 'BusinessDetail.dart';
// import 'BusinessPost.dart';
// import 'CarPost.dart';
// import 'Mobile&Tabletpost.dart';
// import 'Office&ShopRentSell.dart';
// import 'PG&GuestHouse.dart';
// import 'PropertyPost.dart';
// import 'Repaires&Services.dart';

// class ListOfPosts extends StatefulWidget {
//   const ListOfPosts({Key key}) : super(key: key);

//   @override
//   _ListOfPostsState createState() => _ListOfPostsState();
// }

// class _ListOfPostsState extends State<ListOfPosts> {
//   String title = "";
//   @override
//   void initState() {
//     super.initState();
//     bike();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(title),
//       ),
//       body: Container(
//         child: ListView(
//           children: [
//             list("Mobile & Tablet", mobile),
//             list("Post Car", car),
//             list("Post Bike,Scooter", bike),
//             list("Post Property", property),
//             list("Post Office Rent", rent),
//             list("Repair & Services", repair),
//             list("Bussiness", bussiness),
//             list("Job", job),
//             list("Lands&Plots", land),
//             list("PG", pg),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget list(String name, submit) {
//     return ListTile(
//       title: Text(name),
//       onTap: submit,
//     );
//   }

//   void land() {
//     Navigator.of((context), rootNavigator: true)
//         .push(CupertinoPageRoute(builder: (_) => LandsAndPlot()));
//   }

//   void pg() {
//     Navigator.of((context), rootNavigator: true)
//         .push(CupertinoPageRoute(builder: (_) => PGandGustHouse()));
//   }

//   void car() {
//     Navigator.of((context), rootNavigator: true)
//         .push(CupertinoPageRoute(builder: (_) => CarPost()));
//   }

//   void bike() {
//     // Future<String> loadArabic() async {
//     var encoded = utf8.encode("الحاسوبية، الخطوط، تصميم النصوص ");

//     setState(() {
//       title = utf8.decode(encoded);
//     });
//     var result = utf8.decode(encoded);
//     print(result);
//     // }
//     // Navigator.of((context), rootNavigator: true)
//     //     .push(CupertinoPageRoute(builder: (_) => BikePost()));
//   }

//   void property() {
//     Navigator.of((context), rootNavigator: true)
//         .push(CupertinoPageRoute(builder: (_) => PropertyPost()));
//   }

//   void rent() {
//     Navigator.of((context), rootNavigator: true)
//         .push(CupertinoPageRoute(builder: (_) => OfficeAndShopRentAndSell()));
//   }

//   void repair() {
//     Navigator.of((context), rootNavigator: true)
//         .push(CupertinoPageRoute(builder: (_) => RepairesAndServices()));
//   }

//   void bussiness() {
//     Navigator.of((context), rootNavigator: true).push(
//         CupertinoPageRoute(builder: (_) => BusinessDetails(ads_id: "69")));
//   }

//   void mobile() {
//     Navigator.of((context), rootNavigator: true)
//         .push(CupertinoPageRoute(builder: (_) => MobilePost()));
//   }

//   void job() {
//     Navigator.of((context), rootNavigator: true)
//         .push(CupertinoPageRoute(builder: (_) => JobPost()));
//   }
// }
