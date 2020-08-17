import 'package:d2shop_admin/src/provider/state.dart';
import 'package:d2shop_admin/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class SideBarItem extends StatelessWidget {
  final int index;
  final IconData iconData;
  final String title;

  const SideBarItem(
      {@required this.index, @required this.iconData, @required this.title});

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
      builder: (context, value, child) {
        bool check = index == value.currentIndex;

        return Material(
          color: check ? kPrimaryColor : Colors.white,
          animationDuration: Duration(milliseconds: 300),
          borderRadius: BorderRadius.horizontal(
            right: Radius.circular(25),
          ),
          child: ListTile(
            leading: FaIcon(
              iconData,
              color: check ? Color.fromRGBO(25, 103, 210, 1.0) : Colors.black,
            ),
            title: Text(
              title,
              style: TextStyle(
                color: check ? Color.fromRGBO(25, 103, 210, 1.0) : Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            onTap: () => value.changeIndex(index, title),
          ),
        );
      },
    );
  }
}
