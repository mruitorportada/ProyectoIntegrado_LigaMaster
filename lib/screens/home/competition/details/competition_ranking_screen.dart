import 'package:flutter/material.dart';
import 'package:liga_master/screens/generic/appcolors.dart';
import 'package:liga_master/screens/generic/functions.dart';
import 'package:liga_master/screens/home/competition/details/competition_details_viewmodel.dart';

class CompetitionRankingScreen extends StatelessWidget {
  final CompetitionDetailsViewmodel viewModel;
  const CompetitionRankingScreen({super.key, required this.viewModel});

  final Color _backgroundColor = AppColors.background;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: _backgroundColor,
        body: _body,
      ),
    );
  }

  Widget get _body => SizedBox.expand(
        child: _leagueRanking,
      );

  Widget get _leagueRanking {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ValueListenableBuilder(
            valueListenable: viewModel.teamsSortedByPoints,
            builder: (context, teams, _) => Card(
              color: AppColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              child: Container(
                alignment: Alignment.topCenter,
                child: DataTable(
                  columnSpacing: 20,
                  columns: _createColumns(),
                  rows: _createRows(),
                  border: TableBorder(
                    horizontalInside: BorderSide(color: AppColors.buttonColor),
                    verticalInside: BorderSide(color: AppColors.buttonColor),
                  ),
                ),
              ),
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
            style: dataTableTextStyle(),
          ),
        ),
        DataColumn(
            label: Text(
              "Pts",
              style: dataTableTextStyle(),
            ),
            numeric: true),
        DataColumn(
            label: Text(
              "V",
              style: dataTableTextStyle(),
            ),
            numeric: true),
        DataColumn(
            label: Text(
              "E",
              style: dataTableTextStyle(),
            ),
            numeric: true),
        DataColumn(
            label: Text(
              "D",
              style: dataTableTextStyle(),
            ),
            numeric: true),
        DataColumn(
            label: Text(
              "DG",
              style: dataTableTextStyle(),
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
                softWrap: true,
                style: dataTableTextStyle(),
              ),
            ),
            DataCell(
              Text(
                "${team.points}",
                style: dataTableTextStyle(),
              ),
            ),
            DataCell(
              Text(
                "${team.matchesWon}",
                style: dataTableTextStyle(),
              ),
            ),
            DataCell(
              Text(
                "${team.matchesTied}",
                style: dataTableTextStyle(),
              ),
            ),
            DataCell(
              Text(
                "${team.matchesLost}",
                style: dataTableTextStyle(),
              ),
            ),
            DataCell(
              Text(
                "${team.goalDifference}",
                style: dataTableTextStyle(),
              ),
            ),
          ],
        ),
      )
      .toList();
}
