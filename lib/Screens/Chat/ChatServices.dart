import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;
FirebaseDatabase database = FirebaseDatabase.instance;

Future<void> initializeFirebase() async {
  final FirebaseApp app = await Firebase.initializeApp();
  database = FirebaseDatabase(app: app);
}

// Generate a unique chat ID

// Create a new chat room in Firestore
Future<void> createChatRoomFirestore(
    String name, String creatorId, String chatId) async {
  // Generate a unique ID for the new chat room

  // Create a new chat room object
  Map<String, dynamic> chatRoom = {
    'NbUnseen': 1,
    "LastSender": 'He9ne8pNjuX7ixQB80X6gZmkjjw1',
    "LastMessage": "hello, I'm your driver",
    "TimeOfLastMessage": DateTime.now(),
    'name': name,
    'admin': creatorId,
    'chatImage': 'https://via.placeholder.com/150',
  };

  // Add the new chat room to Firestore
  await firestore.collection('chats').doc(chatId).set(chatRoom);

  // Add a welcome message from the creator
  Map<String, dynamic> message = {
    'text': "hello, I'm your driver",
    'sender': creatorId,
    'timestamp': DateTime.now(),
    'ImageUrl': null,
  };
  await firestore
      .collection('chats')
      .doc(chatId)
      .collection('messages')
      .add(message);
  joinChatRoomFirestore(chatId, FirebaseAuth.instance.currentUser!.uid);
  Timer(Duration(seconds: 3), () {
    print("Chat Created ");
  });
}

// Join a chat room in Firestore

Future<void> joinChatRoomFirestore(String chatId, String userId) async {
  // Get a reference to the chat room in Firestore
  DocumentReference chatRef = firestore.collection('chats').doc(chatId);

  // Add the user to the chat room's list of users
  chatRef.collection('members').doc(userId).set({});

  // Add the chat room to the user's list of chats
  await firestore
      .collection('Users')
      .doc(userId)
      .collection('chat')
      .doc(chatId)
      .set({});
  Timer(Duration(seconds: 3), () {
    print("Chat Created ");
  });
}

/*
we can do this after the conductor finished the trip 
Future<void> deleteChatRoomFirestore(String chatId, String userId) async {
  // Get the chat room document from Firestore
  DocumentSnapshot chatDoc =
      await firestore.collection('chats').doc(chatId).get();

  // Check if the user trying to delete the chat room is the admin
  String adminId = chatDoc.get('admin');
  if (adminId != userId) {
    throw Exception("Only the admin can delete the group.");
  }

  // Delete the chat room document from Firestore
  await firestore.collection('chats').doc(chatId).delete();

  // Remove the chat room from each user's list of chats
  QuerySnapshot members = await firestore
      .collection('chats')
      .doc(chatId)
      .collection('members')
      .get();
  for (DocumentSnapshot member in members.docs) {
    String memberId = member.id;
    await firestore
        .collection('Users')
        .doc(memberId)
        .collection('chat')
        .doc(chatId)
        .delete();
  }
}
*/
Future<void> leaveChatRoomFirestore(String chatId, String userId) async {
  // Remove the user from the chat room's list of members
  await firestore
      .collection('chats')
      .doc(chatId)
      .collection('members')
      .doc(userId)
      .delete();

  // Remove the chat room from the user's list of chats
  await firestore
      .collection('Users')
      .doc(userId)
      .collection('chat')
      .doc(chatId)
      .delete();
}

/*
Future<void> deleteMessageFirestore(
    String chatId, String messageId, String userId) async {
  // Get the message document from Firestore
  DocumentSnapshot messageDoc = await firestore
      .collection('chats')
      .doc(chatId)
      .collection('messages')
      .doc(messageId)
      .get();

  // Check if the user trying to delete the message is the sender
  String senderId = messageDoc.get('sender');
  if (senderId != userId) {
    throw Exception("Only the sender can delete the message.");
  }

  // Delete the message document from Firestore
  await firestore
      .collection('chats')
      .doc(chatId)
      .collection('messages')
      .doc(messageId)
      .delete();
}
*/
Future<void> markAllMessagesAsSeen(String chatId) async {
  // Get a reference to the messages subcollection
  final messagesRef = FirebaseFirestore.instance
      .collection('chats')
      .doc(chatId)
      .collection('messages');

  // Create a batched write operation
  final batch = FirebaseFirestore.instance.batch();

  // Query for all the messages and update the "seen" field to true
  final querySnapshot = await messagesRef.get();
  for (final documentSnapshot in querySnapshot.docs) {
    batch.update(documentSnapshot.reference, {'seen': true});
  }
  // Update the NbUnseen field in the chats collection to 0
  final chatRef = FirebaseFirestore.instance.collection('chats').doc(chatId);
  batch.update(chatRef, {'NbUnseen': 0});

  // Commit the batched write operation
  await batch.commit();
}

Future<String> getDepartArriveeString(String tripId) async {
  // Reference to the specific document in the "Trips" collection
  DocumentSnapshot tripSnapshot =
      await FirebaseFirestore.instance.collection('Trips').doc(tripId).get();

  if (tripSnapshot.exists) {
    Map<String, dynamic> tripData = tripSnapshot.data() as Map<String, dynamic>;
    String depart = tripData['Depart'];
    String arrivee = tripData['Arrivee'];
    return '$depart-$arrivee';
  } else {
    throw Exception('Trip document does not exist!');
  }
}
