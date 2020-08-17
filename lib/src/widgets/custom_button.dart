import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Function onTap;
  final String text;
  const CustomButton({@required this.onTap, @required this.text});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onTap,
      textColor: Colors.white,
      child: Text(text),
      color: Colors.blueAccent,
      animationDuration: Duration(milliseconds: 300),
      padding: EdgeInsets.all(15),
    );
  }
}
