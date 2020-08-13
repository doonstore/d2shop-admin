import 'package:d2shop_admin/src/models/admin_model.dart';
import 'package:d2shop_admin/src/screens/add_new_category.dart';
import 'package:d2shop_admin/src/screens/add_new_product.dart';
import 'package:d2shop_admin/src/screens/add_new_user.dart';
import 'package:d2shop_admin/src/screens/existing_users.dart';
import 'package:d2shop_admin/src/screens/featured_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:d2shop_admin/src/screens/category_screen.dart';
import 'package:d2shop_admin/src/screens/customers.dart';
import 'package:d2shop_admin/src/screens/home_page.dart';
import 'package:d2shop_admin/src/screens/products_screen.dart';
import 'package:d2shop_admin/src/screens/orders_screen.dart';

class ApplicationState extends ChangeNotifier {
  AdminModel admin;
  int currentIndex = 0;
  String appBarTitle = '';

  final List<Widget> pages = <Widget>[
    HomePage(),
    CustomersScreen(),
    OrderScreen(),
    CategoryScreen(),
    AddNewCategory(),
    AddNewProduct(),
    ProductScreen(),
    FeaturedPage(),
    UsersScreen(),
    AddNewUser(),
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
}
