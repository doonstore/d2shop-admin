import 'package:d2shop_admin/src/models/admin_model.dart';
import 'package:d2shop_admin/src/models/shopping_model.dart' as st;
import 'package:d2shop_admin/src/screens/add_new_user.dart';
import 'package:d2shop_admin/src/screens/additional_services.dart';
import 'package:d2shop_admin/src/screens/apartment.dart';
import 'package:d2shop_admin/src/screens/category.dart';
import 'package:d2shop_admin/src/screens/chat_screen.dart';
import 'package:d2shop_admin/src/screens/coupons_manage.dart';
import 'package:d2shop_admin/src/screens/existing_users.dart';
import 'package:d2shop_admin/src/screens/featured_page.dart';
import 'package:d2shop_admin/src/screens/notifications.dart';
import 'package:d2shop_admin/src/screens/products.dart';
import 'package:d2shop_admin/src/screens/customers.dart';
import 'package:d2shop_admin/src/screens/home_page.dart';
import 'package:flutter/foundation.dart';
import 'package:d2shop_admin/src/screens/orders_screen.dart';
import 'package:flutter/material.dart';

class ApplicationState extends ChangeNotifier {
  AdminModel admin;
  int currentIndex = 0;
  String appBarTitle = '';
  st.Category category;
  bool _adding = false, _loading = false;

  bool get isAdding => _adding;
  bool get isLoading => _loading;

  Widget get currentWidget => pages[currentIndex];

  final List<Widget> pages = <Widget>[
    HomePage(),
    CustomersScreen(),
    OrderScreen(),
    CategoryManage(),
    ProductsManage(),
    CouponsManage(),
    ChatScreen(),
    PushNotification(),
    FeaturedPage(),
    UsersScreen(),
    AddNewUser(),
    Apartment(),
    AdditionalServices()
  ];

  setAdmin(AdminModel adm) {
    this.admin = adm;
    notifyListeners();
  }

  changeIndex(int val, String value) {
    this.currentIndex = val;
    this.appBarTitle = value;
    notifyListeners();
  }

  setLoading(bool val) {
    this._loading = val;
    notifyListeners();
  }

  changeAdding(bool val) {
    this._adding = val;
    notifyListeners();
  }

  setCategory(st.Category cat) {
    this.category = cat;
    notifyListeners();
  }

  deleteCategory() {
    this.category = null;
    notifyListeners();
  }
}
