import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:services/Constant/Colors.dart';
import 'ChatList.dart';
import 'ChatScreen.dart';
import 'HomePage.dart';
import 'MyPosts.dart';
import 'AdsDetail.dart';
import 'ProfilePage.dart';
import 'SelectService.dart';
import 'SelectService.dart';
import 'AdsListingPage.dart';

class BottomTab extends StatefulWidget {
  @override
  _BottomTabState createState() => _BottomTabState();
}

class _BottomTabState extends State<BottomTab> {
  PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  bool _hideNavBar;

//Screens for each nav items.
  List<Widget> _NavScreens() {
    return [
      new HomePage(),
      new ChatListPage(),
      new SelectService(rootNavigator: true),
      new MyPosts(),
      new ProfilePage(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(
          Icons.home,
          // color: appcolor,
        ),
        title: ("Home"),
        activeColorPrimary: appcolor,
        inactiveColorPrimary: menuColor,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(
          Icons.chat,
          // color: appcolor,
        ),
        title: ("Chats"),
        activeColorPrimary: appcolor,
        inactiveColorPrimary: menuColor,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(
          Icons.add,
          color: white,
        ),
        title: ("Add Post"),
        activeColorPrimary: appcolor,
        inactiveColorPrimary: menuColor,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(
          Icons.assignment_turned_in,
          // color: appcolor,
        ),
        title: ("My Posts"),
        activeColorPrimary: appcolor,
        inactiveColorPrimary: menuColor,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(
          Icons.person,
          // color: appcolor,
        ),
        title: ("My Account"),
        activeColorPrimary: appcolor,
        inactiveColorPrimary: menuColor,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: PersistentTabView(
        context,
        controller: _controller,
        screens: _NavScreens(),
        items: _navBarsItems(),
        confineInSafeArea: true,
        // hideNavigationBar: _hideNavBar,
        stateManagement: true,
        backgroundColor: Color(0xFFf8f8f8),
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        hideNavigationBarWhenKeyboardShows: true,
        popActionScreens: PopActionScreensType.all,
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(0.0),
        ),
        popAllScreensOnTapOfSelectedTab: true,
        navBarStyle: NavBarStyle.style15,
      ),
    );
  }
}
