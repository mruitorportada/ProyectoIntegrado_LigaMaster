import 'package:flutter/material.dart';
import 'package:liga_master/models/user/entities/user_team.dart';
import 'package:liga_master/screens/home/competition/details/competition_team_details_screen.dart';

class CompetitionTeamsDetailsScreen extends StatelessWidget {
  final List<UserTeam> teams;
  const CompetitionTeamsDetailsScreen({super.key, required this.teams});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: body(context),
      ),
    );
  }

  Widget body(BuildContext context) => ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        itemCount: teams.length,
        itemBuilder: (context, index) => _teamItem(context, teams[index]),
      );

  Widget _teamItem(BuildContext context, UserTeam team) => GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CompetitionTeamDetailsScreen(team: team),
            ),
          );
        },
        child: Card(
          child: ListTile(
            title: Text(team.name),
            subtitle: Text(
                "Partidos: ${team.matchesPlayed} Goles: ${team.goals} Goles Recibidos: ${team.goalsConceded}"),
            trailing: Text(
              team.rating.toString(),
              style: TextStyle(
                  fontSize: 14,
                  color:
                      Theme.of(context).listTileTheme.subtitleTextStyle?.color),
            ),
          ),
        ),
      );
}
