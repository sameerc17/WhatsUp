import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutterapp/authentications.dart';
import 'package:flutterapp/signin.dart';

import 'database.dart';
import 'functions.dart';
import 'msgarea.dart';

class Chats extends StatefulWidget {
  @override
  _ChatsState createState() => _ChatsState();
}

String myName;

class _ChatsState extends State<Chats> {
  TextEditingController s = new TextEditingController();
  QuerySnapshot _querySnapshot;

  bool ispresent = false;

  Authentications authmethods = new Authentications();
  Database database = new Database();
  Stream chatRoom;

  void getter() async {
    myName = await Functions.getUserNameSharedPreference();
  }

  Widget chatroomList() {
    return StreamBuilder(
      stream: chatRoom,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  return chatroomTile(
                      snapshot.data.documents[index].data["chatroomID"]
                          .toString()
                          .replaceAll("_", "")
                          .replaceAll(myName, ""),
                      snapshot.data.documents[index].data["chatroomID"]);
                })
            : Container(
                color: Colors.grey.shade300,
              );
      },
    );
  }

  Widget searchList() {
    return _querySnapshot != null
        ? ListView.builder(
            itemCount: _querySnapshot.documents.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return SearchTile(
                userName: _querySnapshot.documents[index].data["name"],
                userEmail: _querySnapshot.documents[index].data["email"],
              );
            })
        : Container();
  }

  Widget SearchTile({String userName, String userEmail}) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: TextStyle(fontSize: 17.0),
                ),
                Text(
                  userEmail,
                  style: TextStyle(fontSize: 17.0),
                ),
              ],
            ),
            Spacer(),
            GestureDetector(
              onTap: () {
                createChatRoomandStartConversation(username: userName);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.green.shade700,
                  borderRadius: BorderRadius.circular(25.0),
                ),
                padding: EdgeInsets.all(10.0),
                child: Text(
                  'Message',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  createChatRoomandStartConversation({String username}) {
    if (username != myName) {
      print(myName);
      String roomID = getChatroomID(username, myName);

      List<String> users = [username, myName];
      Map<String, dynamic> chatRoomMap = {"users": users, "chatroomID": roomID};
      Database().creatChatRoom(roomID, chatRoomMap);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => Conversation(roomID)));
    } else {
      print('You cannot send message to yourself!');
    }
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  initiateSearch() {
    Database().getUserByUsername(s.text).then((val) {
      setState(() {
        _querySnapshot = val;
        if (val.toString() != null) ispresent = true;
      });
      print(val.toString());
    });
  }

  getChatroomID(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0))
      return "$b\_$a";
    return "$a\_$b";
  }

  getUserInfo() async {
    myName = await Functions.getUserNameSharedPreference();
    print(myName);

    await database.getChatRooms(myName).then((val) {
      setState(() {
        chatRoom = val;
      });
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.red.shade700,
          title: Text('Chatroom'),
          leading: Icon(
            Ionicons.ios_chatbubbles,
            color: Colors.white,
          ),
          actions: <Widget>[
            GestureDetector(
              onTap: () {
                Authentications().signout();
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
              color: Colors.red.shade700,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                child: Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        print('CLICKED');
                        initiateSearch();
                      },
                      child: Icon(
                        Icons.search,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: 3,
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 5.0, vertical: 0.0),
                          child: TextField(
                            controller: s,
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
            Container(
              color: Colors.red.shade700,
              height: 5,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
              child: s.text != null && ispresent
                  ? Container(
                      decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(15),),
                      child: searchList(),
                    )
                  : (!ispresent
                      ? Container()
                      : Container(
                          height: 40,
                          child: Center(
                            child: Text(
                              'No such user found',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Text(
                '  Your Chats',
                style: TextStyle(fontSize: 22.5, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
                child: Container(
                  child: chatroomList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class chatroomTile extends StatelessWidget {
  final String username;
  final String chatID;

  chatroomTile(this.username, this.chatID);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => Conversation(chatID)));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 7.5),
        child: Row(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  '$username'.substring(0, 1),
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            SizedBox(
              width: 20.0,
            ),
            Text(
              '$username',
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
