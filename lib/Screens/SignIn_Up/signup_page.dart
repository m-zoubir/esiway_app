import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../widgets/constant.dart';
import '../../widgets/icons_ESIWay.dart';
import '../../widgets/login_text.dart';
import '../../widgets/password_field.dart';
import '../../widgets/prefixe_icon_button.dart';
import '../../widgets/suffixe_icon_button.dart';
import '../../widgets/text_field.dart';
import '../../widgets/text_validation.dart';
import 'email_verification.dart';
import 'login_page.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key? key}) : super(key: key);
  bool yban = true;

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> with UserValidation {
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController confirmpasswordcontroller = TextEditingController();
  TextEditingController phonecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();

  bool emailvalidate = true;
  bool passwordvalidate = true;
  bool confirmvalidate = true;
  bool phonevalidate = true;

  void login() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LogInPage()));
  }

  User? currentuser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    var largeur = MediaQuery.of(context).size.width;
    var hauteur = MediaQuery.of(context).size.height;

    return Container(
      decoration: const BoxDecoration(
          color: color3,
          image: DecorationImage(
            image: AssetImage("Assets/Images/signup.png"),
            fit: BoxFit.cover,
          )),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 0,
                child: SizedBox(
                  height: hauteur,
                  // width: double.infinity,
                  // height: double.infinity,

                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20.0, horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                height: 35,
                                width: 80,
                                child: PrefixeIconButton(
                                    size: const Size(73, 34),
                                    color: Colors.white,
                                    radius: 10,
                                    text: "Back",
                                    textcolor: Color(0xFF20236C),
                                    weight: FontWeight.w600,
                                    fontsize: 14,
                                    icon: Transform.scale(
                                      scale: 0.75,
                                      child: Icons_ESIWay(
                                          icon: "arrow_left",
                                          largeur: 30,
                                          hauteur: 30),
                                    ),
                                    espaceicontext: 5.0,
                                    fct: login),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: hauteur * 0.15),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: largeur * 0.075),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MyText(
                                  largeur: largeur * 0.6,
                                  text: "Sign Up",
                                  weight: FontWeight.w700,
                                  fontsize: 50,
                                  color: const Color(0xff20236C)),
                              SizedBox(height: hauteur * 0.03),
                              Text_Field(
                                type: TextInputType.emailAddress,
                                hinttext: "Enter your email",
                                validate: emailvalidate,
                                bottomheigh: 14,
                                title: "Email",
                                error: "It's not esi mail",
                                textfieldcontroller: emailcontroller,
                                iconName: "email",
                              ),
                              MyPasswordField(
                                controller: passwordcontroller,
                                bottomheigh: 14,
                                title: "Password",
                                error: "At least 8 characters",
                                validate: passwordvalidate,
                              ),
                              MyPasswordField(
                                controller: confirmpasswordcontroller,
                                bottomheigh: 14,
                                title: "Password confirmation",
                                validate: confirmvalidate,
                                error: "Reconfirm your password ",
                              ),
                              Text_Field(
                                type: TextInputType.phone,
                                hinttext: "+213 |",
                                validate: phonevalidate,
                                bottomheigh: 30,
                                title: "Phone number",
                                error: "It's not a phone number",
                                textfieldcontroller: phonecontroller,
                                prefixicon: const Icon(
                                  Icons.phone,
                                  color: vert,
                                ),
                              ),
                              SuffixeIconButton(
                                  size: Size(largeur, hauteur * 0.06),
                                  color: const Color(0xFFFFA18E),
                                  radius: 10,
                                  text: "Next",
                                  textcolor: Color(0xFF20236C),
                                  weight: FontWeight.w700,
                                  fontsize: 20,
                                  icon: const Icon(
                                    Icons.arrow_right_rounded,
                                    color: Color(0xff20236C),
                                    size: 40,
                                  ),
                                  espaceicontext: 0.0,
                                  fct: () async {
                                    if (isEmail(emailcontroller.text)) {
                                      setState(() {
                                        emailvalidate = true;
                                      });
                                    } else {
                                      setState(() {
                                        emailvalidate = false;
                                      });
                                    }

                                    if (isPhone(phonecontroller.text)) {
                                      setState(() {
                                        phonevalidate = true;
                                      });
                                    } else {
                                      setState(() {
                                        phonevalidate = false;
                                      });
                                    }

                                    if (isPassword(passwordcontroller.text)) {
                                      setState(() {
                                        passwordvalidate = true;
                                      });
                                    } else {
                                      setState(() {
                                        passwordvalidate = false;
                                        confirmvalidate = false;
                                      });
                                    }

                                    if (confirmpasswordcontroller.text ==
                                            passwordcontroller.text &&
                                        confirmpasswordcontroller
                                            .text.isNotEmpty) {
                                      setState(() {
                                        confirmvalidate = true;
                                      });
                                    } else {
                                      setState(() {
                                        confirmvalidate = false;
                                      });
                                    }
                                    if (confirmvalidate &&
                                        passwordvalidate &&
                                        emailvalidate &&
                                        passwordvalidate) {
                                      try {
                                        await FirebaseAuth.instance
                                            .createUserWithEmailAndPassword(
                                                email: emailcontroller.text,
                                                password:
                                                    passwordcontroller.text);
                                        setState(() {
                                          currentuser =
                                              FirebaseAuth.instance.currentUser;
                                        });
                                        await FirebaseFirestore.instance
                                            .collection("Users")
                                            .doc(currentuser!.uid)
                                            .set({
                                          "Email": emailcontroller.text,
                                          "Password": passwordcontroller.text,
                                          "Phone": phonecontroller.text,
                                          "CreatedAt": DateTime.now(),
                                        });

                                        currentuser!.sendEmailVerification();

                                        Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context) {
                                            return EmailVerification();
                                          }),
                                        );
                                      } on FirebaseAuthException catch (e) {
                                        print("Error ${e.code}");
                                        if (e.code == "email-already-in-use") {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  backgroundColor: Colors.white,
                                                  duration: Duration(
                                                    seconds: 3,
                                                  ),
                                                  margin: EdgeInsets.symmetric(
                                                      vertical: 30,
                                                      horizontal: 20),
                                                  padding: EdgeInsets.all(12),
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  elevation: 2,
                                                  content: Center(
                                                    child: Text(
                                                      "This email is already used",
                                                      style: TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 12,
                                                        fontFamily:
                                                            "Montserrat",
                                                      ),
                                                    ),
                                                  )));
                                        }
                                        if (e.code ==
                                            "network-request-failed") {
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
                                  }),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Already Have an Account !',
                                    style: TextStyle(
                                      fontFamily: 'Montserrat-',
                                      color: Color(0xff20236C),
                                      fontSize: 12,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: login,
                                    child: const Text(
                                      'Log In',
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
      ),
    );
  }
}
