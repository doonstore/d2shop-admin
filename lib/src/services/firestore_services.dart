import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:d2shop_admin/src/models/doonstore_user.dart';
import 'package:d2shop_admin/src/models/featured_model.dart';
import 'package:d2shop_admin/src/models/shopping_model.dart';
import 'package:d2shop_admin/src/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';

final Firestore _firestore = Firestore.instance;
final CollectionReference adminRef = _firestore.collection('admins');

class FirestoreServices {
  Future<void> saveData(FirebaseUser firebaseUser) {
    return adminRef
        .document(firebaseUser.email)
        .setData({'email': firebaseUser.email, 'name': ''});
  }

  Stream<List<DoonStoreUser>> get getUsers {
    return userRef.snapshots().map((event) =>
        event.documents.map((e) => DoonStoreUser.fromJson(e.data)).toList());
  }

  Stream<List<Category>> get listOfCategories {
    return categoryRef.snapshots().map((QuerySnapshot q) => q.documents
        .map((DocumentSnapshot doc) => Category.fromJson(doc.data))
        .toList());
  }

  Stream<List<FeaturedModel>> get listOfFeaturedHeaders {
    return featuredRef.snapshots().map(
        (q) => q.documents.map((e) => FeaturedModel.fromJSON(e.data)).toList());
  }

  Stream<List<Item>> get listOfItems {
    return itemRef
        .snapshots()
        .map((q) => q.documents.map((e) => Item.fromJson(e.data)).toList());
  }
}
