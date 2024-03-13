import 'package:flutter/material.dart';
import 'package:services/Constant/Colors.dart';
import 'package:bubble/bubble.dart';
import 'package:http/http.dart' as http;
import 'package:services/Constant/api.dart';
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:services/Model/chat_list_model.dart';

class ChatScreen extends StatefulWidget {
  final String adsId;
  // final String receiverID;
  final String user_name;
  final String sendID;
  final String receiveID;

  ChatScreen({Key key, this.adsId, this.user_name, this.sendID, this.receiveID})
      : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController message = new TextEditingController();
  ScrollController controller;
  Timer timer;

  @override
  void initState() {
    controller = new ScrollController();
    chat_history();
    // timer = Timer.periodic(Duration(seconds: 4), (Timer t) => chat_history());
    // timer = Timer.periodic(Duration(seconds: 2), (Timer t) => controller
    //       .jumpTo(controller.position.maxScrollExtent));
    ads_detail();
    // controller.addListener(_scrollListener);
    super.initState();
    // controller.animateTo(controller.position.maxScrollExtent, curve: null, duration: null);
    timer = Timer.periodic(
        Duration(milliseconds: 2000), (Timer t) => chat_history());

    Timer(Duration(milliseconds: 2100),
        () => controller.jumpTo(controller.position.maxScrollExtent));
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  bool _isLoading = true;

  String sender;
  // String fromID;
  // String toID;

  _scrollListener() {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  Future<ChatAdsDetail> ads_detail() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'ads_id': widget.adsId,
      'customer_id': sharedPreferences.getString("user_id"),
    };
    // print(data);
    print('Sender and reviver id');
    print(widget.sendID + " and " + widget.receiveID);
    var jsonResponse;
    var response =
        await http.post(Uri.parse(app_api + '/chat_history'), body: data);
    // jsonResponse = json.decode(response.body)['ads'];
    if (response.statusCode == 200) {
      setState(() {
        _isLoading = false;
      });
      controller.jumpTo(controller.position.maxScrollExtent);
      jsonResponse = json.decode(response.body)['ads'];

      // fromID = (jsonResponse['from_id'].toString());
      // toID = (jsonResponse['to_id'].toString());

      // print(fromID+toID+"NK");
      return ChatAdsDetail.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load post');
    }
  }

