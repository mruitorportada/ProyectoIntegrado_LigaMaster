import 'dart:async';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:liga_master/models/appstrings/appstrings.dart';
import 'package:liga_master/screens/generic/appcolors.dart';
import 'package:liga_master/screens/generic/functions.dart';

class AuthService {
  User? user;

  Future<void> init() async {
    FirebaseAuth.instance.authStateChanges().listen((User? currUser) {
      user = currUser;
    });
  }

  Future<UserCredential> login(String email, String password) async =>
      FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

  Future<UserCredential> register(String email, String password) async {
    return FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<void> resetPasswordOfAccount(
      {required String email,
      required AppStrings strings,
      required Color toastColor}) async {
    final instance = FirebaseAuth.instance;
    try {
      await instance.sendPasswordResetEmail(email: email);
      Fluttertoast.showToast(
        msg: strings.resetPasswordEmail,
        backgroundColor: toastColor,
        textColor: LightThemeAppColors.textColor,
      );
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(
          msg: getErrorMessage(strings, e.code),
          backgroundColor: toastColor,
          textColor: LightThemeAppColors.textColor,
          toastLength: Toast.LENGTH_LONG);
    }
  }
}
