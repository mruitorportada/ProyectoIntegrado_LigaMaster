import 'package:flutter/material.dart';
import 'package:liga_master/models/user/entities/user_player.dart';
import 'package:liga_master/models/user/entities/user_team.dart';
import 'package:liga_master/screens/generic/appcolors.dart';
import 'package:liga_master/screens/home/competition/details/competition_details_viewmodel.dart';

typedef TeamStatSelector = int Function(UserTeam team);

typedef PlayerStatSelector = int Function(UserPlayer player);

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
  final Color _labelColor = AppColors.labeltext;
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
        children: [
          _teamSectionBuilder(
              "Equipos con más goles a favor",
              "Equipo",
              "Goles",
              viewModel.teamsSortedByGoalsScored,
              (item) => item.goals),
          _divider,
          _teamSectionBuilder(
              "Equipos con menos goles encajados",
              "Equipo",
              "Goles",
              viewModel.teamsSortedByGoalsConceded,
              (item) => item.goalsConceded),
          _divider,
          _playerSectionBuilder(
              "Top jugadores con más goles",
              "Jugador",
              "Goles",
              viewModel.playersSortedByGoalsScored,
              (item) => item.goals),
          _divider,
          _playerSectionBuilder(
              "Top jugadores con más asistencias",
              "Jugador",
              "Asistencias",
              viewModel.playersSortedByAssists,
              (item) => item.assists)
        ],
      ),
    );
  }

  Widget get _divider => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Divider(
          color: _dividerColor,
        ),
      );

  Widget _teamSectionBuilder(
          String title,
          String columnFirstLabel,
          String columnSecondLabel,
          ValueNotifier<List<UserTeam>> notifier,
          TeamStatSelector selector) =>
      Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ValueListenableBuilder(
            valueListenable: notifier,
            builder: (context, items, child) => Column(
              children: [
                Text(title, style: TextStyle(color: _textColor)),
                _createTeamStatsTable(
                    columnFirstLabel, columnSecondLabel, items, selector),
              ],
            ),
          ),
        ),
      );

  DataTable _createTeamStatsTable(
          String columnFirstLabel,
          String columnSecondLabel,
          List<UserTeam> items,
          TeamStatSelector selector) =>
      DataTable(
        columns: _createTeamColumns(columnFirstLabel, columnSecondLabel),
        rows: _createTeamRows(items, selector),
        border: TableBorder(
          horizontalInside: BorderSide(color: _dividerColor),
        ),
      );

  List<DataColumn> _createTeamColumns(String firstLabel, String secondLabel) =>
      [
        DataColumn(
          label: Text(
            firstLabel,
            style: TextStyle(color: _labelColor),
          ),
        ),
        DataColumn(
          label: Text(
            secondLabel,
            style: TextStyle(color: _labelColor),
          ),
          numeric: true,
        )
      ];

  List<DataRow> _createTeamRows(
          List<UserTeam> items, TeamStatSelector selector) =>
      items
          .map(
            (item) => DataRow(
              cells: [
                DataCell(
                  Text(
                    item.name,
                    style: TextStyle(color: _textColor),
                  ),
                ),
                DataCell(
                  Text(
                    selector(item).toString(),
                    style: TextStyle(color: _textColor),
                  ),
                )
              ],
            ),
          )
          .toList();

  Widget _playerSectionBuilder(
          String title,
          String columnFirstLabel,
          String columnSecondLabel,
          ValueNotifier<List<UserPlayer>> notifier,
          PlayerStatSelector selector) =>
      Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ValueListenableBuilder(
            valueListenable: notifier,
            builder: (context, items, child) => Column(
              children: [
                Text(title, style: TextStyle(color: _textColor)),
                _createPlayerTeamStatsTable(
                    columnFirstLabel, columnSecondLabel, items, selector),
              ],
            ),
          ),
        ),
      );

  DataTable _createPlayerTeamStatsTable(
          String columnFirstLabel,
          String columnSecondLabel,
          List<UserPlayer> items,
          PlayerStatSelector selector) =>
      DataTable(
        columns: _createPlayerColumns(columnFirstLabel, columnSecondLabel),
        rows: _createPlayerRows(items, selector),
        border: TableBorder(
          horizontalInside: BorderSide(color: _dividerColor),
        ),
      );

  List<DataColumn> _createPlayerColumns(
          String firstLabel, String secondLabel) =>
      [
        DataColumn(
          label: Text(
            firstLabel,
            style: TextStyle(color: _labelColor),
          ),
        ),
        DataColumn(
          label: Text(
            secondLabel,
            style: TextStyle(color: _labelColor),
          ),
          numeric: true,
        )
      ];

  List<DataRow> _createPlayerRows(
          List<UserPlayer> items, PlayerStatSelector selector) =>
      items
          .map(
            (item) => DataRow(
              cells: [
                DataCell(
                  Text(
                    item.name,
                    style: TextStyle(color: _textColor),
                  ),
                ),
                DataCell(
                  Text(
                    selector(item).toString(),
                    style: TextStyle(color: _textColor),
                  ),
                )
              ],
            ),
          )
          .toList();
}
