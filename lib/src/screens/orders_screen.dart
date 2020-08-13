import 'package:d2shop_admin/src/models/doonstore_user.dart';
import 'package:d2shop_admin/src/models/shopping_model.dart';
import 'package:d2shop_admin/src/services/firestore_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: StreamProvider<List<OrderModel>>.value(
        value: FirestoreServices().getOrders,
        child: OrdersTable(),
      ),
    );
  }
}

class OrdersTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<OrderModel> _dataList = Provider.of<List<OrderModel>>(context);

    if (_dataList != null && _dataList.length > 0)
      return Container(
        width: MediaQuery.of(context).size.width * 0.75,
        child: DataTable(
          columns: [
            DataColumn(label: Text('ID')),
            DataColumn(label: Text('User - Name')),
            DataColumn(label: Text('User - Address')),
            DataColumn(label: Text('Product - Names')),
            DataColumn(label: Text('Total Price')),
          ],
          rows: _dataList.map(
            (data) {
              DoonStoreUser user = DoonStoreUser.fromJson(data.user);
              List<Item> itemList = data.itemList.map((e) => Item.fromJson(e));

              return DataRow(
                cells: [
                  DataCell(Text(data.id)),
                  DataCell(Text(user.displayName)),
                  DataCell(Text(getAddress(user.address).join(","))),
                  DataCell(
                      Text(itemList.map((e) => e.name).toList().join(","))),
                  DataCell(Text(data.total.toString())),
                ],
              );
            },
          ).toList(),
        ),
      );
    else
      return Text('No Data Available!');
  }
}
