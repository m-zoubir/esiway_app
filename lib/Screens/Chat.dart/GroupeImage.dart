import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class GroupChatImage extends StatefulWidget {
  final String chatId;
  final double? width;
  final double? height;
  final double n;
  GroupChatImage(
      {required this.chatId, this.width, this.height, required this.n});

  @override
  _GroupChatImageState createState() => _GroupChatImageState();
}

class _GroupChatImageState extends State<GroupChatImage> {
  GlobalKey _globalKey = GlobalKey();

  Future<String> getGroupChatImage() async {
    RenderRepaintBoundary boundary =
        _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 2.0);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData != null) {
      Uint8List uint8list = byteData.buffer.asUint8List();
      return base64Encode(uint8list);
    } else {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: _globalKey,
      child: FutureBuilder<List<String>>(
        future: getMemberProfilePictureUrls(),
        builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
          if (snapshot.hasData) {
            List<String> profilePictureUrls = snapshot.data!;
            return buildGroupChatImage(
              profilePictureUrls,
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }

  Future<List<String>> getMemberProfilePictureUrls() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatId)
        .collection('members')
        .get();
    List<String> memberIds = querySnapshot.docs.map((doc) => doc.id).toList();
    List<String> profilePictureUrls = [];
    for (String memberId in memberIds) {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(memberId)
          .get();
      if (documentSnapshot.exists) {
        Map<String, dynamic>? data =
            documentSnapshot.data() as Map<String, dynamic>?;
        if (data != null) {
          String? profilePictureUrl = data['ProfilePicture'];
          if (profilePictureUrl != null) {
            profilePictureUrls.add(profilePictureUrl);
          }
        }
      }
    }
    return profilePictureUrls;
  }

  Widget buildGroupChatImage(List<String> profilePictureUrls,
      {double width = 100, double height = 100}) {
    if (profilePictureUrls.isEmpty) {
      return Icon(Icons.group);
    }
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        children: [
          for (int i = 0; i < profilePictureUrls.length && i < 3; i++)
            Positioned(
              left: i * 7.0,
              top: i * 17.0,
              child: Transform.rotate(
                angle: 0,
                child: CircleAvatar(
                  radius: width / widget.n,
                  backgroundImage: NetworkImage(profilePictureUrls[i]),
                ),
              ),
            ),
          if (profilePictureUrls.length > 3)
            Positioned(
              left: 3 * 9.0,
              top: 3 * 20.0,
              child: Container(
                width: width, // 4.0,
                height: height, // 4.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey,
                ),
                child: Center(
                  child: Text(
                    '+${profilePictureUrls.length - 3}',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void saveGroupChatImage() async {
    String groupChatImage = await getGroupChatImage();
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatId)
        .set({'chatImage': groupChatImage}, SetOptions(merge: true));
  }
}
