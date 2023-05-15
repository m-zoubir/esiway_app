import 'dart:ui';
import 'package:esiway/widgets/alertdialog.dart';
import 'package:esiway/widgets/bottom_navbar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import '../../widgets/icons_ESIWay.dart';
import '../../widgets/prefixe_icon_button.dart';
import '../Home/home_page.dart';
import 'ChatServices.dart';
import 'Chatting.dart';
import 'GroupeImage.dart';

class Chat_secreen extends StatefulWidget {
  const Chat_secreen({super.key});

  @override
  State<Chat_secreen> createState() => _Chat_secreenState();
}

class _Chat_secreenState extends State<Chat_secreen> {
  String? imageUrl;

  Future<String?> getMemberImageUrl(String memberId) async {
    final DocumentReference userRef =
        FirebaseFirestore.instance.collection('Users').doc(memberId);
    final DocumentSnapshot<Object?> snapshot = await userRef.get();

    final Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

    if (data != null && data.containsKey('ProfilePicture')) {
      imageUrl = data['ProfilePicture'];
    }

    return null;
  }

  @override
  void initState() {
    super.initState();
  }

  void back() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    var largeur = MediaQuery.of(context).size.width;
    var hauteur = MediaQuery.of(context).size.height;

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          if (snapshot.hasData) {
            imageUrl = snapshot.data!.data()!.containsKey('ProfilePicture')
                ? snapshot.data!.data()!['ProfilePicture']
                : null;
            return Scaffold(
              backgroundColor: const Color(0xFFF9F8FF),
              // ignore: prefer_const_constructors
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: hauteur * 0.03,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5, right: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 20),
                              width: 80,
                              height: 35,
                              child: PrefixeIconButton(
                                  size: const Size(73, 34),
                                  color: Colors.white,
                                  radius: 8,
                                  text: "Back",
                                  textcolor: Color(0xFF20236C),
                                  weight: FontWeight.w600,
                                  fontsize: 14,
                                  icon: Transform.scale(
                                    scale: 0.75,
                                    child: Icons_ESIWay(
                                        icon: "arrow_left",
                                        largeur: 30,
                                        hauteur: 30),
                                  ),
                                  espaceicontext: 5.0,
                                  fct: back),
                            ),
                            SizedBox(width: largeur * 0.47),
                            Container(
                              height: 70,
                              width: 70,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1,
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                  ),
                                  shape: BoxShape.circle,
                                  image: imageUrl == null
                                      ? DecorationImage(
                                          image: AssetImage(
                                              "Assets/Images/photo_profile.png"),
                                          fit: BoxFit.cover,
                                        )
                                      : DecorationImage(
                                          image: NetworkImage(imageUrl!),
                                          fit: BoxFit.cover,
                                        )),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: hauteur * 0.03,
                      ),

                      //the Title

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Chat",
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                fontSize: 40,
                                color: Color(0xFF20236C),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: hauteur * 0.02,
                      ),

                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                        ),
                        margin: EdgeInsets.only(
                          left: largeur * 0.03,
                          right: largeur * 0.03,
                        ),
                        height: hauteur * 0.65,
                        child: name(),
                      ),
                    ],
                  ),
                ],
              ),
              //just to test how it will look
              bottomNavigationBar: BottomNavBar(currentindex: 2),
            );
          }
          return CircularProgressIndicator();
        });
  }
}

class name extends StatefulWidget {
  name({
    Key? key,
  }) : super(key: key);

  @override
  State<name> createState() => _nameState();
}

