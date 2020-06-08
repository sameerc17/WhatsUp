import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutterapp/authentications.dart';
import 'package:flutterapp/signin.dart';

class Chats extends StatefulWidget {
  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Your ChatList'),
          leading: Icon(
            Ionicons.ios_chatbubbles,
            color: Colors.white,
          ),
          actions: <Widget>[
            GestureDetector(
              onTap: () {
//                Authentications().signout();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context)=>SignIn()
                  ),
                );
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0,horizontal: 15.0),
                child: Icon(
                  AntDesign.logout,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
