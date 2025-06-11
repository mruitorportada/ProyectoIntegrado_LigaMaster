import 'package:flutter/material.dart';
import 'package:liga_master/models/appstrings/appstrings.dart';
import 'package:liga_master/models/appstrings/appstrings_controller.dart';
import 'package:liga_master/screens/generic/generic_widgets/myappbar.dart';
import 'package:liga_master/screens/generic/generic_widgets/mydrawer.dart';
import 'package:liga_master/screens/home/competition/list/competition_list_screen.dart';
import 'package:liga_master/screens/home/home_screen_viewmodel.dart';
import 'package:liga_master/screens/home/player/list/player_list_screen.dart';
import 'package:liga_master/screens/home/team/list/team_list_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  final HomeScreenViewmodel homeScreenViewModel;
  const HomeScreen({super.key, required this.homeScreenViewModel});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeScreenViewmodel get _homeScreenViewModel => widget.homeScreenViewModel;

  int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<AppStringsController>(context);
    if (controller.isLoading) {
      return Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final strings = controller.strings!;

    return SafeArea(
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar:
              myAppBar(context, "Liga Master", [], null, isHomeScreen: true),
          body: _body,
          drawer: myDrawer(context, _homeScreenViewModel),
          bottomNavigationBar: _bottomNavigationBar(strings),
        ),
      ),
    );
  }

  Widget get _body => PopScope(
        canPop: false,
        child: <Widget>[
          CompetitionListScreen(
            homeScreenViewModel: _homeScreenViewModel,
          ),
          TeamListScreen(
            homeScreenViewModel: _homeScreenViewModel,
          ),
          PlayerListScreen(
            homeScreenViewModel: _homeScreenViewModel,
          ),
        ][_currentPageIndex],
      );

  Widget _bottomNavigationBar(AppStrings strings) => NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        selectedIndex: _currentPageIndex,
        destinations: <Widget>[
          NavigationDestination(
            icon: Icon(Icons.emoji_events),
            label: strings.competitionsLabel,
          ),
          NavigationDestination(
            icon: Icon(Icons.people),
            label: strings.teamsLabel,
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: strings.playersLabel,
          ),
        ],
      );
}
