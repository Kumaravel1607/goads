
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:services/Constant/Colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';

class TestPage extends StatefulWidget {
  final String project_id;
  TestPage({
    Key key,
    this.project_id,
  }) : super(key: key);
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = false;
  int iperate_ID;

  List<Asset> images = List<Asset>();
  String _error;
  bool _isUploading = false;

  SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();
    operateID();
  }

  operateID() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      iperate_ID = sharedPreferences.getInt("operator_id");
    });
  }

  Future<void> _alerDialog(message) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(message),
            //title: Text(),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.pop(context, "ok");
                },
                child: const Text("OK"),
              )
            ],
          );
        });
  }

  String imageData;
  String imageName;

  var imageList = List();
  var imageListName = List();

  Future<void> loadAssets() async {
    setState(() {
      images = List<Asset>();
    });

    List<Asset> resultList;
    String error;

    try {
      resultList = await MultiImagePicker.pickImages(
          // selectedAssets: images,
          maxImages: 300,
          materialOptions: MaterialOptions(
            // actionBarColor: "#abcdef",
            actionBarTitle: "Upload Image",
            allViewTitle: "All Photos",
            useDetailsView: false,
            selectCircleStrokeColor: "#000000",
          ));
      // print('-------------------');
      // print(resultList.length);
      // print((await resultList[0].getThumbByteData(122, 100)));
      // print((await resultList[0].getByteData()));
      // print((await resultList[0].metadata));
      // print('-------------------');
    } on Exception catch (e) {
      error = e.toString();
    }

    for (var asset in resultList) {
      int MAX_WIDTH = 500; //keep ratio
      int height = ((500 * asset.originalHeight) / asset.originalWidth).round();

      ByteData byteData =
          await asset.requestThumbnail(MAX_WIDTH, height, quality: 80);

      String byteDatas = await asset.name.toString();

      // print(byteData);

      if (byteData != null) {
        imageData = base64Encode(byteData.buffer.asUint8List());
        imageName = byteDatas;

        imageList.add(imageData);
        imageListName.add(imageName);
        // print("-------------------");
        // print(imageList);
        // print("yyyyyyyyyyyy");
        // print(imageName);
        // print("--------------kk");
      }
    }

    setState(() {
      _isUploading = true;

      var stringListName = imageListName.join(", ");
      var stringListPath = imageList.join(", ");

      // upload_image(stringListName, stringListPath);

      // print("-------------------");
      // print(stringListName);
      // print("yyyyyyyyyyyy");
      // print(stringListPath);
      // print("--------------kk");
    });

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
      if (error == null) _error = 'No Error Dectected';
    });
  }

  // upload_image(
  //   imagename,
  //   imagepath,
  // ) async {
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   Map data = {
  //     'project_id': widget.project_id,
  //     'image_name': imagename,
  //     'image_path': imagepath,
  //   };
  //   print("-------------------");
  //   print(data);
  //   var jsonResponse = null;
  //   var response = await http.post(api_url + "/add_project_image", body: data);
  //   // jsonResponse = json.decode(response.body);

  //   if (response.statusCode == 200) {
  //     jsonResponse = json.decode(response.body);
  //     if (jsonResponse != null) {
  //       setState(() {
  //         _isLoading = false;
  //       });
  //       _alerDialog(jsonResponse['message']);
  //     }
  //   } else {
  //     jsonResponse = json.decode(response.body);
  //     _alerDialog(jsonResponse['message']);
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   }
  // }

  Widget buildGridView() {
    if (images != null)
      return GridView.count(
        crossAxisCount: 1,
        mainAxisSpacing: 10,
        children: List.generate(images.length, (index) {
          Asset asset = images[index];
          return AssetThumb(
            asset: asset,
            width: 300,
            height: 300,
          );
        }),
      );
    else
      return Container(color: Colors.white);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: appcolor,
        title: Text("Add Project Gallary",
            style: TextStyle(
              color: Colors.white,
            )),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(children: [
            SizedBox(
              height: 25,
            ),
            uploadBtn(),
            SizedBox(
              height: 15,
            ),
            Expanded(
              child: buildGridView(),
            ),
            // Expanded(
            //     child: Container(
            //   child: ListView.builder(
            //       scrollDirection: Axis.vertical,
            //       itemCount: _filePath.length,
            //       itemBuilder: (context, c) {
            //         return Card(
            //           child: Image.file(
            //             _filePath[c],
            //             fit: BoxFit.fill,
            //             width: 400,
            //             height: 400,
            //           ),
            //         );
            //       }),
            // )),
          ]),
        ),
      ),
    );
  }

  Widget uploadBtn() => ButtonTheme(
        minWidth: MediaQuery.of(context).size.width,
        child: RaisedButton(
          color: appcolor,
          padding: EdgeInsets.only(top: 12, bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0.0),
          ),
          child: Text(
            'Upload Gallary',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          textColor: Color(0xFFFFFFFF),
          onPressed: loadAssets,
        ),
      );
}
