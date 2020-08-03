import 'package:d2shop_admin/src/models/doonstore_user.dart';
import 'package:d2shop_admin/src/services/firestore_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UsersScreen extends StatefulWidget {
  @override
  _UsersScreenState createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
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

    if (_users != null)
      return DataTable(
          columnSpacing: 20,
          columns: [
            DataColumn(label: Text('User ID')),
            DataColumn(label: Text('Name')),
            DataColumn(label: Text('Email Address')),
            DataColumn(label: Text('Contact Number')),
            DataColumn(label: Text('DoorBell / WhatsApp')),
            DataColumn(label: Text('Wallet Balance'), numeric: true),
            DataColumn(label: Text('Transactions')),
          ],
          rows: _users
              .map(
                (user) => DataRow(
                  cells: [
                    DataCell(Text(user.userId)),
                    DataCell(Text(user.displayName)),
                    DataCell(Text(user.email)),
                    DataCell(Text(user.phone)),
                    DataCell(Text(
                        '${user.doorBellStatus ? 'Yes' : 'No'} / ${user.whatsAppNotificationSetting ? 'Yes' : 'No'}')),
                    DataCell(Text('\u20b9' + user.wallet.toString())),
                    DataCell(MaterialButton(
                      onPressed: () {},
                      child: Text('All Transactions'),
                      textColor: Colors.blue,
                    )),
                  ],
                ),
              )
              .toList());
    else
      return Center(child: Text('Loading..'));
  }
}
