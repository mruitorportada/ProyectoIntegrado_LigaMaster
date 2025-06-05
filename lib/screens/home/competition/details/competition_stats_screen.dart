import 'package:flutter/material.dart';
import 'package:liga_master/models/appstrings/appstrings_controller.dart';
import 'package:liga_master/models/user/entities/user_player.dart';
import 'package:liga_master/models/user/entities/user_team.dart';
import 'package:liga_master/screens/generic/appcolors.dart';
import 'package:liga_master/screens/generic/functions.dart';
import 'package:liga_master/screens/home/competition/details/competition_details_viewmodel.dart';
import 'package:provider/provider.dart';

typedef TeamStatSelector = int Function(UserTeam team);

typedef PlayerStatSelector = int Function(UserPlayer player);

class CompetitionStatsScreen extends StatelessWidget {
  final CompetitionDetailsViewmodel viewModel;
  const CompetitionStatsScreen({super.key, required this.viewModel});

  final Color _textColor = LightThemeAppColors.textColor;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _body(context),
      ),
    );
  }

  Widget _body(BuildContext context) {
    final controller =
        Provider.of<AppStringsController>(context, listen: false);
    final strings = controller.strings!;

    return SingleChildScrollView(
      child: Column(
        children: [
          _teamSectionBuilder(
              strings.teamsSortedByGoalsScoredTableTitle,
              strings.teamLabel,
              strings.goalsScoredLabel,
              viewModel.teamsSortedByGoalsScored,
              (item) => item.goals),
          _divider(context),
          _teamSectionBuilder(
              strings.teamsSortedByGoalsConcededTableTitle,
              strings.teamLabel,
              strings.goalsScoredLabel,
              viewModel.teamsSortedByGoalsConceded,
              (item) => item.goalsConceded),
          _divider(context),
          _playerSectionBuilder(
              strings.playersSortedByGoalsScoredTableTitle,
              strings.playerLabel,
              strings.goalsScoredLabel,
              viewModel.playersSortedByGoalsScored,
              (item) => item.goals),
          _divider(context),
          _playerSectionBuilder(
              strings.playersSortedByAssistsTableTitle,
              strings.playerLabel,
              strings.assistsLabel,
              viewModel.playersSortedByAssists,
              (item) => item.assists)
        ],
      ),
    );
  }

  Widget _divider(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Divider(
          color: Theme.of(context).dividerColor,
        ),
      );

  Widget _teamSectionBuilder(
          String title,
          String columnFirstLabel,
          String columnSecondLabel,
          ValueNotifier<List<UserTeam>> notifier,
          TeamStatSelector selector) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Card(
          child: Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ValueListenableBuilder(
                valueListenable: notifier,
                builder: (context, items, child) => Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Column(
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                            color: _textColor, fontWeight: FontWeight.bold),
                      ),
                      _createTeamStatsTable(context, columnFirstLabel,
                          columnSecondLabel, items, selector),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );

  DataTable _createTeamStatsTable(
          BuildContext context,
          String columnFirstLabel,
          String columnSecondLabel,
          List<UserTeam> items,
          TeamStatSelector selector) =>
      DataTable(
        columns: _createTeamColumns(columnFirstLabel, columnSecondLabel),
        rows: _createTeamRows(items, selector),
        border: TableBorder(
          horizontalInside: BorderSide(color: Theme.of(context).dividerColor),
        ),
      );

  List<DataColumn> _createTeamColumns(String firstLabel, String secondLabel) =>
      [
        DataColumn(
          label: Text(
            firstLabel,
            style: dataTableTextStyle(),
          ),
        ),
        DataColumn(
          label: Text(
            secondLabel,
            style: dataTableTextStyle(),
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
                    style: dataTableTextStyle(),
                  ),
                ),
                DataCell(
                  Text(
                    selector(item).toString(),
                    style: dataTableTextStyle(),
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
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Card(
          child: Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ValueListenableBuilder(
                valueListenable: notifier,
                builder: (context, items, child) => Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Column(
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                            color: _textColor, fontWeight: FontWeight.bold),
                      ),
                      _createPlayerTeamStatsTable(context, columnFirstLabel,
                          columnSecondLabel, items, selector),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );

  DataTable _createPlayerTeamStatsTable(
          BuildContext context,
          String columnFirstLabel,
          String columnSecondLabel,
          List<UserPlayer> items,
          PlayerStatSelector selector) =>
      DataTable(
        columns: _createPlayerColumns(columnFirstLabel, columnSecondLabel),
        rows: _createPlayerRows(items, selector),
        border: TableBorder(
          horizontalInside: BorderSide(color: Theme.of(context).dividerColor),
        ),
      );

  List<DataColumn> _createPlayerColumns(
          String firstLabel, String secondLabel) =>
      [
        DataColumn(
          label: Text(
            firstLabel,
            style: dataTableTextStyle(),
          ),
        ),
        DataColumn(
          label: Text(
            secondLabel,
            style: dataTableTextStyle(),
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
                    style: dataTableTextStyle(),
                  ),
                ),
                DataCell(
                  Text(
                    selector(item).toString(),
                    style: dataTableTextStyle(),
                  ),
                )
              ],
            ),
          )
          .toList();
}
