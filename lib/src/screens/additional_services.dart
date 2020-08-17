import 'package:d2shop_admin/src/services/firestore_services.dart';
import 'package:d2shop_admin/src/utils/utils.dart';
import 'package:d2shop_admin/src/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AdditionalServices extends StatefulWidget {
  @override
  _AdditionalServicesState createState() => _AdditionalServicesState();
}

class _AdditionalServicesState extends State<AdditionalServices> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  num serviceFee;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    serviceFee = await FirestoreServices().serviceFee;
    setState(() {});
  }

  submit() {
    _formKey.currentState.save();

    FirestoreServices().updateServiceFee(serviceFee).then((value) {
      Utils.showMessage("Additional Services has been successfully updated.");
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.35,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              FutureBuilder<num>(
                future: FirestoreServices().serviceFee,
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Text('Please Wait.. Fetching data from the server');

                  return TextFormField(
                    initialValue: snapshot.data.toString(),
                    decoration: InputDecoration(
                      labelText: 'Service Fee',
                      helperText: 'Note: Numeric Value Only',
                      icon: FaIcon(FontAwesomeIcons.rupeeSign),
                    ),
                    onSaved: (newValue) =>
                        serviceFee = num.parse(newValue.trim()),
                  );
                },
              ),
              SizedBox(height: 15),
              Align(
                alignment: Alignment.centerRight,
                child: CustomButton(onTap: submit, text: 'Make Changes'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
