import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:liga_master/models/user/app_user.dart';
import 'package:liga_master/screens/generic/appcolors.dart';
import 'package:liga_master/screens/generic/functions.dart';
import 'package:liga_master/screens/login/login_screen.dart';
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

  final Color _backgroundColor = LightThemeAppColors.background;
  bool _applyObscureText = true;
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: _backgroundColor,
        body: _body,
      ),
    );
  }

  Widget get _body => Container(
        padding: EdgeInsets.all(20),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Text(
                  "Liga Master",
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
                    "Nombre", Icons.person, () {}),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: _surnameController,
                style: const TextStyle(color: Colors.white),
                decoration: getLoginRegisterInputDecoration(
                    "Apellidos", Icons.person, () {}),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: _usernameController,
                style: const TextStyle(color: Colors.white),
                decoration: getLoginRegisterInputDecoration("Nombre de usuario",
                    Icons.person_pin_circle_rounded, () {}),
              ),
              SizedBox(
                height: 20,
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
                    onPressed: onCreateAccountPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: LightThemeAppColors.buttonColor,
                      foregroundColor: LightThemeAppColors.textColor,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Registrar",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => LoginScreen())),
                    child: Text(
                      "¿Ya tienes una cuenta? Toca aqui para iniciar sesión",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: LightThemeAppColors.buttonColor),
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
                    color: Colors.redAccent,
                    fontSize: 16,
                  ),
                )
              },
            ],
          ),
        ),
      );

  void onCreateAccountPressed() async {
    FocusManager.instance.primaryFocus?.unfocus();
    AppUserService userService =
        Provider.of<AppUserService>(context, listen: false);
    try {
      if (_nameController.text.isEmpty ||
          _surnameController.text.isEmpty ||
          _usernameController.text.isEmpty ||
          _emailController.text.isEmpty ||
          _passwordController.text.isEmpty) {
        setState(() => errorMessage = "Todos los campos son obligatorios");
        return;
      }
      if (!validatePassword()) {
        setState(() => errorMessage =
            "La contraseña debe de tener mínimo 8 caracteres e incluir una letra mayúscula y minúscula y un número.");
        return;
      }
      UserCredential user = await signupScreenViewmodel.onRegister(
          context, _emailController.text, _passwordController.text);

      AppUser userData = AppUser(
        id: user.user!.uid,
        name: _nameController.text,
        surname: _surnameController.text,
        username: _usernameController.text,
        email: user.user!.email!,
      );
      userService.saveUserToFirestore(userData).then((_) => {
            if (mounted)
              {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                ),
              }
          });
      _nameController.text = "";
      _surnameController.text = "";
      _usernameController.text = "";
      _emailController.text = "";
      _passwordController.text = "";
      errorMessage = "";
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = getErrorMessage(e.code);
      });
    }
  }

  String getErrorMessage(String errorcode) {
    return switch (errorcode) {
      "email-already-in-use" => "Ya existe una cuenta con ese email",
      "invalid-email" => "El email no existe",
      "user-disabled" => "El usuario está desabilitado",
      "user-not-found" => "El usuario no existe",
      "wrong-password" => "Contraseña incorrecta",
      "too-many-requests" => "Demasiadas peticiones",
      "user-token-expired" => "El token del usuario ha expirado",
      "network-request-failed" => "La petición de la red falló",
      "invalid-credential" => "Credenciales inválidos",
      "operation-not-allowed" => "Operación no permitida",
      _ => "Error en el registro"
    };
  }

  bool validatePassword() {
    final regex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$');
    return regex.hasMatch(_passwordController.value.text);
  }
}
