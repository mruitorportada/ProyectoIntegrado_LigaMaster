import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:liga_master/screens/generic/appcolors.dart';
import 'package:liga_master/services/auth_service.dart';
import 'package:provider/provider.dart';

class SignupScreenViewmodel {
  Future<UserCredential> onRegister(
      BuildContext context, String email, String password) async {
    AuthService auth = Provider.of<AuthService>(context, listen: false);
    return auth.register(email, password);
  }

  Future<bool> checkEmailIsVerifed() async {
    final instance = FirebaseAuth.instance;
    bool emailVerified = instance.currentUser!.emailVerified;
    Timer? timer;

    timer = Timer.periodic(
      const Duration(seconds: 3),
      (_) async {
        await instance.currentUser?.reload();

        if (emailVerified) {
          Fluttertoast.showToast(
            msg: "Email verificado",
            backgroundColor: LightThemeAppColors.primaryColor,
            textColor: LightThemeAppColors.textColor,
          );
          timer?.cancel();
          emailVerified = true;
        }
      },
    );

    return emailVerified;
  }

  void sendVerificationEmail() {
    FirebaseAuth.instance.currentUser?.sendEmailVerification();
    Fluttertoast.showToast(
      msg: "Se ha enviado un email de verifiación",
      backgroundColor: LightThemeAppColors.primaryColor,
      textColor: LightThemeAppColors.textColor,
    );
  }
}
