import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:liga_master/services/auth_service.dart';
import 'package:provider/provider.dart';

class SignupScreenViewmodel {
  Future<UserCredential> onRegister(
      BuildContext context, String email, String password) {
    AuthService auth = Provider.of<AuthService>(context, listen: false);
    return auth.register(email, password);
  }
}
