import 'package:csv/csv.dart';
import 'package:d2shop_admin/src/models/doonstore_user.dart';
import 'package:d2shop_admin/src/models/excel_data.dart';
import 'package:d2shop_admin/src/models/shopping_model.dart';
import 'package:d2shop_admin/src/services/firebase_storage_service.dart';
import 'package:d2shop_admin/src/services/firestore_services.dart';
import 'package:d2shop_admin/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class OrderScreen extends StatelessWidget {
  _test() async {
    const String URL =
        "https://script.google.com/macros/s/AKfycbyVnHnw44Wv_tb5MHqa6s6YSuDkqACVU8MiZ7LAgR4Ygq7Chck/exec";

    try {
      http
          .get(URL + ExcelData(id: '1', name: 'Text', number: '91').toParam())
          .then((value) {
        Utils.showMessage(value.body);
      });
    } catch (e) {
      Utils.showMessage(e.toString());
    }
  }

  generateCsvFile() async {
    Utils.showMessage("Please Wait...");
    List<OrderModel> _list = await FirestoreServices().getOrdersDocuments();
    List<List<String>> csvData = [
      <String>[
        'Username',
        'Phone Number',
        'Address',
        'Products',
        'Order Date',
        'Delivery Date',
        'Total Price'
      ],
      ..._list.map((e) => [
            e.user['displayName'].toString(),
            e.user['phone'].toString(),
            getAddress(e.user['address']).join(","),
            e.itemList
                .map((e) => Item.fromJson(e))
                .toList()
                .map((e) => "${e.name} (${e.quantityUnit})")
                .toList()
                .join("\n"),
            DateFormat.yMMMMd().add_jm().format(DateTime.parse(e.orderDate)),
            DateFormat.yMMMMd().format(DateTime.parse(e.deliveryDate)),
            "${e.total} ${e.noOfProducts}",
          ])
    ];

    String csv = ListToCsvConverter().convert(csvData);
    Utils.showMessage(csv);

    String url = await FirebaseStorageServices().uploadCsvFile(csv);
    Utils.showMessage(url ?? "Error");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: ListTile(
          onTap: _test,
          leading: FaIcon(FontAwesomeIcons.fileCsv),
          title: Text('Import CSV'),
        ),
      ),
      body: SingleChildScrollView(
        child: StreamProvider<List<OrderModel>>.value(
          value: FirestoreServices().getOrders,
          child: OrdersTable(),
        ),
      ),
    );
  }
}

class OrdersTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<OrderModel> _dataList = Provider.of<List<OrderModel>>(context);

    if (_dataList != null && _dataList.length > 0) {
      _dataList.sort((a, b) => DateTime.parse(b.orderDate)
          .day
          .compareTo(DateTime.parse(a.deliveryDate).day));

      return Container(
        width: MediaQuery.of(context).size.width * 0.75,
        child: DataTable(
          columns: [
            DataColumn(label: Text('User - Info')),
            DataColumn(label: Text('Address')),
            DataColumn(label: Text('Product(s)')),
            DataColumn(label: Text('Order Date')),
            DataColumn(label: Text('Delivery Date')),
            DataColumn(label: Text('Total Price')),
          ],
          rows: _dataList.map(
            (data) {
              DoonStoreUser user = DoonStoreUser.fromJson(data.user);
              String itemList = data.itemList
                  .map((e) => Item.fromJson(e))
                  .toList()
                  .map((e) => "${e.name} (${e.quantityUnit})")
                  .toList()
                  .join("\n");

              return DataRow(
                cells: [
                  DataCell(Text("${user.displayName}\n${user.phone}",
                      textAlign: TextAlign.start)),
                  DataCell(Text(getAddress(user.address).join(","))),
                  DataCell(Text(itemList, textAlign: TextAlign.start)),
                  DataCell(Text(DateFormat.yMMMMd()
                      .add_jm()
                      .format(DateTime.parse(data.orderDate)))),
                  DataCell(Text(DateFormat.yMMMMd()
                      .format(DateTime.parse(data.deliveryDate)))),
                  DataCell(Text("\u20b9${data.total} ${data.noOfProducts}")),
                ],
              );
            },
          ).toList(),
        ),
      );
    } else
      return Text('No Data Available!');
  }
}
