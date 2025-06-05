import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:liga_master/models/appstrings/appstrings_controller.dart';
import 'package:liga_master/screens/boot/boot_screen.dart';
import 'package:liga_master/services/appstrings_service.dart';
import 'package:liga_master/services/appuser_service.dart';
import 'package:liga_master/services/auth_service.dart';
import 'package:liga_master/services/competition_service.dart';
import 'package:liga_master/services/player_service.dart';
import 'package:liga_master/services/team_service.dart';
import 'package:liga_master/styles/app_theme.dart';
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
          create: (context) => AuthService(),
        ),
        ProxyProvider<FirebaseFirestore, CompetitionService>(
          update: (_, firestore, __) {
            return CompetitionService(firestore: firestore);
          },
        ),
        ProxyProvider<FirebaseFirestore, TeamService>(
          update: (_, firestore, __) {
            return TeamService(firestore: firestore);
          },
        ),
        ProxyProvider<FirebaseFirestore, PlayerService>(
          update: (_, firestore, __) {
            return PlayerService(firestore: firestore);
          },
        ),
        InheritedProvider(
          create: (context) => AppUserService(),
        ),
        ProxyProvider<FirebaseFirestore, AppStringsService>(
          update: (_, firestore, __) {
            return AppStringsService(firestore: firestore);
          },
        ),
        ChangeNotifierProxyProvider<AppStringsService, AppStringsController>(
          create: (context) => AppStringsController(
              service: context.read<AppStringsService>(),
              language: Platform.localeName.split("_").first),
          update: (context, service, previous) =>
              previous!..updateService(service),
        )
      ],
      child: MaterialApp(
        title: "Liga Master",
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        home: BootScreen(),
      ),
    );
  }
}
