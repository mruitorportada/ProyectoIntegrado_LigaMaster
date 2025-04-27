import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:liga_master/models/user/app_user.dart';
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
  final Color _backgroundColor = Color.fromARGB(255, 58, 17, 100);
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
                    color: Color.fromARGB(255, 255, 102, 0),
                  ),
                ),
              ),
              TextField(
                controller: _nameController,
                style: const TextStyle(color: Colors.white),
                decoration: _getInputDecoration("Nombre", Icons.person, () {}),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: _surnameController,
                style: const TextStyle(color: Colors.white),
                decoration:
                    _getInputDecoration("Apellidos", Icons.person, () {}),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: _usernameController,
                style: const TextStyle(color: Colors.white),
                decoration: _getInputDecoration("Nombre de usuario",
                    Icons.person_pin_circle_rounded, () {}),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                  controller: _emailController,
                  style: const TextStyle(color: Colors.white),
                  decoration: _getInputDecoration("Email", Icons.email, () {})),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: _passwordController,
                style: const TextStyle(color: Colors.white),
                decoration:
                    _getInputDecoration("Contraseña", Icons.remove_red_eye, () {
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
                      backgroundColor:
                          const Color.fromARGB(255, 0, 204, 204), // Turquesa
                      foregroundColor: Colors.white,
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
                      style: TextStyle(color: Color.fromARGB(255, 255, 102, 0)),
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

  InputDecoration _getInputDecoration(
          String label, IconData suffixIcon, void Function() onIconTap) =>
      InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white54),
          borderRadius: BorderRadius.circular(12),
        ),
        suffixIcon: IconButton(
          onPressed: onIconTap,
          icon: Icon(
            suffixIcon,
            color: Colors.white,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color.fromARGB(255, 0, 204, 204)),
          borderRadius: BorderRadius.circular(12),
        ),
      );

  void onCreateAccountPressed() async {
    SignupScreenViewmodel signUpViewmodel =
        Provider.of<SignupScreenViewmodel>(context, listen: false);
    AppUserService userService =
        Provider.of<AppUserService>(context, listen: false);
    try {
      if (_nameController.text.isEmpty ||
          _surnameController.text.isEmpty ||
          _usernameController.text.isEmpty ||
          _emailController.text.isEmpty ||
          _passwordController.text.isEmpty) {
        errorMessage = "Todos los campos son obligatorios";
        return;
      }
      UserCredential user = await signUpViewmodel.onRegister(
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
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = getErrorMessage(e.code);
      });
    }
  }

  String getErrorMessage(String errorcode) {
    return switch (errorcode) {
      "invalid-email" => "El email es inválido",
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
