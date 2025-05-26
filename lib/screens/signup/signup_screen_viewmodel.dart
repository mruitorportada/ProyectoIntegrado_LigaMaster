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

  void sendVerificationEmail(BuildContext context) {
    FirebaseAuth.instance.currentUser?.sendEmailVerification();
    Fluttertoast.showToast(
      msg: "Se ha enviado un email de verifiación",
      backgroundColor: Theme.of(context).primaryColor,
      textColor: LightThemeAppColors.textColor,
    );
  }
}
