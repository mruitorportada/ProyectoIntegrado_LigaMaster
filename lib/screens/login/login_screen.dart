import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:liga_master/models/appstrings/appstrings.dart';
import 'package:liga_master/models/appstrings/appstrings_controller.dart';
import 'package:liga_master/models/user/app_user.dart';
import 'package:liga_master/screens/boot/boot_screen.dart';
import 'package:liga_master/screens/generic/appcolors.dart';
import 'package:liga_master/screens/generic/functions.dart';
import 'package:liga_master/screens/generic/generic_widgets/generic_textbutton.dart';
import 'package:liga_master/screens/login/login_screen_viewmodel.dart';
import 'package:liga_master/screens/signup/email_verification_screen.dart';
import 'package:liga_master/screens/signup/signup_screen.dart';
import 'package:liga_master/screens/signup/signup_screen_viewmodel.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _applyObscureText = true;
  final LoginScreenViewmodel loginScreenViewmodel = LoginScreenViewmodel();
  String? errorMessage;

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Scaffold(
          body: _body,
        ),
      );

  Widget get _body {
    final controller = Provider.of<AppStringsController>(context);
    if (controller.isLoading) {
      return PopScope(
        canPop: false,
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }
    final strings = controller.strings!;

    return PopScope(
      canPop: false,
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _logoSection(),
                AutofillGroup(
                  child: Column(
                    children: [
                      _emailTextSection(strings),
                      SizedBox(
                        height: 20,
                      ),
                      _passwordTextSection(strings),
                    ],
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                _buttonsSection(strings),
                SizedBox(
                  height: 40,
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
        ),
      ),
    );
  }

  Widget _logoSection() => Container(
        padding: EdgeInsets.symmetric(vertical: 15),
        child: Image(
          image: AssetImage("assets/ligaMaster_logo.png"),
        ),
      );

  Widget _emailTextSection(AppStrings strings) => TextField(
        autofillHints: [AutofillHints.email],
        controller: _emailController,
        style: const TextStyle(color: Colors.white),
        decoration: getLoginRegisterInputDecoration(
            context, strings.emailLabel, Icons.email, () {}),
        keyboardType: TextInputType.visiblePassword,
      );

  Widget _passwordTextSection(AppStrings strings) => TextField(
        autofillHints: [AutofillHints.password],
        controller: _passwordController,
        style: const TextStyle(color: Colors.white),
        decoration: getLoginRegisterInputDecoration(
          context,
          strings.passwordLabel,
          Icons.remove_red_eye,
          () {
            setState(
              () {
                _applyObscureText = !_applyObscureText;
              },
            );
          },
        ),
        keyboardType: TextInputType.visiblePassword,
        obscureText: _applyObscureText,
      );

  Widget _buttonsSection(AppStrings strings) => Column(
        children: [
          ElevatedButton(
            onPressed: () => _onLoginPressed(strings),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              strings.loginButton,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          genericTextButton(
            context,
            onPressed: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => SignupScreen())),
            text: strings.loginText,
          ),
          genericTextButton(
            context,
            onPressed: () {
              _showEmailDialog(strings);
            },
            text: strings.resetPasswordText,
          )
        ],
      );

  void _showEmailDialog(AppStrings strings) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            strings.resetPasswordText,
            style: TextStyle(
              color: LightThemeAppColors.textColor,
            ),
          ),
          content: TextField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: strings.emailLabel,
              filled: false,
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
            keyboardType: TextInputType.visiblePassword,
          ),
          actions: [
            TextButton(
              onPressed: () => _onResetPasswordPressed(),
              child: Text(strings.acceptDialogButtonText),
            ),
          ],
        ),
      );

  void _onLoginPressed(AppStrings strings) async {
    FocusManager.instance.primaryFocus?.unfocus();

    try {
      AppUser? user = await loginScreenViewmodel.onLogin(
          context, _emailController.text, _passwordController.text);

      if (user != null) {
        _emailController.text = "";
        _passwordController.text = "";
        if (mounted) {
          if (user.id == "-1") {
            bool? verified = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => EmailVerificationScreen(
                  viewmodel: SignupScreenViewmodel(),
                ),
              ),
            );
            if (verified ?? false) {
              if (mounted) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => BootScreen(),
                  ),
                );
              }
            }
          } else {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => BootScreen(),
              ),
            );
          }
        }
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

  void _onResetPasswordPressed() {
    FocusManager.instance.primaryFocus?.unfocus();
    loginScreenViewmodel.sendPasswordResetEmail(
        context, _emailController.value.text,
        toastColor: Theme.of(context).primaryColor);
    Navigator.of(context).pop();
  }
}
