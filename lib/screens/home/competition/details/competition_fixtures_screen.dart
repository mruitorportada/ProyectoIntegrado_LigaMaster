import 'package:flutter/material.dart';
import 'package:liga_master/models/fixture/fixture.dart';
import 'package:liga_master/screens/generic/appcolors.dart';
import 'package:liga_master/screens/home/competition/details/competition_details_viewmodel.dart';
import 'package:liga_master/screens/home/competition/details/competition_match_details_screen.dart';

class CompetitionFixturesScreen extends StatefulWidget {
  final CompetitionDetailsViewmodel viewmodel;
  final bool isCreator;
  final bool isLeague;
  const CompetitionFixturesScreen(
      {super.key,
      required this.viewmodel,
      required this.isCreator,
      required this.isLeague});

  @override
  State<CompetitionFixturesScreen> createState() =>
      _CompetitionFixturesScreenState();
}

class _CompetitionFixturesScreenState extends State<CompetitionFixturesScreen> {
  CompetitionDetailsViewmodel get viewModel => widget.viewmodel;
  bool get isCreator => widget.isCreator;
  bool get isLeague => widget.isLeague;

  final Color _backgroundColor = AppColors.background;
  final Color _textColor = AppColors.text;
  final Color _iconColor = AppColors.icon;
  final Color _subTextColor = AppColors.subtext;
  bool fixtureHasTwoLegs = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: _backgroundColor,
        body: _body,
        floatingActionButton:
            isCreator && isLeague ? _floatingActionButton : null,
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
                    _getTournamentFixtureGeneratorButton()
                ],
              ),
            )
          : Column(
              //mainAxisSize: MainAxisSize.min,
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
                    child: _getTournamentFixtureGeneratorButton(),
                  )
              ],
            ),
    );
  }

  ElevatedButton _getTournamentFixtureGeneratorButton() => ElevatedButton(
        onPressed: () => viewModel.generateTournamentRound(
            fixtureHasTwoLegs, List.from(viewModel.competition.teams), context),
        style: ElevatedButton.styleFrom(backgroundColor: _iconColor),
        child: Text(
          viewModel.fixturesGenerated
              ? "Reiniciar torneo"
              : "Generar siguiente ronda",
          style: TextStyle(color: _textColor),
        ),
      );

  Widget fixtureItem(Fixture fixture) => Padding(
        padding: const EdgeInsets.all(12),
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
                builder: (context, _) => Column(
                  children: [
                    ListTile(
                      title: Text(
                        "${_formatDate(match.date)} - N/A",
                        style: TextStyle(fontSize: 14, color: _iconColor),
                      ),
                      subtitle: Text(
                        "${match.teamA.name} ${match.scoreA} : ${match.scoreB} ${match.teamB.name}",
                        style: TextStyle(fontSize: 16, color: _subTextColor),
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
                    Divider(
                      height: 2,
                      color: _iconColor,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  String _formatDate(DateTime date) =>
      "${date.day}/${date.month}/${date.year} ${TimeOfDay(hour: date.hour, minute: date.minute).format(context)}";

  FloatingActionButton get _floatingActionButton => FloatingActionButton(
        onPressed: () => _showCreateFixturesDialog(),
        backgroundColor: _iconColor,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
      );

  void _showCreateFixturesDialog() {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: _backgroundColor,
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
              labelStyle: TextStyle(color: _subTextColor)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              "Cancelar",
              style: TextStyle(color: AppColors.error),
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
              style: TextStyle(color: _iconColor),
            ),
          ),
        ],
      ),
    );
  }
}
