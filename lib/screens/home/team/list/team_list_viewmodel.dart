// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:liga_master/models/user/entities/user_team.dart';

class TeamListViewmodel extends ChangeNotifier {
  List<UserTeam> _teams = List.empty(growable: true);
  List<UserTeam> get teams => _teams;

  TeamListViewmodel(List<UserTeam> userTeams)
      : _teams = userTeams.isNotEmpty ? userTeams : List.empty(growable: true);

  void addTeam(UserTeam team) {
    _teams.add(team);
    notifyListeners();
  }
}
