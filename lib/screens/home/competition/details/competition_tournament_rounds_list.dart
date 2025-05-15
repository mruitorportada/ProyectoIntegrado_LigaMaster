import 'package:flutter/material.dart';
import 'package:liga_master/models/enums.dart';
import 'package:liga_master/models/fixture/fixture.dart';
import 'package:liga_master/models/match/match.dart';
import 'package:liga_master/screens/generic/appcolors.dart';
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

  final Color _textColor = AppColors.text;

  //final Color _labelColor = AppColors.labeltext;

  final Color _secondaryColor = AppColors.accent;

  late TournamentRounds _selectedRound;

  List<TournamentRounds> _rounds = [];

  @override
  void initState() {
    _selectedRound = TournamentRounds.values
        .firstWhere((round) => round.name == viewModel.fixtures.first.name);

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            DropdownMenu(
              initialSelection:
                  _rounds.isNotEmpty ? _rounds.first.name : "Sin rondas",
              dropdownMenuEntries: _rounds
                  .map(
                    (round) => DropdownMenuEntry(
                        value: round.name,
                        label: round.name,
                        style: MenuItemButton.styleFrom(
                            backgroundColor: _secondaryColor,
                            foregroundColor: _textColor)),
                  )
                  .toList(),
              onSelected: (value) => {
                setState(() {
                  _selectedRound = TournamentRounds.values
                      .firstWhere((round) => round.name == value);
                })
              },
              trailingIcon: Icon(
                Icons.arrow_drop_down,
                color: _secondaryColor,
              ),
              menuStyle: MenuStyle(
                backgroundColor:
                    WidgetStateProperty.resolveWith((_) => _secondaryColor),
              ),
              textStyle: TextStyle(color: _textColor),
              inputDecorationTheme: InputDecorationTheme(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: _textColor),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                itemCount: 1,
                itemBuilder: (context, index) => ListenableBuilder(
                  listenable: viewModel.fixtures[index],
                  builder: (context, _) => _fixtureItem(
                    viewModel.fixtures.firstWhere(
                        (fixture) => fixture.name == _selectedRound.name),
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
            ...fixture.matches.map((match) => _matchItem(match)),
          ],
        ),
      );

  Widget _matchItem(SportMatch match) => Column(
        children: [
          Text(
            "${_formatDate(match.date)} - N/A",
            style: TextStyle(fontSize: 14, color: _secondaryColor),
          ),
          ListTile(
            title: Text(
              match.teamA.name,
              style: TextStyle(fontSize: 16, color: _textColor),
            ),
            trailing: Text(
              "${match.scoreA}",
              style: TextStyle(fontSize: 16, color: _textColor),
            ),
          ),
          ListTile(
            title: Text(
              match.teamB.name,
              style: TextStyle(fontSize: 16, color: _textColor),
            ),
            trailing: Text(
              "${match.scoreB}",
              style: TextStyle(fontSize: 16, color: _textColor),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
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
