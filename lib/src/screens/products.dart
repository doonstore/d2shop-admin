import 'package:d2shop_admin/src/components/confirm_dialog.dart';
import 'package:d2shop_admin/src/components/edit_product.dart';
import 'package:d2shop_admin/src/models/shopping_model.dart';
import 'package:d2shop_admin/src/provider/state.dart';
import 'package:d2shop_admin/src/services/firebase_storage_service.dart';
import 'package:d2shop_admin/src/services/firestore_services.dart';
import 'package:d2shop_admin/src/utils/utils.dart';
import 'package:d2shop_admin/src/widgets/custom_button.dart';
import 'package:d2shop_admin/src/widgets/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:universal_html/prefer_universal/html.dart' as html;

class ProductsManage extends StatefulWidget {
  @override
  _ProductsManageState createState() => _ProductsManageState();
}

class _ProductsManageState extends State<ProductsManage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String name, category, subCategory, photoUrl, quantityUnit;
  num quantityValue, price;

  bool loading = false;

  submit() async {
    if (_formKey.currentState.validate()) {
      if (photoUrl != null) {
        _formKey.currentState.save();

        setState(() {
          loading = true;
        });

        Item item = Item(
          id: Uuid().v4(),
          name: name,
          partOfCategory: category,
          partOfSubCategory: subCategory,
          quantityUnit: quantityUnit,
          quantityValue: quantityValue,
          price: price,
          photoUrl: photoUrl,
        );

        FirestoreServices().addNewProduct(item).then((value) {
          Utils.showMessage("$name has been succesfully added.");
          _formKey.currentState.reset();
          setState(() {
            loading = false;
            photoUrl = null;
            Provider.of<ApplicationState>(context, listen: false)
                .changeAdding(false);
          });
        });
      } else
        Utils.showMessage("Please select an image file.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Utils.appBar("Products"),
      floatingActionButton: Utils.fab(
        'Add New Product',
        () {
          Provider.of<ApplicationState>(context, listen: false)
              .changeAdding(true);
        },
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        child: Row(
          children: [
            Consumer<ApplicationState>(
              builder: (context, value, child) => value.isAdding
                  ? Expanded(
                      child: SingleChildScrollView(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              chooseCategory(),
                              SizedBox(height: 10),
                              if (category != null) chooseSubCategory(),
                              SizedBox(height: 10),
                              nameField(),
                              SizedBox(height: 10),
                              priceField(),
                              SizedBox(height: 10),
                              quantityField(),
                              SizedBox(height: 10),
                              unitField(),
                              SizedBox(height: 10),
                              selectImage(),
                              SizedBox(height: 20),
                              !loading
                                  ? Align(
                                      alignment: Alignment.centerRight,
                                      child: CustomButton(
                                          onTap: submit,
                                          text: 'Add New Product'),
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
                    )
                  : SizedBox(),
            ),
            SizedBox(width: 20),
            Expanded(
              child: StreamProvider.value(
                value: FirestoreServices().getProducts,
                builder: (context, child) {
                  List<Item> _dataList = Provider.of<List<Item>>(context);

                  if (_dataList == null) return Utils.loading();
                  if (_dataList.length == 0) return Utils.noDataWidget(context);

                  return ListView.builder(
                    itemCount: _dataList.length,
                    itemBuilder: (context, index) {
                      Item item = _dataList[index];

                      return CustomCard(
                        onTap: () => showDialog(
                          context: context,
                          builder: (context) => EditProduct(item),
                        ),
                        title:
                            "${item.name} - ${item.partOfSubCategory} - ${item.partOfCategory}",
                        subtitle: "\u20b9${item.price} (${item.quantityUnit})",
                        trailing: IconButton(
                          icon: FaIcon(
                            FontAwesomeIcons.times,
                            color: Colors.red,
                          ),
                          tooltip: "Delete ${item.name}",
                          onPressed: () => showDialog(
                            context: context,
                            builder: (context) => ConfirmDialog(
                              title: 'Are you sure to delete ${item.name}?',
                              confirmBtnCallback: () {
                                FirestoreServices().deleteProduct(item);
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ),
                        imageUrl: item.photoUrl,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Material selectImage() {
    return Material(
      color: Colors.blue,
      elevation: 5.0,
      borderRadius: BorderRadius.circular(12),
      child: ListTile(
        leading: FaIcon(FontAwesomeIcons.upload, color: Colors.white),
        title: Text(photoUrl != null ? 'Change Image' : 'Choose Image (PNG)',
            style: TextStyle(color: Colors.white)),
        onTap: uploadImage,
        trailing: photoUrl != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(photoUrl))
            : null,
      ),
    );
  }

  TextFormField unitField() {
    return TextFormField(
      decoration:
          Utils.inputDecoration("Quantity Unit", helper: 'G / KG / L / ML'),
      validator: (value) => value.isEmpty ? 'This field is required.' : null,
      onSaved: (newValue) => quantityUnit = newValue.trim(),
    );
  }

  TextFormField quantityField() {
    return TextFormField(
      decoration: Utils.inputDecoration("Quantity Value (Numeric Value)",
          helper: "250"),
      keyboardType: TextInputType.number,
      validator: (value) => value.isEmpty ? 'This field is required.' : null,
      onSaved: (newValue) => quantityValue = num.parse(newValue.trim()),
    );
  }

  TextFormField priceField() {
    return TextFormField(
      decoration: Utils.inputDecoration("Price of the product (Numeric Value)",
          helper: "150"),
      keyboardType: TextInputType.number,
      validator: (value) => value.isEmpty ? 'This field is required.' : null,
      onSaved: (newValue) => price = num.parse(newValue.trim()),
    );
  }

  TextFormField nameField() {
    return TextFormField(
      decoration:
          Utils.inputDecoration("Name of the product", helper: "Amul Milk"),
      validator: (value) => value.isEmpty ? 'This field is required.' : null,
      onSaved: (newValue) => name = newValue.trim(),
    );
  }

  FutureBuilder<Category> chooseSubCategory() {
    return FutureBuilder(
      future: FirestoreServices().fetchSubCategories(category),
      builder: (context, AsyncSnapshot<Category> snapshot) {
        if (!snapshot.hasData) {
          return Text('Loading...');
        }

        List<String> dataList = snapshot.data.itemList.keys.toList();

        return DropdownButtonFormField<String>(
          decoration: InputDecoration(labelText: 'Choose Sub-Category'),
          items: dataList
              .map((e) => DropdownMenuItem(child: Text(e), value: e))
              .toList(),
          onChanged: (val) => this.setState(() {
            subCategory = val;
          }),
          validator: (value) =>
              value == null ? 'Please select a sub-category' : null,
        );
      },
    );
  }

  FutureBuilder<List<String>> chooseCategory() {
    return FutureBuilder(
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
                .map((e) => DropdownMenuItem(child: Text(e), value: e))
                .toList(),
            onChanged: (val) => this.setState(() {
              category = val;
            }),
            validator: (value) =>
                value == null ? 'Please select a category' : null,
          );
        } else {
          return Text('Sorry, No Category Avaiable! Please add category first');
        }
      },
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
            if (url != null)
              setState(() {
                photoUrl = url;
                loading = false;
              });
          },
        );
      },
    );
  }
}
