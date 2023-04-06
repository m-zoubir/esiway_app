import 'package:esiway/Screens/Profile/settings_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../SignIn_Up/widgets/prefixe_icon_button.dart';
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

  void back() {
    Navigator.of(context).pop();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.35,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage("Assets/Images/background3.png"),
                ),
              ),
              child: Container(
                margin: EdgeInsets.only(top: 20, left: 20),
                width: 80,
                height: 35,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PrefixeIconButton(
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
                  ],
                ),
              ),
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
                            .sendPasswordResetEmail(email: email.text)
                            .then((value) => Navigator.of(context).pop());
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
          ]),
        ),
      ),
    );
  }
}
