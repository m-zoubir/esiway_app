// ignore_for_file: file_names
import 'dart:io';
import 'dart:ui';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:path/path.dart';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:bubble/bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker/image_picker.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:iconsax/iconsax.dart';
//import 'package:flutter_iconsax/flutter_iconsax.dart';
// ignore: unused_import
// ignore: unused_import, depend_on_referenced_packages

import 'ChatAppBar.dart';
import 'GroupeMembers.dart';
//import 'Modeles/usermodele.dart';

class Groupe_Chat extends StatefulWidget {
  const Groupe_Chat({super.key, required this.chatId, required this.ChatName});

  final String ChatName;
  final String chatId;

  @override
  State<Groupe_Chat> createState() => _Groupe_ChatState();
}

class _Groupe_ChatState extends State<Groupe_Chat> {
  //late String chatID = widget.chatId;
  String admin = "";

  late User currentUser;
  final key = ValueKey('group_members_chatID');
  late CollectionReference messagesRef;

  late final Stream<QuerySnapshot<Map<String, dynamic>>> _messagesStream;
  ScrollController _scrollController = ScrollController();
  TextEditingController _textEditingController = TextEditingController();
  String _userImageUrl = '';
  String _userName = '';
  File? _imageFile;
  String ImageURL = '';
  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser!;
    _userName = currentUser.displayName!;
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

  void sendMessage2(
      String messageText, String senderId, String imageUrl) async {
    // Create a new message document in Firestore
    await messagesRef.add({
      'sender': senderId, //i need to find a way to add user's namehere
      'text': messageText,
      'ImageUrl': imageUrl,
      'timestamp': DateTime.now(),
      'seen': false,
    });
    // Update the NbUnseen field of the chat document
    FirebaseFirestore.instance.collection('chats').doc(widget.chatId).update({
      'NbUnseen': FieldValue.increment(1),
    });
  }

  void sendMessage(String messageText, String senderId) async {
    // Create a new message document in Firestore
    await messagesRef.add({
      'sender': senderId, //i need to find a way to add user's namehere
      'text': messageText,
      'ImageUrl': "",
      'timestamp': DateTime.now(),
      'seen': false,
    });
    // Update the NbUnseen field of the chat document
    FirebaseFirestore.instance.collection('chats').doc(widget.chatId).update({
      'NbUnseen': FieldValue.increment(1),
    });
  }

  void onSendMessagePressed2(File imageFile) async {
    String messageText = _textEditingController.text.trim();

    if (imageFile != null) {
      String imageUrl = "";

      // If the message contains an image, upload it to Firebase Storage and get the download URL
      if (imageFile != null) {
        imageUrl = (await uploadImageAndGetUrl(imageFile))!;
        // Send the message to Firestore
        sendMessage2("", currentUser.uid, imageUrl);
      } else {
        sendMessage(messageText, currentUser.uid);
      }
      setState(() {
        imageFile = Null as File;
      });
    } else {
      // Handle the case where the message is empty
      print('Empty message');
    }

    Future.delayed(Duration(milliseconds: 200), () {
      _scrollToBottom();
    });
  }

