import 'package:d2shop_admin/src/models/shopping_model.dart';
import 'package:d2shop_admin/src/services/firestore_services.dart';
import 'package:d2shop_admin/src/utils/utils.dart';
import 'package:d2shop_admin/src/widgets/custom_alert_dialog.dart';
import 'package:flutter/material.dart';

class EditProduct extends StatefulWidget {
  final Item item;
  const EditProduct(this.item);

  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String name, quantityUnit;
  num price, quantityValue;

  submit() {
    _formKey.currentState.save();
    Item item = widget.item;

    item.name = name;
    item.price = price;
    item.quantityUnit = quantityUnit;
    item.quantityValue = quantityValue;

    FirestoreServices().updateProduct(item).then((value) {
      Navigator.pop(context);
      Utils.showMessage("$name has been successfully updated.");
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomAlertDialog(
      submit: submit,
      title: 'Edit Product Details',
      child: child(widget.item),
    );
  }

  Widget child(Item item) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            initialValue: item.name,
            decoration:
                InputDecoration(labelText: 'Name', helperText: 'Amul Milk'),
            onSaved: (newValue) => name = newValue.trim(),
          ),
          TextFormField(
            initialValue: item.price.toString(),
            decoration:
                InputDecoration(labelText: 'Price (Number)', helperText: '150'),
            onSaved: (newValue) => price = num.parse(newValue.trim()),
          ),
          TextFormField(
            initialValue: item.quantityValue.toString(),
            decoration: InputDecoration(
                labelText: 'Quantity Value (Number)', helperText: '250'),
            onSaved: (newValue) => quantityValue = num.parse(newValue.trim()),
          ),
          TextFormField(
            initialValue: item.quantityUnit,
            decoration: InputDecoration(
              labelText: 'Quantity Unit',
              helperText: 'G / KG / L / ML',
            ),
            onSaved: (newValue) => quantityUnit = newValue.trim(),
          ),
        ],
      ),
    );
  }
}
