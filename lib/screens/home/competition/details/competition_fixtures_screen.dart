import 'package:flutter/material.dart';
import 'package:liga_master/models/fixture/fixture.dart';
import 'package:liga_master/models/match/sport_match.dart';
import 'package:liga_master/screens/generic/appcolors.dart';
import 'package:liga_master/screens/home/competition/details/competition_details_viewmodel.dart';
import 'package:liga_master/screens/home/competition/details/competition_match_details_screen.dart';

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

  final Color _secondaryColor = LightThemeAppColors.secondaryColor;

  //bool fixtureHasTwoLegs = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _body,
        floatingActionButton:
            isCreator && isLeague ? _floatingActionButton(context) : null,
      ),
    );
  }

  Widget get _body {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) => viewModel.fixtures.isEmpty
          ? Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "No hay jornadas creadas",
                    style: TextStyle(color: _textColor),
                  ),
                  if (!isLeague && isCreator)
                    _getTournamentFixtureGeneratorButton(context)
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
                      builder: (context, _) => fixtureItem(
                        viewModel.fixtures[index],
                      ),
                    ),
                  ),
                ),
                if (!isLeague && isCreator)
                  Container(
                    padding: EdgeInsets.only(bottom: 10),
                    child: _getTournamentFixtureGeneratorButton(context),
                  )
              ],
            ),
    );
  }

  ElevatedButton _getTournamentFixtureGeneratorButton(BuildContext context) =>
      ElevatedButton(
        onPressed: () => viewModel.generateTournamentRound(
            false, List.from(viewModel.competition.teams), context),
        child: Text(
          viewModel.fixturesGenerated
              ? "Reiniciar torneo"
              : "Generar siguiente ronda",
        ),
      );

  Widget fixtureItem(Fixture fixture) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
              (match) => ListenableBuilder(
                listenable: match,
                builder: (context, _) => _matchItem(match, context),
              ),
            ),
          ],
        ),
      );

  Widget _matchItem(SportMatch match, BuildContext context) => Column(
        children: [
          Card(
            child: ListTile(
              title: Text(
                "${_formatDate(match.date, context)} - ${match.location.name}",
                style: TextStyle(fontSize: 14, color: _secondaryColor),
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

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          "Crear Jornadas",
          style: TextStyle(color: _textColor),
        ),
        content: TextField(
          controller: controller,
          style: TextStyle(color: _textColor),
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: "Numero de veces que se enfrentan",
            filled: false,
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: _secondaryColor),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: _secondaryColor),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              "Cancelar",
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
              "Crear",
              style: TextStyle(color: _secondaryColor),
            ),
          ),
        ],
      ),
    );
  }
}
