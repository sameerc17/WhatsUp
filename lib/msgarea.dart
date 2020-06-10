import 'package:flutter/material.dart';
import 'package:flutterapp/functions.dart';

import 'database.dart';

class Conversation extends StatefulWidget {
  final String chatroomID;

  Conversation(this.chatroomID);

  @override
  _ConversationState createState() => _ConversationState();
}

String myName;

class _ConversationState extends State<Conversation> {
  TextEditingController msg = new TextEditingController();
  Stream chatStream;

  Widget chatList() {
    return StreamBuilder(
      stream: chatStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());
        return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              return MessageTile(snapshot.data.documents[index].data["message"],
                  snapshot.data.documents[index].data["sendBy"] == myName);
            });
      },
    );
  }

  sendMessage() {
    if (msg.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": msg.text,
        "sendBy": myName,
        "time": DateTime.now().millisecondsSinceEpoch
      };
      Database().addConversationMessages(widget.chatroomID, messageMap);
      msg.text = "";
    }
  }

  getMessage() async {
    await Database().getConversationMessages(widget.chatroomID).then((val) {
      setState(() {
        chatStream = val;
      });
    });
  }

  getUserInfo() async {
    myName = await Functions.getUserNameSharedPreference();
    print(myName);
  }

  @override
  void initState() {
    getUserInfo();
    getMessage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat screen'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              child: chatList(),
            ),
          ),
//          Spacer(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(20),
              ),
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Color(0x54FFFFFF),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: msg,
                          style: TextStyle(fontSize: 17.0),
                          decoration: InputDecoration(
                            hintText: 'Type message to be sent',
                            hintStyle: TextStyle(
                                color: Colors.black54, fontSize: 17.0),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        sendMessage();
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        padding: EdgeInsets.all(10.0),
                        child: Icon(Icons.send),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool SentByMe;

  MessageTile(this.message, this.SentByMe);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20.0),
      width: MediaQuery.of(context).size.width,
      alignment: SentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        margin: EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: SentByMe
                    ? [Color(0xff007EF4), Color(0xff2A75BC)]
                    : [Color(0xff007EF4), Color(0xff2A75BC)]),
            borderRadius: SentByMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                    bottomLeft: Radius.circular(20),
                  )
                : BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                    bottomRight: Radius.circular(20),
                  )),
        child: Text(
          message,
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}
