import 'package:d2shop_admin/src/models/doonstore_user.dart';
import 'package:d2shop_admin/src/services/firestore_services.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class CustomersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: StreamProvider<List<DoonStoreUser>>.value(
        value: FirestoreServices().getUsers,
        child: UsersTable(),
      ),
    );
  }
}

class UsersTable extends StatelessWidget {
  const UsersTable({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<DoonStoreUser> _users = Provider.of<List<DoonStoreUser>>(context);

    if (_users != null && _users.length > 0)
      return Container(
        width: MediaQuery.of(context).size.width * 0.75,
        child: DataTable(
          columns: [
            DataColumn(label: Text('Name')),
            DataColumn(label: Text('Email Address')),
            DataColumn(label: Text('Contact Number')),
            DataColumn(label: Text('Wallet Balance')),
            DataColumn(label: Text('Transactions')),
            DataColumn(label: Text('Actions'))
          ],
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
                      onPressed: user.transactions.isNotEmpty ? () {} : null,
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
    else
      return Center(child: Text('No Data Available!'));
  }

  showTransactions(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        scrollable: true,
        content: SingleChildScrollView(
          child: Column(
            children: [],
          ),
        ),
      ),
    );
  }
}
