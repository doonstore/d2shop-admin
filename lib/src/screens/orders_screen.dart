import 'dart:convert';

import 'package:d2shop_admin/src/models/doonstore_user.dart';
import 'package:d2shop_admin/src/models/excel_data.dart';
import 'package:d2shop_admin/src/models/shopping_model.dart';
import 'package:d2shop_admin/src/services/firestore_services.dart';
import 'package:d2shop_admin/src/utils/utils.dart';
import 'package:d2shop_admin/src/widgets/custom_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  bool sendingData = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        elevation: 0.0,
        title: ListTile(
          onTap: () {
            showDialog(
                context: context, builder: (context) => ChooseOrderLimit());
          },
          leading: FaIcon(
            FontAwesomeIcons.googleDrive,
            color: Colors.white,
          ),
          title: Text(
            'Export Orders to Google Sheet',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: StreamProvider<List<OrderModel>>.value(
          value: FirestoreServices().getOrders,
          builder: (context, child) {
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
                          DataCell(
                              Text("\u20b9${data.total} ${data.noOfProducts}")),
                        ],
                      );
                    },
                  ).toList(),
                ),
              );
            } else
              return Text('No Data Available!');
          },
        ),
      ),
    );
  }
}

class ChooseOrderLimit extends StatefulWidget {
  @override
  _ChooseOrderLimitState createState() => _ChooseOrderLimitState();
}

class _ChooseOrderLimitState extends State<ChooseOrderLimit> {
  final TextEditingController _tec = TextEditingController(text: 10.toString());
  String date;

  sendDataToSheets(int limit) async {
    Map<String, Object> result = {'status': 'SUCCESS'};
    List<OrderModel> dataList =
        await FirestoreServices().getOrdersByLimit(limit);

    if (date != null)
      dataList = dataList.where((e) {
        DateTime fetchDate = DateTime.parse(e.orderDate);
        DateTime currentDate = DateTime.parse(date);

        return (fetchDate.month == currentDate.month) &&
            (fetchDate.day == currentDate.day);
      }).toList();

    Utils.showMessage("Sending ${dataList.length} datasets to Google Sheets");

    Future.forEach(dataList, (e) async {
      DoonStoreUser user = DoonStoreUser.fromJson(e.user);

      String params = ExcelData(
        name: user.displayName,
        number: user.phone,
        address: getAddress(e.user['address']).join(" ").replaceAll("#", ""),
        orderDate:
            DateFormat.yMMMMd().add_jm().format(DateTime.parse(e.orderDate)),
        deliveryDate:
            DateFormat.yMMMMd().format(DateTime.parse(e.deliveryDate)),
        price: "${e.total}",
        products: e.itemList
            .map((e) => Item.fromJson(e))
            .toList()
            .map((e) => "${e.name} (${e.quantityUnit})")
            .toList()
            .join("\n"),
        noOfProducts: e.noOfProducts.toString(),
      ).toParam();

      await http.get(ExcelData.URL + params).then((value) {
        result = json.decode(value.body);
      }).catchError((e) {
        Utils.showMessage("Error: $e");
      });
      return Future.value(true);
    }).then((value) {
      Utils.showMessage(result['status']);
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomAlertDialog(
      submit: () {
        try {
          int limit = int.parse((_tec.text));
          sendDataToSheets(limit);
        } catch (e) {
          Utils.showMessage("Error: $e");
          Navigator.pop(context);
        }
      },
      title: "Export Orders",
      child: Column(
        children: [
          TextField(
            controller: _tec,
            decoration:
                Utils.inputDecoration("Show Records (Limit)", helper: "10"),
          ),
          SizedBox(height: 10),
          Material(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(12),
            elevation: 5.0,
            child: ListTile(
              leading: FaIcon(FontAwesomeIcons.calendar, color: Colors.white),
              title: Text(
                'Pick Specific Date',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () => pickDate(context),
              trailing: date != null
                  ? Text(
                      DateFormat.yMMMMEEEEd().format(DateTime.parse(date)),
                      style: TextStyle(color: Colors.white),
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  pickDate(BuildContext context) async {
    DateTime dateTime = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2050),
    );

    if (dateTime != null)
      setState(() {
        date = dateTime.toString();
      });
  }
}
