import 'package:flutter/material.dart';
import 'package:liga_master/models/competition/competition.dart';
import 'package:liga_master/screens/generic/appcolors.dart';
import 'package:liga_master/screens/home/competition/details/competition_details_screen.dart';
import 'package:liga_master/screens/home/home_screen_viewmodel.dart';

class CompetitionListScreen extends StatefulWidget {
  final HomeScreenViewmodel homeScreenViewModel;
  const CompetitionListScreen({super.key, required this.homeScreenViewModel});

  @override
  State<CompetitionListScreen> createState() => _CompetitionListScreenState();
}

class _CompetitionListScreenState extends State<CompetitionListScreen> {
  HomeScreenViewmodel get _homeScreenViewModel => widget.homeScreenViewModel;

  final Color _cardColor = AppColors.cardColor;
  final Color _iconColor = AppColors.icon;
  final Color _textColor = AppColors.text;
  final Color _subTextColor = AppColors.subtext;
  final Color _backgroundColor = AppColors.background;

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

  Widget get _body => competitionList();

  ListenableBuilder competitionList() => ListenableBuilder(
        listenable: _homeScreenViewModel,
        builder: (context, _) => ListView.builder(
          itemCount: _homeScreenViewModel.competitions.length,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          itemBuilder: (context, index) => ListenableBuilder(
            listenable: _homeScreenViewModel.competitions[index],
            builder: (context, _) => competitionItem(
                _homeScreenViewModel.onDeleteCompetition,
                _homeScreenViewModel.competitions[index]),
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
            builder: (context) => CompetitionDetailsScreen(
              competition: competition,
              isCreator: competition.creator.id == _homeScreenViewModel.user.id,
            ),
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
          style: TextStyle(color: _textColor),
        ),
        content: Text("¿Eliminar la competición?",
            style: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.7))),
        actions: [
          TextButton(
              onPressed: () => {
                    deleteCompetition(context, competition),
                    Navigator.of(context).pop()
                  },
              child: Text("Si", style: TextStyle(color: Colors.redAccent))),
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("No", style: TextStyle(color: _textColor))),
        ],
      ),
    );
  }

  void showAddDialog() {
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
            onPressed: () => _homeScreenViewModel.onCreateCompetition(context),
            child: Text(
              "Crear competición",
              style: TextStyle(color: _iconColor),
            ),
          ),
          TextButton(
            onPressed: () async => await showCompetitionCodeDialog(
                _homeScreenViewModel.addCompetitionByCode),
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
