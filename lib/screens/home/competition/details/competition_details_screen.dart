import 'package:flutter/material.dart';
import 'package:liga_master/models/competition/competition.dart';
import 'package:liga_master/screens/generic/generic_widgets/myappbar.dart';
import 'package:liga_master/screens/home/competition/details/competition_details_viewmodel.dart';
import 'package:liga_master/screens/home/competition/details/competition_fixtures_screen.dart';
import 'package:liga_master/screens/home/competition/details/competition_info_screen.dart';
import 'package:liga_master/screens/home/competition/details/competition_ranking_screen.dart';
import 'package:liga_master/screens/home/competition/details/competition_stats_screen.dart';
import 'package:liga_master/screens/home/home_screen_viewmodel.dart';
import 'package:provider/provider.dart';

class CompetitionDetailsScreen extends StatefulWidget {
  final Competition competition;
  const CompetitionDetailsScreen({super.key, required this.competition});

  @override
  State<CompetitionDetailsScreen> createState() =>
      _CompetitionDetailsScreenState();
}

class _CompetitionDetailsScreenState extends State<CompetitionDetailsScreen> {
  Competition get competition => widget.competition;
  late int _tabs;
  late CompetitionDetailsViewmodel viewmodel;
  final Color _backgroundColor = const Color.fromARGB(255, 58, 17, 100);

  @override
  void initState() {
    var homeScreenViewModel =
        Provider.of<HomeScreenViewmodel>(context, listen: false);
    _tabs = competition.creator.id == homeScreenViewModel.user.id ? 4 : 3;
    viewmodel = CompetitionDetailsViewmodel(competition);
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
              onPressed: () => Navigator.of(context).pop(),
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
      CompetitionRankingScreen(
        viewmodel: viewmodel,
        isLeague: competition.format == CompetitionFormat.league,
      ),
      CompetitionFixturesScreen(viewmodel: viewmodel),
      CompetitionStatsScreen(
        viewmodel: viewmodel,
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
