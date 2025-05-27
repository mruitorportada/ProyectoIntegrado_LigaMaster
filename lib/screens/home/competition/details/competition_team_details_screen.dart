import 'package:flutter/material.dart';
import 'package:liga_master/models/user/entities/user_player.dart';
import 'package:liga_master/models/user/entities/user_team.dart';
import 'package:liga_master/screens/generic/appcolors.dart';
import 'package:liga_master/screens/generic/generic_widgets/myappbar.dart';

class CompetitionTeamDetailsScreen extends StatelessWidget {
  final UserTeam team;
  const CompetitionTeamDetailsScreen({super.key, required this.team});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: myAppBar(
          context,
          team.name,
          [],
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.arrow_back),
          ),
        ),
        body: _body,
      ),
    );
  }

  Widget get _body => Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextFormField(
              initialValue: team.name,
              decoration: InputDecoration(
                labelText: "Nombre",
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              initialValue: team.rating.toString(),
              decoration: InputDecoration(
                labelText: "Valoración",
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Jugadores",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: team.players.length,
                itemBuilder: (context, index) => _playerItem(
                  context,
                  team.players[index],
                ),
              ),
            )
          ],
        ),
      );

  Widget _playerItem(BuildContext context, UserPlayer player) =>
      GestureDetector(
        onTap: () => _showPlayerStatsDialog(context, player),
        child: Card(
          child: ListTile(
            title: Text(player.name),
            subtitle: Text(player.position.name),
            trailing: Text(
              player.rating.toString(),
              style: TextStyle(
                  fontSize: 14,
                  color:
                      Theme.of(context).listTileTheme.subtitleTextStyle?.color),
            ),
          ),
        ),
      );

  void _showPlayerStatsDialog(BuildContext context, UserPlayer player) =>
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(player.name),
          content: Column(
            spacing: 24,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Goles: ${player.goals}"),
              Text("Asistencias: ${player.assists}"),
              Text("Tarjetas amarillas: ${player.yellowCards}"),
              Text("Tarjetas rojas: ${player.redCards}"),
              Text("Estado: ${player.playerStatus}")
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                "Cerrar",
                style: TextStyle(
                  color: LightThemeAppColors.error,
                ),
              ),
            )
          ],
        ),
      );
}
