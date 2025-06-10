import 'package:flutter/material.dart';
import 'package:liga_master/models/appstrings/appstrings_controller.dart';
import 'package:liga_master/models/competition/competition.dart';
import 'package:liga_master/screens/generic/appcolors.dart';
import 'package:liga_master/screens/generic/functions.dart';
import 'package:liga_master/screens/generic/generic_widgets/generic_card.dart';
import 'package:liga_master/screens/generic/generic_widgets/simple_alert_dialog.dart';
import 'package:liga_master/screens/home/competition/details/competition_details_screen.dart';
import 'package:liga_master/screens/home/home_screen_viewmodel.dart';
import 'package:provider/provider.dart';

class CompetitionListScreen extends StatelessWidget {
  final HomeScreenViewmodel homeScreenViewModel;
  CompetitionListScreen({super.key, required this.homeScreenViewModel});

  final Color _textColor = LightThemeAppColors.textColor;
  final Color _labelColor = LightThemeAppColors.labeltextColor;

  final TextEditingController _codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _body(context),
        floatingActionButton: _floatingActionButton(context),
      ),
    );
  }

  Widget _body(BuildContext context) => _competitionList(context);

  ListenableBuilder _competitionList(BuildContext context) {
    final controller =
        Provider.of<AppStringsController>(context, listen: false);
    final strings = controller.strings!;
    return ListenableBuilder(
      listenable: homeScreenViewModel,
      builder: (context, _) => homeScreenViewModel.competitions.isEmpty
          ? Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Center(
                child: Text(strings.noCompetitionsMessage),
              ),
            )
          : ListView.builder(
              itemCount: homeScreenViewModel.competitions.length,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              itemBuilder: (context, index) => ListenableBuilder(
                listenable: homeScreenViewModel.competitions[index],
                builder: (context, _) => _competitionItem(
                    context,
                    homeScreenViewModel.onDeleteCompetition,
                    homeScreenViewModel.competitions[index]),
              ),
            ),
    );
  }

  Widget _competitionItem(
      BuildContext context,
      void Function(BuildContext context, Competition competition)
          deleteCompetition,
      Competition competition) {
    final controller =
        Provider.of<AppStringsController>(context, listen: false);
    final strings = controller.strings!;
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CompetitionDetailsScreen(
            competition: competition,
            isCreator: competition.creator.id == homeScreenViewModel.user.id,
          ),
        ),
      ),
      onLongPress: () =>
          _showDeleteDialog(context, deleteCompetition, competition),
      child: genericCard(
        title: competition.name,
        subtitle:
            "${getCompetitionFormatLabel(strings, competition.format)}, ${getSportLabel(strings, competition.competitionSport)} - ${strings.creatorLabel}: ${competition.creator.username}",
        trailIcon: Icon(_getIconBasedOnFormat(competition.format)),
      ),
    );
  }

  FloatingActionButton _floatingActionButton(BuildContext context) =>
      FloatingActionButton(
        foregroundColor: Colors.white,
        onPressed: () => _showAddDialog(context),
        child: Icon(Icons.add),
      );

  void _showDeleteDialog(
      BuildContext context,
      void Function(BuildContext context, Competition competition)
          deleteCompetition,
      Competition competition) {
    final controller =
        Provider.of<AppStringsController>(context, listen: false);
    final strings = controller.strings!;

    showDialog(
      context: context,
      builder: (context) => simpleAlertDialog(
        context,
        title: strings.deleteItemDialogTitle,
        message: strings.deleteCompetitionText,
        actions: [
          TextButton(
            onPressed: () => {
              deleteCompetition(context, competition),
              Navigator.of(context).pop()
            },
            child: Text(
              strings.acceptDialogButtonText,
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              strings.cancelTextButton,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final controller =
        Provider.of<AppStringsController>(context, listen: false);

    final strings = controller.strings!;
    showDialog(
      context: context,
      builder: (context) => simpleAlertDialog(
        context,
        title: strings.addCompetitionByCodeLabel,
        actions: [
          TextButton(
            onPressed: () => homeScreenViewModel.onCreateCompetition(context),
            child: Text(
              strings.addCompetitionText,
              style: TextStyle(color: LightThemeAppColors.textColor),
            ),
          ),
          TextButton(
            onPressed: () async => await _showCompetitionCodeDialog(
                context, homeScreenViewModel.addCompetitionByCode),
            child: Text(
              strings.addCompetitionByCodeText,
              style: TextStyle(color: LightThemeAppColors.textColor),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _showCompetitionCodeDialog(
      BuildContext context,
      void Function(BuildContext, String, {required Color toastColor})
          onAddCompetitionByCode) async {
    final controller =
        Provider.of<AppStringsController>(context, listen: false);

    final strings = controller.strings!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          strings.addCompetitionByCodeText,
          style: TextStyle(color: _textColor),
        ),
        content: TextField(
          controller: _codeController,
          style: TextStyle(color: _textColor),
          decoration: InputDecoration(
            labelText: strings.insertCodeLabel,
            labelStyle: TextStyle(color: _labelColor),
            focusedBorder: UnderlineInputBorder(
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
          keyboardType: TextInputType.visiblePassword,
        ),
        actions: [
          TextButton(
            onPressed: () {
              onAddCompetitionByCode(
                context,
                _codeController.value.text.trim(),
                toastColor: Theme.of(context).scaffoldBackgroundColor,
              );
              _codeController.text = "";
              Navigator.of(context).pop();
            },
            child: Text(
              strings.acceptDialogButtonText,
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }

  IconData _getIconBasedOnFormat(CompetitionFormat format) => switch (format) {
        CompetitionFormat.league => Icons.calendar_month,
        CompetitionFormat.tournament => Icons.emoji_events
      };
}
