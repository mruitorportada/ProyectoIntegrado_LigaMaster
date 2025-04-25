import 'package:flutter/material.dart';
import 'package:liga_master/models/competition/competition.dart';
import 'package:liga_master/models/user/entities/user_player.dart';
import 'package:liga_master/models/user/entities/user_team.dart';

class AppUser extends ChangeNotifier {
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

  List<Competition> _competitions;
  List<Competition> get competitions => _competitions;
  set competitions(List<Competition> value) {
    _competitions = value;
    notifyListeners();
  }

  List<UserTeam> _teams;
  List<UserTeam> get teams => _teams;
  set teams(List<UserTeam> value) {
    _teams = value;
    notifyListeners();
  }

  List<UserPlayer> _players;
  List<UserPlayer> get players => _players;
  set players(List<UserPlayer> value) {
    _players = value;
    notifyListeners();
  }

  AppUser({
    required String id,
    String name = "",
    String surname = "",
    String username = "",
    String email = "",
    List<UserTeam>? teams,
    List<UserPlayer>? players,
    List<Competition>? competitions,
  })  : _id = id,
        _name = name,
        _surname = surname,
        _username = username,
        _email = email,
        _teams = teams ?? List.empty(growable: true),
        _players = players ?? List.empty(growable: true),
        _competitions = competitions ?? List.empty(growable: true);

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "surname": surname,
        "username": username,
        "email": email,
        "teams": teams.map((team) => team.id).toList(),
        "players": players.map((player) => player.id).toList(),
        "competitions":
            competitions.map((competition) => competition.id).toList(),
      };

  factory AppUser.fromMap(Map<String, dynamic> firebaseMap) => AppUser(
        id: firebaseMap["id"],
        name: firebaseMap["name"],
        surname: firebaseMap["surname"],
        username: firebaseMap["username"],
        email: firebaseMap["email"],
      );

  AppUser copy() => AppUser(
      id: id,
      name: _name,
      surname: _surname,
      email: _email,
      username: _username,
      teams: _teams,
      players: _players,
      competitions: _competitions);

  bool equals(AppUser other) =>
      name == other.name &&
      surname == other.surname &&
      username == other.username &&
      email == other.email &&
      teams == other.teams &&
      players == other.players;
}
