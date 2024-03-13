import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Screens/ChatList.dart';
import 'Screens/NotificationPage.dart';
import 'Screens/SplashScreen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  HttpOverrides.global = new MyHttpOverrides();
  runApp(
    MaterialApp(
        debugShowCheckedModeBanner: false,
        home: new MyApp(),
        routes: <String, WidgetBuilder>{
          "/Notification": (BuildContext context) => new NotificationPage(),
          "/Chat": (BuildContext context) => new ChatListPage(),
        }),
  );
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  SharedPreferences sharedPreferences;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    // getMessage();
    super.initState();
  }

  // void _navigateToItemDetail(Map<String, dynamic> message) {
  //   //  final String pagechooser= message['data']['status'];
  //   // Navigator.pushNamed(context, pagechooser);
  //   if (message['data']['status'] == "/Notification") {
  //     Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
  //       builder: (context) => NotificationPage(),
  //     ));
  //   } else {
  //     Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
  //       builder: (context) => ChatListPage(),
  //     ));
  //   }
  //   //   switch (message['data']['status']) {
  //   //   case "/Notification":
  //   //     Navigator.of(context, rootNavigator: true).push(
  //   //     MaterialPageRoute(
  //   //       builder: (context) => NotificationPage(),
  //   //     )
  //   //     );
  //   //     break;
  //   //   default:
  //   //      Navigator.of(context, rootNavigator: true).push(
  //   //       MaterialPageRoute(
  //   //         builder: (context) => ChatListPage(),
  //   //       )
  //   //       );
  //   //     break;
  //   // }
  // }

  // Future<void> getMessage() async {
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   _firebaseMessaging.configure(
  //       onMessage: (Map<String, dynamic> message) async {
  //     print('onMessage: $message');
  //     //  if(sharedPreferences.getString("user_id") != null){
  //     //   _navigateToItemDetail(message);
  //     //   }
  //   }, onLaunch: (Map<String, dynamic> message) async {
  //     print('onLaunch: $message');
  //     if (sharedPreferences.getString("user_id") != null) {
  //       _navigateToItemDetail(message);
  //     }
  //   }, onResume: (Map<String, dynamic> message) async {
  //     print('onResume: $message');
  //     if (sharedPreferences.getString("user_id") != null) {
  //       _navigateToItemDetail(message);
  //     }
  //   });

  //   _firebaseMessaging.getToken().then((token) {
  //     print("nandhu");
  //     print(token);
  //     print(token);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: 'Poppins'),
      title: 'SERVICES',
      home: SplashScreen(),
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        // '/': (context) => FirstScreen(),
        // When navigating to the "/second" route, build the SecondScreen widget.
      },
    );
  }
}
