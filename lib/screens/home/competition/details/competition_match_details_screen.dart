import "package:flutter/material.dart";
import "package:liga_master/models/enums.dart";
import "package:liga_master/models/match/match.dart";
import "package:liga_master/screens/generic/appcolors.dart";
import "package:liga_master/screens/generic/generic_widgets/myappbar.dart";
import "package:liga_master/screens/home/competition/details/competition_details_viewmodel.dart";

class CompetitionMatchDetailsScreen extends StatefulWidget {
  final SportMatch match;
  final CompetitionDetailsViewmodel viewmodel;
  const CompetitionMatchDetailsScreen(
      {super.key, required this.match, required this.viewmodel});

  @override
  State<CompetitionMatchDetailsScreen> createState() =>
      _CompetitionMatchDetailsScreenState();
}

class _CompetitionMatchDetailsScreenState
    extends State<CompetitionMatchDetailsScreen> {
  SportMatch get match => widget.match;
  late SportMatch _originalMatch;
  CompetitionDetailsViewmodel get viewModel => widget.viewmodel;

  final Color _backgroundColor = AppColors.background;
  final Color _textColor = AppColors.text;
  final Color _iconColor = AppColors.icon;
  final Color _dividerColor = AppColors.accent;

  @override
  void initState() {
    _originalMatch = match.copy();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: myAppBar(
          "Detalles del partido",
          _backgroundColor,
          [
            IconButton(
              onPressed: () => match.played
                  ? null
                  : {
                      viewModel.saveMatchDetails(match),
                      Navigator.of(context).pop()
                    },
              icon: Icon(Icons.check),
              color: _iconColor,
            )
          ],
          IconButton(
            onPressed: () {
              viewModel.discardChanges(match, _originalMatch);
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back),
          ),
        ),
        backgroundColor: _backgroundColor,
        body: _body,
        floatingActionButton: _floatingActionButton,
      ),
    );
  }

  Widget get _body {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) => Column(
        children: <Widget>[
          Center(
            child: Text(
              "${match.teamA.name} ${match.scoreA} : ${match.scoreB} ${match.teamB.name}",
              style: TextStyle(
                color: _textColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 10),
          Divider(color: _dividerColor),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: IconButton(
                  onPressed: () async {
                    final dateSelected = await _selectMatchDate();
                    if (dateSelected == null) {
                      return;
                    }
                    final timeSelected = await _selectMatchTime();
                    if (timeSelected == null) {
                      return;
                    }
                    match.date = DateTime(
                      dateSelected.year,
                      dateSelected.month,
                      dateSelected.day,
                      timeSelected.hour,
                      timeSelected.minute,
                    );
                  },
                  icon: Icon(Icons.calendar_today),
                  color: _iconColor,
                ),
              ),
              Expanded(
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.location_on,
                    color: _iconColor,
                  ),
                  color: _iconColor,
                ),
              )
            ],
          ),
          Divider(
            color: _dividerColor,
          ),
          SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _eventList(match.eventsTeamA, isTeamAEvents: true),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _eventList(match.eventsTeamB, isTeamAEvents: false),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _eventList(Map<MatchEvents, List<String>> events,
          {bool isTeamAEvents = false}) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment:
              isTeamAEvents ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: events.entries.expand(
            (entry) {
              final eventName = entry.key.name;
              final playersName = entry.value;
              return [
                Text(
                  eventName,
                  style: TextStyle(
                    color: _textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                ...playersName.map(
                  (player) => Text(
                    player,
                    style: TextStyle(
                      color: _textColor,
                      fontSize: 14,
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                )
              ];
            },
          ).toList(),
        ),
      );

  FloatingActionButton get _floatingActionButton => FloatingActionButton(
        onPressed: () => _showEventSelectionDialog(),
        backgroundColor: _iconColor,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
      );

  void _showEventSelectionDialog() {
    //final matchEvents = [...match.eventsTeamA.keys, ...match.eventsTeamB.keys];
    bool teamAHasGoalEvent =
        match.eventsTeamA.keys.contains(FootballEvents.goal);
    bool teamBHasGoalEvent =
        match.eventsTeamB.keys.contains(FootballEvents.goal);
    showDialog(
      context: context,
      builder: (ctx) => match.played
          ? SimpleDialog(
              title: Text("Atención"),
              children: [
                Center(
                    child:
                        Text("Partido ya editado, no se puede volver a editar"))
              ],
            )
          : SimpleDialog(
              title: Text("Selecciona un evento"),
              children: FootballEvents.values
                  .map((event) => SimpleDialogOption(
                        child: Text(event.name),
                        onPressed: () {
                          Navigator.of(ctx).pop();
                          _showTeamSelectionDialog(event,
                              teamAHasGoalEvent: teamAHasGoalEvent,
                              teamBHasGoalEvent: teamBHasGoalEvent);
                        },
                      ))
                  .toList(),
            ),
    );
  }

  void _showTeamSelectionDialog(FootballEvents event,
      {required bool teamAHasGoalEvent, required bool teamBHasGoalEvent}) {
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Text("Selecciona equipo"),
        children: event == FootballEvents.assist
            ? [
                if (teamAHasGoalEvent)
                  SimpleDialogOption(
                    child: Text(match.teamA.name),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      _showPlayerSelectionDialog(event, isTeamA: true);
                    },
                  ),
                if (teamBHasGoalEvent)
                  SimpleDialogOption(
                    child: Text(match.teamB.name),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      _showPlayerSelectionDialog(event);
                    },
                  ),
              ]
            : [
                SimpleDialogOption(
                  child: Text(match.teamA.name),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    _showPlayerSelectionDialog(event, isTeamA: true);
                  },
                ),
                SimpleDialogOption(
                  child: Text(match.teamB.name),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    _showPlayerSelectionDialog(event);
                  },
                ),
              ],
      ),
    );
  }

  void _showPlayerSelectionDialog(MatchEvents event, {bool isTeamA = false}) {
    final team = isTeamA ? match.teamA : match.teamB;
    final players = team.players;

    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Text("Selecciona un jugador"),
        children: players
            .map((player) => SimpleDialogOption(
                  child: Text(player.name),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    viewModel.addEventToMatch(match, event, player.name,
                        playerIsFromTeamA: isTeamA);
                  },
                ))
            .toList(),
      ),
    );
  }

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
