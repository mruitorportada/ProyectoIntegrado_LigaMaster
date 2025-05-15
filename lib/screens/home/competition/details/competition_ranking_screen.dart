import 'package:flutter/material.dart';
import 'package:liga_master/screens/generic/appcolors.dart';
import 'package:liga_master/screens/home/competition/details/competition_details_viewmodel.dart';

class CompetitionRankingScreen extends StatelessWidget {
  final CompetitionDetailsViewmodel viewModel;
  const CompetitionRankingScreen({super.key, required this.viewModel});

  final Color _backgroundColor = AppColors.background;

  final Color _textColor = AppColors.text;

  final Color _labelColor = AppColors.labeltext;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: _backgroundColor,
      body: _body,
    ));
  }

  Widget get _body => SizedBox.expand(
        child: _leagueRanking,
      );

  Widget get _leagueRanking {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ValueListenableBuilder(
          valueListenable: viewModel.teamsSortedByPoints,
          builder: (context, teams, _) => DataTable(
            columns: _createColumns(),
            rows: _createRows(),
            border: TableBorder(
              horizontalInside: BorderSide(color: AppColors.accent),
            ),
          ),
        ),
      ),
    );
  }

  List<DataColumn> _createColumns() => [
        DataColumn(
          label: Text(
            "Equipo",
            style: TextStyle(color: _labelColor),
          ),
        ),
        DataColumn(
            label: Text(
              "PJ",
              style: TextStyle(color: _labelColor),
            ),
            numeric: true),
        DataColumn(
            label: Text(
              "V",
              style: TextStyle(color: _labelColor),
            ),
            numeric: true),
        DataColumn(
            label: Text(
              "E",
              style: TextStyle(color: _labelColor),
            ),
            numeric: true),
        DataColumn(
            label: Text(
              "D",
              style: TextStyle(color: _labelColor),
            ),
            numeric: true),
        DataColumn(
            label: Text(
              "GF",
              style: TextStyle(color: _labelColor),
            ),
            numeric: true),
        DataColumn(
            label: Text(
              "GC",
              style: TextStyle(color: _labelColor),
            ),
            numeric: true),
        DataColumn(
            label: Text(
              "DG",
              style: TextStyle(color: _labelColor),
            ),
            numeric: true),
        DataColumn(
            label: Text(
              "Pts",
              style: TextStyle(color: _labelColor),
            ),
            numeric: true),
      ];

  List<DataRow> _createRows() => viewModel.teamsSortedByPoints.value
      .map(
        (team) => DataRow(
          cells: [
            DataCell(
              Text(
                team.name,
                style: TextStyle(color: _textColor),
              ),
            ),
            DataCell(
              Text(
                "${team.matchesPlayed}",
                style: TextStyle(color: _textColor),
              ),
            ),
            DataCell(
              Text(
                "${team.matchesWon}",
                style: TextStyle(color: _textColor),
              ),
            ),
            DataCell(
              Text(
                "${team.matchesTied}",
                style: TextStyle(color: _textColor),
              ),
            ),
            DataCell(
              Text(
                "${team.matchesLost}",
                style: TextStyle(color: _textColor),
              ),
            ),
            DataCell(
              Text(
                "${team.goals}",
                style: TextStyle(color: _textColor),
              ),
            ),
            DataCell(
              Text(
                "${team.goalsConceded}",
                style: TextStyle(color: _textColor),
              ),
            ),
            DataCell(
              Text(
                "${team.goalDifference}",
                style: TextStyle(color: _textColor),
              ),
            ),
            DataCell(
              Text(
                "${team.points}",
                style: TextStyle(color: _textColor),
              ),
            ),
          ],
        ),
      )
      .toList();
}
