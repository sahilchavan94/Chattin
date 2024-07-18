import 'package:chattin/core/router/route_path.dart';
import 'package:chattin/core/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

//not used yet, but may add it in future
class BottomNavigationItem {
  String name;
  Widget icon;
  Function onTap;
  BottomNavigationItem({
    required this.name,
    required this.icon,
    required this.onTap,
  });
}

class BottomNavigationManager extends ChangeNotifier {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;

  final List<BottomNavigationItem> _menuItems = [
    BottomNavigationItem(
      name: "Home",
      icon: const Icon(Icons.home),
      onTap: () {
        Constants.navigatorKey.currentContext!.push(
          RoutePath.chatScreen.path,
        );
      },
    ),
    BottomNavigationItem(
      name: "Status",
      icon: const Icon(Icons.check_circle),
      onTap: () {
        Constants.navigatorKey.currentContext!.push(
          RoutePath.selectContact.path,
        );
      },
    ),
    BottomNavigationItem(
      name: "Profile",
      icon: const Icon(Icons.account_circle),
      onTap: () {
        Constants.navigatorKey.currentContext!.push(RoutePath.chatScreen.path);
      },
    ),
  ];

  void navigateToIndex(index) {
    _selectedIndex = index;
    _menuItems[selectedIndex].onTap();
    notifyListeners();
  }

  int get selectedIndex => _selectedIndex;

  List<BottomNavigationItem> get menuItems => _menuItems;

  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;
}
