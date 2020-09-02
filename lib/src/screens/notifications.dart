import 'package:d2shop_admin/src/models/message_model.dart';
import 'package:d2shop_admin/src/services/firebase_storage_service.dart';
import 'package:d2shop_admin/src/services/firestore_services.dart';
import 'package:d2shop_admin/src/utils/utils.dart';
import 'package:d2shop_admin/src/widgets/custom_button.dart';
import 'package:d2shop_admin/src/widgets/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:universal_html/prefer_universal/html.dart' as html;

class PushNotification extends StatefulWidget {
  @override
  _PushNotificationState createState() => _PushNotificationState();
}

class _PushNotificationState extends State<PushNotification> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String title, body, imageUrl;
  bool loading = false;

  void sendNotification() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      setState(() {
        loading = true;
      });

      Message message = Message(title: title, body: body, imageUrl: imageUrl);
      message.sendNotification().then((value) {
        if (value) {
          FirestoreServices().addNotification(message).then((value) {
            Utils.showMessage("Notification has been sent successfully.");
          });
        } else
          Utils.showMessage("Failed to send notification. Error occured");
        setState(() {
          loading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(15),
        child: Row(
          children: [
            Expanded(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      decoration: Utils.inputDecoration("Notification Title"),
                      validator: (value) =>
                          value.isEmpty ? 'This field is required.' : null,
                      onSaved: (newValue) => title = newValue.trim(),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      decoration: Utils.inputDecoration("Notification Body"),
                      validator: (value) =>
                          value.isEmpty ? 'This field is required.' : null,
                      onSaved: (newValue) => body = newValue.trim(),
                    ),
                    SizedBox(height: 10),
                    Material(
                      color: Colors.blue,
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(12),
                      child: ListTile(
                        leading: imageUrl != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(imageUrl),
                              )
                            : null,
                        trailing:
                            FaIcon(FontAwesomeIcons.image, color: Colors.white),
                        title: Text(
                          'Choose Image (Optional)',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: uploadImage,
                      ),
                    ),
                    SizedBox(height: 20),
                    !loading
                        ? Align(
                            alignment: Alignment.centerRight,
                            child: CustomButton(
                                onTap: sendNotification,
                                text: "Send Notification"),
                          )
                        : Utils.loadingBtn(),
                  ],
                ),
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: StreamProvider<List<Message>>.value(
                value: FirestoreServices().getNotifications,
                builder: (context, child) {
                  List<Message> _dataList = Provider.of<List<Message>>(context);

                  if (_dataList == null) return Utils.loading();
                  if (_dataList.length == 0) return Utils.noDataWidget(context);

                  return ListView.builder(
                    itemCount: _dataList.length,
                    itemBuilder: (context, index) {
                      Message msg = _dataList[index];

                      return CustomCard(
                        title: msg.title,
                        subtitle: msg.body,
                        imageUrl: msg.imageUrl,
                        trailing: Text(
                          DateFormat.yMMMMEEEEd()
                              .add_jms()
                              .format(DateTime.parse(msg.date)),
                          style: TextStyle(color: Colors.indigo),
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
            final String url = await FirebaseStorageServices()
                .uploadImageFile(file, isNotification: true);
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
