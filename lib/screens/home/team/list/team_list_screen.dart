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
    return teamList(homeScreenViewModel);
  }

  ListenableBuilder teamList(HomeScreenViewmodel homeScreenViewModel) =>
      ListenableBuilder(
        listenable: homeScreenViewModel,
        builder: (context, _) => ListView.builder(
          itemCount: homeScreenViewModel.teams.length,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          itemBuilder: (context, index) => ListenableBuilder(
            listenable: homeScreenViewModel.teams[index],
            builder: (context, _) => teamItem(homeScreenViewModel.teams[index],
                homeScreenViewModel.onEditTeam),
          ),
        ),
      );

  Widget teamItem(UserTeam team,
          void Function(BuildContext, UserTeam, {bool isNew}) goToEdit) =>
      GestureDetector(
        onTap: () => goToEdit(context, team, isNew: false),
        child: Card(
          child: ListTile(
            title: Text(team.name),
            subtitle: Text("${team.sportPlayed.name} - ${team.rating}"),
            trailing: Icon(Icons.sports_soccer_outlined),
          ),
        ),
      );

  FloatingActionButton get _floatingActionButton => FloatingActionButton(
        onPressed: () {
          var homeScreenViewModel =
              Provider.of<HomeScreenViewmodel>(context, listen: false);
          homeScreenViewModel.onCreateTeam(context);
        },
        child: Icon(Icons.add),
      );
}
