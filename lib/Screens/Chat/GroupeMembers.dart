import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
              print(snapshot.error);
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            if (snapshot.hasData) {
              try {
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.only(left: width * 0.033),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    final member = snapshot.data!.docs[index];
                    final memberId = member.id;

                    return FutureBuilder<
                        DocumentSnapshot<Map<String, dynamic>>>(
                      future: FirebaseFirestore.instance
                          .collection('Users')
                          .doc(memberId)
                          .get(),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                              userSnapshot) {
                        if (snapshot.hasError) {
                          print(snapshot.error);
                        }
                        if (userSnapshot.hasData && userSnapshot.data != null) {
                          try {
                            final userData = userSnapshot.data!.data()!;
                            String? Image =
                                userData.containsKey("ProfilePicture") == false
                                    ? null
                                    : userData["ProfilePicture"];

                            return Column(
                              children: [
                                Container(
                                  height: 62,
                                  width: 62,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 0,
                                        color: Colors.white,
                                      ),
                                      shape: BoxShape.circle,
                                      image: Image == null
                                          ? DecorationImage(
                                              image: AssetImage(
                                                  "Assets/Images/photo_profile.png"),
                                              fit: BoxFit.cover,
                                            )
                                          : DecorationImage(
                                              image: NetworkImage(Image),
                                              fit: BoxFit.cover,
                                            )),
                                ),
                                SizedBox(height: height * 0.0125),
                                Text(
                                  userData['Name'],
                                  style: TextStyle(
                                    fontFamily: 'Montserrat-Bold',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF20236C),
                                  ),
                                  overflow: TextOverflow.fade,
                                ),
                              ],
                            );
                          } catch (e) {
                            print(e);
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      },
                    );
                  },
                );
              } catch (e) {
                print(e);
              }
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
