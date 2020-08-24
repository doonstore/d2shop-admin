import 'package:d2shop_admin/src/components/add_sub_category.dart';
import 'package:d2shop_admin/src/components/confirm_dialog.dart';
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

class CategoryManage extends StatefulWidget {
  @override
  _CategoryManageState createState() => _CategoryManageState();
}

class _CategoryManageState extends State<CategoryManage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController tecName = TextEditingController(),
      tecSub = TextEditingController();
  String name, subCategory, imageUrl;

  bool loading = false;

  submit(bool modify) async {
    if (_formKey.currentState.validate()) {
      if (imageUrl != null || modify) {
        _formKey.currentState.save();

        setState(() {
          loading = true;
        });

        ApplicationState state =
            Provider.of<ApplicationState>(context, listen: false);

        Map itemList = await getSubCategoryList(subCategory);

        Category category;

        if (state.category != null)
          category = Category(
            name: name,
            id: state.category.id,
            isFeatured: state.category.isFeatured,
            photoUrl: state.category.photoUrl,
            itemList: itemList,
          );
        else
          category = Category(
            name: name,
            id: Uuid().v4(),
            isFeatured: false,
            photoUrl: imageUrl,
            itemList: itemList,
          );

        if (state.category != null)
          FirestoreServices().updateCategory(category);
        else
          FirestoreServices().addNewCategory(category);

        Utils.showMessage('$name has been succesfully added / modified.');
        _formKey.currentState.reset();
        setState(() {
          loading = false;
          tecName.text = '';
          tecSub.text = '';
          imageUrl = null;
        });
        Provider.of<ApplicationState>(context, listen: false).deleteCategory();
      } else {
        Utils.showMessage('Please select an image file.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
      builder: (context, value, child) => Container(
        child: Row(
          children: [
            Expanded(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: tecName,
                      decoration: Utils.inputDecoration("Name of the category",
                          helper: 'Milk | Grocery'),
                      validator: (value) =>
                          value.isEmpty ? 'This field is required.' : null,
                      onSaved: (newValue) => name = newValue.trim(),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: tecSub,
                      decoration: Utils.inputDecoration("Sub - Category (List)",
                          helper: "Comma Seprated (If more than one)"),
                      validator: (value) =>
                          value.isEmpty ? 'This field is required.' : null,
                      onSaved: (newValue) => subCategory = newValue.trim(),
                    ),
                    SizedBox(height: 10),
                    if (value.category == null)
                      Material(
                        color: Colors.blue,
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(12),
                        child: ListTile(
                          leading: FaIcon(FontAwesomeIcons.upload,
                              color: Colors.white),
                          title: Text(
                            imageUrl != null
                                ? 'Change Image'
                                : 'Choose Image (PNG)',
                            style: TextStyle(color: Colors.white),
                          ),
                          onTap: uploadImage,
                          trailing: imageUrl != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(imageUrl),
                                )
                              : null,
                        ),
                      ),
                    SizedBox(height: 20),
                    !loading
                        ? Align(
                            alignment: Alignment.centerRight,
                            child: CustomButton(
                                onTap: () => submit(value.category != null),
                                text: value.category != null
                                    ? "Modify Category"
                                    : 'Add New Category'),
                          )
                        : Utils.loadingBtn(),
                    SizedBox(height: 50),
                  ],
                ),
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: StreamProvider<List<Category>>.value(
                value: FirestoreServices().getCategories,
                builder: (context, child) {
                  List<Category> _dataList =
                      Provider.of<List<Category>>(context);

                  if (_dataList == null) return Utils.loading();
                  if (_dataList.length == 0) return Utils.noDataWidget(context);

                  return ListView.builder(
                    itemCount: _dataList.length,
                    itemBuilder: (context, index) {
                      Category category = _dataList[index];

                      return CustomCard(
                        onTap: () {
                          Provider.of<ApplicationState>(context, listen: false)
                              .setCategory(category);

                          setState(() {
                            tecName.text = category.name;
                            tecSub.text = category.itemList.keys.join(",");
                          });
                        },
                        imageUrl: category.photoUrl,
                        title: category.name,
                        subtitle: category.itemList.keys.toList().join(','),
                        trailing: Container(
                          width: 100,
                          child: Row(
                            children: [
                              IconButton(
                                icon: FaIcon(
                                  FontAwesomeIcons.plus,
                                  color: Colors.teal,
                                ),
                                tooltip:
                                    "Add Sub - Category to ${category.name}",
                                onPressed: () => showDialog(
                                  context: context,
                                  builder: (context) =>
                                      AddSubCategory(category: category),
                                ),
                              ),
                              IconButton(
                                icon: FaIcon(
                                  FontAwesomeIcons.times,
                                  color: Colors.red,
                                ),
                                tooltip: "Delete ${category.name}",
                                onPressed: () => showDialog(
                                  context: context,
                                  builder: (context) => ConfirmDialog(
                                    title:
                                        'Are you sure to delete ${category.name}?',
                                    confirmBtnCallback: () {
                                      FirestoreServices()
                                          .deleteCategory(category);
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            )
          ],
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
                imageUrl = url;
                loading = false;
              });
            }
          },
        );
      },
    );
  }
}
