import 'package:flutter/material.dart';
import 'package:liga_master/models/user/entities/user_player.dart';
import 'package:liga_master/models/user/entities/user_team.dart';
import 'package:liga_master/models/user/user.dart';
import 'package:liga_master/screens/generic_widgets/myappbar.dart';
import 'package:provider/provider.dart';

class TeamEditionScreen extends StatefulWidget {
  final UserTeam team;
  const TeamEditionScreen({super.key, required this.team});

  @override
  State<TeamEditionScreen> createState() => _TeamEditionScreenState();
}

class _TeamEditionScreenState extends State<TeamEditionScreen> {
  final _formKey = GlobalKey<FormState>();
  UserTeam get team => widget.team;
  late UserTeam _initTeam;
  late TextEditingController _nameController;
  late TextEditingController _ratingController;
  late List<UserPlayer> _players;
  late List<UserPlayer> _playersSelected;

  @override
  void initState() {
    var user = Provider.of<User>(context, listen: false);
    _initTeam = widget.team.copy();
    _nameController = TextEditingController(text: team.name);
    _ratingController = TextEditingController(text: team.rating.toString());
    _players = user.players
        .where((player) =>
            (player.currentTeamName == null ||
                player.currentTeamName == team.name) &&
            player.sportPlayed == team.sportPlayed)
        .toList();
    _playersSelected = team.players;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: myAppBar(
          "Editar equipo",
          [
            IconButton(
              onPressed: () => submitForm(),
              icon: Icon(Icons.check),
            ),
          ],
          IconButton(
            onPressed: () {
              discardChanges();
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back),
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
              validator: nameValidator,
              decoration: InputDecoration(
                labelText: "Nombre",
              ),
            ),
            TextFormField(
              controller: _ratingController,
              validator: ratingValidator,
              decoration: InputDecoration(labelText: "Valoración"),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              initialValue: team.sportPlayed.name,
              decoration: InputDecoration(labelText: "Deporte"),
              readOnly: true,
            ),
            TextButton(
              onPressed: () => showPlayersDialog(),
              child: Text("Ver jugadores"),
            )
          ],
        ),
      );

  Widget get _floatingActionButton => FloatingActionButton(
        onPressed: showSelectionDialog,
        child: Icon(Icons.add),
      );

  void showSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Selecciona jugadores"),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                child: Column(
                  children: _players
                      .where((player) => player.currentTeamName == null)
                      .map((player) {
                    return _players.isNotEmpty
                        ? CheckboxListTile(
                            title: Text(player.name),
                            value: _playersSelected.contains(player),
                            onChanged: (bool? selected) {
                              setState(() {
                                if (selected == true &&
                                    !team.players.contains(player)) {
                                  _playersSelected.add(player);
                                } else {
                                  _playersSelected.remove(player);
                                }
                              });
                            },
                          )
                        : Text("No hay jugadores disponibles.Cree unos nuevos");
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
              child: Text("Cerrar"),
            ),
          ],
        );
      },
    );
  }

  void showPlayersDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text("Jugadores en el equipo"),
        content: _playersSelected.isEmpty
            ? Text("No hay jugadores")
            : StatefulBuilder(
                builder: (context, setState) => SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: _playersSelected
                        .map(
                          (player) => ListTile(
                            title: Text(player.name),
                            trailing: IconButton(
                              onPressed: () => {
                                setState(() => _playersSelected.remove(player))
                              },
                              icon: Icon(Icons.delete),
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
            child: Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  String? nameValidator(value) {
    if (value == null || value.isEmpty) {
      return "Por favor, introduce un nombre";
    }
    return null;
  }

  String? ratingValidator(value) {
    double ratingSelected = double.parse(value);
    if (ratingSelected < 1 || ratingSelected > 5) {
      return "La valoración debe ser entre 1 y 5";
    }
    return null;
  }

  void updateTeam() {
    team.name = _nameController.value.text;
    team.rating = double.parse(_ratingController.value.text);
    team.players = _playersSelected.map((player) => player.copy()).toList();
  }

  void updatePlayersTeam() {
    for (var player in _players) {
      if (_playersSelected.map((p) => p.id).toList().contains(player.id)) {
        player.currentTeamName = team.name;
      } else {
        player.currentTeamName = null;
      }
    }
  }

  void submitForm() {
    if (_formKey.currentState!.validate()) {
      updatePlayersTeam();
      updateTeam();
      Navigator.of(context).pop(true);
    }
  }

  void discardChanges() {
    team.players = _initTeam.players;
  }
}
