import 'package:flutter/material.dart';
import 'package:liga_master/models/enums.dart';
import 'package:liga_master/models/user/entities/user_team.dart';
import 'package:liga_master/screens/generic_widgets/myappbar.dart';

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
          [
            IconButton(
              onPressed: () => submitForm(),
              icon: Icon(
                Icons.check, /*color: dataChanged ? Colors.black : Colors.grey*/
              ),
            )
          ],
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
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
                },
              ),
            ),
          ],
        ),
      );

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
