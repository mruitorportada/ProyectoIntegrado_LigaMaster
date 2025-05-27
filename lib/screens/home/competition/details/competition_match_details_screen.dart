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
  late bool canEdit;
  CompetitionDetailsViewmodel get viewModel => widget.viewmodel;

  final Color _textColor = LightThemeAppColors.textColor;

  @override
  void initState() {
    canEdit = isCreator && !match.edited;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: myAppBar(
          context,
          "Detalles del partido",
          [
            if (canEdit)
              IconButton(
                onPressed: () async => await _showSaveMatchDialog(),
                icon: Icon(Icons.check),
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
          Divider(
            color: Theme.of(context).colorScheme.secondary,
          ),
          if (canEdit) _iconButtons(),
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

  Widget _iconButtons() => Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 16,
            children: [
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
            ],
          ),
          Divider(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ],
      );

  IconButton _matchDetailsIconButton(
          {required Icon icon, required void Function() onPressed}) =>
      IconButton(
        onPressed: onPressed,
        icon: icon,
        style: ButtonStyle(
          backgroundColor: WidgetStateColor.resolveWith(
            (_) => Theme.of(context).primaryColor,
          ),
        ),
      );

  Widget _eventsSection() => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          Expanded(
            child: _eventList(match.eventsTeamA, isTeamAEvents: true),
          ),
          Expanded(child: _eventList(match.eventsTeamB, isTeamAEvents: false)),
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
                  (player) => Card(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 12,
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
          return Theme.of(context).colorScheme.secondary;
        default:
          return null;
      }
    }
    return null;
  }

  FloatingActionButton get _floatingActionButton => FloatingActionButton(
        onPressed: () => _showEventSelectionDialog(),
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
                child: Row(
                  spacing: 10,
                  children: [
                    Text(
                      event.name,
                      style: TextStyle(color: _textColor),
                    ),
                    Image(
                      image: AssetImage(event.iconPath),
                      width: 20,
                      height: 20,
                      color: _getEventIconColor(event),
                    )
                  ],
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
                  style: TextStyle(color: _textColor),
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
            .where((player) =>
                player.playerStatus.statusName == "Disponible" &&
                (event != FootballEvents.assist
                    ? true
                    : !match.checkPlayerIsTheOnlyScorer(player)))
            .map(
              (player) => SimpleDialogOption(
                child: Text(
                  player.name,
                  style: TextStyle(color: _textColor),
                ),
                onPressed: () async {
                  Navigator.of(ctx).pop();
                  if (event == FootballEvents.injury ||
                      event == FootballEvents.redCard) {
                    int duration = await _showSuspensionDurationDialog();

                    String suspensionName = _getSuspensionName(event);

                    viewModel.setPlayerSuspension(
                        match, suspensionName, duration, player.id, team.name);
                  }
                  viewModel.addEventToMatch(match, event, player.name,
                      playerIsFromTeamA: match.teamA.name == team.name);
                },
              ),
            )
            .toList(),
      ),
    );
  }

  Future<int> _showSuspensionDurationDialog() async {
    int matchesAmount = 1;
    final TextEditingController matchesAmountController =
        TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          "Duración de la suspensión",
          style: TextStyle(color: _textColor),
        ),
        content: TextFormField(
          controller: matchesAmountController,
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Introduzca una duración";
            }

            if ((int.tryParse(value) ?? 1) > viewModel.competition.numMatches) {
              return "La duración no puede ser superior a ${viewModel.competition.numMatches}";
            }

            return null;
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              matchesAmount =
                  int.tryParse(matchesAmountController.value.text) ?? 1;
              Navigator.of(context).pop();
            },
            child: Text("Cerrar"),
          ),
        ],
      ),
    );
    return matchesAmount;
  }

  String _getSuspensionName(MatchEvents event) {
    if (event is FootballEvents) {
      return switch (event) {
        FootballEvents.injury => "Lesionado",
        FootballEvents.redCard => "Suspendido por expulsión",
        _ => ""
      };
    }
    return "";
  }

  Future<void> _showSaveMatchDialog() => showDialog(
        context: context,
        builder: (context) => simpleAlertDialog(
          context,
          title: "Atención",
          message:
              "¿Guardar el partido? NO podrás añadirle eventos de nuevo. Si quieres cambiar la fecha, pulsa el icono de la flecha y se guardará.",
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Cancelar",
                style: TextStyle(color: LightThemeAppColors.error),
              ),
            ),
            TextButton(
              onPressed: () async {
                bool success = await viewModel.saveMatchDetails(match, context);
                if (context.mounted) {
                  Navigator.of(context).pop();
                  if (success) Navigator.of(context).pop();
                }
              },
              child: Text(
                "Aceptar",
                style: TextStyle(
                    color: Theme.of(context)
                        .listTileTheme
                        .subtitleTextStyle
                        ?.color,
                    fontWeight: FontWeight.w600),
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
      );

  Future<TimeOfDay?> _selectMatchTime() => showTimePicker(
        context: context,
        errorInvalidText: "Selecciona una hora válida",
        initialEntryMode: TimePickerEntryMode.inputOnly,
        initialTime:
            TimeOfDay(hour: match.date.hour, minute: match.date.minute),
        builder: (context, child) => Theme(
          data: Theme.of(context),
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
