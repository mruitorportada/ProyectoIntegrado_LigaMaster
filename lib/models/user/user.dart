// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:liga_master/data/competitions.dart';
import 'package:liga_master/data/players.dart';
import 'package:liga_master/data/teams.dart';
import 'package:liga_master/models/competition/competition.dart';
import 'package:liga_master/models/user/entities/user_player.dart';
import 'package:liga_master/models/user/entities/user_team.dart';

class User extends ChangeNotifier {
  final String _id;
  String get id => _id;

  final String _name;
  String get name => _name;

  final String _surname;
  String get surname => _surname;

  final String _username;
  String get username => _username;

  final String _email;
  String get email => _email;

  final String _password;
  String get password => _password;

  List<Competition> _competitions;
  List<Competition> get competitions => _competitions;

  List<UserTeam> _teams;
  List<UserTeam> get teams => _teams;

  List<UserPlayer> _players;
  List<UserPlayer> get players => _players;

  User({
    required String id,
    String name = "",
    String surname = "",
    String username = "",
    String email = "",
    String password = "",
    List<UserTeam>? teams,
    List<UserPlayer>? players,
    List<Competition>? competitions,
  })  : _id = id,
        _name = name,
        _surname = "",
        _username = "",
        _email = "",
        _password = "",
        _teams = teams ?? List.empty(growable: true),
        _players = players ?? List.empty(growable: true),
        _competitions = competitions ?? List.empty(growable: true);

  void addCompetition(Competition competition) {
    _competitions.add(competition);
    notifyListeners();
  }

  void addTeam(UserTeam team) {
    _teams.add(team);
    notifyListeners();
  }

  void addPlayer(UserPlayer player) {
    _players.add(player);
    notifyListeners();
  }

  Future<void> load() async {
    for (Competition comp in competitionsData) {
      addCompetition(comp);
    }
    for (UserTeam team in teamsData) {
      addTeam(team);
    }
    for (UserPlayer player in playersData) {
      addPlayer(player);
    }
  }
}
