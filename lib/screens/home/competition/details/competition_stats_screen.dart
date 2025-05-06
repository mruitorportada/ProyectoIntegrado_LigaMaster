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
  List<UserTeam> _teams = [];
  List<UserPlayer> _players = [];

  final Color _backgroundColor = AppColors.background;
  final Color _textColor = AppColors.text;
  final Color _iconColor = AppColors.icon;
  final Color _dividerColor = AppColors.accent;

  @override
  void initState() {
    _teams = viewModel.competition.teams;
    _players = viewModel.competition.players;
    super.initState();
  }

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
    List<UserTeam> topTeamsGoalsScored = List.from(_teams);
    topTeamsGoalsScored.sort((a, b) => a.goals.compareTo(b.goals));
    topTeamsGoalsScored.removeRange(3, topTeamsGoalsScored.length);

    return SingleChildScrollView(
      child: Column(
        children: [_topTeamsGoalsScoredSection(viewModel, topTeamsGoalsScored)],
      ),
    );
  }

  Widget _topTeamsGoalsScoredSection(
          CompetitionDetailsViewmodel viewModel, List<UserTeam> teams) =>
      ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) => Expanded(
          child: ListView.builder(
            itemCount: teams.length,
            itemBuilder: (context, index) => ListenableBuilder(
              listenable: teams[index],
              builder: (context, _) => _topTeamScoredItem(teams[index]),
            ),
          ),
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
