import 'package:flutter/material.dart';
import 'package:liga_master/models/enums.dart';
import 'package:liga_master/models/user/entities/user_player.dart';
import 'package:liga_master/screens/generic/appcolors.dart';
import 'package:liga_master/screens/generic/functions.dart';
import 'package:liga_master/screens/generic/generic_widgets/myappbar.dart';

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

  final Color _backgroundColor = AppColors.background;
  final Color _primaryColor = AppColors.accent;
  final Color _textColor = AppColors.text;
  final Color _labelColor = AppColors.labeltext;

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
          _backgroundColor,
          [
            IconButton(
              onPressed: () => submitForm(),
              icon: Icon(
                Icons.check,
                color: _primaryColor,
              ),
            )
          ],
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              Icons.arrow_back,
              color: _primaryColor,
            ),
          ),
        ),
        body: _body,
        backgroundColor: _backgroundColor,
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
              decoration:
                  getGenericInputDecoration("Nombre", _labelColor, _textColor),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              initialValue: player.currentTeamName ?? "Sin equipo",
              style: TextStyle(color: _textColor),
              readOnly: true,
              decoration:
                  getGenericInputDecoration("Equipo", _labelColor, _textColor),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: _ratingController,
              style: TextStyle(color: _textColor),
              validator: ratingValidator,
              decoration: getGenericInputDecoration(
                  "Valoración", _labelColor, _textColor),
              keyboardType: TextInputType.number,
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              initialValue: player.sportPlayed.name,
              style: TextStyle(color: _textColor),
              readOnly: true,
              decoration:
                  getGenericInputDecoration("Deporte", _labelColor, _textColor),
            ),
            SizedBox(
              height: 20,
            ),
            DropdownButtonFormField(
              value: _positionSelected,
              dropdownColor: _backgroundColor,
              decoration: getGenericInputDecoration(
                  "Posicion", _labelColor, _textColor),
              validator: positionValidator,
              items: getPositionsBasedOnSportSelected()
                  .map(
                    (pos) => DropdownMenuItem(
                      value: pos,
                      child: Text(
                        pos.name,
                        style: TextStyle(color: _textColor),
                      ),
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
