// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:services/Constant/Colors.dart';
// import 'dart:async';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:services/Constant/api.dart';
// import 'package:services/Model/Location_model.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:io';
// import 'package:image_picker/image_picker.dart';
// import 'package:flutter_typeahead/flutter_typeahead.dart';
// import 'MyPosts.dart';
// import 'package:multi_image_picker/multi_image_picker.dart';
// import 'package:weekday_selector/weekday_selector.dart';

// class AddBusinessPost extends StatefulWidget {
//   final String categoryID;
//   final String subcategoryID;
//   final String mainCategory;
//   final String categoryName;
//   final String subcategoryName;
//   AddBusinessPost(
//       {Key key,
//       this.subcategoryID,
//       this.categoryID,
//       this.mainCategory,
//       this.categoryName,
//       this.subcategoryName})
//       : super(key: key);

//   @override
//   _AddPostsPageState createState() => _AddPostsPageState();
// }

// class _AddPostsPageState extends State<AddBusinessPost> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   final TextEditingController title = new TextEditingController();
//   final TextEditingController description = new TextEditingController();
//   final TextEditingController price = new TextEditingController();
//   final TextEditingController serviceType = new TextEditingController();
//   final TextEditingController location = new TextEditingController();
//   final values = List.filled(7, true);
//   TimeOfDay selectedTime = TimeOfDay.now();

//   bool _isLoading = false;
//   bool enalbleBtn = true;

//   File _image;
//   String _imagefileName;
//   String _imageName;

//   int doorStep = 2;

//   String service;
//   String cityID;

//   @override
//   void initState() {
//     super.initState();
//     servicType();
//   }

//   List<Asset> images = List<Asset>();
//   bool _isUploading = false;
//   String _error;

//   String imageData;
//   String imageName;

//   var imageList = List();
//   var imageListName = List();

//   // var stringListPath;

//   Future<void> loadAssets() async {
//     setState(() {
//       images = List<Asset>();
//     });

//     List<Asset> resultList;
//     String error;

//     try {
//       resultList = await MultiImagePicker.pickImages(
//           // selectedAssets: images,
//           maxImages: 300,
//           materialOptions: MaterialOptions(
//             // actionBarColor: "#abcdef",
//             actionBarTitle: "Upload Image",
//             allViewTitle: "All Photos",
//             useDetailsView: false,
//             selectCircleStrokeColor: "#000000",
//           ));
//     } on Exception catch (e) {
//       error = e.toString();
//     }

//     for (var asset in resultList) {
//       int MAX_WIDTH = 500; //keep ratio
//       int height = ((500 * asset.originalHeight) / asset.originalWidth).round();

//       ByteData byteData =
//           await asset.requestThumbnail(MAX_WIDTH, height, quality: 80);
//       String byteDatas = await asset.name.toString();

//       if (byteData != null) {
//         imageData = base64Encode(byteData.buffer.asUint8List());
//         // imageName = byteDatas;
//         imageList.add(imageData);
//         // imageListName.add(imageName);
//       }
//     }

//     setState(() {
//       _isUploading = true;
//       // var stringListName = imageListName.join(", ");
//       _imagefileName = imageList.join(", ");
//     });
//     if (!mounted) return;
//     setState(() {
//       images = resultList;
//       if (error == null) _error = 'No Error Dectected';
//     });
//   }

//   final picker = ImagePicker();

//   void open_gallery() async {
//     var image =
//         await picker.getImage(source: ImageSource.gallery, imageQuality: 70);
//     //  var pickedFile = await picker.getImage(source: ImageSource.gallery);
//     setState(() {
//       _image = File(image.path);
//       // _image = image;
//       _imageName = _image.path.split('/').last;
//       _imagefileName = base64Encode(_image.readAsBytesSync());

//       // final bytes = _image.readAsBytesSync().lengthInBytes;
//       // final kb = bytes / 1024;
//       // final mb = kb / 1024;
//       // print("-------NK-----------");
//       // print(mb.round());
//     });
//   }

//   void open_camera() async {
//     var image =
//         await picker.getImage(source: ImageSource.camera, imageQuality: 50);
//     //  var pickedFile = await picker.getImage(source: ImageSource.gallery);
//     // print(images);
//     setState(() {
//       _image = File(image.path);
//       // _image = image;
//       _imageName = _image.path.split('/').last;
//       _imagefileName = base64Encode(_image.readAsBytesSync());

