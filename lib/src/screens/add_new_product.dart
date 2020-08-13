import 'package:d2shop_admin/src/models/shopping_model.dart';
import 'package:d2shop_admin/src/services/firebase_storage_service.dart';
import 'package:d2shop_admin/src/services/firestore_services.dart';
import 'package:d2shop_admin/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:universal_html/prefer_universal/html.dart' as html;

class AddNewProduct extends StatefulWidget {
  @override
  _AddNewProductState createState() => _AddNewProductState();
}

class _AddNewProductState extends State<AddNewProduct> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String id, name, category, subCategory, photoUrl, quantityUnit;
  num quantityValue, price;

  bool loading = false;

  submit() async {
    if (_formKey.currentState.validate()) {
      if (photoUrl != null) {
        _formKey.currentState.save();

        setState(() {
          loading = true;
        });

        id = (await _getId()).toString();

        Item item = Item(
            id: id,
            name: name,
            partOfCategory: category,
            partOfSubCategory: subCategory,
            quantityUnit: quantityUnit,
            quantityValue: quantityValue,
            price: price,
            photoUrl: photoUrl);

        FirestoreServices().addNewProduct(item).then((value) {
          Utils.showMessage("$name has been succesfully added.");
          setState(() {
            loading = false;
          });
        });
      } else {
        Utils.showMessage("Please select an image file.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.35,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder(
                future: FirestoreServices().fetchCategories(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Text('Loading...');
                  }

                  List<String> dataList = snapshot.data;

                  if (dataList.length > 0) {
                    return DropdownButtonFormField<String>(
                      decoration: InputDecoration(labelText: 'Choose Category'),
                      items: dataList
                          .map((e) => DropdownMenuItem(
                                child: Text(e),
                                value: e,
                              ))
                          .toList(),
                      onChanged: (val) {
                        setState(() {
                          category = val;
                        });
                      },
                      onSaved: (val) {
                        category = val;
                      },
                      validator: (value) =>
                          value == null ? 'Please select a category' : null,
                    );
                  } else {
                    return Text(
                        'Sorry, No Category Avaiable! Please add category first');
                  }
                },
              ),
              SizedBox(height: 10),
              if (category != null)
                FutureBuilder(
                  future: FirestoreServices().fetchSubCategories(category),
                  builder: (context, AsyncSnapshot<Category> snapshot) {
                    if (!snapshot.hasData) {
                      return Text('Loading...');
                    }

                    List<String> dataList =
                        snapshot.data.itemList.keys.toList();

                    return DropdownButtonFormField<String>(
                      decoration:
                          InputDecoration(labelText: 'Choose Sub-Category'),
                      items: dataList
                          .map((e) => DropdownMenuItem(
                                child: Text(e),
                                value: e,
                              ))
                          .toList(),
                      onChanged: (val) {
                        setState(() {
                          subCategory = val;
                        });
                      },
                      onSaved: (val) {
                        subCategory = val;
                      },
                      validator: (value) =>
                          value == null ? 'Please select a sub-category' : null,
                    );
                  },
                ),
              SizedBox(height: 10),
              TextFormField(
                decoration:
                    InputDecoration(labelText: 'Name', helperText: 'Amul Milk'),
                validator: (value) =>
                    value.isEmpty ? 'This field is required.' : null,
                onSaved: (newValue) => name = newValue.trim(),
              ),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Price (Number)', helperText: '150'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value.isEmpty ? 'This field is required.' : null,
                onSaved: (newValue) => price = num.parse(newValue.trim()),
              ),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Quantity Value (Number)', helperText: '250'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value.isEmpty ? 'This field is required.' : null,
                onSaved: (newValue) =>
                    quantityValue = num.parse(newValue.trim()),
              ),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Quantity Unit', helperText: 'G / KG / L / ML'),
                validator: (value) =>
                    value.isEmpty ? 'This field is required.' : null,
                onSaved: (newValue) => quantityUnit = newValue.trim(),
              ),
              SizedBox(height: 10),
              ListTile(
                title: photoUrl != null
                    ? Text('Change Image')
                    : Text('Choose Image (PNG)'),
                onTap: uploadImage,
                trailing: photoUrl != null ? Image.network(photoUrl) : null,
              ),
              SizedBox(height: 20),
              !loading
                  ? Align(
                      alignment: Alignment.centerRight,
                      child: MaterialButton(
                        onPressed: submit,
                        child: Text('Add New Product'),
                        textColor: Colors.blue,
                        padding: EdgeInsets.all(15),
                      ),
                    )
                  : Align(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(),
                    ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  uploadImage() async {
    html.InputElement uploadInput = html.FileUploadInputElement();
    uploadInput.click();

    uploadInput.onChange.listen(
      (changeEvent) {
        final html.File file = uploadInput.files.first;
        final html.FileReader reader = html.FileReader();

        reader.readAsDataUrl(file);

        reader.onLoadEnd.listen(
          (loadEndEvent) async {
            setState(() {
              loading = true;
            });
            final String url =
                await FirebaseStorageServices().uploadImageFile(file);
            if (url != null) {
              setState(() {
                photoUrl = url;
                loading = false;
              });
            }
          },
        );
      },
    );
  }

  Future<int> _getId() async {
    try {
      final String id =
          (await itemRef.orderBy("id", descending: false).getDocuments())
              .documents
              .last
              .data["id"];

      return int.parse(id) + 1;
    } catch (e) {
      return 1;
    }
  }
}
