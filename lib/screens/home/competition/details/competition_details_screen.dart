import 'package:flutter/material.dart';
import 'package:liga_master/models/appstrings/appstrings_controller.dart';
import 'package:liga_master/models/competition/competition.dart';
import 'package:liga_master/screens/generic/generic_widgets/myappbar.dart';
import 'package:liga_master/screens/home/competition/details/competition_details_viewmodel.dart';
import 'package:liga_master/screens/home/competition/details/competition_fixtures_screen.dart';
import 'package:liga_master/screens/home/competition/details/competition_info_screen.dart';
import 'package:liga_master/screens/home/competition/details/competition_ranking_screen.dart';
import 'package:liga_master/screens/home/competition/details/competition_stats_screen.dart';
import 'package:liga_master/screens/home/competition/details/competition_teams_details_screen.dart';
import 'package:liga_master/screens/home/competition/details/competition_tournament_rounds_list.dart';
import 'package:provider/provider.dart';

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
  late bool _isLeague;
  int _currentPageIndex = 0;

  @override
  void initState() {
    _tabs = isCreator ? 5 : 4;
    _isLeague = competition.format == CompetitionFormat.league;

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
            context,
            _getAppBarTitleBasedOnTabSelected(),
            [],
            IconButton(
              onPressed: () {
                if (isCreator) {
                  setState(
                    () {
                      viewModel.saveCompetition(context);
                    },
                  );
                }
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.arrow_back),
            ),
          ),
          body: _body,
          bottomNavigationBar: _bottomNavigationBar,
        ),
      ),
    );
  }

  Widget get _body {
    return <Widget>[
      if (isCreator) CompetitionInfoScreen(competition: competition),
      CompetitionTeamsDetailsScreen(teams: competition.teams),
      if (_isLeague)
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
        isLeague: _isLeague,
      ),
      CompetitionStatsScreen(
        viewModel: viewModel,
      ),
    ][_currentPageIndex];
  }

  NavigationBar get _bottomNavigationBar => NavigationBar(
        onDestinationSelected: (int index) {
          setState(
            () {
              _currentPageIndex = index;
            },
          );
        },
        selectedIndex: _currentPageIndex,
        destinations: [
          if (isCreator)
            NavigationDestination(
              icon: Icon(
                Icons.info,
              ),
              label: "",
            ),
          NavigationDestination(icon: Icon(Icons.people), label: ""),
          NavigationDestination(
            icon: Icon(
              Icons.format_list_numbered,
            ),
            label: "",
          ),
          NavigationDestination(
            icon: Icon(
              Icons.calendar_today,
            ),
            label: "",
          ),
          NavigationDestination(
            icon: Icon(
              Icons.bar_chart,
            ),
            label: "",
          )
        ],
      );

  String _getAppBarTitleBasedOnTabSelected() {
    final controller =
        Provider.of<AppStringsController>(context, listen: false);
    final strings = controller.strings!;

    return switch (_currentPageIndex) {
      0 => "${competition.name} - ${strings.infoTabLabel}",
      1 => "${competition.name} - ${strings.teamsTabLabel}",
      2 =>
        "${competition.name} - ${_isLeague ? strings.rankingTabLabel : strings.resultsTabLabel}",
      3 => "${competition.name} - ${strings.fixturesTabLabel}",
      4 => "${competition.name} - ${strings.statsTabLabel}",
      _ => "",
    };
  }
}
