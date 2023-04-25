import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../widgets/button.dart';
import '../../widgets/constant.dart';
import '../../widgets/text_field.dart';
import '../../widgets/text_validation.dart';
import 'profile_screen.dart';

class Verification extends StatefulWidget {
  const Verification({super.key});

  @override
  State<Verification> createState() => _VerificationState();
}

class _VerificationState extends State<Verification> with UserValidation {
  String verification_picture = "Assets/Images/verification.png";
  @override
  int _currentindex = 3;
  int _selectedindex = 3;

  TextEditingController phonecontroller = TextEditingController();
  TextEditingController emailController = TextEditingController();
  bool phonevalidate = true;
  bool emailvalidate = true;

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Theme.of(context).scaffoldBackgroundColor,
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentindex,
        unselectedIconTheme: IconThemeData(color: bleu_bg),
        selectedIconTheme: IconThemeData(color: vert),
        items: [
          BottomNavigationBarItem(
            label: "",
            icon: Icon(
              Iconsax.home_2,
            ),
          ),
          BottomNavigationBarItem(
            label: "",
            icon: Icon(
              Iconsax.home_2,
            ),
          ),
          BottomNavigationBarItem(
            label: "",
            icon: Icon(
              Iconsax.home_2,
            ),
          ),
          BottomNavigationBarItem(
            label: "",
            icon: Icon(
              Iconsax.user,
            ),
          ),
        ],
        onTap: (index) {
          setState(() {
            _selectedindex = index;
          });
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) {
              return tab[_selectedindex];
            }),
          );
        },
      ),
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Iconsax.back_square,
            color: vert,
          ),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return Profile();
                },
              ),
            );
          },
          color: vert,
        ),
        title: Text(
          "Verification ",
          style: TextStyle(
            color: bleu_bg,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Iconsax.info_circle,
              color: orange,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 175,
                width: 193,
                child: Image.asset(verification_picture),
              ),
              SizedBox(
                height: 25,
              ),
              Text_Field(
                type: TextInputType.phone,
                hinttext: "hinttext",
                validate: phonevalidate,
                title: "Phone Number",
                bottomheigh: 8,
                textfieldcontroller: phonecontroller,
                subtitle: "A verified phone number is obligatory",
                error: "Not a phone number",
              ),
              Container(
                //margin: EdgeInsets.symmetric(horizontal: 3),
                height: 35,
                width: double.infinity,
                child: Button(
                  color: orange,
                  onPressed: () {
                    if (isPhone(phonecontroller.text) == true) {
                      setState(() {
                        phonevalidate = true;
                      });

                      print(phonecontroller.text);
                    } else {
                      setState(() {
                        phonevalidate = false;
                      });
                    }
                  },
                  title: "Get OTP",
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Text_Field(
                type: TextInputType.emailAddress,
                hinttext: "hinttext",
                validate: emailvalidate,
                title: "Email",
                textfieldcontroller: emailController,
                bottomheigh: 8,
                error: "Not esi mail",
              ),
              Container(
                //margin: EdgeInsets.symmetric(horizontal: 3),
                height: 35,
                width: double.infinity,
                child: Button(
                  color: orange,
                  onPressed: () {
                    if (isEmail(emailController.text) == false) {
                      setState(() {
                        emailvalidate = false;
                      });
                    } else {
                      setState(() {
                        emailvalidate = true;
                      });
                      print(emailController.text);
                    }
                  },
                  title: "Verify your email",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
