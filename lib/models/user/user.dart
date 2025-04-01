// ignore_for_file: prefer_final_fields

import 'package:liga_master/models/competition/competition.dart';
import 'package:liga_master/models/user/entities/user_player.dart';
import 'package:liga_master/models/user/entities/user_team.dart';

class User {
  final String _id;
  get id => _id;

  final String _name;
  get name => _name;

  final String _surname;
  get surname => _surname;

  final String _username;
  get username => _username;

  final String _email;
  get email => _email;

  final String _password;
  get password => _password;

  List<Competition> _competitions = List.empty(growable: true);
  List<Competition> get competitions => _competitions;

  List<UserTeam> _teams = List.empty(growable: true);
  List<UserTeam> get teams => _teams;

  List<UserPlayer> _players = List.empty(growable: true);
  List<UserPlayer> get players => _players;

  User(
    this._id,
    this._name,
    this._surname,
    this._username,
    this._email,
    this._password,
    /*List<Competition> userCompetitions,
      List<UserTeam> userTeamsData,
      List<UserPlayer> userPlayersData*/
  ); /* {
    _teams =
        userTeamsData.isNotEmpty ? userTeamsData : List.empty(growable: true);
    _players = userPlayersData.isNotEmpty
        ? userPlayersData
        : List.empty(growable: true);
    _competitions = userCompetitions.isNotEmpty
        ? userCompetitions
        : List.empty(growable: true);
  }*/
}
