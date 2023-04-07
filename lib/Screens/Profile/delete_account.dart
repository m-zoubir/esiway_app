import 'package:esiway/shared/button.dart';
import 'package:flutter/material.dart';
import '../../SignIn_Up/widgets/password_field.dart';
import '../../shared/constant.dart';
import 'forgot_password_mailadress.dart';

class DeleteAccount extends StatefulWidget {
  const DeleteAccount({Key? key}) : super(key: key);

  @override
  State<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  TextEditingController currentpassword = TextEditingController();

  bool currentpasswordvalidate = true;

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
          "Delete my account",
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
                "Your profile and account details will be deleted.",
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
                bottomheigh: 0,
                title: "Password",
                validate: currentpasswordvalidate,
                error: "Password incorrect",
                hinttext: 'Enter your password',
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
                height: 30,
              ),
              Button(
                  color: orange, title: "Delete my account", onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
