import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:liga_master/models/user/app_user.dart';
import 'package:liga_master/screens/boot/boot_screen.dart';
import 'package:liga_master/screens/generic/appcolors.dart';
import 'package:liga_master/screens/generic/functions.dart';
import 'package:liga_master/screens/login/login_screen_viewmodel.dart';
import 'package:liga_master/screens/signup/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final Color _backgroundColor = LightThemeAppColors.background;
  bool _applyObscureText = true;
  final LoginScreenViewmodel loginScreenViewmodel = LoginScreenViewmodel();
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: _body,
    );
  }

  Widget get _body => Container(
        alignment: Alignment.center,
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Image(
                    image: AssetImage("assets/ligaMaster_logo.png"),
                  ),
                ),
                TextField(
                    controller: _emailController,
                    style: const TextStyle(color: Colors.white),
                    decoration: getLoginRegisterInputDecoration(
                        "Email", Icons.email, () {})),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: _passwordController,
                  style: const TextStyle(color: Colors.white),
                  decoration: getLoginRegisterInputDecoration(
                      "Contraseña", Icons.remove_red_eye, () {
                    setState(() {
                      _applyObscureText = !_applyObscureText;
                    });
                  }),
                  obscureText: _applyObscureText,
                ),
                SizedBox(
                  height: 40,
                ),
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: onLoginPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: LightThemeAppColors.buttonColor,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        "Iniciar sesión",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => SignupScreen())),
                      child: Text(
                        "¿No tienes una cuenta? Toca aqui para crear una",
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(color: LightThemeAppColors.buttonColor),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                if (errorMessage != null) ...{
                  SizedBox(height: 30),
                  Text(
                    errorMessage!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 16,
                    ),
                  )
                },
              ],
            ),
          ),
        ),
      );

  void onLoginPressed() async {
    FocusManager.instance.primaryFocus?.unfocus();
    try {
      AppUser? user = await loginScreenViewmodel.onLogin(
          context, _emailController.text, _passwordController.text);

      if (user != null) {
        _emailController.text = "";
        _passwordController.text = "";
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BootScreen(),
            ),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = getErrorMessage(e.code);
      });
    }
  }

  String getErrorMessage(String errorcode) {
    return switch (errorcode) {
      "invalid-email" => "El email no existe",
      "user-disabled" => "El usuario está desabilitado",
      "user-not-found" => "El usuario no existe",
      "wrong-password" => "Contraseña incorrecta",
      "too-many-requests" => "Demasiadas peticiones",
      "user-token-expired" => "El token del usuario ha expirado",
      "network-request-failed" => "La petición de la red falló",
      "invalid-credential" => "Credenciales inválidos",
      "operation-not-allowed" => "Operación no permitida",
      _ => "Error en el login"
    };
  }
}
