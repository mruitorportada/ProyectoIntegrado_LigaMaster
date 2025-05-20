import 'package:flutter/material.dart';
import 'package:liga_master/models/enums.dart';
import 'package:liga_master/models/user/entities/user_player.dart';
import 'package:liga_master/screens/generic/appcolors.dart';
import 'package:liga_master/screens/generic/functions.dart';
import 'package:liga_master/screens/generic/generic_widgets/myappbar.dart';

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

  final Color _backgroundColor = AppColors.background;
  final Color _primaryColor = AppColors.accent;
  final Color _textColor = AppColors.textColor;
  final Color _labelColor = AppColors.labeltextColor;

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
              controller: _ratingController,
              style: TextStyle(color: _textColor),
              validator: ratingValidator,
              decoration: getGenericInputDecoration(
                  "Valoracion", _labelColor, _textColor),
              keyboardType: TextInputType.number,
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
                          style: TextStyle(
                            color: _textColor,
                          ),
                        ),
                      ))
                  .toList(),
              onChanged: (value) => setState(
                () {
                  _sportSelected = value!;
                  _positionSelected = null;
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            DropdownButtonFormField(
              value: _positionSelected,
              dropdownColor: _backgroundColor,
              style: TextStyle(color: _textColor),
              decoration: getGenericInputDecoration(
                  "Posición", _labelColor, _textColor),
              validator: positionValidator,
              items: getPositionsBasedOnSportSelected(_sportSelected)
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
                  _positionSelected = value;
                },
              ),
            )
          ],
        ),
      );

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
