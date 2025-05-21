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
  final Color _tabBackgroundColor = AppColors.cardColor;
  final Color _tabTextColor = AppColors.textColor;

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
                    color: AppColors.accent,
                  ),
                )
              ],
              null,
              isHomeScreen: true),
          body: _body,
          drawer: myDrawer(context, homeScreenViewModel),
          bottomNavigationBar:
              Container(color: _tabBackgroundColor, child: _tabBar),
        ),
      ),
    );
  }

  Widget get _body {
    return TabBarView(children: [
      CompetitionListScreen(
        homeScreenViewModel: homeScreenViewModel,
      ),
      TeamListScreen(
        homeScreenViewModel: homeScreenViewModel,
      ),
      PlayerListScreen(
        homeScreenViewModel: homeScreenViewModel,
      ),
    ]);
  }

  TabBar get _tabBar => TabBar(
        tabs: <Widget>[
          Tab(
            icon: Icon(Icons.sports_soccer_outlined, color: _tabTextColor),
            child: Text(
              "Competiciones",
              style: TextStyle(color: _tabTextColor),
            ),
          ),
          Tab(
            icon: Icon(
              Icons.people,
              color: Colors.white,
            ),
            child: Text(
              "Equipos",
              style: TextStyle(color: _tabTextColor),
            ),
          ),
          Tab(
            icon: Icon(Icons.person, color: _tabTextColor),
            child: Text(
              "Jugadores",
              style: TextStyle(color: _tabTextColor),
            ),
          )
        ],
      );
}
