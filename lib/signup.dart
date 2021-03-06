import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutterapp/authentications.dart';
import 'package:flutterapp/chats.dart';
import 'package:flutterapp/functions.dart';
import 'package:flutterapp/signin.dart';

import 'database.dart';

void main() {
  runApp(
    SignUp(),
  );
}

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController u = new TextEditingController();
  TextEditingController e = new TextEditingController();
  TextEditingController p = new TextEditingController();
  Authentications authentications=new Authentications();

  final formKey = GlobalKey<FormState>();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red.shade700,
          leading: Icon(Icons.person),
          title: Text('Sign up page'),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        validator: (val) {
                          return val.length > 3
                              ? null
                              : "Please provide username with more than 3 characters";
                        },
                        controller: u,
                        style: TextStyle(color: Colors.black, fontSize: 16),
                        decoration: InputDecoration(
                          labelText: 'Username',
                          labelStyle: TextStyle(color: Colors.pink),
                          hintText: 'Enter username',
                          hintStyle: TextStyle(color: Colors.black38),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black12),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black12),
                          ),
                        ),
                      ),
                      TextFormField(
                        validator: (val) {
                          return RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(val)
                              ? null
                              : "Please provide a valid email address.";
                        },
                        controller: e,
                        style: TextStyle(color: Colors.black, fontSize: 16),
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(color: Colors.pink),
                          hintText: 'Enter email',
                          hintStyle: TextStyle(color: Colors.black38),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black12),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black12),
                          ),
                        ),
                      ),
                      TextFormField(
                        obscureText: true,
                        validator: (val) {
                          return val.length > 6
                              ? null
                              : "Please provide password with more than 6 characters";
                        },
                        controller: p,
                        style: TextStyle(color: Colors.black, fontSize: 16),
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(color: Colors.pink),
                          hintText: 'Enter password',
                          hintStyle: TextStyle(color: Colors.black38),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black12),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    signMeUp();
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade600,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Text(
                      'Sign up',
                      style: TextStyle(color: Colors.white, fontSize: 17),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Text(
                      'Sign up with Google',
                      style: TextStyle(color: Colors.white, fontSize: 17),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Already have an account? ',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => SignIn()));
                      },
                      child: Container(
                        child: Text(
                          'Sign in now ',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  signMeUp() {
    if (formKey.currentState.validate()) {
      Map<String, String> userMap = {"name": u.text, "email": e.text};
      Functions.saveUserEmailSharedPreference(e.text);
      Functions.saveUserNameSharedPreference(u.text);

      setState(() {
        isLoading = true;
      });

      authentications.signUpWithEmailAndPassword(e.text, p.text).then((val) {
        print("$val");

        Database().uploadUserInfo(userMap);
        Functions.saveUserLoggedInSharedPreference(true);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Chats()));
      });
    }
  }
}
