import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:liga_master/screens/generic/generic_widgets/myappbar.dart';
import 'package:liga_master/screens/home/competition/list/competition_list_screen.dart';
import 'package:liga_master/screens/home/home_screen_viewmodel.dart';
import 'package:liga_master/screens/home/player/list/player_list_screen.dart';
import 'package:liga_master/screens/home/team/list/team_list_screen.dart';
import 'package:liga_master/screens/login/login_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Color _backgroundColor = const Color.fromARGB(255, 58, 17, 100);
  final Color _tabBackgroundColor = const Color.fromRGBO(0, 204, 204, 1);
  final Color _tabTextColor = Colors.white;
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
                      Icons.filter_alt_outlined,
                      color: Colors.white,
                    ))
              ],
              null,
              isHomeScreen: true),
          body: _body,
          drawer: _drawer,
          bottomNavigationBar:
              Container(color: _tabBackgroundColor, child: _tabBar),
        ),
      ),
    );
  }

  Widget get _body {
    return TabBarView(children: [
      CompetitionListScreen(),
      TeamListScreen(),
      PlayerListScreen(),
    ]);
  }

  Widget get _drawer {
    var homeScreenViewmodel =
        Provider.of<HomeScreenViewmodel>(context, listen: false);
    var user = homeScreenViewmodel.user;
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: _backgroundColor),
            accountName: Text(
              user.username,
              style: TextStyle(color: Colors.white),
            ),
            accountEmail: Text(
              user.email,
              style: TextStyle(color: Colors.white70),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.logout,
            ),
            title: Text(
              "Cerrar sesión",
              style: TextStyle(),
            ),
            onTap: () => onLogoutTap(context),
          )
        ],
      ),
    );
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

  void onLogoutTap(BuildContext context) {
    var homeScreenViewModel =
        Provider.of<HomeScreenViewmodel>(context, listen: false);
    homeScreenViewModel.onLogOut();
    FirebaseAuth.instance.signOut();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}
