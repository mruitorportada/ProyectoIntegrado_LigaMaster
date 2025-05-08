import 'dart:async';

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
import 'package:liga_master/services/appuser_service.dart';
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

  StreamSubscription<List<UserPlayer>>? _playersSubscription;

  StreamSubscription<List<UserTeam>>? _teamsSubscription;

  StreamSubscription<List<Competition>>? _competitionsSubscription;

  HomeScreenViewmodel(this._user);

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
      _addCompetition(competitionService, competition);
    }
  }

  void onDeleteCompetition(BuildContext context, Competition competition) {
    var competitionService =
        Provider.of<CompetitionService>(context, listen: false);
    competitionService.deleteCompetition(competition, _user.id, () {
      _loadUserCompetitions(competitionService);
    });
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
      await teamService.saveTeam(team, _user.id);
    }
  }

  void onDeleteTeam(BuildContext context, UserTeam team) {
    TeamService teamService = Provider.of<TeamService>(context, listen: false);
    teamService.deleteTeam(team, _user.id);
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
      await playerService.savePlayer(player, _user.id);
    }
  }

  void onDeletePlayer(BuildContext context, UserPlayer player) {
    PlayerService playerService =
        Provider.of<PlayerService>(context, listen: false);
    TeamService teamService = Provider.of<TeamService>(context, listen: false);
    for (UserTeam team in teams) {
      var ids =
          team.players.map((playerFromList) => playerFromList.id).toList();
      if (ids.contains(player.id)) {
        team.players.remove(player);
        teamService.saveTeam(team, _user.id);
      }
    }
    playerService.deletePlayer(player.id, _user.id);
  }

  void loadUserData(CompetitionService compService, TeamService teamService,
      PlayerService playerService, AppUserService userService) {
    _playersSubscription?.cancel();
    _teamsSubscription?.cancel();
    _competitionsSubscription?.cancel();

    _playersSubscription =
        playerService.getPlayers(_user.id).listen((playersFirebase) {
      _user.players = playersFirebase;
      notifyListeners();

      _teamsSubscription = teamService
          .getTeams(userId: _user.id, allPlayers: playersFirebase)
          .listen((teamsFirebase) {
        _user.teams = teamsFirebase;
        notifyListeners();

        _loadUserCompetitions(compService);
      });
    });
  }

  void _loadUserCompetitions(CompetitionService compService) {
    _competitionsSubscription = compService
        .getCompetitions(userId: _user.id)
        .listen((competitionsFirebase) {
      _user.competitions = competitionsFirebase;
      notifyListeners();
    });
  }

  void _addCompetition(
      CompetitionService compService, Competition competition) {
    compService.saveCompetition(competition, _user.id, () {
      _loadUserCompetitions(compService);
    });
  }

  void addCompetitionByCode(BuildContext context, String code) async {
    var compService = Provider.of<CompetitionService>(context, listen: false);
    await compService.addCompetitionToUserByCode(code, _user.id, () {
      _loadUserCompetitions(compService);
    });
  }

  void onLogOut() => _reset();

  void _reset() {
    _playersSubscription?.cancel();
    _teamsSubscription?.cancel();
    _competitionsSubscription?.cancel();

    _playersSubscription = null;
    _teamsSubscription = null;
    _competitionsSubscription = null;

    _user = AppUser.empty();
  }
}
