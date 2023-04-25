import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../../widgets/button.dart';
import '../../widgets/constant.dart';
import '../../widgets/password_field.dart';
import '../SignIn_Up/login_page.dart';
import 'forgot_password_mailadress.dart';

class DeleteAccountPassword extends StatelessWidget {
  DeleteAccountPassword({super.key}) {
    _reference = FirebaseFirestore.instance
        .collection('Users')
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
            return DeleteAccount(password: data["Password"]);
          }

          return Container();
        },
      ),
    );
  }
}

class DeleteAccount extends StatefulWidget {
  DeleteAccount({Key? key, required this.password}) : super(key: key);

  String password;
  @override
  State<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  TextEditingController currentpassword = TextEditingController();

  bool currentpasswordvalidate = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color3,
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: vert,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          color: vert,
        ),
        title: Text(
          "Delete my account",
          style: TextStyle(
            color: bleu_bg,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
          child: Column(
            children: [
              Text(
                "Your profile and account details will be deleted.",
                style: TextStyle(
                  color: bleu_bg,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w400,
                  fontSize: 13,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              MyPasswordField(
                controller: currentpassword,
                bottomheigh: 0,
                title: "Password",
                validate: currentpasswordvalidate,
                error: "Password incorrect",
                hinttext: 'Enter your password',
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return MailAdress();
                          },
                        ),
                      );
                    },
                    child: const Text(
                      'Forgot your Password?',
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'Montserrat',
                        color: Color(0xff20236C),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Button(
                  color: orange,
                  title: "Delete my account",
                  onPressed: () async {
                    if (currentpassword.text == widget.password) {
                      setState(() {
                        currentpasswordvalidate = true;
                      });
                    } else {
                      setState(() {
                        currentpasswordvalidate = false;
                      });
                    }

                    if (currentpasswordvalidate) {
                      User? user = FirebaseAuth.instance.currentUser;

                      final Profile = FirebaseStorage.instance
                          .ref()
                          .child("images/${user!.uid}");
                      final Car = FirebaseStorage.instance
                          .ref()
                          .child("Cars/${user.uid}");
                      final Policy = FirebaseStorage.instance
                          .ref()
                          .child("Policy/${user.uid}");
                      try {
                        await Car.delete();
                        await Policy.delete();
                        await FirebaseFirestore.instance
                            .collection("Users")
                            .doc("${user.uid}")
                            .delete();
                      } catch (e) {
                        print("The fle doesn't exists");
                      }
                      try {
                        await Profile.delete();
                      } catch (e) {
                        print("The fle doesn't exists");
                      }

                      try {
                        await FirebaseFirestore.instance
                            .collection("Cars")
                            .doc("${user.uid}")
                            .delete();
                      } catch (e) {
                        print("The fle doesn't exists");
                      }
                      await user.delete();
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => LogInPage()));
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
