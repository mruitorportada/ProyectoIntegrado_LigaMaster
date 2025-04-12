import 'package:flutter/material.dart';
import 'package:liga_master/models/competition/competition.dart';
import 'package:liga_master/models/competition/competition_entity.dart';
import 'package:liga_master/models/user/entities/user_team.dart';
import 'package:liga_master/models/user/user.dart';
import 'package:liga_master/screens/generic_widgets/myappbar.dart';
import 'package:provider/provider.dart';

class CompetitionCreationScreen extends StatefulWidget {
  final Competition competition;
  const CompetitionCreationScreen({super.key, required this.competition});

  @override
  State<CompetitionCreationScreen> createState() =>
      _CompetitionCreationScreenState();
}

class _CompetitionCreationScreenState extends State<CompetitionCreationScreen> {
  final _formKey = GlobalKey<FormState>();
  Competition get competition => widget.competition;

  late TextEditingController _nameController;
  late Competition _initCompetition;
  late int _numberOfteamsSelected;
  CompetitionFormat _formatSelected = CompetitionFormat.league;
  Sport _sportSelected = Sport.football;
  late final List<UserTeam> _teams;
  final List<UserTeam> _teamsSelected = List.empty(growable: true);
  bool dataChanged = false;

  @override
  void initState() {
    User user = Provider.of<User>(context, listen: false);
    _nameController = TextEditingController(text: competition.name);
    _teams = user.teams;
    _initCompetition = widget.competition.copyValuesFrom(widget.competition);
    _numberOfteamsSelected = _numberOfteamsSelected =
        widget.competition.numberOfTeamsAllowedForLeague.first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: myAppBar(
        "Crear competición",
        [
          IconButton(
            onPressed: () => submit(),
            icon: Icon(
              Icons.check, /*color: dataChanged ? Colors.black : Colors.grey*/
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
    ));
  }

  Widget get _body {
    return Container(
      margin: EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            TextFormField(
              controller: _nameController,
              validator: nameValidator,
              decoration: InputDecoration(
                labelText: "Nombre",
              ),
            ),
            DropdownButtonFormField(
              value: _sportSelected,
              decoration: InputDecoration(
                label: Text("Deporte"),
              ),
              items: Sport.values
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e.name),
                      ))
                  .toList(),
              onChanged: (value) => setState(
                () {
                  _sportSelected = value!;
                },
              ),
            ),
            DropdownButtonFormField(
              value: _formatSelected == CompetitionFormat.league
                  ? competition.numberOfTeamsAllowedForLeague.first
                  : competition.numberOfTeamsAllowedForTournament.first,
              decoration: InputDecoration(
                label: Text("Número de equipos"),
              ),
              items: getNumberTeamsDropDownItems(
                  _formatSelected == CompetitionFormat.league
                      ? competition.numberOfTeamsAllowedForLeague
                      : competition.numberOfTeamsAllowedForTournament),
              onChanged: (value) => setState(
                () {
                  _numberOfteamsSelected = value!;
                },
              ),
            ),
            DropdownButtonFormField(
              value: _formatSelected,
              decoration: InputDecoration(
                label: Text("Formato"),
              ),
              items: CompetitionFormat.values
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e.name),
                      ))
                  .toList(),
              onChanged: (value) => setState(
                () {
                  _formatSelected = value!;
                },
              ),
            ),
            TextButton(
              onPressed: () => showSelectionDialog(),
              child: Text("Seleccionar equipos"),
            )
          ],
        ),
      ),
    );
  }

  void showSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Selecciona equipos'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                child: Column(
                  children: _teams
                      .where((team) =>
                          team.players.length >= team.sportPlayed.minPlayers &&
                          team.sportPlayed == _sportSelected)
                      .map((team) {
                    return CheckboxListTile(
                      title: Text(team.name),
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
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  competition.teams = _teamsSelected;
                });
              },
              child: Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  String? nameValidator(value) {
    if (value == null || value.isEmpty) {
      return "Por favor, introduce un nombre";
    }
    return null;
  }

  String? teamsValidator(value) {
    if (_teamsSelected.length != _numberOfteamsSelected) {
      return "Debe seleccionar $_numberOfteamsSelected equipos. Ha seleccionado ${_teamsSelected.length}";
    }
    return null;
  }

  void updateCompetition() {
    User user = Provider.of<User>(context, listen: false);
    competition.name = _nameController.value.text;
    competition.teams = _teamsSelected;
    competition.creator = user;
    competition.format = _formatSelected;
    competition.competitionSport = _sportSelected;
  }

  void onDataChanged() {
    updateCompetition();
    dataChanged = _initCompetition.equals(competition);
  }

  void submit() {
    if (_formKey.currentState!.validate()) {
      updateCompetition();
      Navigator.of(context).pop(true);
    }
  }

  List<DropdownMenuItem> getNumberTeamsDropDownItems(List<int> items) => items
      .map(
        (e) => DropdownMenuItem(
          value: e,
          child: Text("$e"),
        ),
      )
      .toList();
}
