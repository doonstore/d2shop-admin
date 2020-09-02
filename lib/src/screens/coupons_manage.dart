import 'package:d2shop_admin/src/components/confirm_dialog.dart';
import 'package:d2shop_admin/src/models/coupon_model.dart';
import 'package:d2shop_admin/src/provider/state.dart';
import 'package:d2shop_admin/src/services/firestore_services.dart';
import 'package:d2shop_admin/src/utils/utils.dart';
import 'package:d2shop_admin/src/widgets/custom_button.dart';
import 'package:d2shop_admin/src/widgets/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CouponsManage extends StatefulWidget {
  @override
  _CouponsManageState createState() => _CouponsManageState();
}

class _CouponsManageState extends State<CouponsManage> {
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
            validTill = null;
            Provider.of<ApplicationState>(context, listen: false)
                .changeAdding(false);
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Utils.appBar("Coupons"),
      floatingActionButton: Utils.fab(
        'Add New Coupon',
        () {
          Provider.of<ApplicationState>(context, listen: false)
              .changeAdding(true);
        },
      ),
      body: Container(
        padding: EdgeInsets.all(15),
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
                              TextFormField(
                                textCapitalization:
                                    TextCapitalization.characters,
                                decoration: Utils.inputDecoration("Promo Code",
                                    helper: "MILK50"),
                                validator: (value) => value.isEmpty
                                    ? 'This field is required.'
                                    : null,
                                onSaved: (newValue) =>
                                    promoCode = newValue.trim(),
                              ),
                              SizedBox(height: 10),
                              TextFormField(
                                decoration: Utils.inputDecoration(
                                    "Promotional Message",
                                    helper: "Get 50% off"),
                                validator: (value) => value.isEmpty
                                    ? 'This field is required.'
                                    : null,
                                onSaved: (newValue) =>
                                    message = newValue.trim(),
                              ),
                              SizedBox(height: 10),
                              TextFormField(
                                initialValue: '1',
                                decoration: Utils.inputDecoration(
                                    "Limit (Numeric Value)"),
                                validator: (value) => value.isEmpty
                                    ? 'This field is required.'
                                    : null,
                                onSaved: (newValue) =>
                                    limit = int.parse(newValue.trim()),
                                keyboardType: TextInputType.number,
                              ),
                              SizedBox(height: 10),
                              TextFormField(
                                decoration: Utils.inputDecoration(
                                    "Benifit (Numeric Value)",
                                    helper: "15"),
                                validator: (value) => value.isEmpty
                                    ? 'This field is required.'
                                    : null,
                                onSaved: (newValue) =>
                                    benifitValue = int.parse(newValue.trim()),
                                keyboardType: TextInputType.number,
                              ),
                              SizedBox(height: 10),
                              Material(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(12),
                                elevation: 5.0,
                                child: ListTile(
                                  leading: FaIcon(FontAwesomeIcons.calendar,
                                      color: Colors.white),
                                  title: Text(
                                    'Pick expiry date',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onTap: () => pickDate(context),
                                  trailing: validTill != null
                                      ? Text(
                                          DateFormat.yMMMMEEEEd().format(
                                              DateTime.parse(validTill)),
                                          style: TextStyle(color: Colors.white),
                                        )
                                      : null,
                                ),
                              ),
                              SizedBox(height: 20),
                              !loading
                                  ? Align(
                                      alignment: Alignment.centerRight,
                                      child: CustomButton(
                                          onTap: submit,
                                          text: 'Add New Coupon'),
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
              child: StreamProvider<List<CouponModel>>.value(
                value: FirestoreServices().getCoupons,
                builder: (context, child) {
                  List<CouponModel> _dataList =
                      Provider.of<List<CouponModel>>(context);

                  if (_dataList == null) return Utils.loading();
                  if (_dataList.length == 0) return Utils.noDataWidget(context);
                  return ListView.builder(
                    itemCount: _dataList.length,
                    itemBuilder: (context, index) {
                      CouponModel model = _dataList[index];

                      return CustomCard(
                        leading: model.benifitValue.toString(),
                        title: "${model.promoCode}; Limit: ${model.limit}",
                        subtitle:
                            "${model.message}; ValidTill: (${DateFormat.yMMMMEEEEd().format(DateTime.parse(model.validTill))})",
                        trailing: IconButton(
                          icon: FaIcon(
                            FontAwesomeIcons.times,
                            color: Colors.red,
                          ),
                          tooltip: "Delete ${model.promoCode}",
                          onPressed: () => showDialog(
                            context: context,
                            builder: (context) => ConfirmDialog(
                              title:
                                  "Are you sure to delete ${model.promoCode} from the list?",
                              confirmBtnCallback: () =>
                                  FirestoreServices().removeCoupon(model).then(
                                (value) {
                                  Utils.showMessage(
                                      "${model.promoCode} has been removed successfully.");
                                  Navigator.pop(context);
                                },
                              ),
                            ),
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
