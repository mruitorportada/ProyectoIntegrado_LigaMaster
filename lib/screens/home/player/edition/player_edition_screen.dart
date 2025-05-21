import 'package:flutter/material.dart';
import 'package:liga_master/models/enums.dart';
import 'package:liga_master/models/user/entities/user_player.dart';
import 'package:liga_master/screens/generic/appcolors.dart';
import 'package:liga_master/screens/generic/functions.dart';
import 'package:liga_master/screens/generic/generic_widgets/generic_dropdownmenu.dart';
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
  final Color _textColor = AppColors.textColor;

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
              decoration: getGenericInputDecoration("Nombre"),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              initialValue: player.currentTeamName ?? "Sin equipo",
              style: TextStyle(color: _textColor),
              readOnly: true,
              decoration: getGenericInputDecoration("Equipo"),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: _ratingController,
              style: TextStyle(color: _textColor),
              validator: ratingValidator,
              decoration: getGenericInputDecoration("Valoración"),
              keyboardType: TextInputType.number,
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              initialValue: player.sportPlayed.name,
              style: TextStyle(color: _textColor),
              readOnly: true,
              decoration: getGenericInputDecoration("Deporte"),
            ),
            SizedBox(
              height: 20,
            ),
            genericDropDownMenu(
              initialSelection:
                  getFirstPositionBasedOnSportSelected(player.sportPlayed),
              entries: getPositionsBasedOnSportSelected(player.sportPlayed)
                  .map(
                    (pos) => DropdownMenuEntry(
                      value: pos,
                      label: pos.name,
                      style: genericDropDownMenuEntryStyle(),
                    ),
                  )
                  .toList(),
              onSelected: (value) => setState(
                () {
                  _positionSelected = value;
                },
              ),
              labelText: "Posición",
            )
          ],
        ),
      );

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
