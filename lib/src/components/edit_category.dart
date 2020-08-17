import 'package:d2shop_admin/src/models/shopping_model.dart';
import 'package:d2shop_admin/src/services/firestore_services.dart';
import 'package:d2shop_admin/src/utils/utils.dart';
import 'package:d2shop_admin/src/widgets/custom_alert_dialog.dart';
import 'package:flutter/material.dart';

class EditCategory extends StatefulWidget {
  final Category category;
  const EditCategory(this.category);

  @override
  _EditCategoryState createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {
  String name, sub;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isFeatured = false;

  submit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      Map<String, dynamic> map = await getSubCategoryList(sub);

      Category category = Category(
          id: widget.category.id,
          isFeatured: isFeatured,
          name: name,
          itemList: map,
          photoUrl: widget.category.photoUrl);

      FirestoreServices().updateCategory(category).then((value) {
        Utils.showMessage("$name has been updated.");
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomAlertDialog(
      submit: submit,
      title: 'Edit Details',
      child: child(widget.category),
    );
  }

  Widget child(Category category) => Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              initialValue: category.name,
              decoration: InputDecoration(labelText: 'Category'),
              onSaved: (newValue) => name = newValue.trim(),
            ),
            SizedBox(height: 15),
            TextFormField(
              onSaved: (newValue) => sub = newValue.trim(),
              initialValue: category.itemList.keys.join(','),
              decoration: InputDecoration(labelText: 'Sub - Category'),
            ),
            SizedBox(height: 15),
            SwitchListTile(
              value: isFeatured,
              title: Text('Featured?'),
              onChanged: (val) {
                setState(() {
                  isFeatured = val;
                });
              },
            )
          ],
        ),
      );
}
