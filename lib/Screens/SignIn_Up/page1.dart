// import 'package:esiway/Screens/Home/notif_page.dart';
// import 'package:esiway/notification_services.dart';
// import 'package:flutter/material.dart';

// import '../../Auth.dart';

// class PageOne extends StatelessWidget {
//   const PageOne({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: Center(
//         child: Column(
//           children: [
//             ElevatedButton(
//                 onPressed: () async {
//                   Navigator.push(context,
//                       MaterialPageRoute(builder: (context) => NotifPage()));
//                 },
//                 child: Text(AuthService().auth.currentUser!.email!)),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 shadowColor: Theme.of(context).shadowColor,
//                 backgroundColor: Theme.of(context).primaryColor,
//               ),
//               onPressed: () async {
//                 // addItemToArray(0, "title", "description");
//                 await NotificationService.showNotification(
//                   title: "Covoiturage",
//                   body: "Your request is on keep waiting ",
//                 );
//               },
//               child: Text("Normal Notification"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