  void chat_history() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'ads_id': widget.adsId,
      'customer_id': widget.sendID,
      'receiver_id': widget.receiveID,
    };
    var jsonResponse;
    var response =
        await http.post(Uri.parse(app_api + '/chat_history'), body: data);

    if (response.statusCode == 200) {
      setState(() {
        // _isLoading = false;
        sender = sharedPreferences.getString("user_id");
      });
      chatHistory(json.decode(response.body)['chats']).then((value) {
        setState(() {
          chatList = value;
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

  List<ChatHistory> chatList = List<ChatHistory>();

  Future<List<ChatHistory>> chatHistory(chatsJson) async {
    var allchats = List<ChatHistory>();
    for (var chatJson in chatsJson) {
      allchats.add(ChatHistory.fromJson(chatJson));
    }
    return allchats;
  }

  send_message(msg) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'ads_id': widget.adsId,
      'sender_id': widget.sendID,
      'receiver_id': widget.receiveID,
      'message': msg,
    };
    var jsonResponse;
    var response =
        await http.post(Uri.parse(app_api + '/send_message'), body: data);
    if (response.statusCode == 200) {
      // setState(() {
      //   chat_history();
      //   controller.jumpTo(controller.position.maxScrollExtent);
      // });
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
    await Future.delayed(Duration(milliseconds: 1000));

    // _refreshController.refreshCompleted();
    chat_history();
    _refreshController.refreshToIdle();
  }

  void _onLoading() async {
    await Future.delayed(Duration(milliseconds: 1000));
    if (mounted) setState(() {});
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;
    double px = 1 / pixelRatio;

    BubbleStyle styleSomebody = BubbleStyle(
      nip: BubbleNip.leftTop,
      color: Colors.white,
      elevation: 1 * px,
      margin: BubbleEdges.only(top: 8.0, right: 50.0),
      alignment: Alignment.topLeft,
    );
    BubbleStyle styleMe = BubbleStyle(
      nip: BubbleNip.rightTop,
      color: Color.fromARGB(255, 225, 255, 199),
      elevation: 1 * px,
      margin: BubbleEdges.only(top: 8.0, left: 50.0),
      alignment: Alignment.topRight,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appcolor,
        title: Text(widget.user_name != null ? widget.user_name : "User Name"),
        centerTitle: true,
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
        // actions: [
        //   IconButton(icon: Icon(Icons.more_vert, color: white), onPressed: null)
        // ],
      ),
      body: Stack(
        children: [
          Column(children: [
            FutureBuilder<ChatAdsDetail>(
                future: ads_detail(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Padding(
                      padding: EdgeInsets.all(7),
                      child: Card(
                        elevation: 5.0,
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Row(
                            children: [
                              Container(
                                height: 60,
                                width: 75,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image:
                                        NetworkImage(snapshot.data.ads_image),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    snapshot.data.ads_name,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  // Text("Palcode, Dharmapuri",textAlign: TextAlign.center, style: TextStyle( color: appcolor, fontSize: 10, fontWeight: FontWeight.w500),),
                                  snapshot.data.service_type == "3"
                                      ? Text(
                                          snapshot.data.ads_price != null
                                              ? snapshot.data.ads_price
                                              : "",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                        )
                                      : SizedBox(),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Container(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        backgroundColor: appcolor,
                        valueColor: new AlwaysStoppedAnimation<Color>(white),
                      ),
                    );
                  }
                }),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 70),
                child: SmartRefresher(
                  enablePullDown: true,
                  enablePullUp: false,
                  header: MaterialClassicHeader(),
                  controller: _refreshController,
                  onRefresh: _onRefresh,
                  onLoading: _onLoading,
                  child: new ListView.builder(
                      controller: controller,
                      shrinkWrap: false,
                      reverse: false,
                      scrollDirection: Axis.vertical,
                      itemCount: chatList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                          child: Column(
                            children: [
                              sender != chatList[index].sender_id
                                  ? Bubble(
                                      style: styleSomebody,
                                      child: Text(chatList[index].message),
                                    )
                                  : SizedBox(),
                              sender == chatList[index].sender_id
                                  ? Bubble(
                                      style: styleMe,
                                      child: Text(chatList[index].message),
                                    )
                                  : SizedBox(),
                            ],
                          ),
                        );
                      }),
                ),
              ),
            ),
          ]),
          Container(
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.symmetric(vertical: 0),
            child: Container(
              alignment: Alignment.bottomCenter,
              padding: EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 5),
              height: 60,
              child: TextField(
                cursorHeight: 18,
                // onSaved: (String value) {},
                controller: message,
                obscureText: false,
                onTap: () {
                  Timer(
                      Duration(seconds: 1),
                      () => controller
                          .jumpTo(controller.position.maxScrollExtent));
                },
                onSubmitted: (newValue) {
                  Timer(
                      Duration(seconds: 1),
                      () => controller
                          .jumpTo(controller.position.maxScrollExtent));
                },
                style: TextStyle(
                  fontSize: 14.0,
                  color: black,
                ),
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  fillColor: white,
                  filled: true,
                  contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                  prefixIcon: Icon(
                    Icons.keyboard,
                    color: appcolor,
                  ),
                  suffixIcon: IconButton(
                      splashRadius: 32,
                      icon: Icon(
                        Icons.send,
                        color: appcolor,
                      ),
                      padding: EdgeInsets.all(0),
                      onPressed: () {
                        message.text.isNotEmpty
                            ? send_message(message.text)
                            : () {};

                        message.clear();
                      }),
                  hintText: ("Type a message"),
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 16.0,
                  ),
                  border: new OutlineInputBorder(
                    borderSide: new BorderSide(color: appcolor, width: 0.5),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  focusedErrorBorder: new OutlineInputBorder(
                    borderSide: BorderSide(color: appcolor, width: 0.5),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  errorBorder: new OutlineInputBorder(
                    borderSide: new BorderSide(color: appcolor, width: 1.5),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: appcolor, width: 0.5),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: appcolor, width: 0.5),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
