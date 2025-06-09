import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:liga_master/models/appstrings/appstrings_controller.dart';
import 'package:liga_master/models/user/app_user.dart';
import 'package:liga_master/screens/generic/appcolors.dart';
import 'package:liga_master/screens/generic/functions.dart';
import 'package:liga_master/screens/login/login_screen.dart';
import 'package:liga_master/screens/signup/email_verification_screen.dart';
import 'package:liga_master/screens/signup/signup_screen_viewmodel.dart';
import 'package:liga_master/services/appuser_service.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final SignupScreenViewmodel signupScreenViewmodel = SignupScreenViewmodel();

  bool _applyObscureText = true;
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _body,
      ),
    );
  }

  Widget get _body {
    final controller =
        Provider.of<AppStringsController>(context, listen: false);
    final strings = controller.strings!;

    return Container(
      padding: EdgeInsets.all(20),
      alignment: Alignment.center,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Text(
                strings.homeScreenTitle,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 50,
                  color: LightThemeAppColors.registerTitleColor,
                ),
              ),
            ),
            TextField(
              controller: _nameController,
              style: const TextStyle(color: Colors.white),
              decoration: getLoginRegisterInputDecoration(
                  context, strings.nameLabel, Icons.person, () {}),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: _surnameController,
              style: const TextStyle(color: Colors.white),
              decoration: getLoginRegisterInputDecoration(
                  context, strings.surnameLabel, Icons.person, () {}),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: _usernameController,
              style: const TextStyle(color: Colors.white),
              decoration: getLoginRegisterInputDecoration(
                  context,
                  strings.usernameLabel,
                  Icons.person_pin_circle_rounded,
                  () {}),
            ),
            SizedBox(
              height: 20,
            ),
            AutofillGroup(
              child: Column(
                children: [
                  TextField(
                      autofillHints: [AutofillHints.email],
                      controller: _emailController,
                      style: const TextStyle(color: Colors.white),
                      decoration: getLoginRegisterInputDecoration(
                          context, strings.emailLabel, Icons.email, () {})),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    autofillHints: [
                      AutofillHints.newPassword,
                      AutofillHints.password
                    ],
                    controller: _passwordController,
                    style: const TextStyle(color: Colors.white),
                    decoration: getLoginRegisterInputDecoration(
                        context, strings.passwordLabel, Icons.remove_red_eye,
                        () {
                      setState(() {
                        _applyObscureText = !_applyObscureText;
                      });
                    }),
                    obscureText: _applyObscureText,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Column(
              children: [
                ElevatedButton(
                  onPressed: onCreateAccountPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).dividerColor,
                    foregroundColor: LightThemeAppColors.textColor,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    strings.registerButton,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => LoginScreen())),
                  child: Text(
                    strings.registerText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).dividerColor,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            if (errorMessage != null) ...{
              SizedBox(height: 30),
              Text(
                errorMessage!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: LightThemeAppColors.error,
                  fontSize: 16,
                ),
              )
            },
          ],
        ),
      ),
    );
  }

  void onCreateAccountPressed() async {
    final controller =
        Provider.of<AppStringsController>(context, listen: false);
    final strings = controller.strings!;

    FocusManager.instance.primaryFocus?.unfocus();
    AppUserService userService =
        Provider.of<AppUserService>(context, listen: false);
    try {
      if (_nameController.text.isEmpty ||
          _surnameController.text.isEmpty ||
          _usernameController.text.isEmpty ||
          _emailController.text.isEmpty ||
          _passwordController.text.isEmpty) {
        setState(() => errorMessage = strings.allFieldsRequiredText);
        return;
      }
      if (!validatePassword()) {
        setState(() => errorMessage = strings.passwordFormatErrorText);
        return;
      }

      bool usernameTaken = await userService.checkUsernameIsAlreadyTaken(
          _usernameController.text,
          toastColor: Theme.of(context).primaryColor);
      if (usernameTaken) return;

      if (mounted) {
        UserCredential user = await signupScreenViewmodel.onRegister(
            context, _emailController.text, _passwordController.text);
        AppUser userData = AppUser(
          id: user.user!.uid,
          name: _nameController.text,
          surname: _surnameController.text,
          username: _usernameController.text,
          email: user.user!.email!,
        );

        await userService.saveUserToFirestore(userData);

        if (FirebaseAuth.instance.currentUser != null) {
          if (mounted) {
            bool? verified = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => EmailVerificationScreen(
                  viewmodel: signupScreenViewmodel,
                ),
              ),
            );

            if (verified ?? false) {
              if (mounted) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                );
              }
            }
          }
        }
        _nameController.text = "";
        _surnameController.text = "";
        _usernameController.text = "";
        _emailController.text = "";
        _passwordController.text = "";
        errorMessage = "";
        TextInput.finishAutofillContext();
      }
    } on FirebaseAuthException catch (e) {
      setState(
        () {
          errorMessage = getErrorMessage(strings, e.code);
        },
      );
    }
  }

  bool validatePassword() {
    final regex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$');
    return regex.hasMatch(_passwordController.value.text);
  }
}
