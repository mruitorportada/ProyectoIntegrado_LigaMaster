import 'package:flutter/material.dart';
import 'package:liga_master/data/competitions.dart';
import 'package:liga_master/data/players.dart';
import 'package:liga_master/data/teams.dart';
import 'package:liga_master/models/user/user.dart';
import 'package:liga_master/screens/home/competition/list/competition_list_viewmodel.dart';
import 'package:liga_master/screens/home/home_screen.dart';
import 'package:liga_master/screens/home/player/list/player_list_viewmodel.dart';
import 'package:liga_master/screens/home/team/list/team_list_viewmodel.dart';
import 'package:provider/provider.dart';

class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        InheritedProvider(
          create: (context) => User(
            "1",
            "Mario",
            "Ruiz",
            "mruitor",
            "mruitor@gmail.com",
            "password",
          ),
        ),
        InheritedProvider(
          create: (context) => CompetitionListViewmodel(competitions),
        ),
        InheritedProvider(
          create: (context) => TeamListViewmodel(teams),
        ),
        InheritedProvider(
          create: (context) => PlayerListViewmodel(players),
        )
      ],
      child: MaterialApp(
        title: "Liga Master",
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: HomeScreen(),
      ),
    );
  }
}