  void onSendMessagePressed() async {
    String messageText = _textEditingController.text.trim();

    if (messageText.isNotEmpty) {
      // Send the message to Firestore
      sendMessage(messageText, currentUser.uid);

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
                    // Scroll to the bottom of the list
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
              icon: const Icon(
                Icons.image_outlined,
                color: Color(0xFF72D2C2),
              ),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  builder: (context) {
                    return MyImagePickerBottomSheet(onUploadTapped: () {
                      // ignore: unused_local_variable
                      final imageFile = pickImage(context);
                    }, onTakePhotoTapped: () {
                      // ignore: unused_local_variable
                      final imageFile = openCamera(context);
                    });
                  },
                );
              },
            ),
            GestureDetector(
              child: SvgPicture.asset("Assets/Images/route-square.svg",
                  width: largeur * 0.088, height: hauteur * 0.04),
              onTap: () {
                setState(() {
                  onSendMessagePressed();
                  // Scroll to the bottom of the list
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
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser.uid)
        .get();
    Map<String, dynamic>? userData =
        userSnapshot.data() as Map<String, dynamic>?;
    if (userData != null && userData.containsKey('ProfilePicture')) {
      setState(() {
        _userName = userData['Name'];
        _userImageUrl =
            userData['ProfilePicture'] ?? 'https://via.placeholder.com/150';
      });
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
    //getGroupChatImageUrl(widget.chatId);
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
          Navigator.pop(context);
        },
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: width * 0.12),
                child: Text(
                  widget.ChatName,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                    color: Color(0xFF20236C),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              GroupMembers(
                key: key,
                chatId: widget.chatId,
              ),
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                      0, height * 0.01, width * 0.03, height * 0.01),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18.0),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromARGB(156, 32, 35, 108)
                              .withOpacity(0.05),
                          spreadRadius: 3,
                          blurRadius: 5,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                    height: height * 0.42,
                    child: Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: messagesRef.orderBy('timestamp').snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          final messages = snapshot.data!.docs
                              .map((doc) => doc.data())
                              .toList();
                          return ListView.builder(
                            controller: _scrollController,
                            itemCount: messages.length,
                            itemBuilder: (context, index) {
                              final message = messages[index];
                              // final senderId =message['sender']; //**1**/
                              //  final senderId = message['sender'] as String?;
                              //  final senderId = message != null ? message['sender'] as String? : null;
                              final senderId = message != null
                                  ? (message as Map<String, dynamic>)['sender']
                                      as String?
                                  : null;

                              String senderProfilePicture = '';
                              if (senderId != null) {
                                FirebaseFirestore.instance
                                    .collection('Users')
                                    .doc(senderId)
                                    .get()
                                    .then((doc) {
                                  if (doc.exists) {
                                    senderProfilePicture =
                                        doc.data()?['ProfilePicture'] ?? '';
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
                                            //   var iamgeprofile = snapshot.data!
                                            //     .get('ProfilePicture');
                                            return Row(
                                              mainAxisAlignment: (message
                                                              as Map<String,
                                                                  dynamic>)[
                                                          'sender'] ==
                                                      currentUser.uid
                                                  ? MainAxisAlignment.end
                                                  : MainAxisAlignment.start,
                                              children: [
                                                if (message['sender'] !=
                                                    currentUser.uid)
                                                  CircleAvatar(
                                                    backgroundImage: NetworkImage(
                                                        senderProfilePicture !=
                                                                    null &&
                                                                senderProfilePicture
                                                                    .isNotEmpty
                                                            ? senderProfilePicture
                                                            : 'https://via.placeholder.com/150'), //need tof fix the image url

                                                    radius: 20,
                                                  ),
                                                SizedBox(width: width * 0.022),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        (message['sender'] ==
                                                                currentUser.uid)
                                                            ? CrossAxisAlignment
                                                                .end
                                                            : CrossAxisAlignment
                                                                .start,
                                                    children: [
                                                      Bubble(
                                                        nip: (message[
                                                                    'sender'] ==
                                                                currentUser.uid)
                                                            ? BubbleNip
                                                                .rightBottom
                                                            : BubbleNip
                                                                .leftBottom,
                                                        color: (message['sender'] ==
                                                                admin) //admin
                                                            ? const Color(
                                                                    0xFFFFA18E)
                                                                .withOpacity(
                                                                    0.4)
                                                            : const Color(
                                                                    0xFF72D2C2)
                                                                .withOpacity(
                                                                    0.4),
                                                        borderColor: (message[
                                                                    'sender'] ==
                                                                admin) //admin
                                                            ? const Color(
                                                                    0xFFFFA18E)
                                                                .withOpacity(
                                                                    0.6)
                                                            : const Color(
                                                                    0xFF72D2C2)
                                                                .withOpacity(
                                                                    0.6),
                                                        elevation: 0,
                                                        child: message['text']
                                                                .isNotEmpty
                                                            ? AutoSizeText(
                                                                message['text']
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    color: Colors
                                                                        .black),
                                                                maxLines: 6,
                                                              )
                                                            : message['ImageUrl']
                                                                    .isNotEmpty
                                                                ? CachedNetworkImage(
                                                                    imageUrl: message[
                                                                            'ImageUrl']
                                                                        .toString(),
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    width:
                                                                        width *
                                                                            1,
                                                                    height:
                                                                        height *
                                                                            0.24,
                                                                    placeholder: (context,
                                                                            url) =>
                                                                        Center(
                                                                            child:
                                                                                CircularProgressIndicator()),
                                                                  )
                                                                : Container(),
                                                      ),
                                                      if (message['seen'])
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 4.0,
                                                                  right: 4.0),
                                                          child: Icon(
                                                            Icons.check,
                                                            size: 12.0,
                                                            color: Colors
                                                                .grey[400],
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
                ),
              ),
              SizedBox(height: height * 0.01),
              buildMessageTextField(context),
              SizedBox(height: height * 0.02),
            ],
          ),
        ),
      ),
    );
  }

  Future<File?> pickImage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);

      // ignore: use_build_context_synchronously
      showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        context: context,
        builder: (_) => SubmitImageBottomSheet(
          imagePath: imageFile.path,
          onUploadTapped: () {
            onSendMessagePressed2(imageFile);

            Navigator.pop(context);
            Navigator.pop(context);

            //     Navigator.pop(context); // close the bottom sheet
          },

          // Handle the upload button tap here
        ),
      );
      return imageFile;
    } else {
      return null;
    }
  }

