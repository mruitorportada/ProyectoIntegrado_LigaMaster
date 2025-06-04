import 'package:flutter/material.dart';
import 'package:liga_master/models/appstrings/appstrings_controller.dart';
import 'package:liga_master/screens/generic/functions.dart';
import 'package:liga_master/screens/home/competition/details/competition_details_viewmodel.dart';
import 'package:provider/provider.dart';

class CompetitionRankingScreen extends StatelessWidget {
  final CompetitionDetailsViewmodel viewModel;
  const CompetitionRankingScreen({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
              child: Container(
                alignment: Alignment.topCenter,
                child: DataTable(
                  columnSpacing: 20,
                  columns: _createColumns(context),
                  rows: _createRows(),
                  border: TableBorder(
                    horizontalInside:
                        BorderSide(color: Theme.of(context).dividerColor),
                    verticalInside:
                        BorderSide(color: Theme.of(context).dividerColor),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<DataColumn> _createColumns(BuildContext context) {
    final controller =
        Provider.of<AppStringsController>(context, listen: false);
    final strings = controller.strings!;

    return [
      DataColumn(
        label: Text(
          strings.teamLabel,
          style: dataTableTextStyle(),
        ),
      ),
      DataColumn(
          label: Text(
            strings.pointsLabel,
            style: dataTableTextStyle(),
          ),
          numeric: true),
      DataColumn(
          label: Text(
            strings.victoriesLabel,
            style: dataTableTextStyle(),
          ),
          numeric: true),
      DataColumn(
          label: Text(
            strings.tiesLabel,
            style: dataTableTextStyle(),
          ),
          numeric: true),
      DataColumn(
          label: Text(
            strings.losesLabel,
            style: dataTableTextStyle(),
          ),
          numeric: true),
      DataColumn(
          label: Text(
            strings.goalDifferenceLabel,
            style: dataTableTextStyle(),
          ),
          numeric: true),
    ];
  }

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
