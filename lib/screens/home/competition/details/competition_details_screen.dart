import 'package:flutter/material.dart';
import 'package:liga_master/models/competition/competition.dart';
import 'package:liga_master/screens/generic/generic_widgets/myappbar.dart';
import 'package:liga_master/screens/home/competition/details/competition_details_viewmodel.dart';
import 'package:liga_master/screens/home/competition/details/competition_fixtures_screen.dart';
import 'package:liga_master/screens/home/competition/details/competition_info_screen.dart';
import 'package:liga_master/screens/home/competition/details/competition_ranking_screen.dart';
import 'package:liga_master/screens/home/competition/details/competition_stats_screen.dart';
import 'package:liga_master/screens/home/competition/details/competition_tournament_rounds_list.dart';

class CompetitionDetailsScreen extends StatefulWidget {
  final Competition competition;
  final bool isCreator;
  const CompetitionDetailsScreen(
      {super.key, required this.competition, required this.isCreator});

  @override
  State<CompetitionDetailsScreen> createState() =>
      _CompetitionDetailsScreenState();
}

class _CompetitionDetailsScreenState extends State<CompetitionDetailsScreen> {
  Competition get competition => widget.competition;
  bool get isCreator => widget.isCreator;
  late int _tabs;
  late CompetitionDetailsViewmodel viewModel;
  final Color _backgroundColor = const Color.fromARGB(255, 58, 17, 100);
  late bool isLeague;

  @override
  void initState() {
    _tabs = isCreator ? 4 : 3;
    isLeague = competition.format == CompetitionFormat.league;

    viewModel = CompetitionDetailsViewmodel(competition);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: _tabs,
        child: Scaffold(
          appBar: myAppBar(
            competition.name,
            _backgroundColor,
            [],
            IconButton(
              onPressed: () {
                if (isCreator) {
                  setState(() {
                    viewModel.saveCompetition(context);
                  });
                }
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.arrow_back),
            ),
          ),
          body: _body,
          bottomNavigationBar: _tabBar,
        ),
      ),
    );
  }

  Widget get _body {
    return TabBarView(children: [
      if (_tabs == 4) CompetitionInfoScreen(competition: competition),
      if (isLeague)
        CompetitionRankingScreen(
          viewModel: viewModel,
        )
      else
        CompetitionTournamentRoundsList(
          viewModel: viewModel,
        ),
      CompetitionFixturesScreen(
        viewModel: viewModel,
        isCreator: isCreator,
        isLeague: isLeague,
      ),
      CompetitionStatsScreen(
        viewModel: viewModel,
      ),
    ]);
  }

  TabBar get _tabBar => TabBar(
        tabs: _tabs == 4 ? _creatorTab : _userTabs,
      );
}

List<Tab> get _userTabs => [
      const Tab(
        icon: Icon(Icons.format_list_numbered, color: Colors.black),
      ),
      const Tab(
        icon: Icon(
          Icons.calendar_today,
          color: Colors.black,
        ),
      ),
      const Tab(
        icon: Icon(
          Icons.bar_chart,
          color: Colors.black,
        ),
      )
    ];

List<Tab> get _creatorTab => [
      const Tab(
        icon: Icon(Icons.info, color: Colors.black),
      ),
      const Tab(
        icon: Icon(Icons.format_list_numbered, color: Colors.black),
      ),
      const Tab(
        icon: Icon(
          Icons.calendar_today,
          color: Colors.black,
        ),
      ),
      const Tab(
        icon: Icon(
          Icons.bar_chart,
          color: Colors.black,
        ),
      )
    ];
