import 'package:flutter/material.dart';
import 'package:liga_master/models/appstrings/appstrings.dart';
import 'package:liga_master/models/appstrings/appstrings_controller.dart';
import 'package:liga_master/models/enums.dart';
import 'package:liga_master/models/fixture/fixture.dart';
import 'package:liga_master/models/match/sport_match.dart';
import 'package:liga_master/screens/generic/appcolors.dart';
import 'package:liga_master/screens/generic/functions.dart';
import 'package:liga_master/screens/generic/generic_widgets/generic_dropdownmenu.dart';
import 'package:liga_master/screens/home/competition/details/competition_details_viewmodel.dart';
import 'package:provider/provider.dart';

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

  final Color _textColor = LightThemeAppColors.textColor;

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
        body: _body,
      ),
    );
  }

  Widget get _body {
    final controller =
        Provider.of<AppStringsController>(context, listen: false);
    final strings = controller.strings!;

    return Container(
      alignment: Alignment.center,
      child: _selectedRound != null
          ? _fixturesBody(strings)
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  strings.noRoundsMessage,
                  style: TextStyle(
                    color: _textColor,
                  ),
                ),
              ),
            ),
    );
  }

  Widget _fixturesBody(AppStrings strings) => Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            genericDropDownMenu(
              context,
              initialSelection: _rounds.first.name,
              entries: _rounds
                  .map(
                    (round) => DropdownMenuEntry(
                      value: round.name,
                      label: getTournamentRoundLabel(context, round),
                      style: genericDropDownMenuEntryStyle(context),
                    ),
                  )
                  .toList(),
              onSelected: (value) => {
                setState(() {
                  _selectedRound = TournamentRounds.values
                      .firstWhere((round) => round.name == value);
                })
              },
              labelText: strings.roundLabel,
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
              getTournamentRoundLabel(context, _selectedRound!),
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
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).dividerColor,
            ),
          ),
          Card(
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
                color: Theme.of(context).colorScheme.secondary,
              ),
            )
        ],
      );

  String _formatDate(DateTime date) =>
      "${date.day}/${date.month}/${date.year} ${TimeOfDay(hour: date.hour, minute: date.minute).format(context)}";
}