// Function to take a photo from the camera
  Future<File?> openCamera(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);

      // ignore: use_build_context_synchronously
      showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        context: context,
        builder: (_) => SubmitImageBottomSheet(
            imagePath: imageFile.path,
            onUploadTapped: () {
              onSendMessagePressed2(imageFile);
              Navigator.pop(context);
              Navigator.pop(context);
            }),
      );
      return imageFile;
    } else {
      return null;
    }
  }
}

class SubmitImageBottomSheet extends StatefulWidget {
  final VoidCallback onUploadTapped;
  final String? imagePath;
  const SubmitImageBottomSheet({
    super.key,
    required this.onUploadTapped,
    this.imagePath,
  });

  @override
  State<SubmitImageBottomSheet> createState() => _SubmitImageBottomSheetState();
}

class _SubmitImageBottomSheetState extends State<SubmitImageBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    final height = mediaQuery.size.height;
    final width = mediaQuery.size.width;

    return FractionallySizedBox(
      heightFactor: 0.7,
      child: Column(children: [
        SvgPicture.asset(
          "Assets/Images/Rectangle.svg",
        ),
        SizedBox(
          height: height * 0.01,
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
        SizedBox(height: height * 0.028),
        //the image **1**
        widget.imagePath != null
            ? Image.file(
                File(widget.imagePath!),
                height: height * 0.24,
                width: width * 1,
                fit: BoxFit.contain,
              )
            : Container(),
        SizedBox(height: height * 0.028),
        InkWell(
          onTap: widget.onUploadTapped,
          child: Container(
            height: height * 0.04,
            width: width * 0.402,
            padding: const EdgeInsets.fromLTRB(7, 5, 7, 5),
            decoration: BoxDecoration(
              color: Color(0xFFFFA18E),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.upload, color: Color(0xFF20236C)),
                SizedBox(width: width * 0.013),
                Text(
                  "Send",
                  style: TextStyle(
                    color: Color(0xFF20236C),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}

class MyImagePickerBottomSheet extends StatefulWidget {
  final VoidCallback onUploadTapped;
  final VoidCallback onTakePhotoTapped;

  const MyImagePickerBottomSheet({
    required this.onUploadTapped,
    required this.onTakePhotoTapped,
    Key? key,
  }) : super(key: key);

  @override
  _MyImagePickerBottomSheetState createState() =>
      _MyImagePickerBottomSheetState();
}

class _MyImagePickerBottomSheetState extends State<MyImagePickerBottomSheet> {
  String? _selectedImagePath;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    final height = mediaQuery.size.height;
    final width = mediaQuery.size.width;

    return FractionallySizedBox(
      heightFactor: 0.3,
      child: Column(
        children: [
          SvgPicture.asset(
            "Assets/Images/Rectangle.svg",
          ),
          SizedBox(
            height: height * 0.01,
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
          SizedBox(height: height * 0.028),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: widget.onUploadTapped,
                child: Container(
                  height: height * 0.04,
                  width: width * 0.402,
                  padding: EdgeInsets.fromLTRB(width * 0.019, height * 0.00625,
                      width * 0.019, height * 0.00625),
                  decoration: BoxDecoration(
                    color: const Color(0xFF99CFD7),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.upload, color: Color(0xFF20236C)),
                      SizedBox(width: width * 0.013),
                      Text(
                        "Upload",
                        style: TextStyle(
                          color: Color(0xFF20236C),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: width * 0.038),
              InkWell(
                onTap: widget.onTakePhotoTapped,
                child: Container(
                  height: height * 0.043,
                  width: width * 0.402,
                  padding: EdgeInsets.fromLTRB(width * 0.019, height * 0.00625,
                      width * 0.019, height * 0.00625),
                  decoration: BoxDecoration(
                    color: const Color(0xFF99CFD7),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.camera, color: Color(0xFF20236C)),
                      SizedBox(width: width * 0.038),
                      Text(
                        "Take",
                        style: TextStyle(
                          color: Color(0xFF20236C),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
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
                    child: SvgPicture.asset("Assets/Images/route-square.svg",
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

Future<String?> uploadImageAndGetUrl(File imagePath) async {
  final ref = firebase_storage.FirebaseStorage.instance
      .ref()
      .child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');

  final task = ref.putFile(File(imagePath.path));

  try {
    await task;
    final imageUrl = await ref.getDownloadURL();
    return imageUrl;
  } on firebase_storage.FirebaseException catch (e) {
    print('Failed to upload image: $e');
    return null;
  }
}
