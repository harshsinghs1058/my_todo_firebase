import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_todo/main.dart';

class Auth {
  FirebaseAuth _auth = FirebaseAuth.instance;
  //function for create account
  Future signUp(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return null;
    } catch (e) {
      return e;
    }
  }

  //function to sign in
  Future signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      userUid = result.user.uid;
      print("User uid is " + userUid);
      return null;
    } catch (e) {
      return e;
    }
  }

  //function to sign-out
  Future signOut() async {
    await _auth.signOut();
    print("successfully signed-out");
  }

  dynamic loadUser() {
    var _tempUser = _auth.currentUser;
    if (_tempUser != null) userUid = _tempUser.uid;
    return _tempUser;
  }

  dynamic sendOtp(email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return null;
    } catch (e) {
      return e;
    }
  }
}
