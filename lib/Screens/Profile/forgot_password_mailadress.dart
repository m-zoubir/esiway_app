import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../shared/button.dart';
import '../../shared/constant.dart';
import '../../shared/text_field.dart';
import '../../shared/text_validation.dart';

class MailAdress extends StatefulWidget {
  const MailAdress({Key? key}) : super(key: key);

  @override
  State<MailAdress> createState() => _MailAdressState();
}

class _MailAdressState extends State<MailAdress> with UserValidation {
  @override
  bool emailvalidate = true;
  TextEditingController email = TextEditingController();
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: Image.asset(
                        "Assets/Images/background3.png",
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateColor.resolveWith(
                            (states) => Colors.white),
                      ),
                      icon: Icon(
                        Iconsax.back_square,
                        color: vert,
                        size: 20,
                      ),
                      label: Text(
                        "Back",
                        style: TextStyle(
                            color: bleu_bg,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                width: MediaQuery.of(context).size.width * 0.6,
                child: Text(
                  "Find your \naccount",
                  style: TextStyle(
                    color: bleu_bg,
                    fontWeight: FontWeight.bold,
                    fontSize: 50,
                    fontFamily: "Montesserat",
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text_Field(
                  hinttext: "hinttext",
                  validate: emailvalidate,
                  title: "Enter  your email",
                  error: "Not esi mail",
                  textfieldcontroller: email,
                  prefixicon: Icon(
                    Icons.email,
                    color: vert,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height: 47,
                  width: double.infinity,
                  child: Button(
                    color: orange,
                    title: "Find",
                    onPressed: () async {
                      if (isEmail(email.text) == true) {
                        setState(() {
                          emailvalidate = true;
                        });
                        print(email.text);
                      } else {
                        setState(() {
                          emailvalidate = false;
                        });
                      }
                      if (emailvalidate) {
                        try {
                          await FirebaseAuth.instance
                              .sendPasswordResetEmail(email: email.text);
                          showDialog(
                              context: context,
                              builder: (context) =>
                                  SnackBar(content: Text("Email sent !")));
                        } on FirebaseAuthException catch (e) {
                          print("the error : ${e.message.toString()}");
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                  title: Text(
                                    'Error',
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: bleu_bg,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  content: Text(e.message.toString())));
                        }
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
