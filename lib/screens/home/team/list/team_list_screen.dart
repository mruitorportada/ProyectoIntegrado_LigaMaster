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
  final Color _cardColor = Color.fromRGBO(255, 255, 255, 0.05);
  final Color _iconColor = Color.fromARGB(255, 0, 204, 204);
  final Color _textColor = Colors.white;
  final Color _subTextColor = Color.fromRGBO(255, 255, 255, 0.7);
  final Color _backgroundColor = Color.fromARGB(255, 58, 17, 100);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: _backgroundColor,
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
            builder: (context, _) => teamItem(
                homeScreenViewModel.teams[index],
                homeScreenViewModel.onEditTeam,
                homeScreenViewModel.onDeleteTeam),
          ),
        ),
      );

  Widget teamItem(
          UserTeam team,
          void Function(BuildContext, UserTeam, {bool isNew}) goToEdit,
          void Function(BuildContext, UserTeam team) deleteTeam) =>
      GestureDetector(
        onTap: () => goToEdit(context, team, isNew: false),
        onLongPress: () => showDeleteDialog(deleteTeam, team),
        child: Card(
          color: _cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          child: ListTile(
            title: Text(team.name, style: TextStyle(color: _textColor)),
            subtitle: Text(team.sportPlayed.name,
                style: TextStyle(color: _subTextColor)),
            trailing: Icon(Icons.sports_soccer_outlined, color: _iconColor),
          ),
        ),
      );

  FloatingActionButton get _floatingActionButton => FloatingActionButton(
        backgroundColor: _iconColor,
        foregroundColor: Colors.white,
        onPressed: () {
          var homeScreenViewModel =
              Provider.of<HomeScreenViewmodel>(context, listen: false);
          homeScreenViewModel.onCreateTeam(context);
        },
        child: Icon(Icons.add),
      );

  void showDeleteDialog(
      void Function(BuildContext context, UserTeam team) deleteTeam,
      UserTeam team) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: _backgroundColor,
              title: Text(
                "Atención",
                style: TextStyle(color: Colors.white),
              ),
              content: Text("¿Eliminar el equipo?",
                  style: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.7))),
              actions: [
                TextButton(
                    onPressed: () => {
                          deleteTeam(context, team),
                          Navigator.of(context).pop()
                        },
                    child:
                        Text("Si", style: TextStyle(color: Colors.redAccent))),
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text("No", style: TextStyle(color: Colors.white))),
              ],
            ));
  }
}
