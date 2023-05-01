import 'package:esiway/Screens/Profile/profile_screen.dart';
import 'package:esiway/Screens/SignIn_Up/registration_page.dart';
import 'package:esiway/Screens/home/home_page.dart';
import 'package:esiway/Screens/home/test.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Auth extends StatelessWidget {
  const Auth({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return HomePage();
          } else {
            return RegistrationPage();
          }
        },
      ),
    );
  }
}
