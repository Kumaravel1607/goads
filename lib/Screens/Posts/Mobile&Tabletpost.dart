import 'package:flutter/material.dart';
import 'package:services/Constant/Colors.dart';
import 'package:services/Widgets/ElevatedButton.dart';

class MobilePost extends StatefulWidget {
  MobilePost({Key key}) : super(key: key);

  @override
  _MobilePostState createState() => _MobilePostState();
}

class _MobilePostState extends State<MobilePost> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final TextEditingController model = new TextEditingController();
  final TextEditingController yearOfRegister = new TextEditingController();
  final TextEditingController price = new TextEditingController();

  String condition;
  String brand;
  String fuelType;
  String mobileTab;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: appcolor,
        title: Text(
          "Mobile and Tablet",
          style: TextStyle(color: white),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  decoration:
                      textInputDecoration('Product Type', "Product Type *"),
                  style: TextStyle(fontSize: 14),
                  items: <String>[
                    'Mobile',
                    'Tablet',
                  ]
                      .map((String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(
                                color: color2,
                                fontSize: 15,
                              ),
                            ),
                          ))
                      .toList(),
                  onChanged: (newValue) {
                    setState(() {
                      mobileTab = newValue;
                    });
                  },
                  validator: (value) => value == null ? 'Product Type' : null,
                ),
                SizedBox(
                  height: 15,
                ),
                DropdownButtonFormField<String>(
                  decoration: textInputDecoration('brand *', "Brand *"),
                  style: TextStyle(fontSize: 14),
                  items: <String>[
                    'Samsung',
                    'Redmi',
                    'Oppo',
                    'Vivo',
                    'Apple',
                  ]
                      .map((String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(
                                color: color2,
                                fontSize: 15,
                              ),
                            ),
                          ))
                      .toList(),
                  onChanged: (newValue) {
                    setState(() {
                      brand = newValue;
                    });
                  },
                  validator: (value) => value == null ? 'Select brand ' : null,
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter mobile model';
                    }
                    return null;
                  },
                  onSaved: (String value) {},
                  controller: model,
                  onTap: () {},
                  style: TextStyle(
                    fontSize: 14.0,
                    color: black,
                  ),
                  keyboardType: TextInputType.text,
                  decoration: textInputDecoration(
                    'Enter mobile Model ',
                    'Model *',
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Enter car Purchasing year';
                    }
                    return null;
                  },
                  onSaved: (String value) {},
                  controller: yearOfRegister,
                  onTap: () {},
                  style: TextStyle(
                    fontSize: 14.0,
                    color: black,
                  ),
                  keyboardType: TextInputType.number,
                  decoration: textInputDecoration(
                    'Enter mobile purchase Year ',
                    'Purchase Year *',
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                DropdownButtonFormField<String>(
                  decoration: textInputDecoration('Condition', "Condition *"),
                  style: TextStyle(fontSize: 14),
                  items: <String>[
                    'New',
                    'Like New',
                    'Good',
                    'Fair',
                  ]
                      .map((String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(
                                color: color2,
                                fontSize: 15,
                              ),
                            ),
                          ))
                      .toList(),
                  onChanged: (newValue) {
                    setState(() {
                      condition = newValue;
                    });
                  },
                  validator: (value) =>
                      value == null ? 'Select mobile condition ' : null,
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Enter mobile price';
                    }
                    return null;
                  },
                  onSaved: (String value) {},
                  controller: price,
                  onTap: () {},
                  style: TextStyle(
                    fontSize: 14.0,
                    color: black,
                  ),
                  keyboardType: TextInputType.text,
                  decoration: textInputDecoration(
                    'Enter mobile price ',
                    'Price *',
                  ),
                ),
                SizedBox(
                  height: 50,
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
      ),
    );
  }

  void submitButton() {}
}
