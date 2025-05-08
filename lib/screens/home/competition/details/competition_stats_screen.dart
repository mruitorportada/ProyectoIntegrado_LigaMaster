import 'package:flutter/material.dart';
import 'package:liga_master/models/user/entities/user_player.dart';
import 'package:liga_master/models/user/entities/user_team.dart';
import 'package:liga_master/screens/generic/appcolors.dart';
import 'package:liga_master/screens/home/competition/details/competition_details_viewmodel.dart';

class CompetitionStatsScreen extends StatefulWidget {
  final CompetitionDetailsViewmodel viewmodel;
  const CompetitionStatsScreen({super.key, required this.viewmodel});

  @override
  State<CompetitionStatsScreen> createState() => _CompetitionStatsScreenState();
}

class _CompetitionStatsScreenState extends State<CompetitionStatsScreen> {
  CompetitionDetailsViewmodel get viewModel => widget.viewmodel;

  final Color _backgroundColor = AppColors.background;
  final Color _textColor = AppColors.text;
  final Color _iconColor = AppColors.icon;
  final Color _dividerColor = AppColors.accent;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: _backgroundColor,
        body: _body,
      ),
    );
  }

  Widget get _body {
    return SingleChildScrollView(
      child: Column(
        children: [Text("Hola")],
      ),
    );
  }

  Widget _topTeamsGoalsScoredSection(CompetitionDetailsViewmodel viewModel) =>
      ValueListenableBuilder(
        valueListenable: viewModel.topTeamsByGoalsScored,
        builder: (context, teamsList, _) => Column(
          children: [
            Text("Equipos con más goles a favor"),
            SizedBox(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: teamsList.length,
                itemBuilder: (context, index) => ListenableBuilder(
                  listenable: teamsList[index],
                  builder: (context, _) => _topTeamScoredItem(teamsList[index]),
                ),
              ),
            ),
          ],
        ),
      );

  Widget _topTeamScoredItem(UserTeam team) => ListTile(
        title: Text(
          team.name,
          style: TextStyle(color: _textColor),
        ),
        trailing: Text(
          "${team.goals}",
          style: TextStyle(color: _textColor),
        ),
      );
}
