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
  PlayerPosition _positionSelected = FootballPlayerPosition.portero;

  final Color _textColor = LightThemeAppColors.textColor;

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
          context,
          "Crear jugador",
          [
            IconButton(
              onPressed: () => submitForm(),
              icon: Icon(
                Icons.check,
              ),
            )
          ],
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              Icons.arrow_back,
            ),
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
                labelText: "Valoracion",
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(
              height: 20,
            ),
            genericDropDownMenu(
              context,
              initialSelection: _sportSelected,
              entries: Sport.values
                  .map(
                    (e) => DropdownMenuEntry(
                      value: e,
                      label: e.name,
                      style: genericDropDownMenuEntryStyle(context),
                    ),
                  )
                  .toList(),
              onSelected: (value) => setState(
                () {
                  _sportSelected = value!;
                  _positionSelected =
                      getFirstPositionBasedOnSportSelected(_sportSelected);
                },
              ),
              labelText: "Deporte",
            ),
            SizedBox(
              height: 20,
            ),
            genericDropDownMenu(
              context,
              initialSelection:
                  getFirstPositionBasedOnSportSelected(_sportSelected),
              entries: getPositionsBasedOnSportSelected(_sportSelected)
                  .map(
                    (pos) => DropdownMenuEntry(
                      value: pos,
                      label: pos.name,
                      style: genericDropDownMenuEntryStyle(context),
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
