import 'package:d2shop_admin/src/components/add_sub_category.dart';
import 'package:d2shop_admin/src/components/confirm_dialog.dart';
import 'package:d2shop_admin/src/components/edit_category.dart';
import 'package:d2shop_admin/src/components/view_image.dart';
import 'package:d2shop_admin/src/models/shopping_model.dart';
import 'package:d2shop_admin/src/services/firestore_services.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: StreamProvider<List<Category>>.value(
        value: FirestoreServices().getCategories,
        child: CategoryTable(),
      ),
    );
  }
}

class CategoryTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Category> _dataList = Provider.of<List<Category>>(context);

    if (_dataList != null && _dataList.length > 0)
      return Container(
        width: MediaQuery.of(context).size.width * 0.75,
        child: DataTable(
          columns: [
            DataColumn(label: Text('ID')),
            DataColumn(label: Text('Name')),
            DataColumn(label: Text('IsFeatured')),
            DataColumn(label: Text('Sub - Categories')),
            DataColumn(label: Text('Image')),
            DataColumn(label: Text('Add Sub - Category')),
            DataColumn(label: Text('Actions')),
          ],
          rows: _dataList.map(
            (data) {
              return DataRow(
                cells: [
                  DataCell(Text(data.id)),
                  DataCell(Text(data.name)),
                  DataCell(Text(data.isFeatured ? 'Yes' : 'No')),
                  DataCell(Text(data.itemList.keys.toList().join(','))),
                  DataCell(
                    Hero(
                      tag: data.photoUrl,
                      child: Image.network(
                        data.photoUrl,
                        width: 80,
                        height: 100,
                      ),
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ViewImage(data.photoUrl),
                      ),
                    ),
                  ),
                  DataCell(
                    IconButton(
                      icon: FaIcon(FontAwesomeIcons.plusSquare),
                      onPressed: () => showDialog(
                        context: context,
                        builder: (context) => AddSubCategory(category: data),
                      ),
                      color: Colors.green,
                      tooltip: 'Add Sub - Category',
                    ),
                  ),
                  DataCell(
                    Row(
                      children: [
                        IconButton(
                          icon: FaIcon(FontAwesomeIcons.edit),
                          onPressed: () => showDialog(
                            context: context,
                            builder: (context) => EditCategory(data),
                          ),
                          color: Colors.green,
                          tooltip: 'Edit Details',
                        ),
                        IconButton(
                          icon: FaIcon(FontAwesomeIcons.times),
                          onPressed: () => showDialog(
                            context: context,
                            builder: (context) => ConfirmDialog(
                              title: 'Are you sure to delete ${data.name}?',
                              confirmBtnCallback: () {
                                FirestoreServices().deleteCategory(data);
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          color: Colors.red,
                          tooltip: 'Delete',
                        ),
                      ],
                    ),
                  )
                ],
              );
            },
          ).toList(),
        ),
      );
    else
      return Text('No Data Available.');
  }
}
