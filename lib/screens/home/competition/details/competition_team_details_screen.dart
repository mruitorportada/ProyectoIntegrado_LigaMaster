import 'package:flutter/material.dart';
import 'package:liga_master/models/appstrings/appstrings_controller.dart';
import 'package:liga_master/models/user/entities/user_player.dart';
import 'package:liga_master/models/user/entities/user_team.dart';
import 'package:liga_master/screens/generic/appcolors.dart';
import 'package:liga_master/screens/generic/functions.dart';
import 'package:liga_master/screens/generic/generic_widgets/myappbar.dart';
import 'package:provider/provider.dart';

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
        body: _body(context),
      ),
    );
  }

  Widget _body(BuildContext context) {
    final controller =
        Provider.of<AppStringsController>(context, listen: false);
    final strings = controller.strings!;

    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          TextFormField(
            initialValue: team.name,
            decoration: InputDecoration(
              labelText: strings.nameLabel,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            initialValue: team.rating.toString(),
            decoration: InputDecoration(
              labelText: strings.ratingLabel,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            strings.playersTitle,
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
  }

  Widget _playerItem(BuildContext context, UserPlayer player) {
    final controller =
        Provider.of<AppStringsController>(context, listen: false);
    final strings = controller.strings!;
    return GestureDetector(
      onTap: () => _showPlayerStatsDialog(context, player),
      child: Card(
        child: ListTile(
          title: Text(player.name),
          subtitle: Text(getPlayerPositionLabel(strings, player.position)),
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
  }

  void _showPlayerStatsDialog(BuildContext context, UserPlayer player) {
    final controller =
        Provider.of<AppStringsController>(context, listen: false);
    final strings = controller.strings!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(player.name),
        content: Column(
          spacing: 24,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("${strings.goalsScoredLabel}: ${player.goals}"),
            Text("${strings.assistsLabel}: ${player.assists}"),
            Text("${strings.yellowCardsLabel}: ${player.yellowCards}"),
            Text("${strings.redCardsLabel}: ${player.redCards}"),
            Text(
                "${strings.statusLabel}: ${_showPlayerStatus(context, player.playerStatus)}")
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              strings.closeDialogText,
              style: TextStyle(
                color: LightThemeAppColors.error,
              ),
            ),
          )
        ],
      ),
    );
  }

  String _showPlayerStatus(BuildContext context, PlayerStatus status) {
    final controller =
        Provider.of<AppStringsController>(context, listen: false);
    final strings = controller.strings!;

    return switch (status.statusName) {
      "Disponible" => strings.availableStatusText,
      "Lesionado" =>
        "${strings.injuredStatusText} ${status.duration} ${strings.matchesLabel.toLowerCase()}",
      "Suspendido por expulsión" =>
        "${strings.bannedStatusText} ${status.duration} ${strings.matchesLabel.toLowerCase()}",
      _ => ""
    };
  }
}
