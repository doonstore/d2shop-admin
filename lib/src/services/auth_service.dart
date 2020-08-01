import 'package:d2shop_admin/src/login_screen.dart';
import 'package:d2shop_admin/src/main_screen.dart';
import 'package:d2shop_admin/src/services/firestore_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signup(String email, String password) async {
    try {
      final AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (result != null) {
        await FirestoreServices().saveData(result.user);
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        webBgColor: "#000",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        webBgColor: "#000",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  handleAuth() {
    return StreamBuilder(
      stream: _auth.onAuthStateChanged,
      builder: (context, snapshot) {
        if (snapshot.hasData)
          return MainScreen();
        else
          return LoginPage();
      },
    );
  }
}
