import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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

// Color
final kPrimaryColor = Color.fromRGBO(232, 240, 254, 1.0);

class Utils {
  static showMessage(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      webBgColor: "#000",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
    );
  }
}
