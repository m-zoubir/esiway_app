import 'dart:io';
import 'package:esiway/Screens/Chat/Chat_screen.dart';
import 'package:esiway/widgets/icons_ESIWay.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:bubble/bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../widgets/constant.dart';
import 'ChatAppBar.dart';
import 'GroupeMembers.dart';

class Groupe_Chat extends StatefulWidget {
  const Groupe_Chat({super.key, required this.chatId, required this.ChatName});

  final String ChatName;
  final String chatId;

  @override
  State<Groupe_Chat> createState() => _Groupe_ChatState();
}

class _Groupe_ChatState extends State<Groupe_Chat> {
  late String admin = "";
  late User currentUser;
  final key = ValueKey('group_members_chatID');
  late CollectionReference messagesRef;
  late final Stream<QuerySnapshot<Map<String, dynamic>>> _messagesStream;
  late ScrollController _scrollController;

  TextEditingController _textEditingController = TextEditingController();

  String? _userImageUrl;
  String _userName = '';
  String? ImageURL;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser!;
    _scrollController = ScrollController();
    _getUserData();

    messagesRef = FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatId)
        .collection('messages');

    _messagesStream = messagesRef.orderBy('timestamp').snapshots()
        as Stream<QuerySnapshot<Map<String, dynamic>>>;

    FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatId)
        .get()
        .then((DocumentSnapshot<Map<String, dynamic>> snapshot) {
      if (snapshot.exists) {
        admin = snapshot.data()!['admin'];
      } else {
        print('Document does not exist!');
      }
    }).catchError((error) {
      print('Error getting document: $error');
    });
  }

  File? _image;

  final _picker = ImagePicker();
  Future<void> _openImagePicker(source) async {
    final XFile? pickedImage = await _picker.pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
    Navigator.of(context).pop();

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: FractionallySizedBox(
            heightFactor: 0.7,
            child: Column(
              children: [
                Column(children: [
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Do you Want to Submit:",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Color(0xFF20236C),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.028),
                  //the image **1**
                  Container(
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.height * 0.2,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: vert,
                      ),
                      image: DecorationImage(
                        image: FileImage(_image!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.028),
                  InkWell(
                    onTap: () {
                      _image = null;
                    },
                    child: InkWell(
                      onTap: () => sendMessage(
                          null, FirebaseAuth.instance.currentUser!.uid, _image),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.04,
                        width: MediaQuery.of(context).size.width * 0.402,
                        padding: const EdgeInsets.fromLTRB(7, 5, 7, 5),
                        decoration: BoxDecoration(
                          color: Color(0xFFFFA18E),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.upload, color: Color(0xFF20236C)),
                              SizedBox(
                                  width: MediaQuery.of(context).size.width *
                                      0.013),
                              Text(
                                "Send",
                                style: TextStyle(
                                  color: Color(0xFF20236C),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ]),
                      ),
                    ),
                  ),
                ]),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> sendMessage(
      String? messageText, String senderId, File? _image) async {
    String? imageUrl;
    if (messageText == null) {
      Reference referenceRoot = FirebaseStorage.instance.ref();
      Reference referenceDirImages = referenceRoot.child('Chat');
      //Create a reference for the image to be stored
      Reference referenceImageToUpload =
          referenceDirImages.child("${widget.chatId}-${DateTime.now()}");

      try {
        //Store the file
        await referenceImageToUpload.putFile(File(_image!.path));
        //Success: get the download URL
        imageUrl = await referenceImageToUpload.getDownloadURL();
        print(imageUrl);
        Navigator.of(context).pop();
      } catch (error) {
        print(error);
      }
    }
    if (messageText != null || imageUrl != null) {
      await messagesRef.add({
        'sender': senderId, //i need to find a way to add user's namehere
        'text': messageText,
        'ImageUrl': imageUrl,
        'timestamp': DateTime.now(),
        'seen': false,
      });

      // Update the NbUnseen field of the chat document
      FirebaseFirestore.instance.collection('chats').doc(widget.chatId).update({
        "LastSender": senderId,
        "LastMessage": messageText != null ? messageText : " An image",
        "TimeOfLastMessage": DateTime.now(),
        'NbUnseen': FieldValue.increment(1),
      });
    } else {
      print("please re-try to send the message");
    }
  }

  void onSendMessagePressed() async {
    String messageText = _textEditingController.text.trim();

    if (messageText.isNotEmpty) {
      // Send the message to Firestore
      sendMessage(messageText, currentUser.uid, null);

      // Clear the text field and image file after sending
      _textEditingController.clear();
    } else {
      // Handle the case where the message is empty
      print('Empty message');
    }

    Future.delayed(Duration(milliseconds: 200), () {
      _scrollToBottom();
    });
  }

  Widget buildMessageTextField(BuildContext context) {
    var largeur = MediaQuery.of(context).size.width;
    var hauteur = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.only(
        left: largeur * 0.02,
        right: largeur * 0.03,
      ),
      child: Container(
        width: largeur * 0.95,
        padding: EdgeInsets.symmetric(horizontal: largeur * 0.022),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
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
        child: Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.location_on,
                color: const Color(0xFF72D2C2),
              ),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  builder: (context) {
                    return LocationPickerBottomSheet();
                  },
                );
              },
            ),
            Expanded(
              child: TextField(
                onSubmitted: (String _textEditingController) {
                  setState(() {
                    onSendMessagePressed();
                    _scrollController.animateTo(
                      _scrollController.position.maxScrollExtent,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  });
                  Future.delayed(Duration(milliseconds: 200), () {
                    _scrollToBottom();
                  });
                },
                controller: _textEditingController,
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  border: InputBorder.none,
                ),
              ),
            ),
            IconButton(
              icon: Transform.scale(
                scale: 1,
                child: Icons_ESIWay(icon: "galerie", largeur: 28, hauteur: 28),
              ),
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(30)),
                    ),
                    builder: (context) {
                      return FractionallySizedBox(
                        heightFactor: 0.3,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                "Choose:",
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Color(0xFF20236C),
                                ),
                              ),
                              SizedBox(height: hauteur * 0.028),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(color6),
                                      ),
                                      onPressed: () =>
                                          _openImagePicker(ImageSource.gallery),
                                      icon: Transform.scale(
                                        scale: 0.5,
                                        child: Icons_ESIWay(
                                            icon: "upload",
                                            largeur: 35,
                                            hauteur: 35),
                                      ),
                                      label: Text(
                                        "Upload",
                                        style: TextStyle(
                                          color: bleu_bg,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "Montserrat",
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10.0),
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(color6),
                                      ),
                                      onPressed: () =>
                                          _openImagePicker(ImageSource.camera),
                                      icon: Transform.scale(
                                        scale: 0.5,
                                        child: Icons_ESIWay(
                                            icon: "camera",
                                            largeur: 35,
                                            hauteur: 35),
                                      ),
                                      label: Text(
                                        "Take",
                                        style: TextStyle(
                                          color: bleu_bg,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "Montserrat",
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              },
            ),
            GestureDetector(
              child: Transform.scale(
                scale: 1,
                child:
                    Icons_ESIWay(icon: "send_square", largeur: 30, hauteur: 30),
              ),
              onTap: () {
                setState(() {
                  onSendMessagePressed();
                  _scrollController.animateTo(
                    _scrollController.position.maxScrollExtent,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                });
                Future.delayed(Duration(milliseconds: 200), () {
                  _scrollToBottom();
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getUserData() async {
    currentUser = FirebaseAuth.instance.currentUser!;
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser.uid)
          .get();
      Map<String, dynamic>? userData =
          userSnapshot.data() as Map<String, dynamic>?;
      if (userData != null) {
        setState(() {
          _userName = userData['Name'];
          _userImageUrl = userData.containsKey('ProfilePicture')
              ? userData['ProfilePicture']
              : null;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final height = mediaQuery.size.height;
    final width = mediaQuery.size.width;
    return Scaffold(
      backgroundColor: const Color(0xFFF9F8FF),
      appBar: ChatAppBar(
        UserPic: widget.chatId,
        context: context,
        backgroundImage: 'Assets/Images/BG2.svg',
        onBackButtonPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => Chat_secreen()));
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: width * 0.12),
              child: Text(
                widget.ChatName,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w600,
                  fontSize: 30,
                  color: Color(0xFF20236C),
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            GroupMembers(
              key: key,
              chatId: widget.chatId,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                  width * 0.03, height * 0.01, width * 0.03, height * 0.01),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18.0),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(156, 32, 35, 108).withOpacity(0.05),
                      spreadRadius: 3,
                      blurRadius: 5,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
                height: height * 0.42,
                child: StreamBuilder<QuerySnapshot>(
                  stream: messagesRef.orderBy('timestamp').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    final messages =
                        snapshot.data!.docs.map((doc) => doc.data()).toList();
                    return ListView.builder(
                      controller: _scrollController,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        final senderId = message != null
                            ? (message as Map<String, dynamic>)['sender']
                                as String?
                            : null;

                        String? senderProfilePicture;
                        String? sendername;
                        if (senderId != null) {
                          FirebaseFirestore.instance
                              .collection('Users')
                              .doc(senderId)
                              .get()
                              .then((doc) {
                            if (doc.exists) {
                              senderProfilePicture =
                                  doc.data()!.containsKey("ProfilePicture")
                                      ? doc.data()!['ProfilePicture']
                                      : null;
                              sendername = doc.data()!.containsKey("Name")
                                  ? doc.data()!['Name']
                                  : "Name";
                            }
                          });
                        }
                        return Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: width * 0.044,
                                vertical: height * 0.01),
                            child: message != null
                                ? StreamBuilder<DocumentSnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('Users')
                                        .doc(senderId)
                                        .snapshots(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<DocumentSnapshot>
                                            snapshot) {
                                      if (!snapshot.hasData) {
                                        return CircularProgressIndicator();
                                      }

                                      return Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        mainAxisAlignment: (message as Map<
                                                    String,
                                                    dynamic>)['sender'] ==
                                                currentUser.uid
                                            ? MainAxisAlignment.end
                                            : MainAxisAlignment.start,
                                        children: [
                                          if (message['sender'] !=
                                              currentUser.uid)
                                            Container(
                                              height: 25,
                                              width: 25,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                    width: 1,
                                                    color: Theme.of(context)
                                                        .scaffoldBackgroundColor,
                                                  ),
                                                  shape: BoxShape.circle,
                                                  image: senderProfilePicture ==
                                                          null
                                                      ? DecorationImage(
                                                          image: AssetImage(
                                                              "Assets/Images/photo_profile.png"),
                                                          fit: BoxFit.cover,
                                                        )
                                                      : DecorationImage(
                                                          image: NetworkImage(
                                                              senderProfilePicture!),
                                                          fit: BoxFit.cover,
                                                        )),
                                            ),
                                          SizedBox(width: width * 0.022),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  (message['sender'] ==
                                                          currentUser.uid)
                                                      ? CrossAxisAlignment.end
                                                      : CrossAxisAlignment
                                                          .start,
                                              children: [
                                                Bubble(
                                                  nip: (message['sender'] ==
                                                          currentUser.uid)
                                                      ? BubbleNip.rightBottom
                                                      : BubbleNip.leftBottom,
                                                  color: (message['sender'] ==
                                                          admin) //admin
                                                      ? orange.withOpacity(0.38)
                                                      : bleu_ciel
                                                          .withOpacity(0.4),
                                                  borderColor:
                                                      (message['sender'] ==
                                                              admin) //admin
                                                          ? orange
                                                              .withOpacity(0.6)
                                                          : bleu_ciel
                                                              .withOpacity(0.5),
                                                  elevation: 0,
                                                  child: message['text'] != null
                                                      ? Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                              AutoSizeText(
                                                                '$sendername : ',
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      "Montserrat",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 12,
                                                                  color: Color(
                                                                      0xFF20236C),
                                                                ),
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                              AutoSizeText(
                                                                message['text']
                                                                    .toString(),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        "Montserrat",
                                                                    fontSize:
                                                                        15,
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                            ])
                                                      : message['ImageUrl'] !=
                                                              null
                                                          ? Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                AutoSizeText(
                                                                  '$sendername : ',
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        "Montserrat",
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        12,
                                                                    color: Color(
                                                                        0xFF20236C),
                                                                  ),
                                                                  maxLines: 1,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                                SizedBox(
                                                                  height: 5,
                                                                ),
                                                                CachedNetworkImage(
                                                                  imageUrl: message[
                                                                          'ImageUrl']
                                                                      .toString(),
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  width:
                                                                      width * 1,
                                                                  height:
                                                                      null, //0;24
                                                                  placeholder: (context,
                                                                          url) =>
                                                                      Center(
                                                                          child:
                                                                              CircularProgressIndicator()),
                                                                ),
                                                              ],
                                                            )
                                                          : Container(),
                                                ),
                                                if (message['seen'])
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 4.0,
                                                            right: 4.0),
                                                    child: Icon(
                                                      Icons.check,
                                                      size: 12.0,
                                                      color: Colors.grey[400],
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    })
                                : Container());
                      },
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: height * 0.01),
            buildMessageTextField(context),
            SizedBox(height: height * 0.02),
          ],
        ),
      ),
    );
  }
}

class LocationPickerBottomSheet extends StatefulWidget {
  @override
  _LocationPickerBottomSheetState createState() =>
      _LocationPickerBottomSheetState();
}

class _LocationPickerBottomSheetState extends State<LocationPickerBottomSheet> {
  void hideMyBottomSheet() {
    // Remove the bottom sheet from the widget tree
  }

  @override
  Widget build(BuildContext context) {
    var bottomSheetContext = context;

    final mediaQuery = MediaQuery.of(context);
    final height = mediaQuery.size.height;
    final width = mediaQuery.size.width;
    final _Controller = TextEditingController();

    return FractionallySizedBox(
      heightFactor: 1,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 14,
            ),
            Text(
              "Send Location :",
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Color(0xFF20236C),
              ),
            ),
            SizedBox(height: 14),
            Container(
              width: width * 0.94,
              padding: EdgeInsets.symmetric(horizontal: width * 0.022),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
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
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _Controller,
                      decoration: InputDecoration(
                        hintText: 'Type a location...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  GestureDetector(
                    child: SvgPicture.asset("Assets/Icons/route-square.svg",
                        width: width * 0.08, height: height * 0.04),
                    onTap: () {
                      Navigator.of(bottomSheetContext).pop();
                      setState(() {});
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
