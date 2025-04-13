// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:liga_master/models/competition/competition.dart';
import 'package:liga_master/models/user/entities/user_player.dart';
import 'package:liga_master/models/user/entities/user_team.dart';
import 'package:liga_master/models/user/user.dart';
import 'package:liga_master/screens/home/competition/creation/competition_creation_screen.dart';
import 'package:liga_master/screens/home/player/creation/player_creation_screen.dart';
import 'package:liga_master/screens/home/team/creation/team_creation_screen.dart';
import 'package:liga_master/screens/home/team/edition/team_edition_screen.dart';

class HomeScreenViewmodel extends ChangeNotifier {
  User _user;
  User get user => _user;

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
    teams[teams.indexOf(team)] = team;
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
    bool? save = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) =>
            CompetitionCreationScreen(competition: competition),
      ),
    );

    if (save ?? false) {
      if (isNew) addCompetition(competition);
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
    }
  }

  void onCreatePlayer(BuildContext context) async {
    int num = 1;
    String id = "C$num";
    bool found = false;

    while (!found) {
      if (!players.any((player) => player.id == id)) {
        found = true;
      } else {
        num++;
      }
      id = "C$num";
    }
    onEditPlayer(context, UserPlayer(id), isNew: true);
  }

  void onEditPlayer(BuildContext context, UserPlayer player,
      {bool isNew = false}) async {
    bool? save = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PlayerCreationScreen(player: player),
      ),
    );

    if (save ?? false) {
      if (isNew) {
        addPlayer(player);
      }
    }
  }
}
