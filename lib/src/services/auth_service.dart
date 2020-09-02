import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:d2shop_admin/src/main_screen.dart';
import 'package:d2shop_admin/src/models/admin_model.dart';
import 'package:d2shop_admin/src/provider/state.dart';
import 'package:d2shop_admin/src/services/firestore_services.dart';
import 'package:d2shop_admin/src/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addNewUser(AdminModel adminModel, String pass) async {
    try {
      final UserCredential authResult =
          await _auth.createUserWithEmailAndPassword(
              email: adminModel.emailAddress, password: pass);

      final User firebaseUser = authResult.user;

      if (firebaseUser != null) {
        firebaseUser.sendEmailVerification();
        return FirestoreServices().saveAdminData(adminModel);
      }
    } catch (e) {
      Utils.showMessage(e.toString());
    }
  }

  login(String email, String password, BuildContext context) async {
    try {
      UserCredential authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (authResult.user != null) {
        DocumentSnapshot doc = await adminRef.doc(email).get();

        if (doc.exists) {
          Provider.of<ApplicationState>(context, listen: false)
              .setAdmin(AdminModel.fromJson(doc.data()));

          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => MainScreen()));
        } else {
          Utils.showMessage(
              "You are not authorized to login into the admin panel.");
        }
      }
    } catch (e) {
      Utils.showMessage(e.toString());
    }
  }

  changePassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      Utils.showMessage('Password Reset mail has been sent to $email');
    } catch (e) {
      Utils.showMessage(e.toString());
    }
  }
}