//       // final bytes = _image.readAsBytesSync().lengthInBytes;
//       // final kb = bytes / 1024;
//       // final mb = kb / 1024;
//       // print("-------NK-----------");
//       // print(mb.round());
//     });
//   }

//   postADs(
//     adname,
//     adDescription,
//     type,
//     price,
//     dstep,
//     city,
//   ) async {
//     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//     Map data = {
//       'customer_id': sharedPreferences.getString("user_id"),
//       'main_category': widget.mainCategory,
//       'category_id': widget.categoryID != null ? widget.categoryID : "",
//       'sub_category_id':
//           widget.subcategoryID != null ? widget.subcategoryID : "",
//       'ads_name': adname,
//       'ads_description': adDescription,
//       'type_of_service': type,
//       'ads_price': price,
//       'door_step': dstep,
//       'city_id': city,
//       'ads_image': _imagefileName,
//     };

//     print(data);
//     var jsonResponse;
//     var response =
//         await http.post(Uri.parse(app_api + "/post_ads"), body: data);

//     if (response.statusCode == 200) {
//       jsonResponse = json.decode(response.body);
//       print(jsonResponse);
//       if (jsonResponse != null) {
//         setState(() {
//           _isLoading = false;
//         });
//         print("NandhuKrish");
//         // Navigator.of(context, rootNavigator: false).pushAndRemoveUntil(
//         //     MaterialPageRoute(builder: (BuildContext context) => MyPosts()),
//         //     (Route<dynamic> route) => false);

//         // _alerDialog(jsonResponse['message']);

//         Navigator.of(context, rootNavigator: true).pushReplacement(
//             MaterialPageRoute(builder: (BuildContext context) => MyPosts()));
//       }
//     } else {
//       setState(() {
//         _isLoading = false;
//       });
//       _alerDialog(jsonResponse['message']);
//     }
//   }

//   String titles;

//   void servicType() {
//     if (widget.mainCategory == "1") {
//       service = "Services";
//       titles = "Shop Name/Company Name *";
//     } else if (widget.mainCategory == "2") {
//       titles = "Company Name";
//       service = "Bussiness";
//     } else {
//       service = "Sell";
//     }
//     print(widget.categoryName);
//     if (widget.categoryName == "Jobs") {
//       titles = "Job Type";
//     }
//   }

//   Future<List<Location>> get_locationData(city) async {
//     try {
//       Map data = {
//         'city_name': city,
//       };
//       print(data);
//       var response = await http.post(Uri.parse(app_api + '/city'), body: data);
//       var locationDatas = List<Location>();

//       if (response.statusCode == 200) {
//         var locationDatasJson = (json.decode(response.body));

//         print(locationDatasJson);

//         for (var locationDataJson in locationDatasJson) {
//           locationDatas.add(Location.fromJson(locationDataJson));
//         }
//       }
//       return locationDatas;
//     } catch (e) {
//       print("Error getting location.");
//     }
//   }

//   Widget list(Location location) {
//     return SingleChildScrollView(
//       child: ListTile(
//         title: Text(location.city_name),
//         // subtitle: Text(location.id),
//       ),
//     );
//   }

//   Future<void> _alerDialog(message) async {
//     await showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             content: Text(message),
//             //title: Text(),
//             actions: <Widget>[
//               FlatButton(
//                 onPressed: () {
//                   Navigator.pop(context, "ok");
//                 },
//                 child: const Text("OK"),
//               )
//             ],
//           );
//         });
//   }

