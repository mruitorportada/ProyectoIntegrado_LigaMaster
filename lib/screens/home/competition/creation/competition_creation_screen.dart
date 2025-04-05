import 'package:flutter/material.dart';
import 'package:liga_master/models/competition/competition.dart';
import 'package:liga_master/models/competition/entities/team.dart';
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
  int _numberOfteamsSelected = 0;
  CompetitionFormat _formatSelected = CompetitionFormat.league;
  late final List<CompetitionTeam> _teams;
  final List<CompetitionTeam> _teamsSelected = List.empty(growable: true);
  bool dataChanged = false;

  @override
  void initState() {
    User user = Provider.of<User>(context, listen: false);
    _nameController = TextEditingController(text: competition.name);
    _teams = user.teams.map((team) => team.toCompetitionTeam()).toList();
    _initCompetition = widget.competition.copyValuesFrom(widget.competition);
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
            icon: Icon(Icons.check),
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
                labelText: "Name",
              ),
            ),
            DropdownButtonFormField(
              value: competition.numberOfTeamsAllowed.first,
              decoration: InputDecoration(
                label: Text("Número de equipos"),
              ),
              items: competition.numberOfTeamsAllowed
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text("$e"),
                      ))
                  .toList(),
              onChanged: (value) => setState(
                () {
                  _numberOfteamsSelected = value!;
                },
              ),
            ),
            DropdownButtonFormField(
              value: _teams.first,
              decoration: InputDecoration(
                label: Text("Equipos"),
              ),
              validator: teamsValidator,
              items: _teams
                  .map(
                    (team) => DropdownMenuItem(
                      value: team,
                      child: Text(team.name),
                    ),
                  )
                  .toList(),
              onChanged: (value) => setState(
                () {
                  if (_teamsSelected.contains(value)) {
                    _teamsSelected.remove(value);
                  } else {
                    _teamsSelected.add(value as CompetitionTeam);
                  }
                },
              ),
            ),
            DropdownButtonFormField(
              value: _formatSelected,
              decoration: InputDecoration(
                label: Text("Formatos"),
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
          ],
        ),
      ),
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
  }

  void submit() {
    if (_formKey.currentState!.validate()) {
      updateCompetition();
      Navigator.of(context).pop(true);
    }
  }
}
