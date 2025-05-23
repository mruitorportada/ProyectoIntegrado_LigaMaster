import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:liga_master/screens/generic/appcolors.dart';
import 'package:liga_master/screens/signup/signup_screen_viewmodel.dart';

class EmailVerificationScreen extends StatefulWidget {
  final SignupScreenViewmodel viewmodel;

  const EmailVerificationScreen({super.key, required this.viewmodel});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  SignupScreenViewmodel get viewmodel => widget.viewmodel;
  bool _emailVerified = false;
  Timer? _timer;
  final _instance = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    viewmodel.sendVerificationEmail();
    _timer = Timer.periodic(
        const Duration(seconds: 3), (_) async => _checkEmailIsVerifed());
  }

  void _checkEmailIsVerifed() async {
    await _instance.currentUser?.reload();

    setState(
      () {
        _emailVerified = _instance.currentUser!.emailVerified;
      },
    );

    if (_emailVerified) {
      Fluttertoast.showToast(
        msg: "Email verificado",
        backgroundColor: LightThemeAppColors.primaryColor,
        textColor: LightThemeAppColors.textColor,
      );
      _timer?.cancel();
      if (mounted) Navigator.of(context).pop(true);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              CircularProgressIndicator(
                color: LightThemeAppColors.primaryColor,
              ),
              Text(
                "Verificando email...",
                style: TextStyle(
                  color: LightThemeAppColors.textColor,
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  viewmodel.sendVerificationEmail();
                  if (_emailVerified && context.mounted) {
                    Navigator.of(context).pop(true);
                  }
                },
                child: Text(
                  "Volver a envíar",
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
