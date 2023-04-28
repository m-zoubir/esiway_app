import 'package:esiway/Screens/Profile/settings_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../widgets/button.dart';
import '../../widgets/constant.dart';
import '../../widgets/icons_ESIWay.dart';
import '../../widgets/prefixe_icon_button.dart';
import '../../widgets/text_field.dart';
import '../../widgets/text_validation.dart';

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
                        size: const Size(77, 34),
                        color: Colors.white,
                        radius: 10,
                        text: "Back",
                        textcolor: Color(0xFF20236C),
                        weight: FontWeight.w600,
                        fontsize: 14,
                        icon: Transform.scale(
                          scale: 0.75,
                          child: Icons_ESIWay(
                              icon: "arrow_left", largeur: 30, hauteur: 30),
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
                hinttext: "Enter your email",
                validate: emailvalidate,
                title: "Enter  your email",
                error: "Not esi mail",
                textfieldcontroller: email,
                iconName: "email",
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
