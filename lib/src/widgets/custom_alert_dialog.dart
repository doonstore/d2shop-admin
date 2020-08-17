import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final Function submit;
  final String title;
  final Widget child;
  const CustomAlertDialog(
      {@required this.submit, @required this.title, @required this.child});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Text(title),
      content: Container(
        width: MediaQuery.of(context).size.width * 0.50,
        child: child,
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
