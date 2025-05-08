import 'package:flutter/material.dart';
import 'package:liga_master/models/fixture/fixture.dart';
import 'package:liga_master/screens/generic/appcolors.dart';
import 'package:liga_master/screens/home/competition/details/competition_details_viewmodel.dart';
import 'package:liga_master/screens/home/competition/details/competition_match_details_screen.dart';

class CompetitionFixturesScreen extends StatefulWidget {
  final CompetitionDetailsViewmodel viewmodel;
  const CompetitionFixturesScreen({super.key, required this.viewmodel});

  @override
  State<CompetitionFixturesScreen> createState() =>
      _CompetitionFixturesScreenState();
}

class _CompetitionFixturesScreenState extends State<CompetitionFixturesScreen> {
  CompetitionDetailsViewmodel get viewModel => widget.viewmodel;

  final Color _backgroundColor = AppColors.background;
  final Color _textColor = AppColors.text;
  final Color _iconColor = AppColors.icon;
  final Color _subTextColor = AppColors.subtext;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: _backgroundColor,
        body: _body,
        floatingActionButton: _floatingActionButton,
      ),
    );
  }

  Widget get _body {
    return ListenableBuilder(
      listenable: viewModel.competition,
      builder: (context, _) => viewModel.fixtures.isEmpty
          ? Center(
              child: Text(
                "No hay jornadas creadas",
                style: TextStyle(color: _textColor),
              ),
            )
          : ListView.builder(
              itemCount: viewModel.fixtures.length,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              itemBuilder: (context, index) => ListenableBuilder(
                listenable: viewModel.fixtures[index],
                builder: (context, _) => fixtureItem(
                  viewModel.fixtures[index],
                ),
              ),
            ),
    );
  }

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
                              viewmodel: viewModel, match: match),
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
  String _formatDate(DateTime date) => "${date.day}/${date.month}/${date.year}";

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
              labelText: "Veces que se enfrentan",
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
              viewModel.leagueFixturesGenerator(times);
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
