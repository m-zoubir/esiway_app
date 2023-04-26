// ignore_for_file: file_names, non_constant_identifier_names, avoid_print, unused_element

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../widgets/constant.dart';
import '../../widgets/icons_ESIWay.dart';
import '../../widgets/prefixe_icon_button.dart';
import '../../widgets/suffixe_icon_button.dart';
import '../../widgets/text_field.dart';
import '../../widgets/text_validation.dart';
import '../../widgets/tile_list.dart';
import '../../widgets/title_text_field.dart';
import 'Driver.dart';

class CreateProfile extends StatefulWidget {
  const CreateProfile({super.key});

  @override
  State<CreateProfile> createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> with UserValidation {
  // final firestoreInstance = FirebaseFirestore.instance;

  void back() {
    Navigator.of(context).pop();
  }

  TextEditingController _familynameController = TextEditingController();
  TextEditingController _nameController = TextEditingController();

  bool namevalidate = true;
  bool familynamevalidate = true;

  bool? gender = true;
  bool? staff = false;
  bool? student = true;
  bool? teacher = false;

  String workget() {
    if (staff!)
      return "Staff";
    else if (student!)
      return "Student";
    else
      return "Teatcher";
  }

  String genderget() {
    if (gender!)
      return "Male";
    else
      return "Female";
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var largeur = MediaQuery.of(context).size.width;
    var hauteur = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          //bach ki ytla3 le clavier maysrach overflow
          child: Column(
            children: [
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
                          icon: Transform.scale(
                            scale: 0.75,
                            child: Icons_ESIWay(
                                icon: "arrow_left", largeur: 30, hauteur: 30),
                          ),
                          espaceicontext: 5.0,
                          fct: back),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.2175,
                    ),
                    Center(
                      child: Text(
                        "Create profile",
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
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    SizedBox(
                      height: 14.0,
                    ),

                    Text_Field(
                      hinttext: "Enter your name",
                      validate: namevalidate,
                      title: "Name",
                      error: "Value can't be empty",
                      textfieldcontroller: _nameController,
                      iconName: "user",
                    ),
                    //-----------------------------------------------------------------------
                    SizedBox(
                      height: 10.0,
                    ),
                    Text_Field(
                      hinttext: "Enter your family name",
                      validate: familynamevalidate,
                      title: "Family name",
                      error: "Value can't be empty",
                      textfieldcontroller: _familynameController,
                      iconName: "user",
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TitleTextFeild(title: "Gender"),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Listbox(
                            iconName: "male",
                            scale: 0.6,
                            title: "Male",
                            color: gender == false || gender == null
                                ? null
                                : const Color(0xFF99CFD7),
                            shadow: gender == false || gender == null
                                ? null
                                : const Color(0xFF99CFD7),
                            onPressed: () {
                              setState(() {
                                gender = true;
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Listbox(
                            iconName: "female",
                            scale: 0.6,
                            title: "Female",
                            color: gender == true || gender == null
                                ? null
                                : const Color(0xFF99CFD7),
                            shadow: gender == true || gender == null
                                ? null
                                : const Color(0xFF99CFD7),
                            onPressed: () {
                              setState(() {
                                gender = false;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
//*****************************************************************************/
                    TitleTextFeild(title: "Status "),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Listbox(
                            title: "Teacher",
                            color: teacher == false || teacher == null
                                ? null
                                : const Color(0xFF99CFD7),
                            shadow: teacher == false || teacher == null
                                ? null
                                : const Color(0xFF99CFD7),
                            onPressed: () {
                              setState(() {
                                teacher = true;
                                staff = false;
                                student = false;
                              });
                            },
                            inCenter: true,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Listbox(
                            title: "Student",
                            color: student == false || student == null
                                ? null
                                : const Color(0xFF99CFD7),
                            shadow: student == false || student == null
                                ? null
                                : const Color(0xFF99CFD7),
                            onPressed: () {
                              setState(() {
                                student = true;
                                staff = false;
                                teacher = false;
                              });
                            },
                            inCenter: true,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Listbox(
                            title: "Staff",
                            color: staff == false || staff == null
                                ? null
                                : const Color(0xFF99CFD7),
                            shadow: staff == false || staff == null
                                ? null
                                : const Color(0xFF99CFD7),
                            onPressed: () {
                              setState(() {
                                teacher = false;
                                staff = true;
                                student = false;
                              });
                            },
                            inCenter: true,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.025,
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
                          if (isName(_nameController.text)) {
                            setState(() {
                              namevalidate = true;
                            });
                          } else {
                            setState(() {
                              namevalidate = false;
                            });
                          }
                          if (isName(_familynameController.text)) {
                            setState(() {
                              familynamevalidate = true;
                            });
                          } else {
                            setState(() {
                              familynamevalidate = false;
                            });
                          }

                          if (namevalidate && familynamevalidate) {
                            User? currentuser =
                                FirebaseAuth.instance.currentUser;

                            try {
                              await FirebaseFirestore.instance
                                  .collection("Users")
                                  .doc(currentuser!.uid)
                                  .update({
                                "Gender": genderget(),
                                "Status": workget(),
                                "Name": _nameController.text,
                                "FamilyName": _familynameController.text
                              }).then((value) => Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) {
                                          return Driver();
                                        }),
                                      ));
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
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
                                          "${e.toString()}",
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 12,
                                            fontFamily: "Montserrat",
                                          ),
                                        ),
                                      )));
                              print("Error ${e}");
                            }
                          }
                        })
                  ],
                ),
              ),
              //------------------------------------------------------------------------
            ],
          ),
        ),
      ),
    );
  }
}
