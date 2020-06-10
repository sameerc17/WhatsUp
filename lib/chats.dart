import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
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
          title: Text('Chatroom'),
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
                  MaterialPageRoute(builder: (context) => SignIn()),
                );
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
                child: Icon(
                  AntDesign.logout,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
            Container(
              height: 50,
//              color: Colors.black,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.search,
                      size: 25,
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
//                          borderRadius: BorderRadius.circular(20),
//                          color: Colors.pinkAccent,
                            ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 5.0, vertical: 0.0),
                          child: TextField(
                            style: TextStyle(fontSize: 20),
                            decoration: InputDecoration(
                              hintText: 'Search for any username',
                              hintStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
              child: Container(
                color: Colors.grey.shade200,
                height: 50,
              ),
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
                child: Container(
                  color: Colors.grey.shade300,
                  child: Center(
                    child: Text(
                      'Your\nchats\nwill\nappear\nhere',
                      style: TextStyle(fontSize: 30),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
