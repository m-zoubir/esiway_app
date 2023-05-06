import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esiway/Screens/home/notif_page.dart';
import 'package:esiway/notification_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../Auth.dart';

class PageOne extends StatelessWidget {
  const PageOne({super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> addItemToArray(int type, String nom, String prenom) async {
      // Get a reference to your document

      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('Notifications')
          .doc(FirebaseAuth.instance.currentUser!.uid);

      // Add the new item to the beginning of the 'array' field
      await documentReference.update({
        'array': FieldValue.arrayUnion([
          {
            'type': type,
            'nom': nom,
            'prenom': prenom,
            'uid': "${FirebaseAuth.instance.currentUser!.uid}",
          },
        ]),
      });
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
              addItemToArray(0, "title", "description");
              await NotificationService.showNotification(
                title: "Covoiturage",
                body: "Your request is on keep waiting ",
              );

              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Notifpage()));
            },
            child: Text("Normal Notification"),
          ),
        ],
      ),
    );
  }
}
