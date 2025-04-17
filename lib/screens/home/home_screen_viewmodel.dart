import 'package:flutter/material.dart';
import 'package:liga_master/models/competition/competition.dart';
import 'package:liga_master/models/user/entities/user_player.dart';
import 'package:liga_master/models/user/entities/user_team.dart';
import 'package:liga_master/models/user/app_user.dart';
import 'package:liga_master/screens/home/competition/creation/competition_creation_screen.dart';
import 'package:liga_master/screens/home/player/creation/player_creation_screen.dart';
import 'package:liga_master/screens/home/player/edition/player_edition_screen.dart';
import 'package:liga_master/screens/home/team/creation/team_creation_screen.dart';
import 'package:liga_master/screens/home/team/edition/team_edition_screen.dart';
import 'package:liga_master/services/competition_service.dart';
import 'package:liga_master/services/player_service.dart';
import 'package:liga_master/services/team_service.dart';
import 'package:provider/provider.dart';

class HomeScreenViewmodel extends ChangeNotifier {
  AppUser _user;
  AppUser get user => _user;
  set user(AppUser value) {
    _user = value;
    notifyListeners();
  }

  List<Competition> get competitions => _user.competitions;

  List<UserTeam> get teams => _user.teams;

  List<UserPlayer> get players => _user.players;

  HomeScreenViewmodel(this._user);

  void addCompetition(Competition competition) {
    _user.competitions.add(competition);
    notifyListeners();
  }

  void updateCompetition(Competition competition) {
    int index = _user.competitions.indexOf(competition);
    if (index != -1) {
      _user.competitions[index] = competition;
      notifyListeners();
    }
  }

  void removeCompetition(Competition competition) {
    _user.competitions.remove(competition);
    notifyListeners();
  }

  void addTeam(UserTeam team) {
    _user.teams.add(team);
    notifyListeners();
  }

  void updateTeam(UserTeam team) {
    _user.teams[teams.indexOf(team)] = team;
    notifyListeners();
  }

  void addPlayer(UserPlayer player) {
    _user.players.add(player);
    notifyListeners();
  }

  void onCreateCompetition(BuildContext context) async {
    int num = 1;
    String id = "C$num";
    bool found = false;

    while (!found) {
      if (!competitions.any((c) => c.id == id)) {
        found = true;
      } else {
        num++;
      }
      id = "C$num";
    }
    onEditCompetition(context, Competition(id: id), isNew: true);
  }

  void onEditCompetition(
    BuildContext context,
    Competition competition, {
    bool isNew = false,
  }) async {
    var competitionService =
        Provider.of<CompetitionService>(context, listen: false);
    bool? save = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) =>
            CompetitionCreationScreen(competition: competition),
      ),
    );

    if (save ?? false) {
      if (isNew) addCompetition(competition);

      await competitionService.saveCompetition(competition);
    }
  }

  void onCreateTeam(BuildContext context) async {
    int num = 1;
    String id = "T$num";
    bool found = false;

    while (!found) {
      if (!teams.any((team) => team.id == id)) {
        found = true;
      } else {
        num++;
      }
      id = "T$num";
    }
    onEditTeam(context, UserTeam(id: id), isNew: true);
  }

  void onEditTeam(BuildContext context, UserTeam team,
      {bool isNew = false}) async {
    TeamService teamService = Provider.of<TeamService>(context, listen: false);
    PlayerService playerService =
        Provider.of<PlayerService>(context, listen: false);
    bool? save = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => isNew
            ? TeamCreationScreen(
                team: team,
              )
            : TeamEditionScreen(team: team),
      ),
    );

    if (save ?? false) {
      if (isNew) {
        addTeam(team);
      } else {
        updateTeam(team);
      }
      for (var player in team.players) {
        playerService.savePlayer(player);
      }
      await teamService.saveTeam(team);
    }
  }

  void onCreatePlayer(BuildContext context) async {
    int num = 1;
    String id = "P$num";
    bool found = false;

    while (!found) {
      if (!players.any((player) => player.id == id)) {
        found = true;
      } else {
        num++;
      }
      id = "P$num";
    }
    onEditPlayer(context, UserPlayer(id: id), isNew: true);
  }

  void onEditPlayer(BuildContext context, UserPlayer player,
      {bool isNew = false}) async {
    PlayerService playerService =
        Provider.of<PlayerService>(context, listen: false);
    bool? save = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => isNew
            ? PlayerCreationScreen(player: player)
            : PlayerEditionScreen(player: player),
      ),
    );

    if (save ?? false) {
      if (isNew) addPlayer(player);

      await playerService.savePlayer(player);
    }
  }

  void loadUserData(CompetitionService compService, TeamService teamService,
      PlayerService playerService) async {
    var playersFirebase = await playerService.getPlayers(creator: _user).first;
    var teamsFirebase = await teamService
        .getTeams(creator: _user, allPlayers: playersFirebase)
        .first;

    _user.players = playersFirebase;
    _user.teams = teamsFirebase;
    _user.competitions = await compService
        .getCompetitions(
            creator: _user, allTeams: _user.teams, allPlayers: _user.players)
        .first;
    notifyListeners();
  }
}
