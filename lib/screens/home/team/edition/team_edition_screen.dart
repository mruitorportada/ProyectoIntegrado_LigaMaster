import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:liga_master/models/appstrings/appstrings.dart';
import 'package:liga_master/models/appstrings/appstrings_controller.dart';
import 'package:liga_master/models/user/app_user.dart';
import 'package:liga_master/models/user/entities/user_player.dart';
import 'package:liga_master/models/user/entities/user_team.dart';
import 'package:liga_master/screens/generic/appcolors.dart';
import 'package:liga_master/screens/generic/functions.dart';
import 'package:liga_master/screens/generic/generic_widgets/myappbar.dart';
import 'package:liga_master/screens/generic/generic_widgets/simple_alert_dialog.dart';
import 'package:liga_master/services/player_service.dart';
import 'package:provider/provider.dart';

class TeamEditionScreen extends StatefulWidget {
  final UserTeam team;
  final List<UserPlayer> players;
  final AppUser user;
  const TeamEditionScreen(
      {super.key,
      required this.team,
      required this.players,
      required this.user});

  @override
  State<TeamEditionScreen> createState() => _TeamEditionScreenState();
}

class _TeamEditionScreenState extends State<TeamEditionScreen> {
  final _formKey = GlobalKey<FormState>();
  UserTeam get team => widget.team;
  List<UserPlayer> get _players => widget.players;
  AppUser get _user => widget.user;

  late UserTeam _initTeam;
  late TextEditingController _nameController;
  late TextEditingController _ratingController;
  late List<UserPlayer> _playersSelected;

  final Color _textColor = LightThemeAppColors.textColor;

  @override
  void initState() {
    _initTeam = widget.team.copy();
    _nameController = TextEditingController(text: team.name);
    _ratingController = TextEditingController(text: team.rating.toString());
    _playersSelected = List.of(team.players);
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
          strings.editTeamTitle,
          [
            IconButton(
              onPressed: () => submitForm(
                strings: strings,
                toastColor: Theme.of(context).primaryColor,
              ),
              icon: Icon(
                Icons.check,
              ),
            ),
          ],
          IconButton(
            onPressed: () {
              discardChanges();
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back,
            ),
          ),
        ),
        body: _body(strings),
        floatingActionButton: _floatingActionButton,
      ),
    );
  }

  Widget _body(AppStrings strings) => Form(
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
              decoration: InputDecoration(
                labelText: strings.nameLabel,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: _ratingController,
              style: TextStyle(color: _textColor),
              validator: (value) {
                String? errorMessage = ratingValidator(value);
                return getLocalizedRatingErrorMessage(strings, errorMessage);
              },
              decoration: InputDecoration(
                labelText: strings.ratingLabel,
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              initialValue: getSportLabel(strings, team.sportPlayed),
              style: TextStyle(color: _textColor),
              decoration: InputDecoration(
                labelText: strings.sportLabel,
              ),
              readOnly: true,
            ),
            SizedBox(
              height: 20,
            ),
            TextButton(
              onPressed: () => showPlayersDialog(),
              child: Text(
                strings.playersButtonText,
              ),
            )
          ],
        ),
      );

  Widget get _floatingActionButton => FloatingActionButton(
        onPressed: showSelectionDialog,
        child: Icon(Icons.add),
      );

  void showSelectionDialog() {
    final controller =
        Provider.of<AppStringsController>(context, listen: false);
    final strings = controller.strings!;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _players.isNotEmpty
            ? AlertDialog(
                title: Text(
                  strings.playersButtonText,
                  style: TextStyle(color: _textColor),
                ),
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                content: StatefulBuilder(
                  builder: (context, setState) {
                    return SingleChildScrollView(
                      child: Column(
                        children: _players.map(
                          (player) {
                            return CheckboxListTile(
                              title: Text(
                                player.name,
                                style: TextStyle(color: _textColor),
                              ),
                              value: _playersSelected.contains(player),
                              onChanged: (bool? selected) {
                                setState(
                                  () {
                                    if ((selected ?? false) &&
                                        !team.players.contains(player)) {
                                      _playersSelected.add(player);
                                    } else {
                                      _playersSelected.remove(player);
                                    }
                                  },
                                );
                              },
                            );
                          },
                        ).toList(),
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
                      "Cerrar",
                      style: TextStyle(
                        color: LightThemeAppColors.error,
                      ),
                    ),
                  ),
                ],
              )
            : simpleAlertDialog(
                context,
                title: strings.deleteItemDialogTitle,
                message: strings.noPlayersAvaliableToSelect,
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      strings.closeDialogText,
                      style: TextStyle(
                        color: LightThemeAppColors.error,
                      ),
                    ),
                  ),
                ],
              );
      },
    );
  }

  void showPlayersDialog() {
    final controller =
        Provider.of<AppStringsController>(context, listen: false);
    final strings = controller.strings!;

    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          strings.playersInTeamTitle,
          style: TextStyle(color: _textColor),
        ),
        content: _playersSelected.isEmpty
            ? Text(
                strings.noPlayersInTeamText,
                style: TextStyle(color: _textColor),
              )
            : StatefulBuilder(
                builder: (context, setState) => SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: _playersSelected
                        .map(
                          (player) => ListTile(
                            title: Text(
                              player.name,
                              style: TextStyle(color: _textColor),
                            ),
                            trailing: IconButton(
                              onPressed: () => {
                                setState(
                                  () {
                                    _playersSelected.remove(player);
                                    _players.add(player);
                                  },
                                ),
                              },
                              icon: Icon(
                                Icons.delete,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              strings.closeDialogText,
              style: TextStyle(color: _textColor),
            ),
          ),
        ],
      ),
    );
  }

  void _updateTeam() {
    team.name = _nameController.value.text.trim();
    team.rating = double.parse(_ratingController.value.text);
    team.players = _playersSelected.map((player) => player.copy()).toList();
  }

  void updatePlayersTeam() {
    PlayerService playerService =
        Provider.of<PlayerService>(context, listen: false);

    for (var player in _players) {
      if (_playersSelected.map((p) => p.id).toList().contains(player.id)) {
        player.currentTeamName = team.name;
      } else {
        player.currentTeamName = null;
        playerService.savePlayer(player, _user.id);
      }
    }
  }

  void submitForm(
      {required AppStrings strings, required Color toastColor}) async {
    bool uniqueName = false;
    if (_formKey.currentState!.validate()) {
      uniqueName = !_user.teams.any((userTeam) =>
          userTeam.name == _nameController.value.text &&
          userTeam.id != team.id);

      if (!uniqueName) {
        Fluttertoast.showToast(
            msg: strings.uniqueNameError, backgroundColor: toastColor);
        return;
      }

      _updateTeam();
      if (mounted) Navigator.of(context).pop(true);
    }
  }

  void discardChanges() {
    team.players = _initTeam.players;
  }
}
