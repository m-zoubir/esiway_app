import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esiway/Screens/Profile/profile_screen.dart';
import 'package:esiway/Screens/SignIn_Up/signup_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../widgets/constant.dart';
import '../../widgets/login_text.dart';
import '../../widgets/password_field.dart';
import '../../widgets/simple_button.dart';
import '../../widgets/text_field.dart';
import '../../widgets/text_validation.dart';
import '../Profile/forgot_password_mailadress.dart';

class LogInPage extends StatefulWidget {
  LogInPage({Key? key}) : super(key: key);
  bool yban = true;

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> with UserValidation {
  @override
  void nextpage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SignUpPage()));
  }

  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();

  bool emailvalidate = true;
  bool passwordvalidate = true;
  bool incorrect = false;

  Widget build(BuildContext context) {
    var largeur = MediaQuery.of(context).size.width;
    var hauteur = MediaQuery.of(context).size.height;
    double x = 00;

    /*  void dispose() {
      super.dispose();
      emailcontroller.dispose();
      passwordcontroller.dispose();
    } */
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
        image: AssetImage('Assets/Images/login.png'),
        fit: BoxFit.cover,
      )),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Positioned(
              top: x,
              left: 0,
              right: 0,
              bottom: 0,
              child: SizedBox(
                height: hauteur,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: hauteur * 0.29),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: largeur * 0.075),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MyText(
                                largeur: largeur * 0.6,
                                text: "Welcome",
                                weight: FontWeight.w700,
                                fontsize: 50,
                                color: const Color(0xff20236C)),
                            SizedBox(height: hauteur * 0.05),
                            Text_Field(
                              type: TextInputType.emailAddress,
                              hinttext: "Email",
                              validate: emailvalidate,
                              title: "Email",
                              error: "Is not esi mail",
                              textfieldcontroller: emailcontroller,
                              prefixicon: const Icon(
                                Icons.email_rounded,
                                color: Color(0xff72D2C2),
                              ),
                            ),
                            SizedBox(height: hauteur * 0.02375),
                            MyPasswordField(
                              controller: passwordcontroller,
                              validate: passwordvalidate,
                              title: 'Password',
                              error: 'Password empty',
                              bottomheigh: 0,
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
                              height: hauteur * 0.017,
                            ),
                            SimpleButton(
                              backgroundcolor: const Color(0xFFFFA18E),
                              size: Size(largeur, hauteur * 0.06),
                              radius: 10,
                              text: 'Log in',
                              textcolor: const Color(0xff20236C),
                              weight: FontWeight.w700,
                              fontsize: 20,
                              fct: () async {
                                if (isEmail(emailcontroller.text) == true) {
                                  setState(() {
                                    emailvalidate = true;
                                  });
                                } else {
                                  setState(() {
                                    emailvalidate = false;
                                  });
                                }
                                if (emailvalidate &&
                                    passwordcontroller.text.isNotEmpty) {
                                  User? usersignin;
                                  try {
                                    usersignin = (await FirebaseAuth.instance
                                            .signInWithEmailAndPassword(
                                                email: emailcontroller.text,
                                                password:
                                                    passwordcontroller.text))
                                        .user;

                                    if (usersignin != null &&
                                        usersignin.emailVerified == true) {
                                      setState(() {
                                        incorrect = false;
                                      });
                                      User? user =
                                          FirebaseAuth.instance.currentUser;
                                      await FirebaseFirestore.instance
                                          .collection("Users")
                                          .doc(user!.uid)
                                          .update({
                                        "Password": passwordcontroller.text,
                                      }).then((value) =>
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) {
                                                  return Profile();
                                                }),
                                              ));
                                      Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) {
                                          return Profile();
                                        }),
                                      );
                                    } else if (usersignin!.emailVerified ==
                                        false) {
                                      try {
                                        usersignin.delete();
                                      } catch (e) {
                                        print("Error");
                                      }

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              backgroundColor: Colors.white,
                                              duration: Duration(
                                                seconds: 3,
                                              ),
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 30, horizontal: 20),
                                              padding: EdgeInsets.all(12),
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              elevation: 2,
                                              content: Center(
                                                child: Text(
                                                  "Email or password incorrect",
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 12,
                                                    fontFamily: "Montserrat",
                                                  ),
                                                ),
                                              )));
                                    }
                                  } on FirebaseAuthException catch (e) {
                                    print(
                                        "-----------------> Error  ${e.code}");
                                    if (e.code == 'wrong-password') {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              backgroundColor: Colors.white,
                                              duration: Duration(
                                                seconds: 3,
                                              ),
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 30, horizontal: 20),
                                              padding: EdgeInsets.all(12),
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              elevation: 2,
                                              content: Center(
                                                child: Text(
                                                  "Wrong password provided for that user",
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 12,
                                                    fontFamily: "Montserrat",
                                                  ),
                                                ),
                                              )));
                                    }

                                    if (e.code == "user-not-found") {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              backgroundColor: Colors.white,
                                              duration: Duration(
                                                seconds: 3,
                                              ),
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 30, horizontal: 20),
                                              padding: EdgeInsets.all(12),
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              elevation: 2,
                                              content: Center(
                                                child: Text(
                                                  "Email or password incorrect",
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 12,
                                                    fontFamily: "Montserrat",
                                                  ),
                                                ),
                                              )));
                                    }
                                    if (e.code == "network-request-failed") {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              SimpleDialog(children: [
                                                Container(
                                                  color: Colors.white,
                                                  height: 40,
                                                  width: 100,
                                                  child: Center(
                                                      child: Text(
                                                    "Please check your network",
                                                    style: TextStyle(
                                                      color: bleu_bg,
                                                      fontSize: 13,
                                                    ),
                                                  )),
                                                ),
                                              ]));
                                    }
                                  }
                                }
                              },
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Don\'t have an account yet?',
                                  style: TextStyle(
                                    fontFamily: 'Montserrat-',
                                    color: Color(0xff20236C),
                                    fontSize: 12,
                                  ),
                                ),
                                TextButton(
                                  onPressed: nextpage,
                                  child: const Text(
                                    'Sign Up',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Montserrat',
                                      color: Color(0xff20236C),
                                      fontSize: 12,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
