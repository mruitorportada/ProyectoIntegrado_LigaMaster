import 'package:flutter/material.dart';
import 'package:liga_master/models/appstrings/appstrings_controller.dart';
import 'package:liga_master/models/competition/competition.dart';
import 'package:liga_master/screens/generic/functions.dart';
import 'package:provider/provider.dart';

class CompetitionInfoScreen extends StatelessWidget {
  final Competition competition;
  const CompetitionInfoScreen({super.key, required this.competition});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _body(context),
      ),
    );
  }

  Widget _body(BuildContext context) {
    final controller =
        Provider.of<AppStringsController>(context, listen: false);
    final strings = controller.strings!;

    return ListView(
      padding: EdgeInsets.all(20),
      children: <Widget>[
        TextFormField(
          initialValue: competition.name,
          readOnly: true,
          decoration: InputDecoration(
            labelText: strings.nameLabel,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        TextFormField(
          initialValue: competition.creator.username,
          readOnly: true,
          decoration: InputDecoration(
            labelText: strings.creatorLabel,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        TextFormField(
          initialValue: getSportLabel(strings, competition.competitionSport),
          readOnly: true,
          decoration: InputDecoration(
            labelText: strings.sportLabel,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        TextFormField(
          initialValue: getCompetitionFormatLabel(strings, competition.format),
          readOnly: true,
          decoration: InputDecoration(
            labelText: strings.formatLabel,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        TextFormField(
          initialValue: "${competition.numTeams}",
          readOnly: true,
          decoration: InputDecoration(
            labelText: strings.teamsLabel,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        TextFormField(
          initialValue: competition.code,
          readOnly: true,
          decoration: InputDecoration(
            labelText: strings.codeLabel,
          ),
        ),
      ],
    );
  }
}
