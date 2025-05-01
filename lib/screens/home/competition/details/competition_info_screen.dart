import 'package:flutter/material.dart';
import 'package:liga_master/models/competition/competition.dart';
import 'package:liga_master/screens/generic/appcolors.dart';
import 'package:liga_master/screens/generic/functions.dart';

class CompetitionInfoScreen extends StatelessWidget {
  final Competition competition;
  const CompetitionInfoScreen({super.key, required this.competition});

  final Color _backgroundColor = AppColors.background;
  final Color _textColor = AppColors.text;
  final Color _labelColor = AppColors.labeltext;

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
          decoration:
              getGenericInputDecoration("Nombre", _labelColor, _textColor),
        ),
        SizedBox(
          height: 20,
        ),
        TextFormField(
          initialValue: competition.creator.username,
          readOnly: true,
          style: TextStyle(color: _textColor),
          decoration:
              getGenericInputDecoration("Creador", _labelColor, _textColor),
        ),
        SizedBox(
          height: 20,
        ),
        TextFormField(
          initialValue: competition.competitionSport.name,
          readOnly: true,
          style: TextStyle(color: _textColor),
          decoration:
              getGenericInputDecoration("Deporte", _labelColor, _textColor),
        ),
        SizedBox(
          height: 20,
        ),
        TextFormField(
          initialValue: competition.format.name,
          readOnly: true,
          style: TextStyle(color: _textColor),
          decoration:
              getGenericInputDecoration("Formato", _labelColor, _textColor),
        ),
        SizedBox(
          height: 20,
        ),
        TextFormField(
          initialValue: "${competition.numTeams}",
          readOnly: true,
          style: TextStyle(color: _textColor),
          decoration: getGenericInputDecoration(
              "Número de equipos", _labelColor, _textColor),
        ),
        SizedBox(
          height: 20,
        ),
        TextFormField(
          initialValue: competition.code,
          readOnly: true,
          style: TextStyle(color: _textColor),
          decoration:
              getGenericInputDecoration("Código", _labelColor, _textColor),
        ),
      ]);
}
