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
  CompetitionDetailsViewmodel get viewModel => widget.viewmodel;

  final Color _backgroundColor = AppColors.background;
  final Color _textColor = AppColors.text;
  final Color _iconColor = AppColors.icon;
  final Color _dividerColor = AppColors.accent;
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
            onPressed: () => Navigator.of(context).pop(),
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
          SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: _eventList(match.eventsTeamA, isTeamAEvents: true)),
              SizedBox(width: 16),
              Expanded(
                  child: _eventList(match.eventsTeamB, isTeamAEvents: false)),
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
                          _showTeamSelectionDialog(event);
                        },
                      ))
                  .toList(),
            ),
    );
  }

  void _showTeamSelectionDialog(FootballEvents event) {
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Text("Selecciona equipo"),
        children: [
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

  void _showPlayerSelectionDialog(FootballEvents event,
      {bool isTeamA = false}) {
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
}
