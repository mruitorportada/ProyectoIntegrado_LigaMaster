import 'package:firebase_auth/firebase_auth.dart';

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

  Future<UserCredential> register(String email, String password) async =>
      FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
}

  void _checkEmailIsVerifed(Timer? timer) async {
    final instance = FirebaseAuth.instance;
    await instance.currentUser?.reload();

    if (instance.currentUser!.emailVerified) {
      Fluttertoast.showToast(
        msg: "Email verificado",
        backgroundColor: LightThemeAppColors.background,
        textColor: LightThemeAppColors.textColor,
      );
      timer?.cancel();
    }
  }

  Future<void> resetPasswordOfAccount(String email) async {
    final instance = FirebaseAuth.instance;
    try {
      await instance.sendPasswordResetEmail(email: email);
      Fluttertoast.showToast(
        msg: "Email enviado",
        backgroundColor: LightThemeAppColors.background,
        textColor: LightThemeAppColors.textColor,
      );
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(
          msg: getErrorMessage(e.code),
          backgroundColor: LightThemeAppColors.background,
          textColor: LightThemeAppColors.error,
          toastLength: Toast.LENGTH_LONG);
    }
  }
}
