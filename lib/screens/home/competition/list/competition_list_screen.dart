import 'package:flutter/material.dart';
import 'package:liga_master/models/competition/competition.dart';
import 'package:liga_master/screens/home/home_screen_viewmodel.dart';
import 'package:provider/provider.dart';

class CompetitionListScreen extends StatefulWidget {
  const CompetitionListScreen({super.key});

  @override
  State<CompetitionListScreen> createState() => _CompetitionListScreenState();
}

class _CompetitionListScreenState extends State<CompetitionListScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _body,
        floatingActionButton: _floatingActionButton,
      ),
    );
  }

  Widget get _body {
    var homeScreenViewModel =
        Provider.of<HomeScreenViewmodel>(context, listen: false);
    return competitionList(homeScreenViewModel);
  }

  ListenableBuilder competitionList(HomeScreenViewmodel homeScreenViewModel) =>
      ListenableBuilder(
        listenable: homeScreenViewModel,
        builder: (context, _) => ListView.builder(
          itemCount: homeScreenViewModel.competitions.length,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          itemBuilder: (context, index) => ListenableBuilder(
            listenable: homeScreenViewModel.competitions[index],
            builder: (context, _) =>
                competitionItem(homeScreenViewModel.competitions[index]),
          ),
        ),
      );

  Card competitionItem(Competition competition) => Card(
        child: ListTile(
          title: Text(competition.name),
          subtitle: Text(
              "${competition.format.name} - ${competition.competitionSport.name}"),
          trailing: Icon(Icons.sports_soccer_outlined),
        ),
      );

  FloatingActionButton get _floatingActionButton => FloatingActionButton(
        onPressed: () {
          var homeScreenViewModel =
              Provider.of<HomeScreenViewmodel>(context, listen: false);
          homeScreenViewModel.onCreateCompetition(context);
        },
        child: Icon(Icons.add),
      );
}
