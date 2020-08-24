import 'package:d2shop_admin/src/components/confirm_dialog.dart';
import 'package:d2shop_admin/src/models/admin_model.dart';
import 'package:d2shop_admin/src/services/firestore_services.dart';
import 'package:d2shop_admin/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class UsersScreen extends StatefulWidget {
  @override
  _UsersScreenState createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: StreamProvider<List<AdminModel>>.value(
        value: FirestoreServices().getAdmins,
        builder: (context, child) {
          List<AdminModel> _dataList = Provider.of<List<AdminModel>>(context);

          if (_dataList != null && _dataList.length > 0)
            return Container(
              width: MediaQuery.of(context).size.width * 0.75,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('Username')),
                  DataColumn(label: Text('First Name')),
                  DataColumn(label: Text('Last Name')),
                  DataColumn(label: Text('Email Address')),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('Actions'))
                ],
                rows: _dataList.map(
                  (data) {
                    return DataRow(
                      cells: [
                        DataCell(Text(data.username)),
                        DataCell(Text(data.firstName)),
                        DataCell(Text(data.lastName)),
                        DataCell(Text(data.emailAddress)),
                        DataCell(
                          Tooltip(
                            message: data.status == 101
                                ? 'Verfication mail has been sent to ${data.emailAddress}'
                                : '',
                            child: Text(
                              getStatus(data.status),
                              style: TextStyle(
                                color: data.status == 200
                                    ? Colors.green
                                    : Colors.blue,
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          IconButton(
                            icon: FaIcon(FontAwesomeIcons.times),
                            onPressed: () => removeAdmin(context, data),
                            color: Colors.red,
                            tooltip: 'Delete',
                          ),
                        )
                      ],
                    );
                  },
                ).toList(),
              ),
            );
          else
            return Center(child: Text('No Data Available.'));
        },
      ),
    );
  }

  String getStatus(int status) {
    if (status == 101)
      return 'Pending';
    else
      return 'Confirmed';
  }

  removeAdmin(BuildContext context, AdminModel adminModel) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => ConfirmDialog(
        title: 'Remove ${adminModel.username} as Admin?',
        confirmBtnCallback: () async {
          await FirestoreServices().deleteAdmin(adminModel);
          Utils.showMessage("Removed ${adminModel.username} as Admin.");
          Navigator.pop(context);
        },
      ),
    );
  }
}
