import 'package:d2shop_admin/src/models/shopping_model.dart';
import 'package:d2shop_admin/src/services/firestore_services.dart';
import 'package:d2shop_admin/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String name, subCategory, imageUrl;
  bool isFeatured = false;
  PickedFile pickedFile;

  submit() async {
    if (_formKey.currentState.validate() && imageUrl != null) {
      _formKey.currentState.save();

      int id = (await categoryRef.getDocuments()).documents.length + 1;

      List itemList = subCategory.split(',').toList();
      Map map = {};

      itemList.forEach((e) {
        map[e] = [];
      });

      Category category = Category(
        id: id.toString(),
        isFeatured: isFeatured,
        name: name,
        itemList: map,
      );

      categoryRef.document(id.toString()).setData(category.toJson());
    } else {
      Utils.showMessage("All fields are required.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(labelText: 'Category'),
                          onSaved: (newValue) => name = newValue.trim(),
                          validator: (value) =>
                              value.isEmpty ? 'This field is required.' : null,
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Sub - Categories',
                          ),
                          onSaved: (newValue) => subCategory = newValue.trim(),
                          validator: (value) =>
                              value.isEmpty ? 'This field is required.' : null,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                          child: SwitchListTile(
                        value: isFeatured,
                        onChanged: (bool val) {
                          setState(() {
                            isFeatured = val;
                          });
                        },
                        title: Text('isFeatured'),
                      )),
                      SizedBox(width: 10),
                      Expanded(
                        child: MaterialButton(
                          onPressed: () async {
                            var image = await ImagePicker()
                                .getImage(source: ImageSource.gallery);
                            if (image != null) {
                              setState(() {
                                imageUrl = image.path;
                              });
                            }
                          },
                          child: Text(
                            imageUrl == null ? 'Choose image' : imageUrl,
                          ),
                        ),
                      ),
                    ],
                  ),
                  MaterialButton(
                    onPressed: submit,
                    textColor: Colors.white,
                    color: Colors.teal,
                    child: Text('Add Category'),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          StreamProvider<List<Category>>.value(
            value: FirestoreServices().listOfCategories,
            child: CategoryTable(),
          ),
        ],
      ),
    );
  }
}

class CategoryTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Category> _dataList = Provider.of<List<Category>>(context);

    if (_dataList != null)
      return DataTable(
        columnSpacing: 20,
        columns: [
          DataColumn(label: Text('ID')),
          DataColumn(label: Text('Name')),
          DataColumn(label: Text('Image')),
          DataColumn(label: Text('IsFeatured')),
          DataColumn(label: Text('Sub - Categories')),
        ],
        rows: _dataList.map(
          (data) {
            return DataRow(
              cells: [
                DataCell(Text(data.id)),
                DataCell(Text(data.name)),
                DataCell(Text(data.photoUrl)),
                DataCell(Text(data.isFeatured ? 'Yes' : 'No')),
                DataCell(Text(data.itemList.keys.toList().join(','))),
              ],
            );
          },
        ).toList(),
      );
    else
      return Center(child: Text('Loading..'));
  }
}
