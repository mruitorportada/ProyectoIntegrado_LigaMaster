import 'package:flutter/material.dart';
import 'package:liga_master/models/user/entities/user_player.dart';
import 'package:liga_master/screens/home/player/list/player_list_viewmodel.dart';
import 'package:provider/provider.dart';

class PlayerListScreen extends StatefulWidget {
  const PlayerListScreen({super.key});

  @override
  State<PlayerListScreen> createState() => _PlayerListScreenState();
}

class _PlayerListScreenState extends State<PlayerListScreen> {
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
    var playersViewModel =
        Provider.of<PlayerListViewmodel>(context, listen: false);
    return competitionList(playersViewModel.players);
  }

  ListView competitionList(List<UserPlayer> players) => ListView.builder(
        itemCount: players.length,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        itemBuilder: (context, index) => ListenableBuilder(
          listenable: players[index],
          builder: (context, _) => competitionItem(players[index]),
        ),
      );

  Card competitionItem(UserPlayer player) => Card(
        child: ListTile(
          title: Text(player.name),
          subtitle: Text("Prueba"),
          trailing: Icon(Icons.sports_soccer_outlined),
        ),
      );

  FloatingActionButton get _floatingActionButton => FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      );
}
