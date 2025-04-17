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
