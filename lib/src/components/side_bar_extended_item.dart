import 'package:d2shop_admin/src/components/sidebar_item.dart';
import 'package:d2shop_admin/src/provider/state.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class SideBarExtendedItem extends StatelessWidget {
  final List<SideBarItem> dataList;
  final String title;

  const SideBarExtendedItem({@required this.dataList, @required this.title});

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
      builder: (context, value, child) {
        return ExpansionTile(
          trailing: FaIcon(dataList[0].iconData),
          title: Text(
            title,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          children: dataList.map((e) => e).toList(),
        );
      },
    );
  }
}
