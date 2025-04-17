import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:liga_master/models/user/app_user.dart';
import 'package:liga_master/screens/boot/boot_screen.dart';
import 'package:liga_master/screens/login/login_screen_viewmodel.dart';
import 'package:liga_master/screens/signup/signup_screen.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String title = "Login";
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body,
    );
  }

  Widget get _body => Container(
        alignment: Alignment.center,
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Text(
                  title,
                  style: TextStyle(fontSize: 50),
                ),
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
                  labelText: "Password",
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
                    onPressed: onLoginPressed,
                    child: Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => SignupScreen())),
                    child:
                        Text("¿No tienes una cuenta? Toca aqui para crear una"),
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

  void onLoginPressed() async {
    LoginScreenViewmodel loginViewmodel =
        Provider.of<LoginScreenViewmodel>(context, listen: false);
    try {
      AppUser? user = await loginViewmodel.onLogin(
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
