import 'package:d2shop_admin/src/services/auth_service.dart';
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

      AuthService().login(_email, _pass);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DoonStore'),
        centerTitle: true,
      ),
      body: Center(
        child: FractionallySizedBox(
          widthFactor: 0.4,
          heightFactor: 0.7,
          child: Material(
            elevation: 10,
            borderRadius: BorderRadius.circular(20),
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
                      "Login to DoonStore Admin",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Email Address',
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) => !value.contains('.com')
                          ? 'Please enter a valid email address.'
                          : null,
                      onSaved: (newValue) => _email = newValue.trim(),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Password',
                      ),
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      validator: (value) => value.isEmpty
                          ? 'Please enter a valid password.'
                          : null,
                      onSaved: (newValue) => _pass = newValue.trim(),
                    ),
                    SizedBox(height: 10),
                    MaterialButton(
                      onPressed: submit,
                      child: Text('Login'),
                      color: Colors.blue,
                      textColor: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
