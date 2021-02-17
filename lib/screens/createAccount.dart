import 'dart:io';

import 'package:commons/commons.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_todo/services/autharisation.dart';
import 'package:my_todo/shared/buttonTemplate.dart';
import 'package:my_todo/shared/iconTitle.dart';
import 'package:my_todo/shared/loading.dart';
import 'package:my_todo/shared/textInputForm.dart';
import 'package:email_validator/email_validator.dart';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

//storage fields
String _email = "";
String _password = "";
bool loading = false;
//object of auth class to handle create account
Auth _authObj = Auth();

class _CreateAccountState extends State<CreateAccount> {
  //global formState key for handle validation...
  final _formState = GlobalKey<FormState>();

  bool showInternetError = false;
  int i = 0;
  @override
  void initState() {
    super.initState();
    try {
      InternetAddress.lookup('google.com').then((result) {
        print("result " + result.toString());
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          // internet conn available
          print("connected");
          showInternetError = false;
        } else {
          // no connection
          showInternetError = true;
        }
      }).catchError((error) {
        //no connection
        showInternetError = true;
      });
    } on SocketException catch (_) {
      // no internet
      print("result error " + _.toString());
      showInternetError = true;
    }

    Connectivity().onConnectivityChanged.listen((event) {
      print(event.toString());
      if (event != ConnectivityResult.none) {
        //internet is connected
        showInternetError = false;
      } else {
        //no internet
        showInternetError = true;
      }
      setState(() {
        print("showInternetError " + showInternetError.toString());
        if (showInternetError == true) {
          _showInternetErrorDialog();
        } else {
          if (i == 1) {
            print("fuck");
            Navigator.pop(context);
          } else {
            i++;
          }
        }
      });
    });
  }

  //disposing the connectivity package

  void _showInternetErrorDialog() {
    errorDialog(context, "No internet connection", neutralText: "Exit",
        neutralAction: () {
      print("exitting");
      SystemNavigator.pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Stack(
        children: [
          Scaffold(
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: height * 0.07,
                  ),
                  IconTitle(),
                  SizedBox(
                    height: height * 0.03,
                  ),
                  Text(
                    "Create New Account",
                    style: TextStyle(
                      letterSpacing: 1.2,
                      fontSize: 34,
                      color: Colors.yellowAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: height * 0.03,
                  ),
                  //create accounts fields
                  Form(
                    key: _formState,
                    child: Column(
                      children: [
                        TextInputForm(
                          s: "E-mail",
                          onChange: (value) {
                            _email = value;
                          },
                          validator: (value) {
                            value = value.trim();
                            _email = value;
                            if (EmailValidator.validate(value)) {
                              return null;
                            } else {
                              return "Enter a valid mail";
                            }
                          },
                          keyBoard: TextInputType.emailAddress,
                        ),
                        TextInputForm(
                          s: "Password",
                          onChange: (value) {
                            _password = value;
                          },
                          validator: (value) {
                            if (value.length > 7) {
                              return null;
                            } else {
                              return "Password should be of minimum 8 characters";
                            }
                          },
                          obscureText: true,
                        ),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        Divider(),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        ButtonTemp(
                          s: "Create Account",
                          h: 50,
                          c: Colors.blueAccent[300],
                          fun: () async {
                            if (_formState.currentState.validate()) {
                              setState(() {
                                loading = true;
                              });
                              dynamic result =
                                  await _authObj.signUp(_email, _password);
                              setState(() {
                                loading = false;
                              });
                              if (result == null) {
                                print("Successfully login");
                                await successDialog(
                                    context, "Account successfully created");
                                Navigator.pop(context);
                              } else {
                                String error = result.code.toString();
                                error = error.replaceAll("-", " ");
                                infoDialog(context, error, title: "Error");
                                print("Error " + error);
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          loading == true ? ShowLoading() : Text(""),
        ],
      ),
    );
  }
}
