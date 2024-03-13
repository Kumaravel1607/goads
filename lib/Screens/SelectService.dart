import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:services/Constant/Colors.dart';

import 'CategoryPage.dart';
import 'Posts/JobPost.dart';

class SelectService extends StatefulWidget {
  SelectService({Key key, bool rootNavigator}) : super(key: key);

  @override
  _SelectServiceState createState() => _SelectServiceState();
}

class _SelectServiceState extends State<SelectService>
    with TickerProviderStateMixin {
  String main_catergory;

  AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        duration: const Duration(milliseconds: 700), vsync: this);
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    super.dispose();
    this._controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      // appBar: AppBar(
      //   backgroundColor: appcolor,
      //   title: Text(
      //     "Our Services",
      //     style: TextStyle(color: white),
      //   ),
      //   centerTitle: true,
      //   //  leading: IconButton(icon: Icon(Icons.arrow_back),
      //   // onPressed: (){
      //   //   // Navigator.pop(context);
      //   // }),
      // ),
      body: Padding(
        padding: EdgeInsets.all(20),
        //  child: Container(
        //    alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Select Our Services",
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontSize: 20, color: black, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 45,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(flex: 1, child: category()),
                Expanded(flex: 1, child: category2()),
              ],
            ),
            SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(flex: 1, child: category3()),
                Expanded(flex: 1, child: category4())
              ],
            ),
            // Row(
            //   children: [
            //     Expanded(
            //       flex: 2,
            //       child:InkWell(
            //         onTap: (){
            //           Navigator.push(
            //             context,
            //             MaterialPageRoute(
            //                 builder: (BuildContext context) =>
            //                     CategoryPage()));
            //         },
            //         child:Container(
            //         decoration: BoxDecoration(
            //           color: Colors.grey[200],
            //           borderRadius: BorderRadius.circular(10)),
            //         height: 200,
            //         child: Column(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           crossAxisAlignment: CrossAxisAlignment.center,
            //           children: [
            //             Image.asset("assets/images/service.png", height: 80,width: 80,),
            //             SizedBox(height: 10,),
            //             Text(
            //         "SERVICES",
            //         style: TextStyle(
            //             fontSize: 18,
            //             color: black,
            //             fontWeight: FontWeight.w500),
            //       ),
            //           ],)
            //       ),),
            //       ),
            //       SizedBox(width: 20,),
            //       Expanded(
            //       flex: 2,
            //       child:InkWell(
            //         onTap: (){
            //           Navigator.push(
            //             context,
            //             MaterialPageRoute(
            //                 builder: (BuildContext context) =>
            //                     CategoryPage()));
            //         },
            //         child: Container(
            //         decoration: BoxDecoration(
            //           color: Colors.grey[200],
            //           borderRadius: BorderRadius.circular(10)),
            //         height: 200,
            //         child: Column(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           crossAxisAlignment: CrossAxisAlignment.center,
            //           children: [
            //             Image.asset("assets/images/sale.png", height: 80,width: 80,),
            //             SizedBox(height: 10,),
            //             Text(
            //         "SALES",
            //         style: TextStyle(
            //             fontSize: 18,
            //             color: black,
            //             fontWeight: FontWeight.w500),
            //       ),
            //           ],),
            //       ),
            //       ),
            //       ),
            //   ],
            // ),
          ],
          //  ),
        ),
      ),
    );
  }

  Widget category() {
    // return  ListView.builder(
    //             itemBuilder: (BuildContext context, int index) {
    return Padding(
      padding: EdgeInsets.only(
        top: 15,
        bottom: 15,
      ),
      child: GestureDetector(
        onTap: () {
          // setState(() {
          //   main_catergory = "1";
          // });
          Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
              builder: (BuildContext context) => CategoryPage(
                    main_catergory: "1",
                    addpost: "0",
                    title: "Repair & Services",
                  )));
        },
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(15),
              height: 95,
              width: 100,
              decoration: container_shadow(),
              child: Image.asset(
                "assets/images/services.png",
              ),
            ),
            SizedBox(
              height: 13,
            ),
            Text(
              'Repair & Services',
              style: TextStyle(
                  color: color2, fontSize: 14, fontWeight: FontWeight.w600),
            )
          ],
        ),
      ),
    );
    //    },
    //    itemCount: category_list == null ? 0 : category_list.length,
    // );
  }

  Widget category2() {
    return Padding(
      padding: EdgeInsets.only(
        top: 15,
        bottom: 15,
      ),
      child: GestureDetector(
        onTap: () {
          setState(() {
            main_catergory = "2";
          });
          Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
              builder: (BuildContext context) => CategoryPage(
                    main_catergory: "2",
                    addpost: "0",
                    title: "Business",
                  )));
        },
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(15),
              height: 95,
              width: 100,
              decoration: container_shadow(),
              child: Image.asset(
                "assets/images/business.png",
              ),
            ),
            SizedBox(
              height: 13,
            ),
            Text(
              'Business',
              style: TextStyle(
                  color: color2, fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget category3() {
    return Padding(
      padding: EdgeInsets.only(
        top: 15,
        bottom: 15,
      ),
      child: GestureDetector(
        onTap: () {
          setState(() {
            main_catergory = "3";
          });
          Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
              builder: (BuildContext context) => CategoryPage(
                    main_catergory: "3",
                    addpost: "1",
                    title: "Sell",
                  )));
        },
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(15),
              height: 95,
              width: 100,
              decoration: container_shadow(),
              child: Image.asset(
                "assets/images/buy.png",
              ),
            ),
            SizedBox(
              height: 13,
            ),
            Text(
              'Sell Your Product',
              style: TextStyle(
                  color: color2, fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget category4() {
    return Padding(
      padding: EdgeInsets.only(
        top: 15,
        bottom: 15,
      ),
      child: GestureDetector(
        onTap: () {
          setState(() {
            main_catergory = "4";
          });
          Navigator.of(context, rootNavigator: true).push(CupertinoPageRoute(
              builder: (_) => JobPost(
                    subcat_type: "categoryList[index].category_type",
                    cat_id: "categoryList[index].id",
                    mainCategory: "4",
                  )));
        },
        child: Column(
          children: [
            // Stack(children: <Widget>[
            //   Align(
            //     child: ScaleTransition(
            //       scale: Tween(begin: 0.45, end: 2.0).animate(CurvedAnimation(
            //           parent: _controller, curve: Curves.elasticOut)),
            //       child:
            Container(
              padding: EdgeInsets.all(17),
              height: 95,
              width: 100,
              decoration: container_shadow(),
              child: Image.asset(
                "assets/images/jobs.png",
              ),
            ),
            //     ),
            //   ),
            // ]),
            SizedBox(
              height: 13,
            ),
            Text(
              'Find Job (or) Hire',
              style: TextStyle(
                  color: color2, fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  container_shadow() => BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.cyan[200],
          offset: const Offset(
            5.0,
            5.0,
          ),
          blurRadius: 10.0,
          spreadRadius: 2.0,
        ), //BoxShadow
        BoxShadow(
          color: Colors.white,
          offset: const Offset(0.0, 0.0),
          blurRadius: 0.0,
          spreadRadius: 0.0,
        ), //BoxShadow
      ], color: white, borderRadius: BorderRadius.circular(30));
}

// class Avatar extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() => _Avatar();
// }

// class _Avatar extends State<Avatar> with TickerProviderStateMixin {
//   AnimationController _controller;

//   @override
//   void initState() {
//     super.initState();

//     _controller = AnimationController(
//         duration: const Duration(milliseconds: 700), vsync: this);
//     _controller.repeat(reverse: true);
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     this._controller.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: <Widget>[
//           Align(
//             child: ScaleTransition(
//               scale: Tween(begin: 0.75, end: 2.0).animate(CurvedAnimation(
//                   parent: _controller, curve: Curves.elasticOut)),
//               child: SizedBox(
//                 height: 100,
//                 width: 100,
//                 child: CircleAvatar(
//                     backgroundImage: AssetImage("assets/images/job.png")),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
