// ignore_for_file: file_names, camel_case_types, non_constant_identifier_names
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:iconsax/iconsax.dart';
//import 'package:flutter_iconsax/flutter_iconsax.dart';
// ignore: unused_import
// ignore: unused_import, depend_on_referenced_packages

import 'ChatServices.dart';
import 'Chatting.dart';
import 'GroupeImage.dart';

class Chat_secreen extends StatefulWidget {
  const Chat_secreen({super.key});

  @override
  State<Chat_secreen> createState() => _Chat_secreenState();
}

class _Chat_secreenState extends State<Chat_secreen> {
  late String imageUrl =
      'https://via.placeholder.com/150'; // initialize with default image URL
  late String usrID = "";
  Future<String> getMemberImageUrl(String memberId) async {
    final DocumentReference userRef =
        FirebaseFirestore.instance.collection('Users').doc(memberId);
    final DocumentSnapshot<Object?> snapshot = await userRef.get();

    final Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
    if (data != null && data.containsKey('ProfilePicture')) {
      final String imageUrl = data['ProfilePicture']?.toString() ??
          'https://via.placeholder.com/150';
      return imageUrl;
    }

    return 'https://via.placeholder.com/150';
  }

  Future<void> init_user() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? currentUser = auth.currentUser;
    final String currentUserId = currentUser!.uid;
    final String userImageUrl = await getMemberImageUrl(currentUserId);
    setState(() {
      imageUrl = userImageUrl;
      usrID = currentUserId;
    });
  }

  @override
  void initState() {
    super.initState();
    init_user();
  }

  @override
  Widget build(BuildContext context) {
    var largeur = MediaQuery.of(context).size.width;
    var hauteur = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F8FF),
      // ignore: prefer_const_constructors
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              children: [
                SizedBox(
                  height: hauteur * 0.03,
                ),
                Stack(
                  children: [
                    Stack(
                      children: [
                        SizedBox(
                          height: hauteur * 0.03,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                width: largeur * 0.20,
                                height: hauteur * 0.04,
                                margin: EdgeInsets.only(
                                  left: largeur * 0.086,
                                  top: hauteur * 0.033,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(6),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          const Color.fromARGB(156, 32, 35, 108)
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
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: largeur * 0.02,
                                        right: hauteur * 0.0034,
                                      ),
                                      child: SvgPicture.asset(
                                        'Assets/Images/left.svg',
                                        width: 18,
                                        height: 18,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 3,
                                    ),
                                    const Text(
                                      'Back',
                                      style: TextStyle(
                                        color: Color(0xff20236C),
                                        fontFamily: 'Montserrat-Bold',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: largeur * 0.47),
                            Column(
                              children: [
                                SizedBox(height: hauteur * 0.04),
                                SizedBox(
                                  width: largeur * 0.18, //98,
                                  height: hauteur * 0.08, //9,
                                  child: CircleAvatar(
                                    backgroundImage:
                                        CachedNetworkImageProvider(imageUrl),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: hauteur * 0.03,
                ),
                //the Title
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.09),
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

                //the list of messages
                SizedBox(
                  height: hauteur * 0.02,
                ),
                // la pile
                SingleChildScrollView(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    margin: EdgeInsets.only(
                      left: largeur * 0.03,
                      right: hauteur * 0.03,
                      // top: hauteur * 0.02
                    ),
                    // padding: EdgeInsets.all(largeur * 0.01),
                    height: hauteur * 0.69,
                    child: name(usedId: usrID),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      //just to test how it will look
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: 0,
        onTap: (index) {},
      ),
    );
  }
}

class name extends StatefulWidget {
  final String usedId;

  const name({Key? key, required this.usedId}) : super(key: key);

  @override
  State<name> createState() => _nameState();
}

class _nameState extends State<name> {
  @override
  Widget build(BuildContext context) {
    var largeur = MediaQuery.of(context).size.width;
    var hauteur = MediaQuery.of(context).size.height;
    // ignore: unused_local_variable
    String userId = widget.usedId ?? '';
    return StreamBuilder<QuerySnapshot>(
        stream: widget.usedId != null && widget.usedId.isNotEmpty
            ? FirebaseFirestore.instance
                .collection('Users')
                .doc(widget.usedId)
                .collection('chat')
                .snapshots()
            : null,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('Loading');
          }
          if (snapshot.hasData && snapshot.data != null) {
            final chatDocs = snapshot.data!.docs;

            return ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: chatDocs.length,
                itemBuilder: (BuildContext context, int index) {
                  final chat = chatDocs[index];
                  String chatId = chat.id;
                  // ignore: unused_local_variable
                  String ChatImage = "";
                  // ignore: unused_local_variable
                  int number = 0;
                  final chatRef = FirebaseFirestore.instance
                      .collection('chats')
                      .doc(chatId);
                  chatRef.get().then((doc) {
                    if (doc.exists) {
                      final chatData = doc.data();
                      final nb = chatData!['NbUnseen'];
                      final url = chatData['chatImage'];
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
                    onLongPress: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: const Color(0xFFF9F8FF),
                            title:
                                const Text("Do you want  leave the chat room?",
                                    style: TextStyle(
                                      color: Color(0xFF20236C),
                                    )),
                            actions: <Widget>[
                              TextButton(
                                child: const Text(
                                  "Cancel",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onPressed: () {
                                  // Call your leaveChatRoomFirestore function here
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                },
                              ),
                              TextButton(
                                child: const Text(
                                  "Leave",
                                  style: TextStyle(
                                    color: Color(0xFFF36043),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onPressed: () {
                                  leaveChatRoomFirestore(
                                      chatId,
                                      widget
                                          .usedId); // Call your leaveChatRoomFirestore function here
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    onTap: () {
                      var Name = "chat";
                      final chatRef = FirebaseFirestore.instance
                          .collection('chats')
                          .doc(chatId);
                      chatRef.get().then((doc) {
                        if (doc.exists) {
                          final chatData = doc.data();
                          final chatName = chatData!['name'];
                          Name = chatName;
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
                    child: Column(
                      children: [
                        Container(
                          height: hauteur * 0.1,
                          width: largeur * 0.94,
                          margin: EdgeInsets.only(
                              top: 0,
                              bottom: hauteur * 0.015,
                              left: largeur * 0.027,
                              right: largeur * 0.027),
                          padding: EdgeInsets.symmetric(
                              horizontal: largeur * 0.03,
                              vertical: hauteur * 0.012),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
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
                                        if (!snapshot.hasData) {
                                          return const CircularProgressIndicator();
                                        }
                                        var nb = snapshot.data!.get('NbUnseen');
                                        // ignore: unused_local_variable
                                        var ChatName =
                                            snapshot.data!.get('chatImage');
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

                                              final messages =
                                                  snapshot.data!.docs;

                                              final message = messages.first;
                                              final senderId =
                                                  message.get('sender');

                                              if (senderId == widget.usedId) {
                                                nb = 0;
                                              }

                                              return Stack(
                                                children: [
                                                  SizedBox(
                                                    width: largeur * 0.15, //98,
                                                    height: hauteur * 0.08, //9,
                                                    child: GroupChatImage(
                                                      chatId: chatId,
                                                      width:
                                                          largeur * 0.04, //98,
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
                                                            const EdgeInsets
                                                                .all(2),
                                                        decoration:
                                                            const BoxDecoration(
                                                          color:
                                                              Color(0xFFFFA18E),
                                                          shape:
                                                              BoxShape.circle,
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
                                  Column(
                                    //**1 */
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                            if (!snapshot.hasData) {
                                              return const CircularProgressIndicator();
                                            }
                                            var chatName =
                                                snapshot.data!.get('name');

                                            return Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  alignment: Alignment.topLeft,
                                                  width: largeur * 0.4,
                                                  child: Text(
                                                    chatName, // the problem is in the field name
                                                    //number,
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
                                                  ),
                                                ),
                                                SizedBox(width: largeur * 0.08),
                                                // ignore: sized_box_for_whitespace
                                                Container(
                                                  width: largeur * 0.15,
                                                  child: StreamBuilder<
                                                      QuerySnapshot>(
                                                    stream: messagesRef
                                                        .orderBy('timestamp',
                                                            descending: true)
                                                        .limit(1)
                                                        .snapshots(),
                                                    builder: (BuildContext
                                                            context,
                                                        AsyncSnapshot<
                                                                QuerySnapshot>
                                                            snapshot) {
                                                      if (snapshot.hasError) {
                                                        return const Text(
                                                            'Something went wrong');
                                                      }

                                                      if (snapshot
                                                              .connectionState ==
                                                          ConnectionState
                                                              .waiting) {
                                                        return const Text(
                                                            'Loading...');
                                                      }

                                                      final messages =
                                                          snapshot.data!.docs;

                                                      if (messages.isEmpty) {
                                                        return Text(
                                                          '00:00',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Montserrat-Bold',
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize:
                                                                hauteur * 0.018,
                                                            color: const Color(
                                                                0xFF20236C),
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        );
                                                      }

                                                      final message =
                                                          messages.first;
                                                      final time = DateFormat(
                                                              'HH:mm')
                                                          .format(message
                                                              .get('timestamp')
                                                              .toDate());
                                                      return Text(
                                                        time,
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'Montserrat-Bold',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize:
                                                              hauteur * 0.018,
                                                          color: const Color(
                                                              0xFF20236C),
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ],
                                            );
                                          }),
                                      SizedBox(height: hauteur * 0.00875),
                                      // add a row and add the button
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            // ignore: sized_box_for_whitespace
                                            Container(
                                              width: largeur * 0.4,
                                              child:
                                                  StreamBuilder<QuerySnapshot>(
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

                                                  if (snapshot.hasData &&
                                                      snapshot.data != null) {
                                                    final messages =
                                                        snapshot.data!.docs;

                                                    if (messages.isEmpty) {
                                                      return Text(
                                                        'No messages yet',
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'Montserrat',
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize:
                                                              hauteur * 0.015,
                                                          color: const Color(
                                                              0xFF20236C),
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      );
                                                    } else {
                                                      final message =
                                                          messages.first;
                                                      final senderId =
                                                          message.get('sender');
                                                      return StreamBuilder<
                                                          DocumentSnapshot>(
                                                        stream:
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'Users')
                                                                .doc(senderId)
                                                                .snapshots(),
                                                        builder: (BuildContext
                                                                context,
                                                            AsyncSnapshot<
                                                                    DocumentSnapshot>
                                                                userSnapshot) {
                                                          if (userSnapshot
                                                              .hasError) {
                                                            return const Text(
                                                                'Something went wrong');
                                                          }
                                                          if (userSnapshot
                                                                  .connectionState ==
                                                              ConnectionState
                                                                  .waiting) {
                                                            return Text(
                                                              'Loading...',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Montserrat',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize:
                                                                    hauteur *
                                                                        0.015,
                                                                color: const Color(
                                                                    0xFF20236C),
                                                              ),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            );
                                                          } else {
                                                            final user =
                                                                userSnapshot
                                                                    .data!
                                                                    .get(
                                                                        'Name');
                                                            return Expanded(
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    '$user:',
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          'Montserrat',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontSize:
                                                                          hauteur *
                                                                              0.017,
                                                                      color: const Color(
                                                                          0xFF20236C),
                                                                    ),
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                  ),
                                                                  Expanded(
                                                                    child: Text(
                                                                      message.get('text') !=
                                                                              ""
                                                                          ? message
                                                                              .get('text')
                                                                          : "An Image",
                                                                      style:
                                                                          TextStyle(
                                                                        fontFamily:
                                                                            'Montserrat',
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        fontSize:
                                                                            hauteur *
                                                                                0.015,
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
                                                            );
                                                          }
                                                        },
                                                      );
                                                    }
                                                  } else {
                                                    return const CircularProgressIndicator(); // or any other loading indicator
                                                  }
                                                },
                                              ),
                                            ),

                                            SizedBox(width: largeur * 0.09),
                                            Row(
                                              children: [
                                                SvgPicture.asset(
                                                  'Assets/Images/Icon.svg',
                                                  width: 24,
                                                  height: 24,
                                                ),
                                                SizedBox(
                                                  width: largeur * 0.04,
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: hauteur * 0.0025),
                        SvgPicture.asset("Assets/Images/Line.svg"),
                        SizedBox(height: hauteur * 0.015),
                      ],
                    ),
                  );
                });
          } else {
            return const CircularProgressIndicator();
          }
        });
  }
}
