import 'package:flutter/material.dart';
import 'package:liga_master/models/user/app_user.dart';
import 'package:liga_master/screens/generic/appcolors.dart';
import 'package:liga_master/screens/generic/generic_widgets/myappbar.dart';
import 'package:liga_master/screens/generic/generic_widgets/mydrawer.dart';
import 'package:liga_master/screens/home/competition/list/competition_list_screen.dart';
import 'package:liga_master/screens/home/home_screen_viewmodel.dart';
import 'package:liga_master/screens/home/player/list/player_list_screen.dart';
import 'package:liga_master/screens/home/team/list/team_list_screen.dart';

class HomeScreen extends StatefulWidget {
  final AppUser user;
  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AppUser get _user => widget.user;

  final Color _backgroundColor = AppColors.background;
  final Color _primaryColor = AppColors.primaryColor;
  final Color _tabTextColor = AppColors.textColor;

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
    return SafeArea(
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: _backgroundColor,
          appBar: myAppBar(
              "Liga Master",
              _backgroundColor,
              [
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.filter_alt,
                    color: AppColors.secondaryColor,
                  ),
                )
              ],
              null,
              isHomeScreen: true),
          body: _body,
          drawer: myDrawer(context, homeScreenViewModel),
          bottomNavigationBar: _bottomNavigationBar,
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

  NavigationBar get _bottomNavigationBar => NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        selectedIndex: _currentPageIndex,
        backgroundColor: _primaryColor,
        labelTextStyle: WidgetStateTextStyle.resolveWith(
          (_) => TextStyle(
            color: _tabTextColor,
          ),
        ),
        indicatorColor: AppColors.secondaryColor,
        destinations: <Widget>[
          NavigationDestination(
            icon: Icon(Icons.sports_soccer_outlined, color: _tabTextColor),
            label: "Competiciones",
          ),
          NavigationDestination(
            icon: Icon(Icons.people, color: _tabTextColor),
            label: "Equipos",
          ),
          NavigationDestination(
            icon: Icon(Icons.person, color: _tabTextColor),
            label: "Jugadores",
          ),
        ],
      );
}
