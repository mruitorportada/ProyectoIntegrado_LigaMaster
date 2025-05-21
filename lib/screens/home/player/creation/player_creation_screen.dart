import 'package:flutter/material.dart';
import 'package:liga_master/models/enums.dart';
import 'package:liga_master/models/user/entities/user_player.dart';
import 'package:liga_master/screens/generic/appcolors.dart';
import 'package:liga_master/screens/generic/functions.dart';
import 'package:liga_master/screens/generic/generic_widgets/generic_dropdownmenu.dart';
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
  final Color _secondaryColor = AppColors.accent;
  final Color _textColor = AppColors.textColor;

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
                color: _secondaryColor,
              ),
            )
          ],
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              Icons.arrow_back,
              color: _secondaryColor,
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
              controller: _ratingController,
              style: TextStyle(color: _textColor),
              validator: ratingValidator,
              decoration: getGenericInputDecoration("Valoracion"),
              keyboardType: TextInputType.number,
            ),
            SizedBox(
              height: 20,
            ),
            genericDropDownMenu(
              initialSelection: _sportSelected,
              entries: Sport.values
                  .map(
                    (e) => DropdownMenuEntry(
                      value: e,
                      label: e.name,
                      style: genericDropDownMenuEntryStyle(),
                    ),
                  )
                  .toList(),
              onSelected: (value) => setState(
                () {
                  _sportSelected = value!;
                  _positionSelected = null;
                },
              ),
              labelText: "Deporte",
            ),
            SizedBox(
              height: 20,
            ),
            genericDropDownMenu(
              initialSelection:
                  getFirstPositionBasedOnSportSelected(_sportSelected),
              entries: getPositionsBasedOnSportSelected(_sportSelected)
                  .map(
                    (pos) => DropdownMenuEntry(
                        value: pos,
                        label: pos.name,
                        style: genericDropDownMenuEntryStyle()),
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
