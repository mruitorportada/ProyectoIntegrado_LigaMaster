import 'package:flutter/material.dart';
import 'package:liga_master/models/appstrings/appstrings.dart';
import 'package:liga_master/models/appstrings/appstrings_controller.dart';
import 'package:liga_master/models/fixture/fixture.dart';
import 'package:liga_master/models/match/sport_match.dart';
import 'package:liga_master/screens/generic/appcolors.dart';
import 'package:liga_master/screens/home/competition/details/competition_details_viewmodel.dart';
import 'package:liga_master/screens/home/competition/details/competition_match_details_screen.dart';
import 'package:provider/provider.dart';

class CompetitionFixturesScreen extends StatelessWidget {
  final CompetitionDetailsViewmodel viewModel;
  final bool isCreator;
  final bool isLeague;

  const CompetitionFixturesScreen(
      {super.key,
      required this.viewModel,
      required this.isCreator,
      required this.isLeague});

  final Color _textColor = LightThemeAppColors.textColor;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _body(context),
        floatingActionButton:
            isCreator && isLeague ? _floatingActionButton(context) : null,
      ),
    );
  }

  Widget _body(BuildContext context) {
    final controller =
        Provider.of<AppStringsController>(context, listen: false);
    final strings = controller.strings!;

    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) => viewModel.fixtures.isEmpty
          ? Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    strings.noFixturesMessage,
                    style: TextStyle(color: _textColor),
                  ),
                  if (!isLeague && isCreator)
                    _getTournamentFixtureGeneratorButton(strings, context)
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: viewModel.fixtures.length,
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    itemBuilder: (context, index) => ListenableBuilder(
                      listenable: viewModel.fixtures[index],
                      builder: (context, _) =>
                          _fixtureItem(viewModel.fixtures[index], context),
                    ),
                  ),
                ),
                if (!isLeague && isCreator)
                  Container(
                    padding: EdgeInsets.only(bottom: 10),
                    child:
                        _getTournamentFixtureGeneratorButton(strings, context),
                  )
              ],
            ),
    );
  }

  ElevatedButton _getTournamentFixtureGeneratorButton(
          AppStrings strings, BuildContext context) =>
      ElevatedButton(
        onPressed: () => viewModel.generateTournamentRound(
            false, List.from(viewModel.competition.teams), context),
        child: Text(
          viewModel.fixturesGenerated
              ? strings.resetTournamentButtonText
              : strings.generateNextRoundButtonText,
        ),
      );

  Widget _fixtureItem(Fixture fixture, BuildContext context) {
    final controller =
        Provider.of<AppStringsController>(context, listen: false);
    final strings = controller.strings!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isLeague
                ? "${strings.fixtureLabel} ${fixture.number}"
                : fixture.name,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _textColor,
            ),
          ),
          SizedBox(height: 8),
          ...fixture.matches.map(
            (match) => ListenableBuilder(
              listenable: match,
              builder: (context, _) => _matchItem(match, context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _matchItem(SportMatch match, BuildContext context) => Column(
        children: [
          Card(
            child: ListTile(
              title: Text(
                "${_formatDate(match.date, context)} - ${match.location.name}",
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              subtitle: Text(
                "${match.teamA.name} ${match.scoreA} : ${match.scoreB} ${match.teamB.name}",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CompetitionMatchDetailsScreen(
                    viewmodel: viewModel,
                    match: match,
                    isCreator: isCreator,
                  ),
                ),
              ),
            ),
          ),
        ],
      );

  String _formatDate(DateTime date, BuildContext context) =>
      "${date.day}/${date.month}/${date.year} ${TimeOfDay(hour: date.hour, minute: date.minute).format(context)}";

  FloatingActionButton _floatingActionButton(BuildContext context) =>
      FloatingActionButton(
        onPressed: () => _showCreateFixturesDialog(context),
        child: Icon(Icons.add),
      );

  void _showCreateFixturesDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    final appStringcontroller =
        Provider.of<AppStringsController>(context, listen: false);
    final strings = appStringcontroller.strings!;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          strings.generateFixturesText,
          style: TextStyle(color: _textColor),
        ),
        content: TextField(
          controller: controller,
          style: TextStyle(color: _textColor),
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: strings.numberOfTimesTeamsFaceEachOtherText,
            filled: false,
            border: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              strings.closeDialogText,
              style: TextStyle(color: LightThemeAppColors.error),
            ),
          ),
          TextButton(
            onPressed: () {
              final times = int.tryParse(controller.text) ?? 1;
              viewModel.leagueFixturesGenerator(times, context);
              Navigator.of(context).pop();
            },
            child: Text(
              strings.createFixtureButtonText,
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
