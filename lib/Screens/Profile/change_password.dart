import 'package:esiway/shared/button.dart';
import 'package:esiway/shared/text_field.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../SignIn_Up/widgets/password_field.dart';
import '../../shared/constant.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController currentpassword = TextEditingController();
  TextEditingController newpassword = TextEditingController();
  TextEditingController confirmpassword = TextEditingController();

  bool currentpasswordvalidate = true;
  bool newpassordvalidate = true;
  bool confirmpasswordvalidate = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color3,
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: vert,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          color: vert,
        ),
        title: Text(
          "Change password",
          style: TextStyle(
            color: bleu_bg,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
          child: Column(
            children: [
              Text(
                "Create a password with at least 6 letters and \nshould include numbers. You will need this \npassword to log into your account ",
                style: TextStyle(
                  color: bleu_bg,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w400,
                  fontSize: 13,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              MyPasswordField(
                controller: currentpassword,
                bottomheigh: 14,
                title: "Current password",
                validate: currentpasswordvalidate,
                error: "Password incorrect",
                hinttext: "Current password",
              ),
              MyPasswordField(
                controller: newpassword,
                bottomheigh: 14,
                title: "New password",
                error: "At least 6 characters",
                validate: newpassordvalidate,
                hinttext: "New password",
              ),
              MyPasswordField(
                controller: confirmpassword,
                bottomheigh: 14,
                title: "New password Confirmation",
                error: "Re-confirm your password",
                hinttext: "Re-type new  password",
                validate: confirmpasswordvalidate,
              ),
              SizedBox(
                height: 30,
              ),
              Button(color: orange, title: "Confirm", onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
