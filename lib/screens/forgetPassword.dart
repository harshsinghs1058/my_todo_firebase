import 'package:commons/commons.dart';
import 'package:flutter/material.dart';
import 'package:my_todo/screens/createAccount.dart';
import 'package:my_todo/screens/logIn.dart';
import 'package:my_todo/services/autharisation.dart';
import 'package:my_todo/shared/buttonTemplate.dart';
import 'package:my_todo/shared/textInputForm.dart';
import 'package:email_validator/email_validator.dart';

class ForgetPassword extends StatefulWidget {
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

String _email = "";

class _ForgetPasswordState extends State<ForgetPassword> {
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return SafeArea(
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Spacer(),
              Image.asset(
                "images/fp1.png",
                height: 150,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Reset Password",
                style: TextStyle(fontSize: 28),
              ),
              Spacer(),
              TextInputForm(
                s: "Email",
                keyBoard: TextInputType.emailAddress,
                onChange: (value) {
                  _email = value;
                },
                autofocus: true,
                validator: (value) {
                  _email = _email.trim();
                  print(_email);
                  if (EmailValidator.validate(_email)) {
                    return null;
                  } else
                    return "Enter a valid mail";
                },
              ),
              Spacer(),
              ButtonTemp(
                s: "Get link",
                h: 50,
                c: Colors.blue,
                fun: () async {
                  if (_formKey.currentState.validate()) {
                    dynamic result = await Auth().sendOtp(_email);
                    if (result == null) {
                      await infoDialog(
                          context, "Check mail for password reset link");
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => LogIn()));
                    } else {
                      errorDialog(
                          context, "Email-Id is not registered\nPlease sign-up",
                          positiveText: "sign-up", positiveAction: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CreateAccount()));
                      });
                    }
                  }
                },
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
