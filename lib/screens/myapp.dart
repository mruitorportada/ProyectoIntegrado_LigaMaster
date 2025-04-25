import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
        Provider<FirebaseFirestore>.value(value: FirebaseFirestore.instance),
        Provider<FirebaseAuth>.value(value: FirebaseAuth.instance),
        InheritedProvider(
          create: (context) => HomeScreenViewmodel(
            AppUser(id: ""),
          ),
        ),
        InheritedProvider(
          create: (context) => AuthService(),
        ),
        ProxyProvider<FirebaseFirestore, CompetitionService>(
            update: (_, firestore, __) {
          return CompetitionService(firestore: firestore);
        }),
        ProxyProvider2<FirebaseFirestore, FirebaseAuth, TeamService>(
            update: (_, firestore, auth, __) {
          final user = auth.currentUser;
          if (user == null) {
            throw Exception("User not logged in");
          }
          return TeamService(firestore: firestore, uid: user.uid);
        }),
        ProxyProvider2<FirebaseFirestore, FirebaseAuth, PlayerService>(
            update: (_, firestore, auth, __) {
          final user = auth.currentUser;
          if (user == null) {
            throw Exception("User not logged in");
          }
          return PlayerService(firestore: firestore, uid: user.uid);
        }),
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
