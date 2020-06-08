import 'package:firebase_auth/firebase_auth.dart';

class Authentications {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Appuser _user(FirebaseUser user) {
    return user != null ? Appuser(ID: user.uid) : null;
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      FirebaseUser firebaseUser = result.user;
      return _user(firebaseUser);
    } catch (e) {
      print(e.toString());
    }
  }

  Future signUpWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser firebaseUser = result.user;
      return _user(firebaseUser);
    } catch (e) {
      print(e.toString());
    }
  }

  Future resetPass(String email) async {
    try {
      return await auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
    }
  }

  Future signout() async {
    try {
      return await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
}

class Appuser {
  String ID;
  Appuser({this.ID});
}
