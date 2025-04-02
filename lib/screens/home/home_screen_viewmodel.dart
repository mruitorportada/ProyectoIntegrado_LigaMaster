// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:liga_master/models/competition/competition.dart';
import 'package:liga_master/models/user/entities/user_player.dart';
import 'package:liga_master/models/user/entities/user_team.dart';
import 'package:liga_master/models/user/user.dart';

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

  void addPlayer(UserPlayer player) {
    _user.players.add(player);
    notifyListeners();
  }
}
