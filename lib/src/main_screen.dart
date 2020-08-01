import 'package:d2shop_admin/src/screens/category_screen.dart';
import 'package:d2shop_admin/src/screens/home_page.dart';
import 'package:d2shop_admin/src/screens/item_screen.dart';
import 'package:d2shop_admin/src/screens/orders_screen.dart';
import 'package:d2shop_admin/src/screens/users.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentPage = 0;
  final List<dynamic> _pages = [
    [HomePage(), 'Home'],
    [UsersScreen(), 'Users'],
    [OrderScreen(), 'Orders'],
    [CategoryScreen(), 'Category'],
    [ItemScreen(), 'Items']
  ];
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Drawer(
            child: Container(
              color: Colors.white,
              height: size.height,
              child: Column(
                children: [
                  DrawerHeader(
                    child: Center(
                      child: Text(
                        'Admin',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 25,
                        ),
                      ),
                    ),
                  ),
                  drawerListTile(_pages[0][1], FontAwesomeIcons.home, 0),
                  drawerListTile(_pages[1][1], FontAwesomeIcons.user, 1),
                  drawerListTile(_pages[2][1], FontAwesomeIcons.shoppingBag, 2),
                  drawerListTile(
                      _pages[3][1], FontAwesomeIcons.shoppingBasket, 3),
                  drawerListTile(_pages[4][1], FontAwesomeIcons.icons, 4),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: Container(
            decoration: BoxDecoration(color: Colors.white),
            padding: const EdgeInsets.only(top: 100, left: 20),
            child: Scaffold(
              appBar: AppBar(
                elevation: 0,
                title: Text(
                  _pages[_currentPage][1],
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 35,
                    color: Colors.black,
                  ),
                ),
                backgroundColor: Colors.white,
              ),
              body: _pages[_currentPage][0],
            ),
          ),
        ),
      ],
    );
  }

  Material drawerListTile(String text, IconData iconData, int index) {
    return Material(
      color: index == _currentPage
          ? Color.fromRGBO(232, 240, 254, 1.0)
          : Colors.white,
      animationDuration: Duration(milliseconds: 300),
      borderRadius: BorderRadius.horizontal(
        right: Radius.circular(25),
      ),
      child: ListTile(
        leading: FaIcon(
          iconData,
          color: index == _currentPage
              ? Color.fromRGBO(25, 103, 210, 1.0)
              : Colors.black,
        ),
        title: Text(
          text,
          style: TextStyle(
            color: index == _currentPage
                ? Color.fromRGBO(25, 103, 210, 1.0)
                : Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        onTap: () {
          setState(() {
            _currentPage = index;
          });
        },
      ),
    );
  }
}

// Color(0xff2A3F54)
