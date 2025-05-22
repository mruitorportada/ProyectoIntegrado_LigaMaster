import 'package:flutter/material.dart';
import 'package:liga_master/models/competition/competition.dart';
import 'package:liga_master/screens/generic/appcolors.dart';
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
  final Color _backgroundColor = LightThemeAppColors.background;
  final Color _primaryColor = LightThemeAppColors.primaryColor;
  late bool _isLeague;
  int _currentPageIndex = 0;

  @override
  void initState() {
    _tabs = isCreator ? 4 : 3;
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
            competition.name,
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
          backgroundColor: _backgroundColor,
          body: _body,
          bottomNavigationBar: _bottomNavigationBar,
        ),
      ),
    );
  }

  Widget get _body {
    return <Widget>[
      if (isCreator) CompetitionInfoScreen(competition: competition),
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
        backgroundColor: _primaryColor,
        labelTextStyle: WidgetStateTextStyle.resolveWith(
          (_) => TextStyle(
            color: LightThemeAppColors.textColor,
          ),
        ),
        indicatorColor: LightThemeAppColors.secondaryColor,
        destinations: [
          if (isCreator)
            NavigationDestination(
              icon: Icon(
                Icons.info,
                color: Colors.white,
              ),
              label: "Información",
            ),
          NavigationDestination(
            icon: Icon(
              Icons.format_list_numbered,
              color: Colors.white,
            ),
            label: _isLeague ? "Clasificación" : "Resultados",
            //style: TextStyle(color: AppColors.textColor, fontSize: 11),
          ),
          NavigationDestination(
            icon: Icon(
              Icons.calendar_today,
              color: Colors.white,
            ),
            label: "Calendario",
          ),
          NavigationDestination(
            icon: Icon(
              Icons.bar_chart,
              color: Colors.white,
            ),
            label: "Estadísticas",
          )
        ],
      );
}
