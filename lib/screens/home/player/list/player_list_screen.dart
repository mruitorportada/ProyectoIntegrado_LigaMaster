import 'package:flutter/material.dart';
import 'package:liga_master/models/user/entities/user_player.dart';
import 'package:liga_master/screens/generic/appcolors.dart';
import 'package:liga_master/screens/generic/generic_widgets/generic_card.dart';
import 'package:liga_master/screens/generic/generic_widgets/simple_alert_dialog.dart';
import 'package:liga_master/screens/home/home_screen_viewmodel.dart';

class PlayerListScreen extends StatelessWidget {
  final HomeScreenViewmodel homeScreenViewModel;
  const PlayerListScreen({super.key, required this.homeScreenViewModel});

  final Color _secondaryColor = AppColors.accent;

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

  Widget get _body => playerList();

  ListenableBuilder playerList() => ListenableBuilder(
        listenable: homeScreenViewModel,
        builder: (context, _) => ListView.builder(
          itemCount: homeScreenViewModel.players.length,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          itemBuilder: (context, index) => ListenableBuilder(
            listenable: homeScreenViewModel.players[index],
            builder: (context, _) => playerItem(
                context,
                homeScreenViewModel.players[index],
                homeScreenViewModel.onEditPlayer,
                homeScreenViewModel.onDeletePlayer),
          ),
        ),
      );

  Widget playerItem(
          BuildContext context,
          UserPlayer player,
          void Function(BuildContext, UserPlayer, {bool isNew}) goToEdit,
          void Function(BuildContext, UserPlayer player) deletePlayer) =>
      GestureDetector(
        onTap: () => goToEdit(context, player, isNew: false),
        onLongPress: () => showDeleteDialog(context, deletePlayer, player),
        child: genericCard(
          title: player.name,
          subtitle: player.currentTeamName ?? "Sin equipo",
          trailIcon: Icons.sports_soccer_outlined,
        ),
      );

  FloatingActionButton _floatingActionButton(BuildContext context) =>
      FloatingActionButton(
        backgroundColor: _secondaryColor,
        foregroundColor: Colors.white,
        onPressed: () {
          homeScreenViewModel.onCreatePlayer(context);
        },
        child: Icon(Icons.add),
      );

  void showDeleteDialog(
      BuildContext context,
      void Function(BuildContext context, UserPlayer player) deletePlayer,
      UserPlayer player) {
    showDialog(
      context: context,
      builder: (context) => simpleAlertDialog(
        title: "Atención",
        message: "¿Eliminar el jugador?",
        actions: [
          TextButton(
              onPressed: () =>
                  {deletePlayer(context, player), Navigator.of(context).pop()},
              child: Text("Si", style: TextStyle(color: Colors.redAccent))),
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("No", style: TextStyle(color: Colors.white))),
        ],
      ),
    );
  }
}
