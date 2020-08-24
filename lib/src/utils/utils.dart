import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// Firestore Refrences
final Firestore _firestore = Firestore.instance;
final CollectionReference userRef = _firestore.collection('users');
final CollectionReference itemRef = _firestore.collection('item');
final CollectionReference categoryRef = _firestore.collection('category');
final CollectionReference featuredRef = _firestore.collection('featured');
final CollectionReference requestRef = _firestore.collection('requests');
final CollectionReference adminRef = _firestore.collection('admins');
final CollectionReference orderRef = _firestore.collection('orders');
final CollectionReference servicesRef = _firestore.collection('services');
final CollectionReference couponRef = _firestore.collection('coupons');
final CollectionReference chatRef = _firestore.collection('chats');
final CollectionReference apartmentRef = _firestore.collection('apartments');
final CollectionReference notificationRef =
    _firestore.collection('notifications');

// Color
final kPrimaryColor = Color.fromRGBO(232, 240, 254, 1.0);

class Utils {
  static Widget makeDecision(List dataList, BuildContext context,
      {Widget child}) {
    if (dataList == null) return loading();
    if (dataList.length == 0) return noDataWidget(context);

    return child;
  }

  static Widget loading() {
    return Center(
      child: Text('Loading, Please wait...'),
    );
  }

  static Widget loadingBtn() {
    return Material(
      color: Color.fromRGBO(46, 174, 227, 1.0),
      animationDuration: Duration(milliseconds: 400),
      elevation: 8.0,
      shape: StadiumBorder(),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Loading, Please wait...',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(width: 15),
            SpinKitRotatingCircle(
              color: Colors.white,
              size: 25,
            ),
          ],
        ),
      ),
    );
  }

  static Widget noDataWidget(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/no_data.png",
            height: MediaQuery.of(context).size.height * 0.60,
            width: MediaQuery.of(context).size.width * 0.60,
          ),
          Text('No Data!')
        ],
      ),
    );
  }

  static InputDecoration inputDecoration(String label,
      {String helper, Widget icon}) {
    return InputDecoration(
      labelText: label,
      helperText: helper != null ? "For example: " + helper : null,
      icon: icon,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      isDense: true,
    );
  }

  static showMessage(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      webBgColor: "#000",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
    );
  }
}
