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
    return competitionList(homeScreenViewModel.competitions);
  }

  ListView competitionList(List<Competition> competitions) => ListView.builder(
        itemCount: competitions.length,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        itemBuilder: (context, index) => ListenableBuilder(
          listenable: competitions[index],
          builder: (context, _) => competitionItem(competitions[index]),
        ),
      );

  Card competitionItem(Competition competition) => Card(
        child: ListTile(
          title: Text(competition.name),
          subtitle: Text("Prueba"),
          trailing: Icon(Icons.sports_soccer_outlined),
        ),
      );

  FloatingActionButton get _floatingActionButton => FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      );
}
