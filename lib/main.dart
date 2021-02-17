import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_todo/screens/homePage.dart';
import 'package:my_todo/screens/logIn.dart';
import 'package:my_todo/services/autharisation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //this will initialize every change in firebase server..
  await Firebase.initializeApp();
  runApp(MyApp());
}

//global user uid
var userUid;

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Wrapper(),
      theme: ThemeData.dark(),
      title: "My Todo",
      debugShowCheckedModeBanner: false,
    );
  }
}

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    if (Auth().loadUser() != null) {
      return HomePage();
    } else {
      return LogIn();
    }
  }
}
