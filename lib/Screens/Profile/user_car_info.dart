import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../SignIn_Up/widgets/prefixe_icon_button.dart';
import '../../shared/constant.dart';
import '../../shared/title_text_field.dart';

class UserCarInfo extends StatefulWidget {
  UserCarInfo({Key? key}) : super(key: key);

  @override
  State<UserCarInfo> createState() => _UserCarInfoState();
}

class _UserCarInfoState extends State<UserCarInfo> {
  void back() {
    Navigator.of(context).pop();
  }

  void initState() {
    super.initState();

    _reference = FirebaseFirestore.instance
        .collection('Cars')
        .doc(FirebaseAuth.instance.currentUser!.uid);
    _futureData = _reference.get();
  }

  late DocumentReference _reference;

  //_reference.get()  --> returns Future<DocumentSnapshot>
  //_reference.snapshots() --> Stream<DocumentSnapshot>
  late Future<DocumentSnapshot> _futureData;
  late Map data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color3,
      body: FutureBuilder<DocumentSnapshot>(
        future: _futureData,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData) {
            //Get the data
            DocumentSnapshot documentSnapshot = snapshot.data;
            data = documentSnapshot.data() as Map;

            //display the data
            return SafeArea(
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.3,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(data["CarPicture"]),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(25.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () => back(),
                            child: Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8)),
                              child: Center(
                                child: Icon(color: vert, Icons.close),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TitleTextFeild(title: "Brand"),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "${data["brand"]}",
                          style: TextStyle(
                              color: bleu_bg,
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                              fontFamily: "Montserat"),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TitleTextFeild(title: "Model"),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "${data["model"]}",
                          style: TextStyle(
                              color: bleu_bg,
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                              fontFamily: "Montserat"),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TitleTextFeild(title: "Registration number"),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "${data["registrationNumber"]}",
                          style: TextStyle(
                              color: bleu_bg,
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                              fontFamily: "Montserat"),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TitleTextFeild(title: "Insurance policy"),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.34,
                          decoration: BoxDecoration(
                            border: Border.all(color: vert, width: 2),
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: NetworkImage(data["Policy"]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          return Container();
        },
      ),
    );
  }
}
