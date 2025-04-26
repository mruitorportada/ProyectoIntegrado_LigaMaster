import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:liga_master/screens/generic_widgets/myappbar.dart';
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
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: myAppBar(
              "Liga Master",
              [
                IconButton(
                    onPressed: () {}, icon: Icon(Icons.filter_alt_outlined))
              ],
              null,
              isHomeScreen: true),
          body: _body,
          drawer: _drawer,
          bottomNavigationBar: _tabBar,
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
            accountName: Text(user.username),
            accountEmail: Text(user.email),
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
          const Tab(
            icon: Icon(Icons.sports_soccer_outlined, color: Colors.black),
            child: Text(
              "Competiciones",
              style: TextStyle(color: Colors.black),
            ),
          ),
          const Tab(
            icon: Icon(
              Icons.people,
              color: Colors.black,
            ),
            child: Text(
              "Equipos",
              style: TextStyle(color: Colors.black),
            ),
          ),
          const Tab(
            icon: Icon(
              Icons.person,
              color: Colors.black,
            ),
            child: Text(
              "Jugadores",
              style: TextStyle(color: Colors.black),
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
