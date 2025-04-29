import 'package:flutter/material.dart';
import 'package:liga_master/models/enums.dart';
import 'package:liga_master/models/user/entities/user_player.dart';
import 'package:liga_master/screens/generic_widgets/myappbar.dart';

class PlayerCreationScreen extends StatefulWidget {
  final UserPlayer player;
  const PlayerCreationScreen({super.key, required this.player});

  @override
  State<PlayerCreationScreen> createState() => _PlayerCreationScreenState();
}

class _PlayerCreationScreenState extends State<PlayerCreationScreen> {
  final _formKey = GlobalKey<FormState>();
  UserPlayer get player => widget.player;
  late TextEditingController _nameController;
  late TextEditingController _ratingController;
  Sport _sportSelected = Sport.football;
  PlayerPosition? _positionSelected;
  final Color _backgroundColor = const Color.fromARGB(255, 58, 17, 100);

  @override
  void initState() {
    _nameController = TextEditingController(text: player.name);
    _ratingController = TextEditingController(text: player.rating.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: myAppBar(
          "Crear jugador",
          _backgroundColor,
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
              controller: _ratingController,
              validator: ratingValidator,
              decoration: InputDecoration(labelText: "Valoración"),
              keyboardType: TextInputType.number,
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
                  _positionSelected = null;
                },
              ),
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
                  _positionSelected = value;
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
    return switch (_sportSelected) {
      Sport.football => FootballPlayerPosition.values,
      Sport.futsal => FutsalPlayerPosition.values
    };
  }

  void updatePlayer() {
    player.name = _nameController.value.text.trim();
    player.rating = double.parse(_ratingController.value.text);
    player.sportPlayed = _sportSelected;
    player.position = _positionSelected;
  }

  void submitForm() {
    if (_formKey.currentState!.validate()) {
      updatePlayer();
      Navigator.of(context).pop(true);
    }
  }
}
