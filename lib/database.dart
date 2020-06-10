import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  getUserByUsername(String username) async {
    return await Firestore.instance
        .collection("users")
        .where("name", isEqualTo: username)
        .getDocuments();
  }

  getUserByUserEmail(String userEmail) async {
    return await Firestore.instance
        .collection("users")
        .where("email", isEqualTo: userEmail)
        .getDocuments();
  }

  uploadUserInfo(userMap) {
    Firestore.instance.collection("users").add(userMap);
  }

  creatChatRoom(String chatroomID, chatRoomMap) {
    Firestore.instance
        .collection("chatroom")
        .document(chatroomID)
        .setData(chatRoomMap)
        .catchError((e) {
      print(e.toString);
    });
  }

  addConversationMessages(String chatroomID, messageMap) {
    Firestore.instance
        .collection("chatroom")
        .document(chatroomID)
        .collection("chats")
        .add(messageMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  getConversationMessages(String chatroomID) async {
    return await Firestore.instance
        .collection("chatroom")
        .document(chatroomID)
        .collection("chats")
        .orderBy("time",descending: false)
        .snapshots();
  }

  getChatRooms(String username) async{
    return Firestore.instance.collection("chatroom").where("users",arrayContains: username).snapshots();
  }

}
