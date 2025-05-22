import 'package:flutter/material.dart';
import 'package:liga_master/models/competition/competition.dart';
import 'package:liga_master/screens/generic/appcolors.dart';

class CompetitionInfoScreen extends StatelessWidget {
  final Competition competition;
  const CompetitionInfoScreen({super.key, required this.competition});

  final Color _backgroundColor = LightThemeAppColors.background;
  final Color _textColor = LightThemeAppColors.textColor;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: _backgroundColor,
      body: _body,
    ));
  }

  Widget get _body => ListView(padding: EdgeInsets.all(20), children: <Widget>[
        TextFormField(
          initialValue: competition.name,
          readOnly: true,
          style: TextStyle(color: _textColor),
          decoration: InputDecoration(
            labelText: "Nombre",
          ),
        ),
        SizedBox(
          height: 20,
        ),
        TextFormField(
          initialValue: competition.creator.username,
          readOnly: true,
          style: TextStyle(color: _textColor),
          decoration: InputDecoration(
            labelText: "Creador",
          ),
        ),
        SizedBox(
          height: 20,
        ),
        TextFormField(
          initialValue: competition.competitionSport.name,
          readOnly: true,
          style: TextStyle(color: _textColor),
          decoration: InputDecoration(
            labelText: "Deporte",
          ),
        ),
        SizedBox(
          height: 20,
        ),
        TextFormField(
          initialValue: competition.format.name,
          readOnly: true,
          style: TextStyle(color: _textColor),
          decoration: InputDecoration(
            labelText: "Formato",
          ),
        ),
        SizedBox(
          height: 20,
        ),
        TextFormField(
          initialValue: "${competition.numTeams}",
          readOnly: true,
          style: TextStyle(color: _textColor),
          decoration: InputDecoration(
            labelText: "Número de equipos",
          ),
        ),
        SizedBox(
          height: 20,
        ),
        TextFormField(
          initialValue: competition.code,
          readOnly: true,
          style: TextStyle(color: _textColor),
          decoration: InputDecoration(
            labelText: "Código",
          ),
        ),
      ]);
}
