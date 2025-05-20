import 'package:flutter/material.dart';
import 'package:liga_master/models/competition/competition.dart';
import 'package:liga_master/screens/generic/appcolors.dart';
import 'package:liga_master/screens/generic/generic_widgets/simple_alert_dialog.dart';
import 'package:liga_master/screens/home/competition/details/competition_details_screen.dart';
import 'package:liga_master/screens/home/home_screen_viewmodel.dart';

class CompetitionListScreen extends StatelessWidget {
  final HomeScreenViewmodel homeScreenViewModel;
  CompetitionListScreen({super.key, required this.homeScreenViewModel});

  final Color _cardColor = AppColors.cardColor;

  final Color _iconColor = AppColors.accent;

  final Color _textColor = AppColors.textColor;

  final Color _subTextColor = AppColors.subtextColor;

  final Color _backgroundColor = AppColors.background;

  final TextEditingController _codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: _backgroundColor,
        body: _body,
        floatingActionButton: _floatingActionButton(context),
      ),
    );
  }

  Widget get _body => competitionList();

  ListenableBuilder competitionList() => ListenableBuilder(
        listenable: homeScreenViewModel,
        builder: (context, _) => ListView.builder(
          itemCount: homeScreenViewModel.competitions.length,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          itemBuilder: (context, index) => ListenableBuilder(
            listenable: homeScreenViewModel.competitions[index],
            builder: (context, _) => competitionItem(
                context,
                homeScreenViewModel.onDeleteCompetition,
                homeScreenViewModel.competitions[index]),
          ),
        ),
      );

  Widget competitionItem(
          BuildContext context,
          void Function(BuildContext context, Competition competition)
              deleteCompetition,
          Competition competition) =>
      GestureDetector(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CompetitionDetailsScreen(
              competition: competition,
              isCreator: competition.creator.id == homeScreenViewModel.user.id,
            ),
          ),
        ),
        onLongPress: () =>
            showDeleteDialog(context, deleteCompetition, competition),
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

  FloatingActionButton _floatingActionButton(BuildContext context) =>
      FloatingActionButton(
        backgroundColor: _iconColor,
        foregroundColor: Colors.white,
        onPressed: () => showAddDialog(context),
        child: Icon(Icons.add),
      );

  void showDeleteDialog(
      BuildContext context,
      void Function(BuildContext context, Competition competition)
          deleteCompetition,
      Competition competition) {
    showDialog(
      context: context,
      builder: (context) => simpleAlertDialog(
        title: "Atención",
        message: "¿Eliminar la competición?",
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

  void showAddDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => simpleAlertDialog(
        title: "Añadir competición",
        actions: [
          TextButton(
            onPressed: () => homeScreenViewModel.onCreateCompetition(context),
            child: Text(
              "Crear competición",
              style: TextStyle(color: _iconColor),
            ),
          ),
          TextButton(
            onPressed: () async => await showCompetitionCodeDialog(
                context, homeScreenViewModel.addCompetitionByCode),
            child: Text(
              "Añadir competición de otro usuario",
              style: TextStyle(color: _iconColor),
            ),
          )
        ],
      ),
    );
  }

  Future<void> showCompetitionCodeDialog(BuildContext context,
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