//   Future<void> _alerBox() async {
//     await showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             content: Text("Please check image and location"),
//             //title: Text(),
//             actions: <Widget>[
//               FlatButton(
//                 onPressed: () {
//                   Navigator.pop(context, "ok");
//                 },
//                 child: const Text("OK"),
//               )
//             ],
//           );
//         });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: white,
//       appBar: AppBar(
//         backgroundColor: appcolor,
//         title: Text(
//           "Create Post",
//           style: TextStyle(
//             color: white,
//           ),
//         ),
//         centerTitle: true,
//         leading: IconButton(
//             icon: Icon(Icons.arrow_back),
//             onPressed: () {
//               Navigator.pop(context);
//             }),
//         // actions: [
//         //   IconButton(icon: Icon(Icons.ac_unit_outlined),
//         // onPressed: (){
//         //   loadAssets();
//         // }),
//         // ],
//       ),
//       body: SingleChildScrollView(
//           child: Padding(
//         padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Wrap(
//                 children: [
//                   Card(
//                     color: Colors.grey[300],
//                     child: Padding(
//                         padding: EdgeInsets.fromLTRB(7, 5, 7, 5),
//                         child: Text(service != null ? service : "")),
//                   ),
//                   // SizedBox(width: 5,),
//                   widget.categoryName != null
//                       ? Card(
//                           color: Colors.grey[300],
//                           child: Padding(
//                               padding: EdgeInsets.fromLTRB(7, 5, 7, 5),
//                               child: Text(widget.categoryName != null
//                                   ? widget.categoryName
//                                   : "")),
//                         )
//                       : SizedBox(),

//                   widget.subcategoryName != null
//                       ? Card(
//                           color: Colors.grey[300],
//                           child: Padding(
//                               padding: EdgeInsets.fromLTRB(7, 5, 7, 5),
//                               child: Text(widget.subcategoryName != null
//                                   ? widget.subcategoryName
//                                   : "")),
//                         )
//                       : SizedBox(),
//                   //  SizedBox(width: 10,),
//                   //  InkWell(
//                   //    onTap: (){
//                   //      Navigator.pop(context);
//                   //    },
//                   //    child: Text("change", style: TextStyle(color:appcolor, fontSize: 14),),
//                   //  )
//                 ],
//               ),
//               SizedBox(
//                 height: 25,
//               ),
//               Text(
//                 titles != null ? titles : "Company Name  / Shop Name",
//                 style: TextStyle(color: black, fontSize: 16),
//               ),
//               TextFormField(
//                 validator: (value) {
//                   if (value.isEmpty) {
//                     return 'Please fill the detail';
//                   }
//                   return null;
//                 },
//                 cursorHeight: 18,
//                 onSaved: (String value) {},
//                 controller: title,
//                 obscureText: false,
//                 // focusNode: AlwaysDisabledFocusNode(),
//                 onTap: () {},
//                 style: TextStyle(
//                   fontSize: 14.0,
//                   color: black,
//                 ),
//                 keyboardType: TextInputType.text,
//                 decoration: textDecoration(titles != null ? titles : "Title"),
//               ),
//               SizedBox(
//                 height: 25,
//               ),
//               Text(
//                 "Owner Name",
//                 style: TextStyle(color: black, fontSize: 16),
//               ),
//               TextFormField(
//                 validator: (value) {
//                   if (value.isEmpty) {
//                     return 'Please fill the detail';
//                   }
//                   return null;
//                 },
//                 cursorHeight: 18,
//                 onSaved: (String value) {},
//                 controller: title,
//                 obscureText: false,
//                 // focusNode: AlwaysDisabledFocusNode(),
//                 onTap: () {},
//                 style: TextStyle(
//                   fontSize: 14.0,
//                   color: black,
//                 ),
//                 keyboardType: TextInputType.text,
//                 decoration: textDecoration("Owner Name"),
//               ),
//               SizedBox(
//                 height: 25,
//               ),
//               Text(
//                 "Mobile No",
//                 style: TextStyle(color: black, fontSize: 16),
//               ),
//               TextFormField(
//                 validator: (value) {
//                   if (value.isEmpty) {
//                     return 'Please fill the detail';
//                   }
//                   return null;
//                 },
//                 cursorHeight: 18,
//                 onSaved: (String value) {},
//                 controller: title,
//                 obscureText: false,
//                 // focusNode: AlwaysDisabledFocusNode(),
//                 onTap: () {},
//                 style: TextStyle(
//                   fontSize: 14.0,
//                   color: black,
//                 ),
//                 keyboardType: TextInputType.text,
//                 decoration: textDecoration("Mobile No"),
//               ),
//               SizedBox(
//                 height: 25,
//               ),
//               Text(
//                 "Email Address",
//                 style: TextStyle(color: black, fontSize: 16),
//               ),
//               TextFormField(
//                 validator: (value) {
//                   if (value.isEmpty) {
//                     return 'Please fill the detail';
//                   }
//                   return null;
//                 },
//                 cursorHeight: 18,
//                 onSaved: (String value) {},
//                 controller: title,
//                 obscureText: false,
//                 // focusNode: AlwaysDisabledFocusNode(),
//                 onTap: () {},
//                 style: TextStyle(
//                   fontSize: 14.0,
//                   color: black,
//                 ),
//                 keyboardType: TextInputType.text,
//                 decoration: textDecoration("Email Address"),
//               ),
//               SizedBox(
//                 height: 25,
//               ),
//               Text(
//                 "Address Line 1",
//                 style: TextStyle(color: black, fontSize: 16),
//               ),
//               TextFormField(
//                 validator: (value) {
//                   if (value.isEmpty) {
//                     return 'Please fill the detail';
//                   }
//                   return null;
//                 },
//                 cursorHeight: 18,
//                 onSaved: (String value) {},
//                 controller: title,
//                 obscureText: false,
//                 // focusNode: AlwaysDisabledFocusNode(),
//                 onTap: () {},
//                 style: TextStyle(
//                   fontSize: 14.0,
//                   color: black,
//                 ),
//                 keyboardType: TextInputType.text,
//                 decoration: textDecoration("Address Line 1"),
//               ),

