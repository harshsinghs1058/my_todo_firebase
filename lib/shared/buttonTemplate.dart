import 'package:flutter/material.dart';

class ButtonTemp extends StatelessWidget {
  const ButtonTemp({Key key, this.s, this.h, this.c, this.fun, this.fontColor})
      : super(key: key);

  final String s;
  final double h;
  final Color c;
  final Function fun;
  final Color fontColor;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        fun();
      },
      style: ElevatedButton.styleFrom(
        onPrimary: c,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          // color: c,
        ),
      ),
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
