import 'package:esiway/Screens/Profile/profile_screen.dart';
import 'package:esiway/SignIn_Up/signup_page.dart';
import 'package:esiway/SignIn_Up/widgets/simple_button.dart';
import 'package:esiway/shared/constant.dart';
import 'package:esiway/shared/text_field.dart';
import 'package:esiway/shared/text_validation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'Services/Auth.dart';
import 'widgets/login_text.dart';
import 'widgets/login_text_field.dart';
import 'widgets/password_field.dart';

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

  Future<void> logIn() async {
    await AuthService().logIn(
        email: emailcontroller.text.trim(),
        password: passwordcontroller.text.trim());
  }

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
                            MyPasswordField(controller: passwordcontroller , validate: passwordvalidate, title: 'Password', error: 'Password empty',bottomheigh: 0,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () {},
                                  child: TextButton(
                                    onPressed: () {},
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
                                ),
                              ],
                            ),
                            incorrect
                                ? Center(
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: hauteur * 0.075,
                                        ),
                                        Text(
                                          "Email or password incorrect",
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 12.0),
                                        ),
                                        SizedBox(
                                          height: 3,
                                        )
                                      ],
                                    ),
                                  )
                                : SizedBox(
                                    height: hauteur * 0.075,
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
                                  final User? usersignin = (await FirebaseAuth
                                          .instance
                                          .signInWithEmailAndPassword(
                                              email: emailcontroller.text,
                                              password:
                                                  passwordcontroller.text))
                                      .user;

                                  try {
                                    if (usersignin != null) {
                                      setState(() {
                                        incorrect = true;
                                      });
                                      Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) {
                                          return Profile();
                                        }),
                                      );
                                    } else {
                                      setState(() {
                                        incorrect = false;
                                      });
                                      print("Error");
                                    }
                                  } on FirebaseAuthException catch (e) {
                                    print("Error  ${e}");
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