//               SizedBox(
//                 height: 25,
//               ),
//               Text(
//                 "Address Line 2",
//                 style: TextStyle(color: black, fontSize: 16),
//               ),
//               TextFormField(
//                 validator: (value) {
//                   if (value.isEmpty) {
//                     return 'Please fill the detail';
//                   }
//                   return null;
//                 },
//                 cursorHeight: 18,
//                 onSaved: (String value) {},
//                 controller: title,
//                 obscureText: false,
//                 // focusNode: AlwaysDisabledFocusNode(),
//                 onTap: () {},
//                 style: TextStyle(
//                   fontSize: 14.0,
//                   color: black,
//                 ),
//                 keyboardType: TextInputType.text,
//                 decoration: textDecoration("Address Line 2"),
//               ),
//               SizedBox(
//                 height: 25,
//               ),

//               Text(
//                 "Location *",
//                 style: TextStyle(color: black, fontSize: 16),
//               ),
//               TypeAheadField(
//                 // validator: (value) {
//                 //   if (value.isEmpty) {
//                 //     return 'Please choose location';
//                 //   }
//                 //   return null;
//                 // },
//                 textFieldConfiguration: TextFieldConfiguration(
//                     // autofocus: true,
//                     controller: location,
//                     decoration: textDecoration("Select Location")),
//                 suggestionsCallback: (pattern) async {
//                   return await get_locationData(pattern);
//                 },
//                 itemBuilder: (context, item) {
//                   return list(item);
//                 },
//                 onSuggestionSelected: (item) async {
//                   SharedPreferences sharedPreferences =
//                       await SharedPreferences.getInstance();
//                   setState(() {
//                     location.text = item.city_name;
//                     cityID = item.id;
//                   });
//                   // Navigator.of(context).push(MaterialPageRoute(
//                   //     builder: (context) =>
//                   //         (product: item)));
//                 },
//               ),
//               SizedBox(
//                 height: 25,
//               ),
//               Text(
//                 "Upload Image",
//                 style: TextStyle(color: black, fontSize: 16),
//               ),
//               FlatButton(
//                   color: Colors.grey.shade200,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(7.0),
//                   ),
//                   onPressed: () {
//                     _showPicker(context);
//                   },
//                   child: Text("Choose Image")),
//               // Text(_imageName != null ? _imageName : "", style: TextStyle(color:black, fontSize: 14),),
//               _image != null
//                   ? Image.file(
//                       _image,
//                       height: 100,
//                       width: 100,
//                     )
//                   : SizedBox(),
//               SizedBox(
//                 height: 20,
//               ),
//               Text(
//                 "Business Details",
//                 style: TextStyle(
//                     color: black, fontSize: 24, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(
//                 height: 25,
//               ),
//               Text(
//                 "In Business Since",
//                 style: TextStyle(color: black, fontSize: 16),
//               ),
//               TextFormField(
//                 validator: (value) {
//                   if (value.isEmpty) {
//                     return 'Please fill the detail';
//                   }
//                   return null;
//                 },
//                 cursorHeight: 18,
//                 onSaved: (String value) {},
//                 controller: title,
//                 obscureText: false,
//                 // focusNode: AlwaysDisabledFocusNode(),
//                 onTap: () {},
//                 style: TextStyle(
//                   fontSize: 14.0,
//                   color: black,
//                 ),
//                 keyboardType: TextInputType.text,
//                 decoration: textDecoration("In Business Since"),
//               ),
//               SizedBox(
//                 height: 25,
//               ),
//               Text(
//                 "Description *",
//                 style: TextStyle(color: black, fontSize: 16),
//               ),
//               TextFormField(
//                 validator: (value) {
//                   if (value.isEmpty) {
//                     return 'Please fill the detail';
//                   }
//                   return null;
//                 },
//                 cursorHeight: 18,
//                 onSaved: (String value) {},
//                 controller: description,
//                 obscureText: false,
//                 // focusNode: AlwaysDisabledFocusNode(),
//                 maxLines: 10,
//                 minLines: 1,
//                 onTap: () {},
//                 style: TextStyle(
//                   fontSize: 14.0,
//                   color: black,
//                 ),
//                 keyboardType: TextInputType.multiline,
//                 decoration: textDecoration('Description'),
//               ),
//               SizedBox(
//                 height: 25,
//               ),
//               WeekdaySelector(
//                 onChanged: (int day) {
//                   setState(() {
//                     // Use module % 7 as Sunday's index in the array is 0 and
//                     // DateTime.sunday constant integer value is 7.
//                     final index = day % 7;
//                     // We "flip" the value in this example, but you may also
//                     // perform validation, a DB write, an HTTP call or anything
//                     // else before you actually flip the value,
//                     // it's up to your app's needs.
//                     values[index] = !values[index];
//                   });
//                 },
//                 values: values,
//               ),

