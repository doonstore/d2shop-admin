import 'package:d2shop_admin/src/components/confirm_dialog.dart';
import 'package:d2shop_admin/src/components/view_image.dart';
import 'package:d2shop_admin/src/models/shopping_model.dart';
import 'package:d2shop_admin/src/services/firestore_services.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ProductScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Item>>.value(
      value: FirestoreServices().getProducts,
      child: ProductTable(),
    );
  }
}

class ProductTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Item> _productList = Provider.of<List<Item>>(context);

    if (_productList != null && _productList.length > 0)
      return Container(
        width: MediaQuery.of(context).size.width * 0.75,
        child: DataTable(
          columns: [
            DataColumn(label: Text('ID')),
            DataColumn(label: Text('Name')),
            DataColumn(label: Text('Category')),
            DataColumn(label: Text('Quantity')),
            DataColumn(label: Text('Price')),
            DataColumn(label: Text('Image')),
            DataColumn(label: Text('Actions'))
          ],
          rows: _productList.map(
            (data) {
              return DataRow(
                cells: [
                  DataCell(Text(data.id)),
                  DataCell(Text(data.name)),
                  DataCell(Text(
                      "${data.partOfCategory}, ${data.partOfSubCategory}")),
                  DataCell(
                      Text("${data.quantityValue} (${data.quantityUnit})")),
                  DataCell(Text("${data.price}")),
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
                      icon: FaIcon(FontAwesomeIcons.times),
                      onPressed: () => showDialog(
                        context: context,
                        builder: (context) => ConfirmDialog(
                          title: 'Are you sure to delete ${data.name}?',
                          confirmBtnCallback: () {
                            FirestoreServices().deleteProduct(data);
                            Navigator.pop(context);
                          },
                        ),
                      ),
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
      return Text('No Data Avaiable!');
  }
}
