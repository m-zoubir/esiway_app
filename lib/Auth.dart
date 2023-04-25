import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class AuthService {
  final auth = FirebaseAuth.instance;
  /*  Future<void> authAnonym() =>
      auth.signInAnonymously().then((credetial) => null);
 */

  Stream<User?> get userchanged => auth.authStateChanges();

  Future<bool> logIn({required String email, required String password}) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      print(" login");
      return true;
    } on FirebaseException catch (e) {
      print("false login ");
      return false;
    }
  }

  Future<bool> signUp(
      {required String email,
      required String password,
      required String confirmpassword,
      required BuildContext context}) async {
    try {
      if (password == confirmpassword) {
        await auth.createUserWithEmailAndPassword(
            email: email, password: password);
      }
      return true;
    } on FirebaseException catch (e) {
      return false;
    }
  }

  Future<void> logOut() => auth.signOut().then((value) => null);
}
