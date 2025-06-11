import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:liga_master/models/user/app_user.dart';
import 'package:liga_master/screens/generic/appcolors.dart';

class AppUserService {
  Future<AppUser?> loadAppUserFromFirestore(String id) async {
    final document =
        await FirebaseFirestore.instance.collection("users").doc(id).get();

    if (!document.exists || document.data() == null) return null;

    return AppUser.fromMap(document.data()!);
  }

  Future<void> saveUserToFirestore(AppUser user) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user.id)
        .set(user.toMap());
  }

  Future<void> updateUserToFirestore(AppUser user) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user.id)
        .update(user.toMap());
  }

  Future<bool> checkUsernameIsAlreadyTaken(String username,
      {required String usernameErrorMessage, required Color toastColor}) async {
    CollectionReference<Map<String, dynamic>> collection =
        FirebaseFirestore.instance.collection("users");
    var query =
        await collection.where("username", isEqualTo: username).limit(1).get();

    if (query.docs.isNotEmpty) {
      Fluttertoast.showToast(
        msg: usernameErrorMessage,
        textColor: LightThemeAppColors.textColor,
        backgroundColor: toastColor,
        toastLength: Toast.LENGTH_LONG,
      );
      return true;
    }
    return false;
  }

  Future<bool> checkEmailExistsInDatabase(String email) async {
    CollectionReference<Map<String, dynamic>> collection =
        FirebaseFirestore.instance.collection("users");
    var query =
        await collection.where("email", isEqualTo: email).limit(1).get();

    return query.docs.isNotEmpty;
  }
}
