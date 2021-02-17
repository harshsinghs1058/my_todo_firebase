import 'package:flutter/material.dart';

class ButtonTemp extends StatelessWidget {
  const ButtonTemp(
      {Key key,
      @required this.s,
      @required this.h,
      @required this.c,
      @required this.fun,
      this.fontColor})
      : super(key: key);

  final String s;
  final double h;
  final Color c;
  final Function fun;
  final Color fontColor;
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: () {
        fun();
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: c,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: h, vertical: 10),
        child: Text(
          s,
          style: TextStyle(fontSize: 28, color: fontColor ?? Colors.white),
        ),
      ),
    );
  }
}
