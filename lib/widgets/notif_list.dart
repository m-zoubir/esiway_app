import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class MyWidget extends StatefulWidget {
  List<dynamic> notiflist = [];
  MyWidget({
    super.key,
    required this.notiflist,
  });

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView.builder(
            itemCount: widget.notiflist.length,
            itemBuilder: (context, index) {
              return Container(
                child: widget.notiflist[index],
              );
            }));
  }
}
