import 'package:flutter/material.dart';
import 'package:liga_master/models/user/entities/user_player.dart';
import 'package:liga_master/screens/generic/appcolors.dart';
import 'package:liga_master/screens/home/home_screen_viewmodel.dart';
import 'package:provider/provider.dart';

class PlayerListScreen extends StatefulWidget {
  const PlayerListScreen({super.key});

  @override
  State<PlayerListScreen> createState() => _PlayerListScreenState();
}

class _PlayerListScreenState extends State<PlayerListScreen> {
  final Color _cardColor = AppColors.cardColor;
  final Color _iconColor = AppColors.icon;
  final Color _textColor = AppColors.text;
  final Color _subTextColor = AppColors.subtext;
  final Color _backgroundColor = AppColors.background;

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
    return playerList(homeScreenViewModel);
  }

  ListenableBuilder playerList(HomeScreenViewmodel homeScreenViewModel) =>
      ListenableBuilder(
        listenable: homeScreenViewModel,
        builder: (context, _) => ListView.builder(
          itemCount: homeScreenViewModel.players.length,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          itemBuilder: (context, index) => ListenableBuilder(
            listenable: homeScreenViewModel.players[index],
            builder: (context, _) => playerItem(
                homeScreenViewModel.players[index],
                homeScreenViewModel.onEditPlayer,
                homeScreenViewModel.onDeletePlayer),
          ),
        ),
      );

  Widget playerItem(
          UserPlayer player,
          void Function(BuildContext, UserPlayer, {bool isNew}) goToEdit,
          void Function(BuildContext, UserPlayer player) deletePlayer) =>
      GestureDetector(
        onTap: () => goToEdit(context, player, isNew: false),
        onLongPress: () => showDeleteDialog(deletePlayer, player),
        child: Card(
          color: _cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          child: ListTile(
            title: Text(player.name, style: TextStyle(color: _textColor)),
            subtitle: Text(player.currentTeamName ?? "Sin equipo",
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
          homeScreenViewModel.onCreatePlayer(context);
        },
        child: Icon(Icons.add),
      );

  void showDeleteDialog(
      void Function(BuildContext context, UserPlayer player) deletePlayer,
      UserPlayer player) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: _backgroundColor,
              title: Text(
                "Atención",
                style: TextStyle(color: Colors.white),
              ),
              content: Text("¿Eliminar el jugador?",
                  style: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.7))),
              actions: [
                TextButton(
                    onPressed: () => {
                          deletePlayer(context, player),
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
