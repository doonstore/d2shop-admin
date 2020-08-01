import 'package:flutter/material.dart';

class UsersScreen extends StatefulWidget {
  @override
  _UsersScreenState createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: DataTable(
        columns: [
          DataColumn(label: Text('Name')),
          DataColumn(label: Text('Email')),
          DataColumn(label: Text('ID'))
        ],
        rows: [
          DataRow(
            cells: [
              DataCell(Text('Hey')),
              DataCell(Text('Hey')),
              DataCell(Text('Hey')),
            ],
          ),
        ],
      ),
    );
  }
}
