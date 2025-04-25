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
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                  "Registro",
                  style: TextStyle(fontSize: 50),
                ),
              ),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "Nombre",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: _surnameController,
                decoration: InputDecoration(
                  labelText: "Apellidos",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: "Nombre de usuario",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: "Contraseña",
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(
                height: 40,
              ),
              Column(
                children: [
                  ElevatedButton(
                    onPressed: onCreateAccountPressed,
                    child: Text(
                      "Registrar",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => LoginScreen())),
                    child: Text(
                        "¿Ya tienes una cuenta? Toca aqui para iniciar sesión"),
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
                    color: Colors.red,
                    fontSize: 16,
                  ),
                )
              },
            ],
          ),
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
