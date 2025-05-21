import 'package:flutter/material.dart';
import 'package:liga_master/models/enums.dart';
import 'package:liga_master/models/user/entities/user_team.dart';
import 'package:liga_master/screens/generic/appcolors.dart';
import 'package:liga_master/screens/generic/functions.dart';
import 'package:liga_master/screens/generic/generic_widgets/generic_dropdownmenu.dart';
import 'package:liga_master/screens/generic/generic_widgets/myappbar.dart';

class TeamCreationScreen extends StatefulWidget {
  final UserTeam team;
  const TeamCreationScreen({super.key, required this.team});

  @override
  State<TeamCreationScreen> createState() => _TeamCreationScreenState();
}

class _TeamCreationScreenState extends State<TeamCreationScreen> {
  final _formKey = GlobalKey<FormState>();
  UserTeam get team => widget.team;

  late TextEditingController _nameController;
  late TextEditingController _ratingController;
  Sport _sportSelected = Sport.football;

  final Color _backgroundColor = AppColors.background;
  final Color _secondaryColor = AppColors.accent;
  final Color _textColor = AppColors.textColor;
  final Color _labelColor = AppColors.labeltextColor;

  @override
  void initState() {
    _nameController = TextEditingController(text: team.name);
    _ratingController = TextEditingController(text: team.rating.toString());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: myAppBar(
          "Crear equipo",
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
            onPressed: () {
              Navigator.of(context).pop();
            },
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
              validator: nameValidator,
              style: TextStyle(color: _textColor),
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
                  "Valoración", _labelColor, _textColor),
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
                    ),
                  )
                  .toList(),
              onSelected: (value) => setState(
                () {
                  _sportSelected = value!;
                },
              ),
              labelText: "Deporte",
            ),
          ],
        ),
      );

  void updateTeam() {
    team.name = _nameController.value.text.trim();
    team.rating = double.parse(_ratingController.value.text);
    team.sportPlayed = _sportSelected;
  }

  void submitForm() {
    if (_formKey.currentState!.validate()) {
      updateTeam();
      Navigator.of(context).pop(true);
    }
  }
}