class _nameState extends State<name> {
  @override
  Widget build(BuildContext context) {
    String Name = "";
    var largeur = MediaQuery.of(context).size.width;
    var hauteur = MediaQuery.of(context).size.height;
    // ignore: unused_local_variable
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('chat')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Center(child: const Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (snapshot.hasData && snapshot.data != null) {
            final chatDocs = snapshot.data!.docs;
            return ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: chatDocs.length,
                itemBuilder: (BuildContext context, int index) {
                  final chat = chatDocs[index];
                  String chatId = chat.id;
                  String? ChatImage;
                  int number = 0;
                  final chatRef = FirebaseFirestore.instance
                      .collection('chats')
                      .doc(chatId);
                  chatRef.get().then((doc) {
                    if (doc.exists) {
                      final chatData = doc.data();
                      final nb = chatData!['NbUnseen'];
                      final url = chatData['chatImage'];
                      Name = chatData['name'];
                      ChatImage = url;
                      number = nb;
                    } else {}
                  }).catchError((error) {
                    const CircularProgressIndicator();
                  });
                  final messagesRef = FirebaseFirestore.instance
                      .collection('chats')
                      .doc(chatId)
                      .collection('messages');

                  return GestureDetector(
//****************************************************************************************************************************************************** */
                    onLongPress: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CustomAlertDialog(
                              greentext: "Cancel",
                              question: "Do you want  leave the chat room",
                              redtext: "Leave",
                              greenfct: () {
                                Navigator.pop(context);
                              },
                              redfct: () {
                                leaveChatRoomFirestore(
                                    chatId,
                                    FirebaseAuth.instance.currentUser!
                                        .uid); // Call your leaveChatRoomFirestore function here
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => Chat_secreen()));
                              },
                            );
                          });
                    },
//****************************************************************************************************************************************************** */

