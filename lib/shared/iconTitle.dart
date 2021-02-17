import 'package:flutter/material.dart';

class IconTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            "images/logo.png",
            height: 150,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "My Todo",
            style: TextStyle(
              letterSpacing: 1.2,
              fontSize: 40,
              color: Colors.lightBlue[300],
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}
