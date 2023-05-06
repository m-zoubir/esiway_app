import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'Chat2.dart';
import 'ChatServices.dart';
import 'Chatting.dart';

class Test extends StatefulWidget {
  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  final TextEditingController _textEditingController = TextEditingController();

  late String _chatId;

  @override
  void initState() {
    super.initState();
    // Generate a unique chat ID when the widget is initialized
    _chatId = generateChatId();
  }

  void _createChatRoom(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;

    // Create a new chat room in Firestore
    createChatRoomFirestore("the name of the chat ", currentUser!.uid);
    // Join the chat room as a member
    //joinChatRoomFirestore(_chatId, currentUser.uid);
    // Navigate to the chat room screen
    /*  Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Groupe_Chat(chatId: _chatId),
      ),
    );*/
  }

  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: Column(
        children: [
          Center(
            child: ElevatedButton(
              child: Text('create'),
              onPressed: () {
                _createChatRoom(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Chat_secreen()),
                );
              },
            ),
          ),
          Center(
            child: ElevatedButton(
              child: Text('chats'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Chat_secreen()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
