import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:liga_master/models/appstrings/appstrings_controller.dart';
import 'package:liga_master/screens/generic/appcolors.dart';
import 'package:liga_master/screens/signup/signup_screen_viewmodel.dart';
import 'package:provider/provider.dart';

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
    viewmodel.sendVerificationEmail(context);
    _timer = Timer.periodic(
        const Duration(seconds: 3),
        (_) async =>
            _checkEmailIsVerifed(toastColor: Theme.of(context).primaryColor));
  }

  void _checkEmailIsVerifed({required Color toastColor}) async {
    final controller =
        Provider.of<AppStringsController>(context, listen: false);
    final strings = controller.strings!;

    await _instance.currentUser?.reload();

    setState(
      () {
        _emailVerified = _instance.currentUser!.emailVerified;
      },
    );

    if (_emailVerified) {
      Fluttertoast.showToast(
        msg: strings.emailVerifiedText,
        backgroundColor: toastColor,
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
    final controller =
        Provider.of<AppStringsController>(context, listen: false);
    final strings = controller.strings!;

    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
              Text(
                strings.emailVerificationText,
                style: TextStyle(
                  color: LightThemeAppColors.textColor,
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  viewmodel.sendVerificationEmail(context);
                  if (_emailVerified && context.mounted) {
                    Navigator.of(context).pop(true);
                  }
                },
                child: Text(
                  strings.resendButtonText,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
