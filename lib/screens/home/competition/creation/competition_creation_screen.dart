import 'package:flutter/material.dart';
import 'package:liga_master/models/competition/competition.dart';
import 'package:liga_master/models/enums.dart';
import 'package:liga_master/models/user/entities/user_team.dart';
import 'package:liga_master/screens/generic/appcolors.dart';
import 'package:liga_master/screens/generic/functions.dart';
import 'package:liga_master/screens/generic/generic_widgets/generic_dropdownmenu.dart';
import 'package:liga_master/screens/generic/generic_widgets/myappbar.dart';
import 'package:liga_master/screens/generic/generic_widgets/simple_alert_dialog.dart';

class CompetitionCreationScreen extends StatefulWidget {
  final Competition competition;
  final List<UserTeam> teams;
  const CompetitionCreationScreen(
      {super.key, required this.competition, required this.teams});

  @override
  State<CompetitionCreationScreen> createState() =>
      _CompetitionCreationScreenState();
}

class _CompetitionCreationScreenState extends State<CompetitionCreationScreen> {
  final _formKey = GlobalKey<FormState>();
  Competition get competition => widget.competition;
  List<UserTeam> get _teams => widget.teams;

  late TextEditingController _nameController;
  late int _numberOfteamsSelected;
  CompetitionFormat _formatSelected = CompetitionFormat.league;
  Sport _sportSelected = Sport.football;
  final List<UserTeam> _teamsSelected = List.empty(growable: true);
  bool dataChanged = false;
  String errorMessage = "";

  final Color _textColor = LightThemeAppColors.textColor;
  final Color _redTextColor = LightThemeAppColors.error;

  @override
  void initState() {
    _nameController = TextEditingController(text: competition.name);
    _numberOfteamsSelected = _numberOfteamsSelected =
        widget.competition.numberOfTeamsAllowedForLeague.first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: myAppBar(
          context,
          "Crear competición",
          [
            IconButton(
              onPressed: () {
                FocusManager.instance.primaryFocus?.unfocus();
                _submit();
              },
              icon: Icon(
                Icons.check,
              ),
            )
          ],
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back),
          ),
        ),
        body: _body,
      ),
    );
  }

  Widget get _body {
    return Form(
      key: _formKey,
      child: ListView(
        padding: EdgeInsets.all(20),
        children: <Widget>[
          TextFormField(
            controller: _nameController,
            style: TextStyle(color: _textColor),
            validator: nameValidator,
            decoration: InputDecoration(labelText: "Nombre"),
          ),
          SizedBox(
            height: 20,
          ),
          genericDropDownMenu(context,
              initialSelection: _sportSelected,
              entries: Sport.values
                  .map(
                    (e) => DropdownMenuEntry(
                      value: e,
                      label: e.name,
                      style: genericDropDownMenuEntryStyle(context),
                    ),
                  )
                  .toList(),
              onSelected: (value) => setState(
                    () {
                      _sportSelected = value!;
                    },
                  ),
              labelText: "Deporte"),
          SizedBox(
            height: 20,
          ),
          genericDropDownMenu(context,
              initialSelection: _formatSelected == CompetitionFormat.league
                  ? competition.numberOfTeamsAllowedForLeague.first
                  : competition.numberOfTeamsAllowedForTournament.first,
              entries: getNumberTeamsDropDownItems(
                  _formatSelected == CompetitionFormat.league
                      ? competition.numberOfTeamsAllowedForLeague
                      : competition.numberOfTeamsAllowedForTournament),
              onSelected: (value) => setState(
                    () {
                      _numberOfteamsSelected = value!;
                    },
                  ),
              labelText: "Número de equipos"),
          SizedBox(
            height: 20,
          ),
          genericDropDownMenu(
            context,
            initialSelection: _formatSelected,
            entries: CompetitionFormat.values
                .map(
                  (e) => DropdownMenuEntry(
                    value: e,
                    label: e.name,
                    style: genericDropDownMenuEntryStyle(context),
                  ),
                )
                .toList(),
            onSelected: (value) => setState(
              () {
                _formatSelected = value!;
              },
            ),
            labelText: "Formato",
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton(
              onPressed: () => _showSelectionDialog(),
              child: Text(
                "Seleccionar equipos",
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          if (errorMessage != "")
            Text(
              errorMessage,
            )
        ],
      ),
    );
  }

  void _showSelectionDialog() {
    final List<UserTeam> avaliableTeams = _teams
        .where((team) =>
            team.players.length >= team.sportPlayed.minPlayers &&
            team.sportPlayed == _sportSelected)
        .toList();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return avaliableTeams.isNotEmpty
            ? AlertDialog(
                title: Text(
                  "Selecciona equipos",
                  style: TextStyle(color: _textColor),
                ),
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                content: StatefulBuilder(
                  builder: (context, setState) {
                    return SingleChildScrollView(
                      child: Column(
                        children: avaliableTeams.map((team) {
                          return CheckboxListTile(
                            title: Text(
                              team.name,
                              style: TextStyle(
                                color: _textColor,
                              ),
                            ),
                            value: _teamsSelected.contains(team),
                            onChanged: (bool? selected) {
                              setState(() {
                                if (selected == true) {
                                  _teamsSelected.add(team);
                                } else {
                                  _teamsSelected.remove(team);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Cancelar",
                      style: TextStyle(color: _redTextColor),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        competition.teams = _teamsSelected;
                      });
                    },
                    child: Text(
                      "Aceptar",
                    ),
                  ),
                ],
              )
            : simpleAlertDialog(
                context,
                title: "Atención",
                message:
                    "No tienes equipos que cumplan los requisitos\nDeporte: ${_sportSelected.name}\nMínimo de jugadores en el equipo: ${_sportSelected.minPlayers}",
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Cancelar",
                      style: TextStyle(color: _redTextColor),
                    ),
                  ),
                ],
              );
      },
    );
  }

  void _updateCompetition() {
    competition.name = _nameController.value.text.trim();
    competition.teams = _teamsSelected.map((team) => team.copy()).toList();
    for (var team in _teamsSelected) {
      for (var player in team.players) {
        competition.players.add(player);
      }
    }
    competition.format = _formatSelected;
    competition.competitionSport = _sportSelected;
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (_numberOfteamsSelected != _teamsSelected.length) {
        setState(() => errorMessage =
            "Debes seleccionar $_numberOfteamsSelected equipos, has seleccionado ${_teamsSelected.length}");
        return;
      }
      _updateCompetition();
      setState(() => errorMessage = "");
      Navigator.of(context).pop(true);
    }
  }

  List<DropdownMenuEntry> getNumberTeamsDropDownItems(List<int> items) => items
      .map(
        (e) => DropdownMenuEntry(
          value: e,
          label: "$e",
          style: genericDropDownMenuEntryStyle(context),
        ),
      )
      .toList();
}
