import 'package:d2shop_admin/src/services/firestore_services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/coupon_model.dart';
import 'package:provider/provider.dart';

class CouponScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: StreamProvider<List<CouponModel>>.value(
        value: FirestoreServices().getCoupons,
        builder: (context, child) => CouponTable(),
      ),
    );
  }
}

class CouponTable extends StatefulWidget {
  @override
  _CouponTableState createState() => _CouponTableState();
}

class _CouponTableState extends State<CouponTable> {
  @override
  Widget build(BuildContext context) {
    List<CouponModel> _dataList = Provider.of<List<CouponModel>>(context);

    return _dataList != null && _dataList.length > 0
        ? Container(
            width: MediaQuery.of(context).size.width * 0.75,
            child: DataTable(
              columns: [
                DataColumn(label: Text('PromoCode')),
                DataColumn(label: Text('Message')),
                DataColumn(label: Text('Expiry Date')),
                DataColumn(label: Text('Limit')),
                DataColumn(label: Text('Benifit Value')),
              ],
              rows: _dataList.map(
                (data) {
                  return DataRow(
                    cells: [
                      DataCell(Text(data.promoCode)),
                      DataCell(Text(data.message)),
                      DataCell(
                        Text(
                          DateFormat.yMMMMEEEEd()
                              .format(DateTime.parse(data.validTill)),
                        ),
                      ),
                      DataCell(Text(data.limit.toString())),
                      DataCell(Text("${data.benifitValue.toString()}%")),
                    ],
                  );
                },
              ).toList(),
            ),
          )
        : Text('No data available.');
  }
}
