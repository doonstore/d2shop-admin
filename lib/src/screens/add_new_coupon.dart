import 'package:d2shop_admin/src/services/firestore_services.dart';
import 'package:d2shop_admin/src/utils/utils.dart';
import 'package:d2shop_admin/src/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../models/coupon_model.dart';

class AddNewCoupon extends StatefulWidget {
  @override
  _AddNewCouponState createState() => _AddNewCouponState();
}

class _AddNewCouponState extends State<AddNewCoupon> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String promoCode, message, validTill;
  int limit, benifitValue;

  bool loading = false;

  submit() {
    if (_formKey.currentState.validate()) {
      if (validTill != null) {
        _formKey.currentState.save();

        setState(() {
          loading = true;
        });

        CouponModel couponModel = CouponModel(
          promoCode: promoCode.toUpperCase(),
          benifitValue: benifitValue,
          limit: limit,
          message: message,
          validTill: validTill,
        );

        FirestoreServices().addNewCoupon(couponModel).then((value) {
          Utils.showMessage("$promoCode has been successfully added.");
          _formKey.currentState.reset();
          setState(() {
            loading = false;
          });
        });
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
              TextFormField(
                textCapitalization: TextCapitalization.characters,
                decoration: InputDecoration(
                  labelText: 'Promo Code',
                  helperText: "MILK50",
                ),
                validator: (value) =>
                    value.isEmpty ? 'This field is required.' : null,
                onSaved: (newValue) => promoCode = newValue.trim(),
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Promotional Message',
                  helperText: "Get 50% off",
                ),
                validator: (value) =>
                    value.isEmpty ? 'This field is required.' : null,
                onSaved: (newValue) => message = newValue.trim(),
              ),
              SizedBox(height: 10),
              TextFormField(
                initialValue: '1',
                decoration: InputDecoration(
                  labelText: 'Limit (Numeric Value)',
                  helperText: "1",
                ),
                validator: (value) =>
                    value.isEmpty ? 'This field is required.' : null,
                onSaved: (newValue) => limit = int.parse(newValue.trim()),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Benifit (Numeric Value)',
                  helperText: "15",
                ),
                validator: (value) =>
                    value.isEmpty ? 'This field is required.' : null,
                onSaved: (newValue) =>
                    benifitValue = int.parse(newValue.trim()),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),
              ListTile(
                leading: FaIcon(FontAwesomeIcons.calendar),
                title: Text('Pick expiry date'),
                onTap: () => pickDate(context),
                trailing: validTill != null
                    ? Text(
                        DateFormat.yMMMMEEEEd()
                            .format(DateTime.parse(validTill)),
                      )
                    : null,
              ),
              SizedBox(height: 20),
              !loading
                  ? Align(
                      alignment: Alignment.centerRight,
                      child:
                          CustomButton(onTap: submit, text: 'Add New Coupon'),
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

  pickDate(BuildContext context) async {
    DateTime dateTime = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
    );

    if (dateTime != null)
      setState(() {
        validTill = dateTime.toString();
      });
  }
}
