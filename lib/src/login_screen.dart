import 'package:d2shop_admin/src/provider/state.dart';
import 'package:d2shop_admin/src/services/auth_service.dart';
import 'package:d2shop_admin/src/utils/utils.dart';
import 'package:d2shop_admin/src/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _email, _pass;
  bool loading = false;

  submit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      setState(() {
        loading = true;
      });

      AuthService().login(_email, _pass, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<ApplicationState>(
      builder: (context, value, child) => Scaffold(
          body: Container(
        width: size.width,
        height: size.height,
        color: kColor,
        padding: const EdgeInsets.all(50),
        child: Material(
          elevation: 10.0,
          color: Colors.white,
          animationDuration: Duration(milliseconds: 300),
          borderRadius: BorderRadius.circular(15),
          child: Row(
            children: [
              sideBarImage(),
              loginArea(),
            ],
          ),
        ),
      )),
    );
  }

  Expanded sideBarImage() {
    return Expanded(
      child: Image.asset(
        "assets/login.png",
        fit: BoxFit.cover,
      ),
      flex: 2,
    );
  }

  Expanded loginArea() {
    return Expanded(
      child: Material(
        elevation: 10,
        color: Colors.white,
        borderRadius: BorderRadius.horizontal(right: Radius.circular(15)),
        animationDuration: Duration(milliseconds: 300),
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Welcome to DoonStore Admin",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Login in, to see it in action.",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 25),
                TextFormField(
                  decoration: Utils.inputDecoration("Email Address"),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: (value) => !value.contains('.com')
                      ? 'Please enter a valid email address.'
                      : null,
                  onSaved: (newValue) => _email = newValue.trim(),
                ),
                SizedBox(height: 15),
                TextFormField(
                  decoration: Utils.inputDecoration("Password"),
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.done,
                  validator: (value) =>
                      value.isEmpty ? 'Please enter a valid password.' : null,
                  onSaved: (newValue) => _pass = newValue.trim(),
                ),
                SizedBox(height: 20),
                !loading
                    ? CustomButton(onTap: submit, text: "Login")
                    : Utils.loadingBtn()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
