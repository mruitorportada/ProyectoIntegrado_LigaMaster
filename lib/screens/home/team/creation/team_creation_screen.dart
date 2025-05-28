import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:liga_master/models/enums.dart';
import 'package:liga_master/models/user/entities/user_team.dart';
import 'package:liga_master/screens/generic/appcolors.dart';
import 'package:liga_master/screens/generic/functions.dart';
import 'package:liga_master/screens/generic/generic_widgets/generic_dropdownmenu.dart';
import 'package:liga_master/screens/generic/generic_widgets/myappbar.dart';
import 'package:liga_master/services/team_service.dart';
import 'package:provider/provider.dart';

class TeamCreationScreen extends StatefulWidget {
  final UserTeam team;
  final String userId;
  const TeamCreationScreen(
      {super.key, required this.team, required this.userId});

  @override
  State<TeamCreationScreen> createState() => _TeamCreationScreenState();
}

class _TeamCreationScreenState extends State<TeamCreationScreen> {
  final _formKey = GlobalKey<FormState>();
  UserTeam get team => widget.team;
  String get _userId => widget.userId;

  late TextEditingController _nameController;
  late TextEditingController _ratingController;
  Sport _sportSelected = Sport.football;

  final Color _textColor = LightThemeAppColors.textColor;

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
          context,
          "Crear equipo",
          [
            IconButton(
              onPressed: () => _submitForm(
                toastColor: Theme.of(context).primaryColor,
              ),
              icon: Icon(
                Icons.check,
              ),
            )
          ],
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
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
              validator: nameValidator,
              style: TextStyle(color: _textColor),
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
                labelText: "Valoración",
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

  void _updateTeam() {
    team.name = _nameController.value.text.trim();
    team.rating = double.parse(_ratingController.value.text);
    team.sportPlayed = _sportSelected;
  }

  void _submitForm({required Color toastColor}) async {
    var teamService = Provider.of<TeamService>(context, listen: false);
    bool uniqueName = false;
    if (_formKey.currentState!.validate()) {
      uniqueName = await teamService.checkTeamNameIsUnique(
          _nameController.value.text.trim(), _userId);

      if (!uniqueName) {
        Fluttertoast.showToast(
            msg: "El nombre debe de ser único", backgroundColor: toastColor);
        return;
      }

      _updateTeam();
      if (mounted) Navigator.of(context).pop(true);
    }
  }
}
