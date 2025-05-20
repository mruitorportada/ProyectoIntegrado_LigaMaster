import 'package:flutter/material.dart';
import 'package:liga_master/models/user/entities/user_team.dart';
import 'package:liga_master/screens/generic/appcolors.dart';
import 'package:liga_master/screens/generic/generic_widgets/simple_alert_dialog.dart';
import 'package:liga_master/screens/home/home_screen_viewmodel.dart';

class TeamListScreen extends StatelessWidget {
  final HomeScreenViewmodel homeScreenViewModel;
  const TeamListScreen({super.key, required this.homeScreenViewModel});

  final Color _cardColor = AppColors.cardColor;

  final Color _iconColor = AppColors.accent;

  final Color _textColor = AppColors.textColor;

  final Color _subTextColor = AppColors.subtextColor;

  final Color _backgroundColor = AppColors.background;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: _backgroundColor,
        body: _body,
        floatingActionButton: _floatingActionButton(context),
      ),
    );
  }

  Widget get _body => teamList();

  ListenableBuilder teamList() => ListenableBuilder(
        listenable: homeScreenViewModel,
        builder: (context, _) => ListView.builder(
          itemCount: homeScreenViewModel.teams.length,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          itemBuilder: (context, index) => ListenableBuilder(
            listenable: homeScreenViewModel.teams[index],
            builder: (context, _) => teamItem(
                homeScreenViewModel.teams[index],
                context,
                homeScreenViewModel.onEditTeam,
                homeScreenViewModel.onDeleteTeam),
          ),
        ),
      );

  Widget teamItem(
          UserTeam team,
          BuildContext context,
          void Function(BuildContext, UserTeam, {bool isNew}) goToEdit,
          void Function(BuildContext, UserTeam team) deleteTeam) =>
      GestureDetector(
        onTap: () => goToEdit(context, team, isNew: false),
        onLongPress: () => showDeleteDialog(context, deleteTeam, team),
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

  FloatingActionButton _floatingActionButton(BuildContext context) =>
      FloatingActionButton(
        backgroundColor: _iconColor,
        foregroundColor: Colors.white,
        onPressed: () => homeScreenViewModel.onCreateTeam(context),
        child: Icon(Icons.add),
      );

  void showDeleteDialog(
      BuildContext context,
      void Function(BuildContext context, UserTeam team) deleteTeam,
      UserTeam team) {
    showDialog(
        context: context,
        builder: (context) => simpleAlertDialog(
              title: "Atención",
              message: "¿Eliminar el equipo?",
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
