import 'dart:async';

import 'package:esiway/SignIn_Up/CreateProfile.dart';
import 'package:esiway/SignIn_Up/widgets/prefixe_icon_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../shared/button.dart';
import '../shared/constant.dart';

class EmailVerification extends StatefulWidget {
  const EmailVerification({super.key});

  @override
  State<EmailVerification> createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  User? currentuser = FirebaseAuth.instance.currentUser;
  void back() {
    Navigator.of(context).pop();
    User? user = FirebaseAuth.instance.currentUser;
    user!.delete();
  }

  Timer? timer;
  bool? isVerified;
  @override
  void initState() {
    super.initState();
    isVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    timer = Timer.periodic(Duration(seconds: 3), (_) async {
      await FirebaseAuth.instance.currentUser!.reload();
      setState(() {
        isVerified = FirebaseAuth.instance.currentUser!.emailVerified;
      });
      if (isVerified == true) {
        timer?.cancel();
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => CreateProfile()));
      }
    });
  }

  bool enabled = false;
  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future SendVerificationEmail() async {
    try {
      await currentuser!.sendEmailVerification();
      setState(() {
        enabled = false;
      });
      Future.delayed(Duration(milliseconds: 5));
      setState(() {
        enabled = true;
      });
    } catch (e) {
      print('${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    var largeur = MediaQuery.of(context).size.width;
    var hauteur = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: color3,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.35,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage("Assets/Images/background3.png"),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 20, left: 20),
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
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Color(0xFF72D2C2),
                          size: 18,
                        ),
                        espaceicontext: 5.0,
                        fct: back),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.22,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      "Check your ",
                      style: TextStyle(
                          color: bleu_bg,
                          fontFamily: "Montserrat",
                          fontSize: 42,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "MailBox !",
                    style: TextStyle(
                        color: bleu_bg,
                        fontFamily: "Montserrat",
                        fontSize: 42,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: hauteur * 0.05,
                  ),
                  Text(
                    "To confirm your email address,\nplease click on the link in the email\nwe sent you",
                    style: TextStyle(
                        color: bleu_bg,
                        fontSize: 15,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.normal),
                  ),
                  SizedBox(
                    height: hauteur * 0.05,
                  ),
                  Container(
                    height: 36,
                    width: double.infinity,
                    child: Button(
                        color: orange,
                        title: "Resent",
                        onPressed: () {
                          if (enabled) {
                            SendVerificationEmail();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                backgroundColor: Colors.white,
                                duration: Duration(
                                  seconds: 3,
                                ),
                                margin: EdgeInsets.symmetric(
                                    vertical: 30, horizontal: 20),
                                padding: EdgeInsets.all(12),
                                behavior: SnackBarBehavior.floating,
                                elevation: 2,
                                content: Center(
                                  child: Text(
                                    "The link is sent",
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 12,
                                      fontFamily: "Montserrat",
                                    ),
                                  ),
                                )));
                          }
                        }),
                  ),
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}
