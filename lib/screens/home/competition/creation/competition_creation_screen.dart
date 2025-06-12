import 'package:flutter/material.dart';
import 'package:liga_master/models/appstrings/appstrings.dart';
import 'package:liga_master/models/appstrings/appstrings_controller.dart';
import 'package:liga_master/models/competition/competition.dart';
import 'package:liga_master/models/enums.dart';
import 'package:liga_master/models/user/entities/user_team.dart';
import 'package:liga_master/screens/generic/appcolors.dart';
import 'package:liga_master/screens/generic/functions.dart';
import 'package:liga_master/screens/generic/generic_widgets/generic_dropdownmenu.dart';
import 'package:liga_master/screens/generic/generic_widgets/myappbar.dart';
import 'package:liga_master/screens/generic/generic_widgets/simple_alert_dialog.dart';
import 'package:provider/provider.dart';

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
    final controller =
        Provider.of<AppStringsController>(context, listen: false);
    final strings = controller.strings!;

    return SafeArea(
      child: Scaffold(
        appBar: myAppBar(
          context,
          strings.addCompetitionScreenTitle,
          [
            IconButton(
              onPressed: () {
                FocusManager.instance.primaryFocus?.unfocus();
                submit(strings.errorNumberOfTeamsSelected);
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
        body: _body(strings),
      ),
    );
  }

  Widget _body(AppStrings strings) {
    return PopScope(
      canPop: false,
      child: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(20),
          children: <Widget>[
            TextFormField(
              controller: _nameController,
              style: TextStyle(color: _textColor),
              validator: (value) {
                String? nameErrorMessage = nameValidator(value);
                return nameErrorMessage != null
                    ? getLocalizedNameErrorMessage(strings)
                    : null;
              },
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(labelText: strings.nameLabel),
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
                        label: getSportLabel(strings, e),
                        style: genericDropDownMenuEntryStyle(context),
                      ),
                    )
                    .toList(),
                onSelected: (value) => setState(
                      () {
                        _sportSelected = value!;
                      },
                    ),
                labelText: strings.sportLabel),
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
                labelText: strings.numberOfTeamsThatParticipateLabel),
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
                      label: getCompetitionFormatLabel(strings, e),
                      style: genericDropDownMenuEntryStyle(context),
                    ),
                  )
                  .toList(),
              onSelected: (value) => setState(
                () {
                  _formatSelected = value!;
                },
              ),
              labelText: strings.formatLabel,
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                onPressed: () => showSelectionDialog(strings),
                child: Text(strings.selectTeamsButtonText),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            if (errorMessage != "")
              Text(
                errorMessage,
                style: TextStyle(
                  color: LightThemeAppColors.error,
                ),
              )
          ],
        ),
      ),
    );
  }

  void showSelectionDialog(AppStrings strings) {
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
                  strings.selectTeamsButtonText,
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
                      strings.cancelTextButton,
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
                      strings.acceptDialogButtonText,
                    ),
                  ),
                ],
              )
            : simpleAlertDialog(
                context,
                title: strings.deleteItemDialogTitle,
                message: strings.noTeamsAvaliableToAddText,
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      strings.cancelTextButton,
                      style: TextStyle(color: _redTextColor),
                    ),
                  ),
                ],
              );
      },
    );
  }

  void updateCompetition() {
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

  void submit(String errorText) {
    if (_formKey.currentState!.validate()) {
      if (_numberOfteamsSelected != _teamsSelected.length) {
        setState(() => errorMessage = errorText);
        return;
      }
      updateCompetition();
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
