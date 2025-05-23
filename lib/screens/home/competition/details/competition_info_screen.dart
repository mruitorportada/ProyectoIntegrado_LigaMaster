import 'package:flutter/material.dart';
import 'package:liga_master/models/competition/competition.dart';

class CompetitionInfoScreen extends StatelessWidget {
  final Competition competition;
  const CompetitionInfoScreen({super.key, required this.competition});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _body,
      ),
    );
  }

  Widget get _body => ListView(
        padding: EdgeInsets.all(20),
        children: <Widget>[
          TextFormField(
            initialValue: competition.name,
            readOnly: true,
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
            decoration: InputDecoration(
              labelText: "Código",
            ),
          ),
        ],
      );
}
