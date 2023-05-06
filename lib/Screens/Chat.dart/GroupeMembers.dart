// ignore_for_file: file_names

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:iconsax/iconsax.dart';

class GroupMembers extends StatefulWidget {
  final String chatId;

  const GroupMembers({Key? key, required this.chatId}) : super(key: key);

  @override
  State<GroupMembers> createState() => _GroupMembersState();
}

class _GroupMembersState extends State<GroupMembers> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final height = mediaQuery.size.height;
    final width = mediaQuery.size.width;
    return Padding(
      padding:
          EdgeInsets.fromLTRB(0, height * 0.062, width * 0.03, width * 0.015),
      child: Container(
        height: height * 0.15,
        width: width * 0.96,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18.0),
          color: Color.fromARGB(255, 255, 255, 255),
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(156, 32, 35, 108).withOpacity(0.05),
              spreadRadius: 3,
              blurRadius: 5,
              offset: Offset(0, 0),
            ),
          ],
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collection('chats')
              .doc(widget.chatId)
              .collection('members')
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            return ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.only(left: width * 0.033),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int index) {
                final member = snapshot.data!.docs[index];
                final memberId = member.id;

                return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  future: FirebaseFirestore.instance
                      .collection('Users')
                      .doc(memberId)
                      .get(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                          userSnapshot) {
                    if (userSnapshot.hasData && userSnapshot.data != null) {
                      final userData = userSnapshot.data!.data()!;
                      // var Image = 'https://via.placeholder.com/150';

                      /*   if (userData['ProfilePicture'] != Null) {
                        Image = userData['ProfilePicture'];
                        //Image = 'https://via.placeholder.com/150';
                      } else {
                        //  Image = userData['ProfilePicture'];
                        Image = 'https://via.placeholder.com/150';
                      }*/
                      var Image = userData['ProfilePicture'] ??
                          'https://via.placeholder.com/150';

                      return Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 35,
                              backgroundImage: CachedNetworkImageProvider(
                                // userData['ProfilePicture'],
                                //'https://via.placeholder.com/150',
                                Image,
                              ),
                            ),
                            SizedBox(height: height * 0.0125),
                            Text(
                              userData['Name'],
                              style: TextStyle(
                                fontFamily: 'Montserrat-Bold',
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF20236C),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
