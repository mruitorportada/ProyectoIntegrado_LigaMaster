import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:liga_master/models/user/app_user.dart';
import 'package:liga_master/screens/generic/appcolors.dart';
import 'package:liga_master/services/appuser_service.dart';
import 'package:liga_master/services/auth_service.dart';
import 'package:provider/provider.dart';

class LoginScreenViewmodel {
  Future<AppUser?> onLogin(
      BuildContext context, String email, String password) async {
    AuthService auth = Provider.of<AuthService>(context, listen: false);
    UserCredential userCredential = await auth.login(email, password);

    String uid = userCredential.user!.uid;

    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();

    if (!snapshot.exists) return null;

    return AppUser.fromMap(snapshot.data() as Map<String, dynamic>);
  }

  Future<AppUser?> loadAppUserFromFirestore(String id) async {
    final document =
        await FirebaseFirestore.instance.collection("users").doc(id).get();

    if (!document.exists || document.data() == null) return null;

    return AppUser.fromMap(
      document.data()!,
    );
  }

  Future<void> sendPasswordResetEmail(
      BuildContext context, String email) async {
    var authService = Provider.of<AuthService>(context, listen: false);
    var userService = Provider.of<AppUserService>(context, listen: false);
    bool emailFound = await userService.checkEmailExistsInDatabase(email);
    if (emailFound) {
      authService.resetPasswordOfAccount(email);
    } else {
      Fluttertoast.showToast(
          msg: "No se ha encontrado una cuenta asociada a ese email",
          backgroundColor: LightThemeAppColors.primaryColor,
          textColor: LightThemeAppColors.textColor,
          toastLength: Toast.LENGTH_LONG);
    }
  }
}
