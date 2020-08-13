import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:d2shop_admin/src/models/admin_model.dart';
import 'package:d2shop_admin/src/models/doonstore_user.dart';
import 'package:d2shop_admin/src/models/featured_model.dart';
import 'package:d2shop_admin/src/models/shopping_model.dart';
import 'package:d2shop_admin/src/utils/utils.dart';

class FirestoreServices {
  // Admins
  Future<void> saveAdminData(AdminModel admin) {
    return adminRef.document(admin.emailAddress).setData(admin.toMap());
  }

  Future<void> updateAdminData(AdminModel admin) {
    return adminRef.document(admin.emailAddress).updateData(admin.toMap());
  }

  Future<void> deleteAdmin(AdminModel adminModel) {
    return adminRef.document(adminModel.emailAddress).delete();
  }

  // Category
  Future<void> addNewCategory(Category category) {
    return categoryRef.document(category.id).setData(category.toJson());
  }

  Future<void> updateCategory(Category category) {
    return categoryRef.document(category.id).updateData(category.toJson());
  }

  Future<void> deleteCategory(Category category) {
    return categoryRef.document(category.id).delete();
  }

  // Product
  Future<void> addNewProduct(Item item) async {
    Category category = await fetchSubCategories(item.partOfCategory);

    List list = category.itemList["${item.partOfSubCategory}"];
    list.add(item.toJson());

    updateCategory(category);
    return itemRef.document(item.id).setData(item.toJson());
  }

  Future<void> updateProduct(Item item) {
    return itemRef.document(item.id).updateData(item.toJson());
  }

  Future<void> deleteProduct(Item item) async {
    Category category = await fetchSubCategories(item.partOfCategory);

    List list = category.itemList["${item.partOfSubCategory}"];
    list.removeWhere((element) => element['name'] == item.name);

    updateCategory(category);

    return itemRef.document(item.id).delete();
  }

  // Featured Tab
  Future<void> addFeaturedBanner(FeaturedModel featuredModel) {
    return featuredRef
        .document(featuredModel.date)
        .setData(featuredModel.toJSON());
  }

  Future<void> deleteFeaturedBanner(FeaturedModel featuredModel) {
    return featuredRef.document(featuredModel.date).delete();
  }

  Future<List<String>> fetchCategories() async {
    QuerySnapshot querySnapshot = await categoryRef.getDocuments();
    List<Category> _list =
        querySnapshot.documents.map((e) => Category.fromJson(e.data)).toList();
    if (_list.length > 0)
      return _list.map((e) => e.name).toList();
    else
      return [];
  }

  Future<Category> fetchSubCategories(String name) async {
    List<Category> _list = await categoryRef.getDocuments().then((value) =>
        value.documents.map((e) => Category.fromJson(e.data)).toList());

    return _list.where((element) => element.name == name).toList().first;
  }

  // Streams
  Stream<List<AdminModel>> get getAdmins {
    return adminRef.snapshots().map((event) =>
        event.documents.map((e) => AdminModel.fromJson(e.data)).toList());
  }

  Stream<List<DoonStoreUser>> get getUsers {
    return userRef.snapshots().map((event) =>
        event.documents.map((e) => DoonStoreUser.fromJson(e.data)).toList());
  }

  Stream<List<Category>> get getCategories {
    return categoryRef.snapshots().map((QuerySnapshot q) => q.documents
        .map((DocumentSnapshot doc) => Category.fromJson(doc.data))
        .toList());
  }

  Stream<List<FeaturedModel>> get getFeaturedHeaders {
    return featuredRef.orderBy('date', descending: false).snapshots().map(
        (q) => q.documents.map((e) => FeaturedModel.fromJSON(e.data)).toList());
  }

  Stream<List<Item>> get getProducts {
    return itemRef
        .snapshots()
        .map((q) => q.documents.map((e) => Item.fromJson(e.data)).toList());
  }

  Stream<List<OrderModel>> get getOrders {
    return orderRef.snapshots().map(
        (q) => q.documents.map((e) => OrderModel.fromJson(e.data)).toList());
  }
}
