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
  final Color _cardColor = Color.fromRGBO(255, 255, 255, 0.05);
  final Color _iconColor = Color.fromARGB(255, 0, 204, 204);
  final Color _textColor = Colors.white;
  final Color _subTextColor = Color.fromRGBO(255, 255, 255, 0.7);
  final Color _backgroundColor = Color.fromARGB(255, 58, 17, 100);

  final TextEditingController _codeController = TextEditingController();
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
      GestureDetector(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                CompetitionDetailsScreen(competition: competition),
          ),
        ),
        onLongPress: () => showDeleteDialog(deleteCompetition, competition),
        child: Card(
          color: _cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          child: ListTile(
            title: Text(
              competition.name,
              style: TextStyle(color: _textColor),
            ),
            subtitle: Text(
                "${competition.format.name} de ${competition.competitionSport.name} - Creado por ${competition.creator.username}",
                style: TextStyle(color: _subTextColor)),
            trailing: Icon(
              getIconBasedOnFormat(competition.format),
              color: _iconColor,
            ),
          ),
        ),
      );

  FloatingActionButton get _floatingActionButton => FloatingActionButton(
        backgroundColor: _iconColor,
        foregroundColor: Colors.white,
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
              backgroundColor: _backgroundColor,
              title: Text(
                "Atención",
                style: TextStyle(color: Colors.white),
              ),
              content: Text("¿Eliminar la competición?",
                  style: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.7))),
              actions: [
                TextButton(
                    onPressed: () => {
                          deleteCompetition(context, competition),
                          Navigator.of(context).pop()
                        },
                    child:
                        Text("Si", style: TextStyle(color: Colors.redAccent))),
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text("No", style: TextStyle(color: Colors.white))),
              ],
            ));
  }

  void showAddDialog() {
    var homeScreenViewModel =
        Provider.of<HomeScreenViewmodel>(context, listen: false);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _backgroundColor,
        title: Text(
          "Añadir competición",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => homeScreenViewModel
                .onEditCompetition(context, Competition(id: ""), isNew: true),
            child: Text(
              "Crear competición",
              style: TextStyle(color: _iconColor),
            ),
          ),
          TextButton(
            onPressed: () async => await showCompetitionCodeDialog(
                homeScreenViewModel.addCompetitionByCode),
            child: Text(
              "Añadir competición de otro usuario",
              style: TextStyle(color: _iconColor),
            ),
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
        backgroundColor: _backgroundColor,
        title: Text(
          "Añadir competición de otro usuario",
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: _codeController,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
              labelText: "Insertar código",
              labelStyle: TextStyle(color: Colors.white)),
        ),
        actions: [
          TextButton(
            onPressed: () {
              onAddCompetitionByCode(
                  context, _codeController.value.text.trim());
              Navigator.of(context).pop();
            },
            child: Text(
              "Aceptar",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }

  IconData getIconBasedOnFormat(CompetitionFormat format) => switch (format) {
        CompetitionFormat.league => Icons.calendar_month,
        CompetitionFormat.tournament => Icons.emoji_events
      };
}
