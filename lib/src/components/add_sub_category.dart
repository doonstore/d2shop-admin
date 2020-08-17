import 'package:d2shop_admin/src/widgets/custom_alert_dialog.dart';
import 'package:d2shop_admin/src/models/shopping_model.dart';
import 'package:d2shop_admin/src/services/firestore_services.dart';
import 'package:d2shop_admin/src/utils/utils.dart';
import 'package:flutter/material.dart';

class AddSubCategory extends StatefulWidget {
  final Category category;
  const AddSubCategory({@required this.category});

  @override
  _AddSubCategoryState createState() => _AddSubCategoryState();
}

class _AddSubCategoryState extends State<AddSubCategory> {
  TextEditingController tec = TextEditingController();

  submit() {
    if (tec.text.isNotEmpty) {
      Category category = widget.category;
      Map map = category.itemList;
      map[tec.text] = [];
      FirestoreServices().updateCategory(category).then((value) {
        Utils.showMessage(
            "${tec.text} has been added to the ${category.name}.");
        Navigator.pop(context);
      });
    } else {
      Utils.showMessage("Please enter something to continue.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomAlertDialog(
      submit: submit,
      title: 'Add Sub - Category',
      child: TextFormField(
        controller: tec,
        decoration: InputDecoration(labelText: 'Sub - Category'),
      ),
    );
  }
}