                    child: Column(
                      children: [
                        Container(
                          height: 95,
                          width: largeur,
                          margin:
                              EdgeInsets.only(bottom: 10, left: 10, right: 10),
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0),
                            color: const Color.fromARGB(255, 255, 255, 255),
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(156, 32, 35, 108)
                                    .withOpacity(0.05),
                                spreadRadius: 3,
                                blurRadius: 5,
                                offset: const Offset(0, 0),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              StreamBuilder<DocumentSnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('chats')
                                      .doc(chatId)
                                      .snapshots(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<DocumentSnapshot>
                                          snapshot) {
                                    if (snapshot.hasError) {
                                      print(snapshot.error);
                                      return const CircularProgressIndicator();
                                    }
                                    if (!snapshot.hasData) {
                                      return const CircularProgressIndicator();
                                    }
                                    Map datas = snapshot.data!.data() as Map;
                                    var nb = datas['NbUnseen'];
                                    var ChatName = datas['chatImage'];
                                    return StreamBuilder<QuerySnapshot>(
                                        stream: messagesRef
                                            .orderBy('timestamp',
                                                descending: true)
                                            .limit(1)
                                            .snapshots(),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<QuerySnapshot>
                                                snapshot) {
                                          if (snapshot.hasError) {
                                            return const Text(
                                                'Something went wrong');
                                          }
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const Text('Loading...');
                                          }

                                          final messages = snapshot.data!.docs;

                                          final message = messages.first;
                                          final senderId =
                                              message.get('sender');

                                          if (senderId ==
                                              FirebaseAuth
                                                  .instance.currentUser!.uid) {
                                            nb = 0;
                                          }

                                          return Stack(
                                            children: [
                                              SizedBox(
                                                width: largeur * 0.15, //98,
                                                height: hauteur * 0.08, //9,
                                                child: GroupChatImage(
                                                  chatId: chatId,
                                                  width: largeur * 0.04, //98,
                                                  height: hauteur * 0.030,
                                                  n: 5,
                                                ),
                                              ),
                                              Positioned(
                                                top: 3,
                                                left: 27,
                                                child: Visibility(
                                                  visible: nb != 0,
                                                  child: Container(
                                                    height: 20,
                                                    width: 20,
                                                    padding:
                                                        const EdgeInsets.all(2),
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: Color(0xFFFFA18E),
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Text(
                                                      nb.toString(),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        color: const Color
                                                                .fromARGB(
                                                            255, 0, 0, 0),
                                                        fontSize:
                                                            hauteur * 0.02,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        });
                                  }),
                              StreamBuilder<DocumentSnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('chats')
                                      .doc(chatId)
                                      .snapshots(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<DocumentSnapshot>
                                          snapshot) {
                                    if (!snapshot.hasData) {
                                      return const CircularProgressIndicator();
                                    }
                                    if (snapshot.hasData) {
                                      try {
                                        Map Donnee =
                                            snapshot.data!.data() as Map;

                                        late Map data;
                                        String chatName = Donnee["name"];
                                        String lastMessage =
                                            Donnee['LastMessage'];
                                        String timeLastMessage =
                                            DateFormat('HH:mm').format(
                                                Donnee['TimeOfLastMessage']
                                                    .toDate());
                                        String lastSender =
                                            Donnee['LastSender'];
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
//****************************************************************************************************************************************************** */
                                                Container(
                                                  width: largeur * 0.505,
                                                  child: Text(
                                                    chatName,
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'Montserrat-Bold',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15,
                                                      color: const Color(
                                                          0xFF20236C),
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ),
                                                ),
//****************************************************** ************************************************************************************************ */
                                                SizedBox(
                                                    width: largeur * 0.005),
//****************************************************************************************************************************************************** */
                                                Container(
                                                  child: Text(
                                                    "$timeLastMessage",
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'Montserrat-Bold',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: hauteur * 0.018,
                                                      color: const Color(
                                                          0xFF20236C),
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            StreamBuilder<DocumentSnapshot>(
                                              stream: FirebaseFirestore.instance
                                                  .collection("Users")
                                                  .doc(lastSender)
                                                  .snapshots(),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot snapshot) {
                                                if (snapshot.hasError) {
                                                  print(
                                                      "Error : ${snapshot.error}");
                                                }

                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return CircularProgressIndicator();
                                                }
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return Text(
                                                    'Loading...',
                                                    style: TextStyle(
                                                      fontFamily: 'Montserrat',
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: hauteur * 0.015,
                                                      color: const Color(
                                                          0xFF20236C),
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  );
                                                }
                                                if (snapshot.hasData) {
                                                  DocumentSnapshot
                                                      documentSnapshot =
                                                      snapshot.data;
                                                  try {
                                                    data = documentSnapshot
                                                        .data() as Map;

                                                    return Row(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              '${data["Name"]} : ',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Montserrat',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 13,
                                                                color: const Color(
                                                                    0xFF20236C),
                                                              ),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                            SizedBox(
                                                              width: largeur *
                                                                      0.35 -
                                                                  24 -
                                                                  data["Name"]
                                                                      .toString()
                                                                      .length,
                                                              child: Text(
                                                                "$lastMessage",
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      'Montserrat',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontSize: 12,
                                                                  color: const Color(
                                                                      0xFF20236C),
                                                                ),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          width: largeur * 0.03,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Transform.scale(
                                                              scale: 1,
                                                              child: Icons_ESIWay(
                                                                  icon:
                                                                      "open_chat",
                                                                  largeur: 24,
                                                                  hauteur: 24),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    );
                                                  } catch (e) {
                                                    print(e);
                                                  }
                                                }
                                                return Container();
                                              },
                                            ),
                                          ],
                                        );
                                      } catch (e) {
                                        print(e);
                                      }
                                    }
                                    return CircularProgressIndicator();
                                  }),
                            ],
                          ),
                        ),
                        SizedBox(height: 3),
                        SvgPicture.asset("Assets/Icons/Line.svg"),
                        SizedBox(height: 10),
                      ],
                    ),
//****************************************************************************************************************************************************** */

                    onTap: () {
                      final chatRef = FirebaseFirestore.instance
                          .collection('chats')
                          .doc(chatId);
                      chatRef.get().then((doc) {
                        if (doc.exists) {
                          final chatData = doc.data();
                          Name = chatData!['name'];
                        } else {}
                      }).catchError((error) {
                        const CircularProgressIndicator();
                      });
                      markAllMessagesAsSeen(chatId);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Groupe_Chat(
                                  chatId: chatId,
                                  ChatName: Name,
                                )), //there is a problem in this field
                      );
                    },
                  );
                });
          } else {
            return const CircularProgressIndicator();
          }
        });
  }
}
