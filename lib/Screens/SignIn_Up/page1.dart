import 'package:cloud_firestore/cloud_firestore.dart';
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
    Future<void> addItemToArray(int type, DateTime date) async {
      // Get a reference to your document

      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('Notifications')
          .doc(FirebaseAuth.instance.currentUser!.uid);

      CollectionReference notifCollection =
          FirebaseFirestore.instance.collection('Notifications');

      // Add the new item to the beginning of the 'array' field
      await documentReference.update({
        'array': FieldValue.arrayUnion([
          {
            'type': type,
            'date': date,
            'uid': "${FirebaseAuth.instance.currentUser!.uid}",
          },
        ]),
      });
    }

    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    void readCollection() async {
      try {
        QuerySnapshot snapshot = await firestore
            .collection('Notifications')
            .where('uid', isEqualTo: 'He9ne8pNjuX7ixQB80X6gZmkjjw1')
            .orderBy('date')
            .get();

        List<DocumentSnapshot> docs = snapshot.docs;
        List<Object?> dataList = docs.map((doc) => doc.data()).toList();

        // Now the dataList variable contains a list of maps, where each map represents a document in the collection
        // You can use the dataList variable to populate your UI or perform other operations with the retrieved data.
        print("========================================");
        print(snapshot.size);
        print("========================================");
        print(dataList); // This will print the list in your console
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
              addItemToArray(0, DateTime.now());

              /*  firestore
                  .collection('Notifications')
                  .where('uid', isEqualTo: 'He9ne8pNjuX7ixQB80X6gZmkjjw1')
                  .orderBy('date')
                  .get()
                  .then((QuerySnapshot querySnapshot) {
                List<DocumentSnapshot> docs = snapshot.docs;
                List<Map<String, dynamic>> dataList =
                    docs.map((doc) => doc.data()).toList();
                print("print ======== ");
                print(dataList); */
              // querySnapshot contains the ordered list of documents matching the query
              // you can access the data using querySnapshot.docs

              /*   Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Notifpage())); */
            },
            child: Text(FirebaseAuth.instance.currentUser!.uid),
          ),
        ],
      ),
    );
  }
}
