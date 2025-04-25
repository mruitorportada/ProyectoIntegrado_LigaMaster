import 'package:flutter/material.dart';
import 'package:liga_master/models/competition/competition.dart';
import 'package:liga_master/screens/home/competition/details/competition_details_screen.dart';
import 'package:liga_master/screens/home/home_screen_viewmodel.dart';
import 'package:provider/provider.dart';

class CompetitionListScreen extends StatefulWidget {
  const CompetitionListScreen({super.key});

  @override
  State<CompetitionListScreen> createState() => _CompetitionListScreenState();
}

class _CompetitionListScreenState extends State<CompetitionListScreen> {
  final TextEditingController _codeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _body,
        floatingActionButton: _floatingActionButton,
      ),
    );
  }

  Widget get _body {
    var homeScreenViewModel =
        Provider.of<HomeScreenViewmodel>(context, listen: false);
    return competitionList(homeScreenViewModel);
  }

  ListenableBuilder competitionList(HomeScreenViewmodel homeScreenViewModel) =>
      ListenableBuilder(
        listenable: homeScreenViewModel,
        builder: (context, _) => ListView.builder(
          itemCount: homeScreenViewModel.competitions.length,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          itemBuilder: (context, index) => ListenableBuilder(
            listenable: homeScreenViewModel.competitions[index],
            builder: (context, _) => competitionItem(
                homeScreenViewModel.onDeleteCompetition,
                homeScreenViewModel.competitions[index]),
          ),
        ),
      );

  Widget competitionItem(
          void Function(BuildContext context, Competition competition)
              deleteCompetition,
          Competition competition) =>
      Card(
        child: GestureDetector(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  CompetitionDetailsScreen(competition: competition),
            ),
          ),
          onLongPress: () => showDeleteDialog(deleteCompetition, competition),
          child: ListTile(
            title: Text(competition.name),
            subtitle: Text(
                "${competition.format.name} de ${competition.competitionSport.name} - Creado por ${competition.creator.username}"),
            trailing: Icon(
              getIconBasedOnFormat(competition.format),
            ),
          ),
        ),
      );

  FloatingActionButton get _floatingActionButton => FloatingActionButton(
        onPressed: () => showAddDialog(),
        child: Icon(Icons.add),
      );

  void showDeleteDialog(
      void Function(BuildContext context, Competition competition)
          deleteCompetition,
      Competition competition) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Atención"),
              content: Text("¿Eliminar la competición?"),
              actions: [
                TextButton(
                    onPressed: () => {
                          deleteCompetition(context, competition),
                          Navigator.of(context).pop()
                        },
                    child: Text("Si")),
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text("No")),
              ],
            ));
  }

  void showAddDialog() {
    var homeScreenViewModel =
        Provider.of<HomeScreenViewmodel>(context, listen: false);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Añadir competición"),
        actions: [
          TextButton(
            onPressed: () => homeScreenViewModel
                .onEditCompetition(context, Competition(id: ""), isNew: true),
            child: Text("Crear competición"),
          ),
          TextButton(
            onPressed: () async => await showCompetitionCodeDialog(
                homeScreenViewModel.addCompetitionByCode),
            child: Text("Añadir competición de otro usuario"),
          )
        ],
      ),
    );
  }

  Future<void> showCompetitionCodeDialog(
      void Function(BuildContext, String) onAddCompetitionByCode) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
          title: Text("Añadir competición de otro usuario"),
          content: Column(
            children: <Widget>[
              TextFormField(
                controller: _codeController,
                decoration: InputDecoration(labelText: "Insertar código"),
              ),
              TextButton(
                onPressed: () {
                  onAddCompetitionByCode(context, _codeController.value.text);
                  Navigator.of(context).pop();
                },
                child: Text("Aceptar"),
              )
            ],
          )),
    );
  }

  IconData getIconBasedOnFormat(CompetitionFormat format) => switch (format) {
        CompetitionFormat.league => Icons.calendar_month,
        CompetitionFormat.tournament => Icons.emoji_events
      };
}
