import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:services/Constant/Colors.dart';
import 'package:services/Constant/api.dart';
import 'package:services/Screens/AddPost.dart';
import 'package:services/Widgets/ElevatedButton.dart';
import 'package:services/Widgets/LoadingWidget.dart';

class LandsAndPlot extends StatefulWidget {
  final String subcat_type;
  final String cat_id;
  final String subcat_id;
  LandsAndPlot({Key key, this.subcat_type, this.cat_id, this.subcat_id})
      : super(key: key);

  @override
  _LandsAndPlotState createState() => _LandsAndPlotState();
}

class _LandsAndPlotState extends State<LandsAndPlot> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final TextEditingController plotArea = new TextEditingController();
  final TextEditingController length = new TextEditingController();
  final TextEditingController breadth = new TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String type;
  String addListedBY;
  String facing;
  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDropdownValues();
  }

  List typeList = List();
  List facingList = List();
  List addListedBYList = List();

  Future<String> getDropdownValues() async {
    Map data = {
      'attribute_id': "lands-and-plot",
    };
    var res =
        await http.post(Uri.parse(app_api + "/attribute_mutiple"), body: data);
    if (res.statusCode == 200) {
      var resBody = (json.decode(res.body));
      print("---------------NK-----------------");
      print(resBody);
      setState(() {
        _isLoading = true;
        facingList = resBody['facing'];
        typeList = resBody['lands-and-plot-type'];
        addListedBYList = resBody['listed-by'];
      });
      // print(allBrands);
      return "Success";
    } else {
      print("error");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appcolor,
        title: Text(
          "Lands And Plots",
          style: TextStyle(color: white),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: white),
      ),
      body: _isLoading
          ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      DropdownButtonFormField<String>(
                        decoration: textInputDecoration('Type', "Type *"),
                        style: TextStyle(fontSize: 14),
                        items: typeList.map((item) {
                          return DropdownMenuItem<String>(
                            value: item["id"].toString(),
                            child: new Text(
                              item['attribute_list_name'],
                              style: TextStyle(
                                color: color2,
                                fontSize: 15,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            type = newValue;
                          });
                        },
                        validator: (value) =>
                            value == null ? 'Select type ' : null,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      DropdownButtonFormField<String>(
                        decoration:
                            textInputDecoration('Listed By', "Listed By *"),
                        style: TextStyle(fontSize: 14),
                        items: addListedBYList.map((item) {
                          return DropdownMenuItem<String>(
                            value: item["id"].toString(),
                            child: new Text(
                              item['attribute_list_name'],
                              style: TextStyle(
                                color: color2,
                                fontSize: 15,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            addListedBY = newValue;
                          });
                        },
                        validator: (value) =>
                            value == null ? 'Select listed by ' : null,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Enter Plot Area';
                          }
                          return null;
                        },
                        onSaved: (String value) {},
                        controller: plotArea,
                        onTap: () {},
                        style: TextStyle(
                          fontSize: 14.0,
                          color: black,
                        ),
                        keyboardType: TextInputType.text,
                        decoration: textInputDecoration(
                          'Plot Area ',
                          'Plot Area *',
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Enter Length ';
                          }
                          return null;
                        },
                        onSaved: (String value) {},
                        controller: length,
                        onTap: () {},
                        style: TextStyle(
                          fontSize: 14.0,
                          color: black,
                        ),
                        keyboardType: TextInputType.text,
                        decoration: textInputDecoration(
                          'Enter Length ',
                          'Length *',
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter breadth';
                          }
                          return null;
                        },
                        onSaved: (String value) {},
                        controller: breadth,
                        onTap: () {},
                        style: TextStyle(
                          fontSize: 14.0,
                          color: black,
                        ),
                        keyboardType: TextInputType.text,
                        decoration: textInputDecoration(
                          'Enter breadth ',
                          'Breadth *',
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      DropdownButtonFormField<String>(
                        decoration: textInputDecoration('Facing', "Facing *"),
                        style: TextStyle(fontSize: 14),
                        items: facingList.map((item) {
                          return DropdownMenuItem<String>(
                            value: item["id"].toString(),
                            child: new Text(
                              item['attribute_list_name'],
                              style: TextStyle(
                                color: color2,
                                fontSize: 15,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            facing = newValue;
                          });
                        },
                        validator: (value) =>
                            value == null ? 'Select Facing ' : null,
                      ),
                      SizedBox(
                        height: 60,
                      ),
                      Center(
                        child: Container(
                            width: MediaQuery.of(context).size.width * 0.90,
                            child: ElevatedBtn(submitButton, "Next")),
                      )
                    ],
                  ),
                ),
              ),
            )
          : FullScreenLoading(),
    );
  }

  void submitButton() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      Map landData = {
        'sub_category_type': widget.subcat_type,
        'property_type': type,
        'listed_by': addListedBY,
        'plot_area': plotArea.text,
        'length': length.text,
        'breadth': breadth.text,
        'facing': facing,
      };

      print(landData);
      Navigator.of(context, rootNavigator: true).pushReplacement(
          CupertinoPageRoute(
              builder: (_) => AddPostsPage(
                  categoryID: widget.cat_id.toString(),
                  subcategoryID: widget.subcat_id,
                  mapdata: landData,
                  subcategoryName: widget.subcat_type,
                  productType: widget.subcat_type)));
    }
  }
}
