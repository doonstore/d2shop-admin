import 'package:d2shop_admin/src/models/featured_model.dart';
import 'package:d2shop_admin/src/services/firebase_storage_service.dart';
import 'package:d2shop_admin/src/services/firestore_services.dart';
import 'package:d2shop_admin/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:universal_html/prefer_universal/html.dart' as html;

class FeaturedPage extends StatefulWidget {
  @override
  _FeaturedPageState createState() => _FeaturedPageState();
}

class _FeaturedPageState extends State<FeaturedPage> {
  String imageUrl;
  bool loading = false;

  submit() {
    FeaturedModel featuredModel =
        FeaturedModel(photoUrl: imageUrl, date: DateTime.now().toString());

    FirestoreServices().addFeaturedBanner(featuredModel).then((value) {
      Utils.showMessage("New Featured Banner Added.");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: imageUrl != null
          ? FloatingActionButton.extended(
              onPressed: submit,
              label: Text('Add Banner'),
            )
          : null,
      bottomSheet: loading
          ? Container(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Please Wait... Image is being uploading.'),
                  SizedBox(width: 15),
                  CircularProgressIndicator()
                ],
              ),
            )
          : null,
      body: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onTap: uploadImage,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey[200],
                ),
                child: Center(
                  child: imageUrl != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(imageUrl))
                      : FaIcon(FontAwesomeIcons.plus),
                ),
              ),
            ),
            StreamProvider<List<FeaturedModel>>.value(
              value: FirestoreServices().getFeaturedHeaders,
              builder: (context, child) {
                final List<FeaturedModel> _dataList =
                    Provider.of<List<FeaturedModel>>(context);

                if (_dataList != null && _dataList.length > 0)
                  return ListView.builder(
                    itemCount: _dataList.length,
                    itemBuilder: (context, index) => Container(
                      height: 300,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(_dataList[index].photoUrl),
                      ),
                    ),
                  );
                return Container();
              },
            ),
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
