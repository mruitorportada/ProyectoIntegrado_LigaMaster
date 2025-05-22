import 'package:flutter/material.dart';
import 'package:liga_master/models/enums.dart';
import 'package:liga_master/models/fixture/fixture.dart';
import 'package:liga_master/models/match/sport_match.dart';
import 'package:liga_master/screens/generic/appcolors.dart';
import 'package:liga_master/screens/generic/generic_widgets/generic_dropdownmenu.dart';
import 'package:liga_master/screens/home/competition/details/competition_details_viewmodel.dart';

class CompetitionTournamentRoundsList extends StatefulWidget {
  final CompetitionDetailsViewmodel viewModel;
  const CompetitionTournamentRoundsList({super.key, required this.viewModel});

  @override
  State<CompetitionTournamentRoundsList> createState() =>
      _CompetitionTournamentRoundsListState();
}

class _CompetitionTournamentRoundsListState
    extends State<CompetitionTournamentRoundsList> {
  CompetitionDetailsViewmodel get viewModel => widget.viewModel;

  final Color _backgroundColor = AppColors.background;

  final Color _textColor = AppColors.textColor;

  //final Color _labelColor = AppColors.labeltext;

  final Color _secondaryColor = AppColors.accent;

  late TournamentRounds? _selectedRound;

  List<TournamentRounds> _rounds = [];

  @override
  void initState() {
    _selectedRound = viewModel.fixtures.isNotEmpty
        ? TournamentRounds.values
            .firstWhere((round) => round.name == viewModel.fixtures.first.name)
        : null;

    final List<String> fixtureNames =
        viewModel.fixtures.map((fixture) => fixture.name).toList();

    _rounds = TournamentRounds.values
        .where((round) => fixtureNames.contains(round.name))
        .toList();

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

  Widget get _body => Container(
        alignment: Alignment.center,
        child: _selectedRound != null
            ? _fixturesBody()
            : Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "No hay resultados que mostrar, tienes que primero crear las rondas",
                    style: TextStyle(
                      color: _textColor,
                    ),
                  ),
                ),
              ),
      );

  Widget _fixturesBody() => Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            genericDropDownMenu(
              initialSelection: _rounds.first.name,
              entries: _rounds
                  .map(
                    (round) => DropdownMenuEntry(
                      value: round.name,
                      label: round.name,
                      style: genericDropDownMenuEntryStyle(),
                    ),
                  )
                  .toList(),
              onSelected: (value) => {
                setState(() {
                  _selectedRound = TournamentRounds.values
                      .firstWhere((round) => round.name == value);
                })
              },
              labelText: "Ronda",
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                itemCount: 1,
                itemBuilder: (context, index) => ListenableBuilder(
                  listenable: viewModel.fixtures[index],
                  builder: (context, _) => _fixtureItem(
                    viewModel.fixtures.firstWhere(
                        (fixture) => fixture.name == _selectedRound!.name),
                  ),
                ),
              ),
            )
          ],
        ),
      );

  Widget _fixtureItem(Fixture fixture) => Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              fixture.name,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _textColor,
              ),
            ),
            SizedBox(height: 8),
            ...fixture.matches.map(
              (match) => _matchItem(match,
                  isLastFixtureMatch: fixture.matches.last.id == match.id),
            ),
          ],
        ),
      );

  Widget _matchItem(SportMatch match, {required bool isLastFixtureMatch}) =>
      Column(
        children: [
          Text(
            "${_formatDate(match.date)} - N/A",
            style: TextStyle(fontSize: 14, color: AppColors.buttonColor),
          ),
          Card(
            color: AppColors.cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
            child: ListTile(
              title: Text(
                match.teamA.name,
                style: TextStyle(fontSize: 16, color: _textColor),
              ),
              trailing: Text(
                "${match.scoreA}",
                style: TextStyle(fontSize: 16, color: _textColor),
              ),
            ),
          ),
          Card(
            color: AppColors.cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
            child: ListTile(
              title: Text(
                match.teamB.name,
                style: TextStyle(fontSize: 16, color: _textColor),
              ),
              trailing: Text(
                "${match.scoreB}",
                style: TextStyle(fontSize: 16, color: _textColor),
              ),
            ),
          ),
          if (!isLastFixtureMatch)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Divider(
                height: 2,
                color: _secondaryColor,
              ),
            )
        ],
      );

  String _formatDate(DateTime date) =>
      "${date.day}/${date.month}/${date.year} ${TimeOfDay(hour: date.hour, minute: date.minute).format(context)}";
}
