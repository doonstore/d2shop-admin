import 'package:d2shop_admin/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CustomButton extends StatelessWidget {
  final Function onTap;
  final String text;
  const CustomButton({@required this.onTap, @required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 45,
      child: RaisedButton(
        onPressed: onTap,
        child: Text(text),
        textColor: Colors.white,
        elevation: 2.0,
        hoverElevation: 10.0,
        hoverColor: Colors.teal,
        color: kColor,
        animationDuration: Duration(milliseconds: 400),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
    );
  }
}
