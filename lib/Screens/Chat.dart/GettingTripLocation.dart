// ignore_for_file: file_names

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

// to get the name of the chat
class GettingTripLocations extends StatelessWidget {
  final String startField;
  final String arrivalField;

  GettingTripLocations({required this.startField, required this.arrivalField});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('trip').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return const CircularProgressIndicator();

        final List<QueryDocumentSnapshot> documents = snapshot.data!.docs;

        final List<String> tripLocations = [];

        for (var document in documents) {
          final String startLocation = document.get(startField);
          final String arrivalLocation = document.get(arrivalField);
          tripLocations.add('$startLocation-$arrivalLocation');
        }

        return ListView(
          children: tripLocations.map((String tripLocation) {
            return ListTile(
              title: ResponsiveText(
                text: tripLocation,
                minFontSize: 15,
                maxFontSize: 25,
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
