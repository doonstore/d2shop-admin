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
        .doc(id)
        .get()
        .then((value) => DoonStoreUser.fromJson(value.data()));
  }

  Future<void> sendMessageToSupport(SupportMessages supportMessages) {
    return chatRef.doc(supportMessages.id).set(supportMessages.toJson());
  }

  Future<List<OrderModel>> getOrdersByLimit(int limit) {
    return orderRef
        .limit(limit)
        .orderBy("orderDate", descending: false)
        .get()
        .then((value) =>
            value.docs.map((e) => OrderModel.fromJson(e.data())).toList());
  }

  // Admins
  Future<void> saveAdminData(AdminModel admin) {
    return adminRef.doc(admin.emailAddress).set(admin.toMap());
  }

  Future<void> updateAdminData(AdminModel admin) {
    return adminRef.doc(admin.emailAddress).update(admin.toMap());
  }

  Future<void> deleteAdmin(AdminModel adminModel) {
    return adminRef.doc(adminModel.emailAddress).delete();
  }

  // Category
  Future<void> addNewCategory(Category category) {
    return categoryRef.doc(category.id).set(category.toJson());
  }

  Future<void> updateCategory(Category category) {
    return categoryRef.doc(category.id).update(category.toJson());
  }

  Future<void> deleteCategory(Category category) {
    return categoryRef.doc(category.id).delete();
  }

  // Product
  Future<void> addNewProduct(Item item) async {
    Category category = await fetchSubCategories(item.partOfCategory);

    category.itemList["${item.partOfSubCategory}"].add(item.toJson());

    updateCategory(category);
    return itemRef.doc(item.id).set(item.toJson());
  }

  Future<void> updateProduct(Item item) async {
    Category category = await fetchSubCategories(item.partOfCategory);

    category.itemList["${item.partOfSubCategory}"]
        .removeWhere((element) => element['id'] == item.id);
    category.itemList["${item.partOfSubCategory}"].add(item.toJson());

    updateCategory(category);

    return itemRef.doc(item.id).update(item.toJson());
  }

  Future<void> deleteProduct(Item item) async {
    Category category = await fetchSubCategories(item.partOfCategory);

    category.itemList["${item.partOfSubCategory}"]
        .removeWhere((element) => element['id'] == item.id);

    updateCategory(category);

    return itemRef.doc(item.id).delete();
  }

  // Orders
  Future<List<OrderModel>> getOrdersdocs() {
    return orderRef.get().then((value) =>
        value.docs.map((e) => OrderModel.fromJson(e.data())).toList());
  }

  // Apartment
  Future<void> addNewApartment(ApartmentModel apartmentModel) {
    return apartmentRef.doc(apartmentModel.value).set(apartmentModel.toJson());
  }

  Future<void> deleteApartment(ApartmentModel apartmentModel) {
    return apartmentRef.doc(apartmentModel.value).delete();
  }

  // Coupon
  Future<void> addNewCoupon(CouponModel couponModel) {
    return couponRef.doc(couponModel.promoCode).set(couponModel.toJson());
  }

  Future<void> removeCoupon(CouponModel couponModel) {
    return couponRef.doc(couponModel.promoCode).delete();
  }

  // Notifications
  Future<void> addNotification(Message msg) {
    return notificationRef.doc(Uuid().v4()).set(msg.toJson());
  }

  // Featured Tab
  Future<void> addFeaturedBanner(FeaturedModel featuredModel) {
    return featuredRef.doc(featuredModel.date).set(featuredModel.toJSON());
  }

  Future<void> deleteFeaturedBanner(FeaturedModel featuredModel) {
    return featuredRef.doc(featuredModel.date).delete();
  }

  Future<List<String>> fetchCategories() async {
    QuerySnapshot querySnapshot = await categoryRef.get();
    List<Category> _list =
        querySnapshot.docs.map((e) => Category.fromJson(e.data())).toList();
    if (_list.length > 0)
      return _list.map((e) => e.name).toList();
    else
      return [];
  }

  Future<Category> fetchSubCategories(String name) async {
    List<Category> _list = await categoryRef.get().then(
        (value) => value.docs.map((e) => Category.fromJson(e.data())).toList());

    return _list.where((element) => element.name == name).toList().first;
  }

  // Streams
  Stream<List<AdminModel>> get getAdmins {
    return adminRef.snapshots().map((event) =>
        event.docs.map((e) => AdminModel.fromJson(e.data())).toList());
  }

  Stream<List<DoonStoreUser>> get getUsers {
    return userRef.snapshots().map((event) =>
        event.docs.map((e) => DoonStoreUser.fromJson(e.data())).toList());
  }

  Stream<List<Category>> get getCategories {
    return categoryRef.snapshots().map((QuerySnapshot q) =>
        q.docs.map((doc) => Category.fromJson(doc.data())).toList());
  }

  Stream<List<FeaturedModel>> get getFeaturedHeaders {
    return featuredRef.orderBy('date', descending: false).snapshots().map(
        (q) => q.docs.map((e) => FeaturedModel.fromJSON(e.data())).toList());
  }

  Stream<List<ApartmentModel>> get getApartments {
    return apartmentRef.snapshots().map(
        (q) => q.docs.map((e) => ApartmentModel.fromJson(e.data())).toList());
  }

  Stream<List<Item>> get getProducts {
    return itemRef
        .snapshots()
        .map((q) => q.docs.map((e) => Item.fromJson(e.data())).toList());
  }

  Stream<List<OrderModel>> get getOrders {
    return orderRef
        .snapshots()
        .map((q) => q.docs.map((e) => OrderModel.fromJson(e.data())).toList());
  }

  Stream<List<SupportMessages>> get getMessages {
    return chatRef.snapshots().map(
        (q) => q.docs.map((e) => SupportMessages.fromJson(e.data())).toList());
  }

  Stream<List<CouponModel>> get getCoupons {
    return couponRef
        .snapshots()
        .map((q) => q.docs.map((e) => CouponModel.fromJson(e.data())).toList());
  }

  Stream<List<Message>> get getNotifications {
    return notificationRef
        .snapshots()
        .map((q) => q.docs.map((e) => Message.fromJson(e.data())).toList());
  }

  // Service Fee
  Future<num> get serviceFee {
    return servicesRef
        .doc('serviceFee')
        .get()
        .then((value) => value.data()['value']);
  }

  Future<void> updateServiceFee(num value) {
    return servicesRef.doc('serviceFee').update({'value': value});
  }
}
