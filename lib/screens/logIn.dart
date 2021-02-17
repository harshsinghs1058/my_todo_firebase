import 'dart:io';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_todo/screens/createAccount.dart';
import 'package:my_todo/screens/forgetPassword.dart';
import 'package:my_todo/services/autharisation.dart';
import 'package:my_todo/shared/buttonTemplate.dart';
import 'package:my_todo/shared/iconTitle.dart';
import 'package:my_todo/shared/loading.dart';
import 'package:my_todo/shared/textInputForm.dart';
import 'package:commons/commons.dart';
import 'homePage.dart';
import 'package:connectivity/connectivity.dart';

//storage fields
String _email = "";
String _password = "";
bool loading = false;

//object of auth class to handle create account
Auth _authObj = Auth();

class LogIn extends StatefulWidget {
  //global formState key for handle validation...
  @override
  _LogInState createState() => _LogInState();
}

//log in screen class
class _LogInState extends State<LogIn> {
  final _formState = GlobalKey<FormState>();
  bool showInternetError = false;
  int i = 0;
  //init state for handling internet connectivity
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
    //this function is called when connnectivity is changed
    Connectivity().onConnectivityChanged.listen((event) {
      print(event.toString());
      if (event != ConnectivityResult.none) {
        //internet is connected
        showInternetError = false;
      } else {
        //no internet
        showInternetError = true;
      }
      //calling setState for showing and hiding internet error dialog
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

//internet error dialog box
  void _showInternetErrorDialog() {
    errorDialog(context, "No internet connection", neutralText: "Exit",
        neutralAction: () {
      print("exitting");
      SystemNavigator.pop();
    });
  }

  //main screen function
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: height * 0.02,
                  ),
                  IconTitle(),
                  SizedBox(
                    height: height * 0.03,
                  ),
                  Text(
                    "Sign-In to My-Todo",
                    style: TextStyle(
                      letterSpacing: 1.2,
                      fontSize: 34,
                      color: Colors.yellowAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: height * 0.02,
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
                              return "Password should be of minimum 8 chracters";
                            }
                          },
                          obscureText: true,
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        ButtonTemp(
                          s: "Sign-In",
                          h: 50,
                          c: Colors.blueAccent[300],
                          fun: () async {
                            if (_formState.currentState.validate()) {
                              setState(() {
                                loading = true;
                              });
                              dynamic result =
                                  await _authObj.signIn(_email, _password);
                              setState(() {
                                loading = false;
                              });
                              if (result == null) {
                                print("Successfully login");
                                await successDialog(
                                    context, "Sign in Successfully");
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomePage()));
                              } else {
                                String error = result.code.toString();
                                error = error.replaceAll("-", " ");
                                print("Error " + error);
                                infoDialog(context, error, title: "Error");
                              }
                            }
                          },
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ForgetPassword()));
                          },
                          child: Text(
                            "forgotten password?",
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.blueAccent,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Divider(),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        ButtonTemp(
                          s: "Create New Account",
                          h: 20,
                          c: Colors.green,
                          fun: () async {
                            loadingScreen(context,
                                duration: Duration(hours: 1));

                            // navigating to Create account file
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CreateAccount()));
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            loading == true ? ShowLoading() : Text(""),
          ],
        ),
      ),
    );
  }
}
