import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:liga_master/models/user/entities/user_player.dart';
import 'package:liga_master/models/user/entities/user_team.dart';
import 'package:liga_master/screens/generic/appcolors.dart';
import 'package:liga_master/screens/generic/functions.dart';
import 'package:liga_master/screens/generic/generic_widgets/myappbar.dart';
import 'package:liga_master/screens/generic/generic_widgets/simple_alert_dialog.dart';
import 'package:liga_master/services/team_service.dart';
import 'package:provider/provider.dart';

class TeamEditionScreen extends StatefulWidget {
  final UserTeam team;
  final List<UserPlayer> players;
  final String userId;
  const TeamEditionScreen(
      {super.key,
      required this.team,
      required this.players,
      required this.userId});

  @override
  State<TeamEditionScreen> createState() => _TeamEditionScreenState();
}

class _TeamEditionScreenState extends State<TeamEditionScreen> {
  final _formKey = GlobalKey<FormState>();
  UserTeam get team => widget.team;
  List<UserPlayer> get _players => widget.players;
  String get _userId => widget.userId;

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
    return SafeArea(
      child: Scaffold(
        appBar: myAppBar(
          context,
          "Editar equipo",
          [
            IconButton(
              onPressed: () => _submitForm(
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
        body: _body,
        floatingActionButton: _floatingActionButton,
      ),
    );
  }

  Widget get _body => Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(20),
          children: <Widget>[
            TextFormField(
              controller: _nameController,
              style: TextStyle(color: _textColor),
              validator: nameValidator,
              decoration: InputDecoration(
                labelText: "Nombre",
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: _ratingController,
              style: TextStyle(color: _textColor),
              validator: ratingValidator,
              decoration: InputDecoration(
                labelText: "Valoración",
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              initialValue: team.sportPlayed.name,
              style: TextStyle(color: _textColor),
              decoration: InputDecoration(
                labelText: "Deporte",
              ),
              readOnly: true,
            ),
            SizedBox(
              height: 20,
            ),
            TextButton(
              onPressed: () => _showPlayersDialog(),
              child: Text(
                "Ver jugadores",
              ),
            )
          ],
        ),
      );

  Widget get _floatingActionButton => FloatingActionButton(
        onPressed: _showSelectionDialog,
        child: Icon(Icons.add),
      );

  void _showSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _players.isNotEmpty
            ? AlertDialog(
                title: Text(
                  "Selecciona jugadores",
                  style: TextStyle(color: _textColor),
                ),
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                content: StatefulBuilder(
                  builder: (context, setState) {
                    return SingleChildScrollView(
                      child: Column(
                        children: _players
                            .map(
                              (player) => CheckboxListTile(
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
                              ),
                            )
                            .toList(),
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
                title: "Atención",
                message: "No hay jugadores disponibles. Cree unos nuevos",
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
              );
      },
    );
  }

  void _showPlayersDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          "Jugadores en el equipo",
          style: TextStyle(color: _textColor),
        ),
        content: _playersSelected.isEmpty
            ? Text(
                "No hay jugadores",
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
              "Cerrar",
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

  void _submitForm({required Color toastColor}) async {
    var teamService = Provider.of<TeamService>(context, listen: false);
    bool uniqueName = false;
    if (_formKey.currentState!.validate()) {
      uniqueName = await teamService.checkTeamNameIsUnique(
          _nameController.value.text.trim(), _userId);

      if (!uniqueName) {
        Fluttertoast.showToast(
            msg: "El nombre debe de ser único", backgroundColor: toastColor);
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
