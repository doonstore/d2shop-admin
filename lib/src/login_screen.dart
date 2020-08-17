import 'package:d2shop_admin/src/services/auth_service.dart';
import 'package:d2shop_admin/src/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _email, _pass;

  submit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      AuthService().login(_email, _pass, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(46, 174, 227, 1.0),
              Color.fromRGBO(100, 199, 235, 1.0)
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Center(
          child: FractionallySizedBox(
            widthFactor: 0.3,
            heightFactor: 0.6,
            child: Material(
              elevation: 10,
              borderRadius: BorderRadius.circular(12),
              animationDuration: Duration(milliseconds: 300),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
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
                        decoration: InputDecoration(
                          labelText: 'Email Address',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) => !value.contains('.com')
                            ? 'Please enter a valid email address.'
                            : null,
                        onSaved: (newValue) => _email = newValue.trim(),
                      ),
                      SizedBox(height: 15),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        obscureText: true,
                        keyboardType: TextInputType.visiblePassword,
                        validator: (value) => value.isEmpty
                            ? 'Please enter a valid password.'
                            : null,
                        onSaved: (newValue) => _pass = newValue.trim(),
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: CustomButton(onTap: submit, text: "Login"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
