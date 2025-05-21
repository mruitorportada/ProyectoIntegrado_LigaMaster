import "package:flutter/material.dart";
import "package:liga_master/models/enums.dart";
import "package:liga_master/models/match/sport_match.dart";
import "package:liga_master/models/user/entities/user_team.dart";
import "package:liga_master/screens/generic/appcolors.dart";
import "package:liga_master/screens/generic/generic_widgets/generic_selection_dialog.dart";
import "package:liga_master/screens/generic/generic_widgets/simple_alert_dialog.dart";
import "package:liga_master/screens/generic/generic_widgets/myappbar.dart";
import "package:liga_master/screens/home/competition/details/competition_details_viewmodel.dart";
import "package:liga_master/screens/home/competition/details/map_location_picker.dart";

class CompetitionMatchDetailsScreen extends StatefulWidget {
  final SportMatch match;
  final CompetitionDetailsViewmodel viewmodel;
  final bool isCreator;

  const CompetitionMatchDetailsScreen(
      {super.key,
      required this.match,
      required this.viewmodel,
      required this.isCreator});

  @override
  State<CompetitionMatchDetailsScreen> createState() =>
      _CompetitionMatchDetailsScreenState();
}

class _CompetitionMatchDetailsScreenState
    extends State<CompetitionMatchDetailsScreen> {
  SportMatch get match => widget.match;
  bool get isCreator => widget.isCreator;
  CompetitionDetailsViewmodel get viewModel => widget.viewmodel;

  final Color _backgroundColor = AppColors.background;
  final Color _textColor = AppColors.textColor;
  final Color _secondaryColor = AppColors.accent;

  @override
  Widget build(BuildContext context) {
    bool canEdit = isCreator && !match.edited;
    return SafeArea(
      child: Scaffold(
        appBar: myAppBar(
          "Detalles del partido",
          _backgroundColor,
          [
            if (canEdit)
              IconButton(
                onPressed: () async => {
                  await _showSaveMatchDialog(),
                },
                icon: Icon(Icons.check),
                color: _secondaryColor,
              )
          ],
          IconButton(
            onPressed: () {
              if (canEdit) {
                viewModel.discardChanges(match);
              }
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back),
          ),
        ),
        backgroundColor: _backgroundColor,
        body: _body,
        floatingActionButton: canEdit ? _floatingActionButton : null,
      ),
    );
  }

  Widget get _body {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) => Column(
        children: <Widget>[
          _header(),
          Divider(color: _secondaryColor),
          _iconButtons(),
          if (isCreator)
            Divider(
              color: _secondaryColor,
            ),
          SizedBox(height: 10),
          _eventsSection(),
        ],
      ),
    );
  }

  Widget _header() => ListTile(
        title: Center(
          child: Text(
            "${match.teamA.name} ${match.scoreA} : ${match.scoreB} ${match.teamB.name}",
            style: TextStyle(
              color: _textColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        subtitle: Center(
          child: Text(
            "${match.location.name} : ${match.location.address}",
            style: TextStyle(
              color: _textColor,
              fontSize: 12,
            ),
          ),
        ),
      );

  Widget _iconButtons() => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 16,
        children: isCreator
            ? [
                SizedBox(
                  height: 40,
                  width: 70,
                  child: _matchDetailsIconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () async {
                      final dateSelected = await _selectMatchDate();
                      if (dateSelected == null) {
                        return;
                      }
                      final timeSelected = await _selectMatchTime();
                      if (timeSelected == null) {
                        return;
                      }

                      final date = DateTime(
                        dateSelected.year,
                        dateSelected.month,
                        dateSelected.day,
                        timeSelected.hour,
                        timeSelected.minute,
                      );

                      if (context.mounted) {
                        setState(
                          () {
                            viewModel.updateMatchDate(match, date, context);
                          },
                        );
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 40,
                  width: 70,
                  child: _matchDetailsIconButton(
                    icon: Icon(Icons.location_on),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => MatchLocationPicker(
                            match: match,
                            viewModel: viewModel,
                          ),
                        ),
                      );
                    },
                  ),
                )
              ]
            : [],
      );

  IconButton _matchDetailsIconButton(
          {required Icon icon, required void Function() onPressed}) =>
      IconButton(
        onPressed: onPressed,
        icon: icon,
        color: _textColor,
        style: ButtonStyle(
          backgroundColor: WidgetStateColor.resolveWith((_) => _secondaryColor),
        ),
      );

  Widget _eventsSection() => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _eventList(match.eventsTeamA, isTeamAEvents: true),
          ),
          _eventList(match.eventsTeamB, isTeamAEvents: false),
        ],
      );

  Widget _eventList(Map<MatchEvents, List<String>> events,
          {bool isTeamAEvents = false}) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          crossAxisAlignment:
              isTeamAEvents ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: events.entries.expand(
            (entry) {
              final event = entry.key;
              final eventIconPath = entry.key.iconPath;
              final playersName = entry.value;
              return [
                ...playersName.map(
                  (player) => Row(
                    spacing: 8,
                    children: [
                      Text(
                        player,
                        style: TextStyle(
                          color: _textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Image(
                        image: AssetImage(eventIconPath),
                        width: 20,
                        height: 20,
                        color: _getEventIconColor(event),
                      )
                    ],
                  ),
                ),
              ];
            },
          ).toList(),
        ),
      );

  Color? _getEventIconColor(MatchEvents event) {
    if (event is FootballEvents) {
      switch (event) {
        case FootballEvents.goal ||
              FootballEvents.assist ||
              FootballEvents.playerSubstitution:
          return _secondaryColor;
        default:
          return null;
      }
    }
    return null;
  }

  FloatingActionButton get _floatingActionButton => FloatingActionButton(
        onPressed: () => _showEventSelectionDialog(),
        backgroundColor: _secondaryColor,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
      );

  void _showEventSelectionDialog() {
    bool teamAHasGoalEvent =
        match.eventsTeamA.keys.contains(FootballEvents.goal);
    bool teamBHasGoalEvent =
        match.eventsTeamB.keys.contains(FootballEvents.goal);

    int assistsTeamA = 0;
    int assistsTeamB = 0;

    if (match.eventsTeamA.keys.contains(FootballEvents.assist)) {
      MapEntry<MatchEvents, List<String>> assistsEntryA = match
          .eventsTeamA.entries
          .firstWhere((entry) => entry.key == FootballEvents.assist);

      assistsTeamA = assistsEntryA.value.length;
    }

    if (match.eventsTeamB.keys.contains(FootballEvents.assist)) {
      MapEntry<MatchEvents, List<String>>? assistsEntryB = match
          .eventsTeamB.entries
          .firstWhere((entry) => entry.key == FootballEvents.assist);

      assistsTeamB = assistsEntryB.value.length;
    }

    showDialog(
      context: context,
      builder: (ctx) => genericSelectionDialog(
        "Selecciona un evento",
        options: FootballEvents.values
            .where(
              (event) => (!teamAHasGoalEvent && !teamBHasGoalEvent)
                  ? event != FootballEvents.assist
                  : (match.scoreA > assistsTeamA || match.scoreB > assistsTeamB)
                      ? true
                      : event != FootballEvents.assist,
            )
            .map(
              (event) => SimpleDialogOption(
                child: Text(
                  event.name,
                  style: TextStyle(color: _secondaryColor),
                ),
                onPressed: () {
                  Navigator.of(ctx).pop();
                  _showTeamSelectionDialog(
                    event,
                    List.from(
                      [match.teamA, match.teamB],
                    ),
                    teamAHasGoalEvent: teamAHasGoalEvent,
                    teamBHasGoalEvent: teamBHasGoalEvent,
                  );
                },
              ),
            )
            .toList(),
      ),
    );
  }

  void _showTeamSelectionDialog(FootballEvents event, List<UserTeam> teams,
      {required bool teamAHasGoalEvent, required bool teamBHasGoalEvent}) {
    showDialog(
      context: context,
      builder: (ctx) => genericSelectionDialog(
        "Selecciona equipo",
        options: teams
            .where(
              (team) => event != FootballEvents.assist
                  ? true
                  : match.checkTeamHasScoredAndAssistsAreLessThanGoals(team),
            )
            .map(
              (team) => SimpleDialogOption(
                child: Text(
                  team.name,
                  style: TextStyle(color: _secondaryColor),
                ),
                onPressed: () {
                  Navigator.of(ctx).pop();
                  _showPlayerSelectionDialog(event, team);
                },
              ),
            )
            .toList(),
      ),
    );
  }

  void _showPlayerSelectionDialog(MatchEvents event, UserTeam team) {
    final players = team.players;

    showDialog(
      context: context,
      builder: (ctx) => genericSelectionDialog(
        "Selecciona jugador",
        options: players
            .where((player) => event != FootballEvents.assist
                ? true
                : !match.checkPlayerIsTheOnlyScorer(player))
            .map((player) => SimpleDialogOption(
                  child: Text(
                    player.name,
                    style: TextStyle(color: _secondaryColor),
                  ),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    viewModel.addEventToMatch(match, event, player.name,
                        playerIsFromTeamA: match.teamA.name == team.name);
                  },
                ))
            .toList(),
      ),
    );
  }

  Future<void> _showSaveMatchDialog() => showDialog(
        context: context,
        builder: (context) => simpleAlertDialog(
          title: "Atención",
          message:
              "¿Guardar el partido? NO podrás añadirle eventos de nuevo. Si quieres cambiar la fecha, pulsa el icono de la flecha y se guardará.",
          actions: [
            TextButton(
              onPressed: () {
                viewModel.discardChanges(match);
                Navigator.of(context).pop();
              },
              child: Text(
                "Cancelar",
                style: TextStyle(color: AppColors.error),
              ),
            ),
            TextButton(
              onPressed: () {
                viewModel.saveMatchDetails(match, context);
                Navigator.of(context).pop();
              },
              child: Text(
                "Aceptar",
                style: TextStyle(color: _secondaryColor),
              ),
            ),
          ],
        ),
      );

  Future<DateTime?> _selectMatchDate() => showDatePicker(
        context: context,
        errorInvalidText: "Selecciona una fecha válida",
        initialDate: match.date,
        firstDate: match.date,
        lastDate: DateTime(2100),
        builder: (context, child) => Theme(
          data: Theme.of(context).copyWith(
            datePickerTheme: DatePickerThemeData(
              backgroundColor: _secondaryColor,
              headerForegroundColor: _textColor,
              dividerColor: _textColor,
              yearForegroundColor: _getPickerStateProperty(),
              dayForegroundColor: _getPickerStateProperty(),
              weekdayStyle: TextStyle(color: _backgroundColor),
              inputDecorationTheme: InputDecorationTheme(
                labelStyle: TextStyle(color: _textColor),
                outlineBorder: BorderSide(color: _textColor),
              ),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: _textColor),
            ),
          ),
          child: child!,
        ),
      );

  WidgetStateProperty<Color> _getPickerStateProperty() =>
      WidgetStateColor.resolveWith((_) => _textColor);

  Future<TimeOfDay?> _selectMatchTime() => showTimePicker(
        context: context,
        errorInvalidText: "Selecciona una hora válida",
        initialEntryMode: TimePickerEntryMode.inputOnly,
        initialTime:
            TimeOfDay(hour: match.date.hour, minute: match.date.minute),
        builder: (context, child) => Theme(
          data: Theme.of(context).copyWith(
            inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: _backgroundColor,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: _backgroundColor,
                ),
              ),
              outlineBorder: BorderSide(color: _textColor),
              contentPadding: EdgeInsets.all(4),
            ),
            timePickerTheme: TimePickerThemeData(
              inputDecorationTheme: InputDecorationTheme(
                hintStyle: TextStyle(color: _textColor),
                labelStyle: TextStyle(color: _textColor),
              ),
              backgroundColor: _secondaryColor,
              helpTextStyle: TextStyle(color: _textColor),
              hourMinuteTextColor: _textColor,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: _textColor),
            ),
          ),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(alwaysUse24HourFormat: true),
                child: child!),
          ),
        ),
      );
}
