import 'package:flutter/material.dart';
import 'package:liga_master/models/user/app_user.dart';
import 'package:liga_master/screens/generic/appcolors.dart';
import 'package:liga_master/screens/home/home_screen.dart';
import 'package:liga_master/screens/login/login_screen.dart';
import 'package:liga_master/services/appuser_service.dart';
import 'package:liga_master/services/auth_service.dart';
import 'package:provider/provider.dart';

class BootScreen extends StatefulWidget {
  const BootScreen({super.key});

  @override
  State<BootScreen> createState() => _BootScreenState();
}

class _BootScreenState extends State<BootScreen> {
  late AuthService auth;
  final Color _backgroundColor = LightThemeAppColors.background;
  late AppUser? _user;

  Future<void> boot() async {
    auth = Provider.of<AuthService>(context, listen: false);
    await auth.init();
  }

  Future<void> setHomeScreenViewModelUser() async {
    AppUserService userService =
        Provider.of<AppUserService>(context, listen: false);

    _user = await userService.loadAppUserFromFirestore(auth.user!.uid);
  }

  @override
  void initState() {
    var navigator = Navigator.of(context);
    boot().then(
      (_) => {
        if (auth.user != null)
          {
            setHomeScreenViewModelUser().then(
              (_) => navigator.pushReplacement(
                MaterialPageRoute(
                  builder: (context) => _user != null
                      ? HomeScreen(
                          user: _user!,
                        )
                      : LoginScreen(),
                ),
              ),
            ),
          }
        else
          {
            navigator.pushReplacement(
              MaterialPageRoute(
                builder: (context) => LoginScreen(),
              ),
            )
          }
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(
          color: _backgroundColor,
          alignment: Alignment.center,
          child: Image(
            image: AssetImage("assets/ligaMaster_logo.png"),
          ),
        ),
      );
}
