import 'package:flutter/material.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final Function confirmBtnCallback;

  const ConfirmDialog(
      {@required this.title, @required this.confirmBtnCallback});

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(title),
      children: [
        SimpleDialogOption(
          onPressed: confirmBtnCallback,
          child: Center(
            child: Text(
              'Proceed',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ),
        SimpleDialogOption(
          onPressed: () => Navigator.pop(context),
          child: Center(
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.green),
            ),
          ),
        )
      ],
    );
  }
}
