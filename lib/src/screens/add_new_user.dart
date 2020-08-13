import 'package:d2shop_admin/src/components/confirm_dialog.dart';
import 'package:d2shop_admin/src/components/create_new_user.dart';
import 'package:d2shop_admin/src/models/admin_model.dart';
import 'package:d2shop_admin/src/provider/state.dart';
import 'package:d2shop_admin/src/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddNewUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ApplicationState>(
        builder: (context, value, child) {
          AdminModel admin = value.admin;

          return Container(
            width: MediaQuery.of(context).size.width * 0.35,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  initialValue: admin?.firstName ?? '',
                  decoration: InputDecoration(
                    labelText: 'First Name',
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  initialValue: admin?.lastName ?? '',
                  decoration: InputDecoration(
                    labelText: 'Last Name',
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  initialValue: admin?.username ?? '',
                  decoration: InputDecoration(
                    labelText: 'Username',
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  initialValue: admin?.emailAddress ?? '',
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      onPressed: () =>
                          resetPassword(context, admin.emailAddress),
                      child: Text('Change Password'),
                      textColor: Colors.blue,
                      padding: EdgeInsets.all(15),
                    ),
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      onPressed: () => showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => CreateNewUser(),
                      ),
                      child: Text('Create New User'),
                      textColor: Colors.blue,
                      padding: EdgeInsets.all(15),
                    )
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> resetPassword(BuildContext context, String email) {
    return showDialog(
      context: context,
      builder: (_) => ConfirmDialog(
        title: 'Reset Password?',
        confirmBtnCallback: () => AuthService().changePassword(email),
      ),
    );
  }
}
