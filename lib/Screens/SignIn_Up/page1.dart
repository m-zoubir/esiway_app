/* import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esiway/Screens/home/notif_page.dart';
import 'package:esiway/notification_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../Auth.dart';

class PageOne extends StatelessWidget {
  const PageOne({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    void writeData(int type, DateTime date) async {
      try {
        await firestore.collection('Notifications').add({
          'type': type,
          'date': date,
          'uid': "${FirebaseAuth.instance.currentUser!.uid}",
          // add more fields and values as needed
        });
        print('Data has been written successfully!');
      } catch (e) {
        print('Error writing data: $e');
      }
    }

    List<Map<String, dynamic>>? dataList = [];

    Future<void> readCollection() async {
      try {
        QuerySnapshot snapshot = await firestore
            .collection('Notifications')
            .where('uid',
                isEqualTo: '${FirebaseAuth.instance.currentUser!.uid}')
            .orderBy('date')
            .get();

        List<DocumentSnapshot> docs = snapshot.docs;
        dataList =
            docs.map((doc) => doc.data()).cast<Map<String, dynamic>>().toList();

        // Set the state to rebuild the widget and display the retrieved data
      } catch (e) {
        print('Error reading collection: $e');
      }
    }

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          /*       Center(
            child: ElevatedButton(
                onPressed: () async {
                  await AuthService().logOut();
                },
                child: Text(AuthService().auth.currentUser!.email!)),
          ), */
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shadowColor: Theme.of(context).shadowColor,
              backgroundColor: Theme.of(context).primaryColor,
            ),
            onPressed: () async {
              //      addItemToArray(0, "title", "description");
              await NotificationService.showNotification(
                title: "Covoiturage",
                body: "Your request is on keep waiting ",
              );
              // writeData(1, DateTime.now());

              readCollection();

              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Notifpage(dataNotif: dataList,)));
            },
            child: Text(FirebaseAuth.instance.currentUser!.uid),
          ),
        ],
      ),
    );
  }
}
 */