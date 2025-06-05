import 'package:flutter/material.dart';
import 'package:liga_master/models/appstrings/appstrings.dart';
import 'package:liga_master/models/appstrings/appstrings_controller.dart';
import 'package:liga_master/models/user/app_user.dart';
import 'package:liga_master/screens/generic/generic_widgets/myappbar.dart';
import 'package:liga_master/screens/generic/generic_widgets/mydrawer.dart';
import 'package:liga_master/screens/home/competition/list/competition_list_screen.dart';
import 'package:liga_master/screens/home/home_screen_viewmodel.dart';
import 'package:liga_master/screens/home/player/list/player_list_screen.dart';
import 'package:liga_master/screens/home/team/list/team_list_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  final AppUser user;
  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AppUser get _user => widget.user;

  int _currentPageIndex = 0;
  late HomeScreenViewmodel homeScreenViewModel;

  @override
  void initState() {
    homeScreenViewModel = HomeScreenViewmodel(_user);
    homeScreenViewModel.loadUserData(context);
    super.initState();
  }

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
          drawer: myDrawer(context, homeScreenViewModel),
          bottomNavigationBar: _bottomNavigationBar(strings),
        ),
      ),
    );
  }

  Widget get _body => <Widget>[
        CompetitionListScreen(
          homeScreenViewModel: homeScreenViewModel,
        ),
        TeamListScreen(
          homeScreenViewModel: homeScreenViewModel,
        ),
        PlayerListScreen(
          homeScreenViewModel: homeScreenViewModel,
        ),
      ][_currentPageIndex];

  Widget _bottomNavigationBar(AppStrings strings) => NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        selectedIndex: _currentPageIndex,
        destinations: <Widget>[
          NavigationDestination(
            icon: Icon(Icons.sports_soccer_outlined),
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
