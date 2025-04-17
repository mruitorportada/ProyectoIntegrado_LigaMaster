import 'package:flutter/material.dart';
import 'package:liga_master/models/user/app_user.dart';
import 'package:liga_master/screens/boot/boot_screen.dart';
import 'package:liga_master/screens/home/home_screen_viewmodel.dart';
import 'package:liga_master/screens/login/login_screen_viewmodel.dart';
import 'package:liga_master/screens/signup/signup_screen_viewmodel.dart';
import 'package:liga_master/services/appuser_service.dart';
import 'package:liga_master/services/auth_service.dart';
import 'package:liga_master/services/competition_service.dart';
import 'package:liga_master/services/player_service.dart';
import 'package:liga_master/services/team_service.dart';
import 'package:provider/provider.dart';

class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        InheritedProvider(
          create: (context) => HomeScreenViewmodel(
            AppUser(id: ""),
          ),
        ),
        InheritedProvider(
          create: (context) => AuthService(),
        ),
        InheritedProvider(
          create: (context) => CompetitionService(),
        ),
        InheritedProvider(
          create: (context) => TeamService(),
        ),
        InheritedProvider(
          create: (context) => PlayerService(),
        ),
        InheritedProvider(
          create: (context) => AppUserService(),
        ),
        InheritedProvider(
          create: (context) => LoginScreenViewmodel(),
        ),
        InheritedProvider(
          create: (context) => SignupScreenViewmodel(),
        )
      ],
      child: MaterialApp(
        title: "Liga Master",
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: BootScreen(),
      ),
    );
  }
}
