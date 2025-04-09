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
  late TextEditingController _nameController;
  late TextEditingController _ratingController;
  late TextEditingController _sportsController;
  late List<UserPlayer> _players;
  late List<UserPlayer> _playersSelected;

  @override
  void initState() {
    var user = Provider.of<User>(context, listen: false);
    _nameController = TextEditingController(text: team.name);
    _ratingController = TextEditingController(text: team.rating.toString());
    _sportsController = TextEditingController(text: team.sportPlayed.name);
    _players = user.players;
    _playersSelected =
        team.players.isNotEmpty ? team.players : List.empty(growable: true);
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
            onPressed: () => Navigator.of(context).pop(),
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
              controller: _sportsController,
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
          title: Text('Selecciona jugadores'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                child: Column(
                  children: _players
                      .where((player) => player.currentTeamName == null)
                      .map((player) {
                    return CheckboxListTile(
                      title: Text(player.name),
                      value: _playersSelected.contains(player),
                      onChanged: (bool? selected) {
                        setState(() {
                          if (selected == true) {
                            _playersSelected.add(player);
                          } else {
                            _playersSelected.remove(player);
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
                  team.players = _playersSelected;
                });
              },
              child: Text('Aceptar'),
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
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: _playersSelected
                    .map(
                      (player) => ListTile(
                        title: Text(player.name),
                      ),
                    )
                    .toList(),
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
    team.players = _playersSelected;
  }

  void submitForm() {
    if (_formKey.currentState!.validate()) {
      updateTeam();
      Navigator.of(context).pop(true);
    }
  }
}
