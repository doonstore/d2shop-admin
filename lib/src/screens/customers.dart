import 'package:d2shop_admin/src/models/doonstore_user.dart';
import 'package:d2shop_admin/src/services/firestore_services.dart';
import 'package:d2shop_admin/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CustomersScreen extends StatelessWidget {
  final List<String> _titles = [
    "Name",
    "Email Address",
    "Contact Number",
    "Wallet Balance",
    "Transactions",
    "Actions"
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: StreamProvider<List<DoonStoreUser>>.value(
        value: FirestoreServices().getUsers,
        builder: (context, child) {
          List<DoonStoreUser> _users =
              Provider.of<List<DoonStoreUser>>(context);

          if (_users == null) return Utils.loading();
          if (_users.length > 0)
            return Container(
              width: MediaQuery.of(context).size.width * 0.75,
              child: DataTable(
                columns:
                    _titles.map((e) => DataColumn(label: Text(e))).toList(),
                rows: _users.map(
                  (user) {
                    return DataRow(
                      cells: [
                        DataCell(Text(user.displayName)),
                        DataCell(Text(user.email)),
                        DataCell(Text(user.phone)),
                        DataCell(Text('\u20b9' + user.wallet.toString())),
                        DataCell(
                          MaterialButton(
                            onPressed: user.transactions.isNotEmpty
                                ? () => showTransactions(context, user)
                                : null,
                            child: user.transactions.isEmpty
                                ? Text('No Transactions')
                                : Text('All Transactions'),
                          ),
                        ),
                        DataCell(Row(
                          children: [
                            IconButton(
                              icon: FaIcon(FontAwesomeIcons.edit),
                              onPressed: () {},
                              color: Colors.indigo,
                              tooltip: "Edit user details",
                            ),
                            IconButton(
                              icon: FaIcon(FontAwesomeIcons.times),
                              onPressed: () {},
                              color: Colors.red,
                              tooltip: 'Delete',
                            )
                          ],
                        ))
                      ],
                    );
                  },
                ).toList(),
              ),
            );

          return Utils.noDataWidget(context);
        },
      ),
    );
  }

  showTransactions(BuildContext context, DoonStoreUser user) {
    List _dataList = user.transactions;
    _dataList.sort((a, b) =>
        DateTime.parse(b['date']).compareTo(DateTime.parse(a['date'])));

    showBottomSheet(
      context: context,
      builder: (context) => Material(
        elevation: 5,
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
        color: kPrimaryColor.withOpacity(0.5),
        child: Column(
          children: [
            SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${user.displayName}\'s transactions',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                    ),
                  ),
                  IconButton(
                    icon: FaIcon(FontAwesomeIcons.times),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _dataList.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> map = _dataList[index];

                  return ListTile(
                    title: Text(
                        "${map['title']} (${DateFormat.yMMMMEEEEd().format(DateTime.parse(map['date']))})"),
                    subtitle: Text("${map['desc']}"),
                    trailing: Text(
                      '${map['type'] == 'Credited' ? '+' : '-'}\u20b9${map['amount']}\nUpdated balance \u20b9${map['newBalance']}',
                      style: TextStyle(
                        color: map['type'] == 'Credited'
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
