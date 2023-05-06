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

//will be called when a Trip is Created
  Future<void> _createChatRoom(BuildContext context) async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    String tripId =
        '22 - 5 - 2023-11 : 03-ie6w7FN8PgXu9UUCZ9Xdnx0Xvdl2_'; // IDK how to get the trip Id
    try {
      String departArrivee = await getDepartArriveeString(tripId);
      createChatRoomFirestore(departArrivee, currentUser!.uid);
    } catch (e) {
      print(e.toString());
    }
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
