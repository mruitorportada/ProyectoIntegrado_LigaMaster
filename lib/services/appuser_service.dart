import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:liga_master/models/user/app_user.dart';

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
}
