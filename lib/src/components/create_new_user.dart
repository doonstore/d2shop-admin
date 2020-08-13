import 'package:d2shop_admin/src/models/admin_model.dart';
import 'package:d2shop_admin/src/services/auth_service.dart';
import 'package:d2shop_admin/src/utils/utils.dart';
import 'package:flutter/material.dart';

class CreateNewUser extends StatefulWidget {
  @override
  _CreateNewUserState createState() => _CreateNewUserState();
}

class _CreateNewUserState extends State<CreateNewUser> {
  GlobalKey<FormState> _formState = GlobalKey<FormState>();
  String firstName, lastName, emailAddress, password, username;

  submit() {
    if (_formState.currentState.validate()) {
      _formState.currentState.save();

      AdminModel adminModel = AdminModel(
        firstName: firstName,
        lastName: lastName,
        emailAddress: emailAddress,
        username: username,
        status: 101,
      );

      AuthService().addNewUser(adminModel, password).then((value) {
        Utils.showMessage("$username added as Admin");
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Create a New User'),
      scrollable: true,
      content: Container(
        width: MediaQuery.of(context).size.width * 0.50,
        child: Form(
          key: _formState,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      textCapitalization: TextCapitalization.words,
                      validator: (value) =>
                          value.isEmpty ? 'This field can\'t be empty.' : null,
                      onSaved: (newValue) => firstName = newValue.trim(),
                      decoration: InputDecoration(
                        labelText: 'First Name',
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      textCapitalization: TextCapitalization.words,
                      validator: (value) =>
                          value.isEmpty ? 'This field can\'t be empty.' : null,
                      onSaved: (newValue) => lastName = newValue.trim(),
                      decoration: InputDecoration(
                        labelText: 'Last Name',
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              TextFormField(
                validator: (value) =>
                    value.isEmpty ? 'This field can\'t be empty.' : null,
                onSaved: (newValue) => username = newValue.trim(),
                decoration: InputDecoration(
                  labelText: 'Username',
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value.isEmpty || !value.contains('.com')
                    ? 'Please enter a valid email address.'
                    : null,
                onSaved: (newValue) => emailAddress = newValue.trim(),
                decoration: InputDecoration(
                  labelText: 'Email Address',
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                validator: (value) =>
                    value.isEmpty ? 'This field can\'t be empty.' : null,
                onSaved: (newValue) => password = newValue.trim(),
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        MaterialButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
          textColor: Colors.blue,
        ),
        MaterialButton(
          onPressed: submit,
          child: Text('Proceed'),
          textColor: Colors.blue,
        ),
      ],
    );
  }
}
