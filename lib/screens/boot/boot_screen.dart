import 'package:flutter/material.dart';
import 'package:liga_master/models/user/app_user.dart';
import 'package:liga_master/screens/home/home_screen.dart';
import 'package:liga_master/screens/home/home_screen_viewmodel.dart';
import 'package:liga_master/screens/login/login_screen.dart';
import 'package:liga_master/services/appuser_service.dart';
import 'package:liga_master/services/auth_service.dart';
import 'package:liga_master/services/competition_service.dart';
import 'package:liga_master/services/player_service.dart';
import 'package:liga_master/services/team_service.dart';
import 'package:provider/provider.dart';

class BootScreen extends StatefulWidget {
  const BootScreen({super.key});

  @override
  State<BootScreen> createState() => _BootScreenState();
}

class _BootScreenState extends State<BootScreen> {
  late AuthService auth;
  final Color _backgroundColor = Color.fromARGB(255, 58, 17, 100);

  Future<void> boot() async {
    auth = Provider.of<AuthService>(context, listen: false);
    await auth.init();
  }

  Future<void> setHomeScreenViewModelUser() async {
    HomeScreenViewmodel homeScreenViewmodel =
        Provider.of<HomeScreenViewmodel>(context, listen: false);
    AppUserService userService =
        Provider.of<AppUserService>(context, listen: false);
    CompetitionService competitionService =
        Provider.of<CompetitionService>(context, listen: false);
    TeamService teamService = Provider.of<TeamService>(context, listen: false);
    PlayerService playerService =
        Provider.of<PlayerService>(context, listen: false);

    AppUser? user = await userService.loadAppUserFromFirestore(auth.user!.uid);
    if (user != null) {
      homeScreenViewmodel.user = user;
      homeScreenViewmodel.loadUserData(
          competitionService, teamService, playerService, userService);
      await Future.delayed(Duration(seconds: 1));
    }
  }

  @override
  void initState() {
    var navigator = Navigator.of(context);
    boot().then(
      (_) => {
        if (auth.user != null)
          {
            setHomeScreenViewModelUser().then(
              (_) => navigator.pushReplacement(
                MaterialPageRoute(
                  builder: (context) => HomeScreen(),
                ),
              ),
            ),
          }
        else
          {
            navigator.pushReplacement(
              MaterialPageRoute(
                builder: (context) => LoginScreen(),
              ),
            )
          }
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(
            color: _backgroundColor,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage("assets/ligaMaster_logo.png"),
                ),
                Text(
                  "Cargando datos...",
                  style: TextStyle(color: Colors.white),
                )
              ],
            )),
      );
}
