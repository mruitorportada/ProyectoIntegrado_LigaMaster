import 'package:flutter/material.dart';
import 'package:liga_master/models/enums.dart';
import 'package:liga_master/models/user/entities/user_player.dart';
import 'package:liga_master/screens/generic_widgets/myappbar.dart';

class PlayerEditionScreen extends StatefulWidget {
  final UserPlayer player;
  const PlayerEditionScreen({super.key, required this.player});

  @override
  State<PlayerEditionScreen> createState() => _PlayerEditionScreenState();
}

class _PlayerEditionScreenState extends State<PlayerEditionScreen> {
  final _formKey = GlobalKey<FormState>();
  UserPlayer get player => widget.player;
  late TextEditingController _nameController;
  late TextEditingController _ratingController;
  late PlayerPosition _positionSelected;

  @override
  void initState() {
    _nameController = TextEditingController(text: player.name);
    _ratingController = TextEditingController(text: player.rating.toString());
    _positionSelected = player.position!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: myAppBar(
          "Editar jugador",
          [
            IconButton(
              onPressed: () => submitForm(),
              icon: Icon(Icons.check),
            )
          ],
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.arrow_back),
          ),
        ),
        body: _body,
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
              decoration: InputDecoration(labelText: "Nombre"),
            ),
            TextFormField(
              initialValue: player.currentTeamName ?? "Sin equipo",
              readOnly: true,
              decoration: InputDecoration(labelText: "Equipo"),
            ),
            TextFormField(
              controller: _ratingController,
              validator: ratingValidator,
              decoration: InputDecoration(labelText: "Valoración"),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              initialValue: player.sportPlayed.name,
              readOnly: true,
              decoration: InputDecoration(labelText: "Deporte"),
            ),
            DropdownButtonFormField(
              value: _positionSelected,
              decoration: InputDecoration(label: Text("Posición")),
              validator: positionValidator,
              items: getPositionsBasedOnSportSelected()
                  .map(
                    (pos) => DropdownMenuItem(
                      value: pos,
                      child: Text(pos.name),
                    ),
                  )
                  .toList(),
              onChanged: (value) => setState(
                () {
                  _positionSelected = value!;
                },
              ),
            )
          ],
        ),
      );

  String? nameValidator(value) => (value == null || value.isEmpty)
      ? "Por favor, introduce un nombre"
      : null;

  String? ratingValidator(value) {
    double ratingSelected = double.parse(value);
    if (ratingSelected < 1 || ratingSelected > 5) {
      return "La valoración debe ser entre 1 y 5";
    }
    return null;
  }

  String? positionValidator(value) =>
      value == null ? "Seleccione una posición" : null;

  List<PlayerPosition> getPositionsBasedOnSportSelected() {
    return switch (player.sportPlayed) {
      Sport.football => FootballPlayerPosition.values,
      Sport.futsal => FutsalPlayerPosition.values
    };
  }

  void updatePlayer() {
    player.name = _nameController.value.text;
    player.rating = double.parse(_ratingController.value.text);
    player.position = _positionSelected;
  }

  void submitForm() {
    if (_formKey.currentState!.validate()) {
      updatePlayer();
      Navigator.of(context).pop(true);
    }
  }
}
