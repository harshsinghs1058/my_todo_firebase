import 'package:flutter/material.dart';

class ShowLoading extends StatefulWidget {
  @override
  _ShowLoadingState createState() => _ShowLoadingState();
}

class _ShowLoadingState extends State<ShowLoading> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.withOpacity(0.7),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width * 0.8,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CircularProgressIndicator(),
              Text(
                "Loading...       ",
                style: TextStyle(
                    decoration: TextDecoration.none,
                    color: Colors.red,
                    fontSize: 34),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
