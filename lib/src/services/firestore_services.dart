import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:d2shop_admin/src/models/admin_model.dart';
import 'package:d2shop_admin/src/models/apartment_model.dart';
import 'package:d2shop_admin/src/models/chat_model.dart';
import 'package:d2shop_admin/src/models/doonstore_user.dart';
import 'package:d2shop_admin/src/models/featured_model.dart';
import 'package:d2shop_admin/src/models/message_model.dart';
import 'package:d2shop_admin/src/models/shopping_model.dart';
import 'package:d2shop_admin/src/utils/utils.dart';
import 'package:uuid/uuid.dart';
import '../models/coupon_model.dart';

class FirestoreServices {
  // Users
  Future<DoonStoreUser> getUser(String id) {
    return userRef
        .document(id)
        .get()
        .then((value) => DoonStoreUser.fromJson(value.data));
  }

  Future<void> sendMessageToSupport(SupportMessages supportMessages) {
    return chatRef
        .document(supportMessages.id)
        .setData(supportMessages.toJson());
  }

  Future<List<OrderModel>> getOrdersByLimit(int limit) {
    return orderRef
        .limit(limit)
        .orderBy("orderDate", descending: false)
        .getDocuments()
        .then((value) =>
            value.documents.map((e) => OrderModel.fromJson(e.data)).toList());
  }

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

    category.itemList["${item.partOfSubCategory}"].add(item.toJson());

    updateCategory(category);
    return itemRef.document(item.id).setData(item.toJson());
  }

  Future<void> updateProduct(Item item) async {
    Category category = await fetchSubCategories(item.partOfCategory);

    category.itemList["${item.partOfSubCategory}"]
        .removeWhere((element) => element['id'] == item.id);
    category.itemList["${item.partOfSubCategory}"].add(item.toJson());

    updateCategory(category);

    return itemRef.document(item.id).updateData(item.toJson());
  }

  Future<void> deleteProduct(Item item) async {
    Category category = await fetchSubCategories(item.partOfCategory);

    category.itemList["${item.partOfSubCategory}"]
        .removeWhere((element) => element['id'] == item.id);

    updateCategory(category);

    return itemRef.document(item.id).delete();
  }

  // Orders
  Future<List<OrderModel>> getOrdersDocuments() {
    return orderRef.getDocuments().then((value) =>
        value.documents.map((e) => OrderModel.fromJson(e.data)).toList());
  }

  // Apartment
  Future<void> addNewApartment(ApartmentModel apartmentModel) {
    return apartmentRef
        .document(apartmentModel.value)
        .setData(apartmentModel.toJson());
  }

  Future<void> deleteApartment(ApartmentModel apartmentModel) {
    return apartmentRef.document(apartmentModel.value).delete();
  }

  // Coupon
  Future<void> addNewCoupon(CouponModel couponModel) {
    return couponRef
        .document(couponModel.promoCode)
        .setData(couponModel.toJson());
  }

  Future<void> removeCoupon(CouponModel couponModel) {
    return couponRef.document(couponModel.promoCode).delete();
  }

  // Notifications
  Future<void> addNotification(Message msg) {
    return notificationRef.document(Uuid().v4()).setData(msg.toJson());
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

  Stream<List<ApartmentModel>> get getApartments {
    return apartmentRef.snapshots().map((q) =>
        q.documents.map((e) => ApartmentModel.fromJson(e.data)).toList());
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

  Stream<List<SupportMessages>> get getMessages {
    return chatRef.snapshots().map((q) =>
        q.documents.map((e) => SupportMessages.fromJson(e.data)).toList());
  }

  Stream<List<CouponModel>> get getCoupons {
    return couponRef.snapshots().map(
        (q) => q.documents.map((e) => CouponModel.fromJson(e.data)).toList());
  }

  Stream<List<Message>> get getNotifications {
    return notificationRef
        .snapshots()
        .map((q) => q.documents.map((e) => Message.fromJson(e.data)).toList());
  }

  // Service Fee
  Future<num> get serviceFee {
    return servicesRef
        .document('serviceFee')
        .get()
        .then((value) => value['value']);
  }

  Future<void> updateServiceFee(num value) {
    return servicesRef.document('serviceFee').updateData({'value': value});
  }
}
