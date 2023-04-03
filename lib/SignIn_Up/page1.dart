import 'package:flutter/material.dart';

import 'Services/Auth.dart';


class PageOne extends StatelessWidget {
  const PageOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: ElevatedButton(
            onPressed: () async {
              await AuthService().logOut();
            },
            child: Text(AuthService().auth.currentUser!.email!)),
      ),
    );
  }
}
