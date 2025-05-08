import 'package:flutter/material.dart';
import 'package:liga_master/models/competition/competition.dart';
import 'package:liga_master/models/enums.dart';
import 'package:liga_master/models/user/entities/user_team.dart';
import 'package:liga_master/screens/generic/appcolors.dart';
import 'package:liga_master/screens/generic/functions.dart';
import 'package:liga_master/screens/generic/generic_widgets/myappbar.dart';
import 'package:liga_master/screens/home/home_screen_viewmodel.dart';
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
  String errorMessage = "";

  final Color _backgroundColor = AppColors.background;
  final Color _primaryColor = AppColors.accent;
  final Color _textColor = AppColors.text;
  final Color _labelColor = AppColors.labeltext;
  final Color _redTextColor = AppColors.error;

  @override
  void initState() {
    HomeScreenViewmodel homeScreenViewModel =
        Provider.of<HomeScreenViewmodel>(context, listen: false);
    _nameController = TextEditingController(text: competition.name);
    _teams = homeScreenViewModel.teams;
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
        _backgroundColor,
        [
          IconButton(
            onPressed: () => submit(),
            icon: Icon(
              Icons.check,
              color: _primaryColor,
            ),
          )
        ],
        IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back),
          color: _primaryColor,
        ),
      ),
      body: _body,
      backgroundColor: _backgroundColor,
    ));
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
            decoration:
                getGenericInputDecoration("Nombre", _labelColor, _textColor),
          ),
          SizedBox(
            height: 20,
          ),
          DropdownButtonFormField(
            value: _sportSelected,
            dropdownColor: _backgroundColor,
            decoration:
                getGenericInputDecoration("Deporte", _labelColor, _textColor),
            items: Sport.values
                .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(
                        e.name,
                        style: TextStyle(color: _textColor),
                      ),
                    ))
                .toList(),
            onChanged: (value) => setState(
              () {
                _sportSelected = value!;
              },
            ),
          ),
          SizedBox(
            height: 20,
          ),
          DropdownButtonFormField(
            value: _formatSelected == CompetitionFormat.league
                ? competition.numberOfTeamsAllowedForLeague.first
                : competition.numberOfTeamsAllowedForTournament.first,
            dropdownColor: _backgroundColor,
            decoration: getGenericInputDecoration(
                "Número de equipos", _labelColor, _textColor),
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
          SizedBox(
            height: 20,
          ),
          DropdownButtonFormField(
            value: _formatSelected,
            dropdownColor: _backgroundColor,
            decoration:
                getGenericInputDecoration("Formato", _labelColor, _textColor),
            items: CompetitionFormat.values
                .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(
                        e.name,
                        style: TextStyle(color: _textColor),
                      ),
                    ))
                .toList(),
            onChanged: (value) => setState(
              () {
                _formatSelected = value!;
              },
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextButton(
            onPressed: () => showSelectionDialog(),
            child: Text(
              "Seleccionar equipos",
              style: TextStyle(color: _textColor),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          if (errorMessage != "")
            Text(
              errorMessage,
              style: TextStyle(color: _redTextColor),
            )
        ],
      ),
    );
  }

  void showSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Selecciona equipos",
            style: TextStyle(color: _textColor),
          ),
          backgroundColor: _backgroundColor,
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
                      title: Text(
                        team.name,
                        style: TextStyle(color: _textColor),
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
                style: TextStyle(color: _textColor),
              ),
            ),
          ],
        );
      },
    );
  }

  void updateCompetition() {
    HomeScreenViewmodel homeScreenViewModel =
        Provider.of<HomeScreenViewmodel>(context, listen: false);
    competition.name = _nameController.value.text.trim();
    competition.teams = _teamsSelected.map((team) => team.copy()).toList();
    for (var team in _teamsSelected) {
      for (var player in team.players) {
        competition.players.add(player);
      }
    }
    competition.creator = homeScreenViewModel.user;
    competition.format = _formatSelected;
    competition.competitionSport = _sportSelected;
  }

  void onDataChanged() {
    updateCompetition();
    dataChanged = _initCompetition.equals(competition);
  }

  void submit() {
    if (_formKey.currentState!.validate()) {
      if (_numberOfteamsSelected != _teamsSelected.length) {
        setState(() => errorMessage =
            "Debes seleccionar $_numberOfteamsSelected equipos, has seleccionado ${_teamsSelected.length}");
        return;
      }
      updateCompetition();
      setState(() => errorMessage = "");
      Navigator.of(context).pop(true);
    }
  }

  List<DropdownMenuItem> getNumberTeamsDropDownItems(List<int> items) => items
      .map(
        (e) => DropdownMenuItem(
          value: e,
          child: Text(
            "$e",
            style: TextStyle(color: _textColor),
          ),
        ),
      )
      .toList();
}
