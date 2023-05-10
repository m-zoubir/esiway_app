import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'Chat_screen.dart';
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
  }

//will be called when a Trip is Created
  Future<void> _createChatRoom(BuildContext context) async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    String tripId =
        'He9ne8pNjuX7ixQB80X6gZmkjjw1_17 - 5 - 2023-21 : 35'; // IDK how to get the trip Id
    try {
      String departArrivee = await getDepartArriveeString(tripId);
      createChatRoomFirestore(
          departArrivee, currentUser!.uid, "test ${DateTime.now()}");
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;

    return SafeArea(
      child: Scaffold(
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
      ),
    );
  }
}
