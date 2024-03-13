import 'package:flutter/material.dart';
import 'package:services/Constant/Colors.dart';

import 'package:http/http.dart' as http;
import 'package:services/Constant/api.dart';
import 'package:services/Model/chat_list_model.dart';
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'ChatScreen.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ChatListPage extends StatefulWidget {
  ChatListPage({Key key}) : super(key: key);

  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    chat_list();
  }

  String uID;
  void chat_list() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'customer_id': sharedPreferences.getString("user_id"),
    };
    var jsonResponse;
    var response =
        await http.post(Uri.parse(app_api + '/chat_list'), body: data);

    if (response.statusCode == 200) {
      setState(() {
        _isLoading = false;
      });

      uID = sharedPreferences.getString("user_id");
      get_chatList(json.decode(response.body)).then((value) {
        setState(() {
          chatList = value;
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

  List<ChatList> chatList = List<ChatList>();

  Future<List<ChatList>> get_chatList(chatsJson) async {
    var chats = List<ChatList>();
    for (var chatJson in chatsJson) {
      chats.add(ChatList.fromJson(chatJson));
    }
    return chats;
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshToIdle();
    chat_list();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: appcolor,
        title: Text(
          "Chat List",
          style: TextStyle(color: white, fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: WaterDropHeader(),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: chatList.length != 0
            ? new ListView.builder(
                shrinkWrap: false,
                scrollDirection: Axis.vertical,
                itemCount: chatList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(
                            chatList[index].display_name,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 18,
                                color: black,
                                fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            chatList[index].ads_name,
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500),
                          ),
                          leading: Container(
                            padding: EdgeInsets.all(2),
                            height: 47,
                            width: 47,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: chatList[index].ads_image != null
                                        ? NetworkImage(
                                            chatList[index].ads_image)
                                        : AssetImage(
                                            'assets/images/user.png'))),
                          ),
                          trailing: Text(
                            chatList[index].display_time != null
                                ? chatList[index].display_time
                                : "",
                            style: TextStyle(color: Colors.grey, fontSize: 10),
                          ),
                          onTap: () {
                            Navigator.of(context, rootNavigator: true).push(
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        ChatScreen(
                                          adsId: chatList[index].ads_id,
                                          // receiverID: chatList[index].receiver_id
                                          user_name:
                                              chatList[index].display_name,
                                          sendID: uID,
                                          receiveID:
                                              chatList[index].sender_id != uID
                                                  ? chatList[index].sender_id
                                                  : chatList[index].receiver_id,
                                        )));
                            // print("sendID"+ chatList[index].receiver_id,);
                            // print("receiveID"+ chatList[index].sender_id,);
                          },
                        ),
                        divider2(),
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
                      "No data found...",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
      ),
    );
  }
}
