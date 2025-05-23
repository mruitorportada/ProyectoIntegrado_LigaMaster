import 'package:flutter/material.dart';
import 'package:liga_master/models/competition/competition.dart';
import 'package:liga_master/screens/generic/appcolors.dart';
import 'package:liga_master/screens/generic/generic_widgets/generic_card.dart';
import 'package:liga_master/screens/generic/generic_widgets/simple_alert_dialog.dart';
import 'package:liga_master/screens/home/competition/details/competition_details_screen.dart';
import 'package:liga_master/screens/home/home_screen_viewmodel.dart';

class CompetitionListScreen extends StatelessWidget {
  final HomeScreenViewmodel homeScreenViewModel;
  CompetitionListScreen({super.key, required this.homeScreenViewModel});

  final Color _secondaryColor = LightThemeAppColors.secondaryColor;
  final Color _textColor = LightThemeAppColors.textColor;
  final Color _backgroundColor = LightThemeAppColors.background;
  final Color _labelColor = LightThemeAppColors.labeltextColor;

  final TextEditingController _codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
        child: genericCard(
          title: competition.name,
          subtitle:
              "${competition.format.name} de ${competition.competitionSport.name} - Creador: ${competition.creator.username}",
          trailIcon: getIconBasedOnFormat(competition.format),
        ),
      );

  FloatingActionButton _floatingActionButton(BuildContext context) =>
      FloatingActionButton(
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
            child: Text(
              "Si",
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              "No",
              style: TextStyle(color: Colors.white),
            ),
          ),
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
              style: TextStyle(color: LightThemeAppColors.textColor),
            ),
          ),
          TextButton(
            onPressed: () async => await showCompetitionCodeDialog(
                context, homeScreenViewModel.addCompetitionByCode),
            child: Text(
              "Añadir competición de otro usuario",
              style: TextStyle(color: LightThemeAppColors.textColor),
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
          style: TextStyle(color: _textColor),
        ),
        content: TextField(
          controller: _codeController,
          style: TextStyle(color: _textColor),
          decoration: InputDecoration(
            labelText: "Insertar código",
            labelStyle: TextStyle(color: _labelColor),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: _secondaryColor),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: _secondaryColor),
            ),
          ),
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
