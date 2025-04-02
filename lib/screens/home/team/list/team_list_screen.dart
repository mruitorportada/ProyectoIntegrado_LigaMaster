import 'package:flutter/material.dart';
import 'package:liga_master/models/user/entities/user_team.dart';
import 'package:liga_master/screens/home/home_screen_viewmodel.dart';
import 'package:provider/provider.dart';

class TeamListScreen extends StatefulWidget {
  const TeamListScreen({super.key});

  @override
  State<TeamListScreen> createState() => _TeamListScreenState();
}

class _TeamListScreenState extends State<TeamListScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _body,
        floatingActionButton: _floatingActionButton,
      ),
    );
  }

  Widget get _body {
    var homeScreenViewModel =
        Provider.of<HomeScreenViewmodel>(context, listen: false);
    return teamList(homeScreenViewModel.teams);
  }

  ListView teamList(List<UserTeam> teams) => ListView.builder(
        itemCount: teams.length,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        itemBuilder: (context, index) => ListenableBuilder(
          listenable: teams[index],
          builder: (context, _) => teamItem(teams[index]),
        ),
      );

  Card teamItem(UserTeam team) => Card(
        child: ListTile(
          title: Text(team.name),
          subtitle: Text("Prueba"),
          trailing: Icon(Icons.sports_soccer_outlined),
        ),
      );

  FloatingActionButton get _floatingActionButton => FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      );
}
