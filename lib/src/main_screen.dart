import 'package:d2shop_admin/src/components/side_bar_extended_item.dart';
import 'package:d2shop_admin/src/components/sidebar_item.dart';
import 'package:d2shop_admin/src/provider/state.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
      builder: (context, value, child) {
        return Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Drawer(
                child: SingleChildScrollView(
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        DrawerHeader(
                          child: Center(
                            child: Text(
                              value.admin?.username ?? '',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 25,
                              ),
                            ),
                          ),
                        ),
                        SideBarItem(
                          index: 0,
                          iconData: FontAwesomeIcons.home,
                          title: 'Home',
                        ),
                        SideBarItem(
                            index: 1,
                            iconData: FontAwesomeIcons.userFriends,
                            title: 'Customers'),
                        SideBarItem(
                          index: 2,
                          iconData: FontAwesomeIcons.shoppingBag,
                          title: 'Orders',
                        ),
                        SideBarItem(
                            index: 3,
                            iconData: FontAwesomeIcons.shoppingBasket,
                            title: 'Category'),
                        SideBarItem(
                            index: 4,
                            iconData: FontAwesomeIcons.productHunt,
                            title: 'Products'),
                        SideBarItem(
                            index: 5,
                            iconData: FontAwesomeIcons.gifts,
                            title: 'Coupons'),
                        SideBarItem(
                            index: 6,
                            iconData: FontAwesomeIcons.userCheck,
                            title: 'Chat - Support'),
                        SideBarItem(
                            index: 7,
                            iconData: FontAwesomeIcons.paperPlane,
                            title: 'Send Notifications'),
                        SideBarItem(
                            index: 8,
                            iconData: FontAwesomeIcons.images,
                            title: 'Featured Banner'),
                        SideBarExtendedItem(dataList: [
                          SideBarItem(
                              index: 9,
                              iconData: FontAwesomeIcons.users,
                              title: 'Existing Users'),
                          SideBarItem(
                              index: 10,
                              iconData: FontAwesomeIcons.userPlus,
                              title: 'Add New User'),
                        ], title: 'Users'),
                        SideBarItem(
                            index: 11,
                            iconData: FontAwesomeIcons.city,
                            title: "Apartment List"),
                        SideBarItem(
                            index: 12,
                            iconData: FontAwesomeIcons.cog,
                            title: 'Additional Services'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.only(top: 100, left: 20),
                child: Scaffold(
                  appBar: AppBar(
                    elevation: 0,
                    title: Text(
                      value.appBarTitle,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 35,
                        color: Colors.blueGrey[700],
                      ),
                    ),
                    backgroundColor: Colors.white,
                  ),
                  body: Padding(
                    padding: EdgeInsets.all(20),
                    child: value.pages[value.currentIndex],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
