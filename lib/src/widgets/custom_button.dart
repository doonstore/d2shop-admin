import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Function onTap;
  final String text;
  const CustomButton({@required this.onTap, @required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Material(
        color: Color.fromRGBO(46, 174, 227, 1.0),
        animationDuration: Duration(milliseconds: 400),
        elevation: 5.0,
        shape: StadiumBorder(),
        child: Container(
          padding: EdgeInsets.all(15),
          child: Center(
            child: Text(
              text,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
