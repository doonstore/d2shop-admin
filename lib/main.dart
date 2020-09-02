import 'package:d2shop_admin/src/login_screen.dart';
import 'package:d2shop_admin/src/provider/state.dart';
import 'package:d2shop_admin/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ApplicationState>(
      create: (context) => ApplicationState(),
      child: MaterialApp(
        title: 'D2Shop | Admin Panel',
        theme: ThemeData(
          primaryColor: kColor,
          scaffoldBackgroundColor: Colors.white,
          dialogTheme: DialogTheme(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          buttonTheme: ButtonThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        home: LoginPage(),
      ),
    );
  }
}