//               ButtonTheme(
//                 buttonColor: appcolor,
//                 minWidth: 400,
//                 child: FlatButton(
//                   color: appcolor,
//                   padding: EdgeInsets.fromLTRB(13, 8, 13, 8),
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(0.0),
//                       side: BorderSide(color: appcolor)),
//                   onPressed: () async {
//                     if (_formKey.currentState.validate()) {
//                       _formKey.currentState.save();
//                       if (_imagefileName != null && cityID != null) {
//                         if (enalbleBtn == true) {
//                           postADs(
//                             title.text,
//                             description.text,
//                             serviceType.text,
//                             price.text,
//                             "$doorStep",
//                             cityID,
//                           );
//                           setState(() {
//                             enalbleBtn = false;
//                           });

//                           print("ads added");
//                         } else {
//                           setState(() {
//                             enalbleBtn = false;
//                           });
//                           Navigator.pop(context);
//                           print("error");
//                         }
//                       } else {
//                         _alerBox();
//                       }
//                     }
//                   },
//                   child: enalbleBtn == true
//                       ? Text(
//                           "NEXT",
//                           style: TextStyle(
//                               fontSize: 20,
//                               fontWeight: FontWeight.w600,
//                               color: white),
//                         )
//                       : CircularProgressIndicator(
//                           backgroundColor: white,
//                           valueColor:
//                               new AlwaysStoppedAnimation<Color>(appcolor),
//                         ),
//                 ),
//               ),

//               SizedBox(
//                 height: 15,
//               ),
//             ],
//           ),
//         ),
//       )),
//     );
//   }

//   void _showPicker(context) {
//     showModalBottomSheet(
//         context: context,
//         builder: (BuildContext bc) {
//           return SafeArea(
//             child: Container(
//               child: new Wrap(
//                 children: <Widget>[
//                   new ListTile(
//                       leading: new Icon(Icons.photo_library),
//                       title: new Text('Photo Gallery'),
//                       onTap: () {
//                         // open_gallery();
//                         loadAssets();
//                         Navigator.of(context).pop();
//                       }),
//                   new ListTile(
//                     leading: new Icon(Icons.photo_camera),
//                     title: new Text('Camera'),
//                     onTap: () {
//                       open_camera();
//                       Navigator.of(context).pop();
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           );
//         });
//   }
// }
