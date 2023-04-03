import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esiway/Screens/Profile/profile_screen.dart';
import 'package:esiway/SignIn_Up/widgets/prefixe_icon_button.dart';
import 'package:esiway/shared/text_field.dart';
import 'package:esiway/shared/text_validation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../shared/constant.dart';
import 'Services/Auth.dart';
import 'login_page.dart';
import 'verification_page.dart';
import 'widgets/login_text.dart';
import 'widgets/login_text_field.dart';
import 'widgets/password_field.dart';
import 'widgets/suffixe_icon_button.dart';

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

  void verification() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => VerificationPage()));
  }

  User? currentuser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    var largeur = MediaQuery.of(context).size.width;
    var hauteur = MediaQuery.of(context).size.height;

    Future<void> signUp() async {
      await AuthService().signUp(
          email: emailcontroller.text.trim(),
          password: passwordcontroller.text.trim(),
          confirmpassword: confirmpasswordcontroller.text.trim(),
          context: context);
    }

    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
        image: AssetImage("Assets/Images/signup.png"),
        fit: BoxFit.cover,
      )),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
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
                      SizedBox(height: hauteur * 0.05),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            PrefixeIconButton(
                                size: const Size(73, 34),
                                color: Colors.white,
                                radius: 10,
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
                                fct: login),
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
                              prefixicon: const Icon(
                                Icons.email_rounded,
                                color: vert,
                              ),
                            ),
                            MyPasswordField(
                              controller: passwordcontroller,
                              bottomheigh: 14,
                              title: "Password",
                              error: "At least 8 characters" ,
                              validate: passwordvalidate,
                            ),
                            MyPasswordField(
                              controller: confirmpasswordcontroller,
                              bottomheigh: 14,
                              title: "Password confirmation",
                              validate: confirmvalidate,
                              error:  "Reconfirm your password ",
                            ),
                            Text_Field(
                              type:   TextInputType.phone,
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
                                    if( isEmail(emailcontroller.text))
                                      {
                                        setState(() {
                                          emailvalidate =true ;
                                        });
                                      }
                                    else
                                      {
                                        setState(() {
                                          emailvalidate =false ;

                                          });
                                      }


                                    if( isPhone(phonecontroller.text))
                                      {
                                        setState(() {
                                          phonevalidate = true ;
                                        });
                                      }
                                    else{
                                      setState(() {
                                        phonevalidate = false ;
                                      });
                                    }


                                    if( isPassword(passwordcontroller.text))
                                      {
                                        setState(() {
                                          passwordvalidate = true ;
                                        });
                                      }
                                    else{
                                      setState(() {
                                        passwordvalidate = false ;
                                        confirmvalidate = false ;
                                      });
                                    }

                                    if( confirmpasswordcontroller.text == passwordcontroller.text && confirmpasswordcontroller.text.isNotEmpty)
                                      {
                                        setState(() {
                                          confirmvalidate =true ;
                                        });

                                      }
                                    else
                                      {
                                        setState(() {
                                          confirmvalidate = false ;
                                        });
                                      }
                                    if( confirmvalidate && passwordvalidate && emailvalidate && passwordvalidate)
                                      {
                                        try{
                                          await FirebaseAuth.instance
                                              .createUserWithEmailAndPassword(
                                              email: emailcontroller.text,
                                              password: passwordcontroller.text);
                                          setState(() {
                                            currentuser =
                                                FirebaseAuth.instance.currentUser;
                                          });
                                          FirebaseFirestore.instance
                                              .collection("Users")
                                              .doc()
                                              .set({
                                            "Email": emailcontroller.text,
                                            "Password": passwordcontroller.text,
                                            "phone": phonecontroller.text,
                                            "uid": currentuser!.uid,
                                            "CreatedAt": DateTime.now(),
                                          }).then((value) => Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) {
                                                  return Profile();
                                                }),
                                          ));

                                        } catch(e)
                                        {
                                          print("Error ${e}") ;
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
    );
  }
}
