import 'package:d2shop_admin/src/models/shopping_model.dart';
import 'package:d2shop_admin/src/services/firebase_storage_service.dart';
import 'package:d2shop_admin/src/services/firestore_services.dart';
import 'package:d2shop_admin/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:universal_html/prefer_universal/html.dart' as html;

class AddNewCategory extends StatefulWidget {
  @override
  _AddNewCategoryState createState() => _AddNewCategoryState();
}

class _AddNewCategoryState extends State<AddNewCategory> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String name, subCategory, imageUrl;

  bool loading = false;

  submit() async {
    if (_formKey.currentState.validate()) {
      if (imageUrl != null) {
        _formKey.currentState.save();

        setState(() {
          loading = true;
        });

        int id = await _getId();
        Map itemList = await getSubCategoryList(subCategory);

        final Category category = Category(
          name: name,
          id: id.toString(),
          isFeatured: false,
          photoUrl: imageUrl,
          itemList: itemList,
        );

        FirestoreServices().addNewCategory(category).then((value) {
          Utils.showMessage('$name has been succesfully added.');
          setState(() {
            loading = false;
          });
        });
      } else {
        Utils.showMessage('Please select an image file.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.35,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Name',
                helperText: 'Milk | Grocery',
              ),
              validator: (value) =>
                  value.isEmpty ? 'This field is required.' : null,
              onSaved: (newValue) => name = newValue.trim(),
            ),
            SizedBox(height: 10),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Sub - Category',
                helperText: 'Comma Seprated (If more than one)',
              ),
              validator: (value) =>
                  value.isEmpty ? 'This field is required.' : null,
              onSaved: (newValue) => subCategory = newValue.trim(),
            ),
            SizedBox(height: 10),
            ListTile(
              title: imageUrl != null
                  ? Text('Change Image (PNG)')
                  : Text('Choose Image'),
              onTap: uploadImage,
              trailing: imageUrl != null ? Image.network(imageUrl) : null,
            ),
            SizedBox(height: 20),
            !loading
                ? Align(
                    alignment: Alignment.centerRight,
                    child: MaterialButton(
                      onPressed: submit,
                      child: Text('Add New Category'),
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

  Future<int> _getId() async {
    try {
      final String id =
          (await categoryRef.orderBy("id", descending: false).getDocuments())
              .documents
              .last
              .data["id"];

      return int.parse(id) + 1;
    } catch (e) {
      return 1;
    }
  }
}
