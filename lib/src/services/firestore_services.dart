import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final Firestore _firestore = Firestore.instance;
final CollectionReference adminRef = _firestore.collection('admins');

class FirestoreServices {
  saveData(FirebaseUser firebaseUser) {
    adminRef
        .document(firebaseUser.email)
        .setData({'email': firebaseUser.email, 'name': ''});
  }
}
