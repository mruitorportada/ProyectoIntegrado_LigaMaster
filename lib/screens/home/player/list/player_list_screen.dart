import 'package:flutter/material.dart';
import 'package:liga_master/models/appstrings/appstrings_controller.dart';
import 'package:liga_master/models/user/entities/user_player.dart';
import 'package:liga_master/screens/generic/generic_widgets/generic_card.dart';
import 'package:liga_master/screens/generic/generic_widgets/simple_alert_dialog.dart';
import 'package:liga_master/screens/home/home_screen_viewmodel.dart';
import 'package:provider/provider.dart';

class PlayerListScreen extends StatelessWidget {
  final HomeScreenViewmodel homeScreenViewModel;
  const PlayerListScreen({super.key, required this.homeScreenViewModel});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
      void Function(BuildContext, UserPlayer player) deletePlayer) {
    final controller =
        Provider.of<AppStringsController>(context, listen: false);
    final strings = controller.strings!;

    return GestureDetector(
      onTap: () => goToEdit(context, player, isNew: false),
      onLongPress: () => showDeleteDialog(context, deletePlayer, player),
      child: genericCard(
        title: player.name,
        subtitle:
            "${player.currentTeamName ?? strings.noTeamText} - ${player.position.name}",
        trailIcon: Icons.sports_soccer_outlined,
      ),
    );
  }

  FloatingActionButton _floatingActionButton(BuildContext context) =>
      FloatingActionButton(
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
    final controller =
        Provider.of<AppStringsController>(context, listen: false);
    final strings = controller.strings!;

    showDialog(
      context: context,
      builder: (context) => simpleAlertDialog(
        context,
        title: strings.deleteItemDialogTitle,
        message: strings.deletePlayerText,
        actions: [
          TextButton(
            onPressed: () =>
                {deletePlayer(context, player), Navigator.of(context).pop()},
            child: Text(
              "Si",
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              "No",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
