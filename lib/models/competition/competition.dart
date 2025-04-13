import 'dart:math';

import 'package:flutter/material.dart';
import 'package:liga_master/models/enums.dart';
import 'package:liga_master/models/user/entities/user_player.dart';
import 'package:liga_master/models/user/entities/user_team.dart';
import 'package:liga_master/models/user/user.dart';

class Competition extends ChangeNotifier {
  final String _id;
  get id => _id;

  User _creator;
  User get creator => _creator;
  set creator(value) {
    _creator = _creator;
  }

  String _name;
  String get name => _name;
  set name(value) {
    _name = value;
    notifyListeners();
  }

  Sport _competitionSport;
  Sport get competitionSport => _competitionSport;
  set competitionSport(value) {
    _competitionSport = value;
    notifyListeners();
  }

  CompetitionFormat _format;
  CompetitionFormat get format => _format;
  set format(value) {
    _format = value;
    notifyListeners();
  }

  final int _minTeams = 4;

  final int _maxTeamsTournament = 64;

  final int _maxTeamsLeague = 20;

  List<int> get numberOfTeamsAllowedForTournament =>
      List.generate(_maxTeamsTournament, (i) => i)
          .map((exp) => pow(2, exp).toInt())
          .where((valor) => valor >= _minTeams && valor <= _maxTeamsTournament)
          .toList();

  List<int> get numberOfTeamsAllowedForLeague =>
      List.generate(_maxTeamsLeague, (i) => i)
          .map((exp) => exp * 2)
          .where((valor) => valor >= _minTeams && valor <= _maxTeamsLeague)
          .toList();

  int get numTeams => _teams.length;

  List<UserTeam> _teams;
  List<UserTeam> get teams => _teams;
  set teams(value) {
    _teams = value;
    notifyListeners();
  }

  List<UserPlayer> _players;
  List<UserPlayer> get players => _players;
  set players(value) {
    _players = value;
    notifyListeners();
  }

  Competition({
    required String id,
    User? creator,
    String name = "",
    List<UserTeam>? teams,
    List<UserPlayer>? players,
    CompetitionFormat? format,
    Sport? sport,
  })  : _id = id,
        _creator = creator ?? User(id: ""),
        _name = name,
        _teams = teams ?? List.empty(growable: true),
        _players = players ?? List.empty(growable: true),
        _format = format ?? CompetitionFormat.league,
        _competitionSport = sport ?? Sport.football;

  bool equals(Competition other) =>
      _id == other._id &&
      _name == other._name &&
      _creator == other._creator &&
      _format == other._format;

  Competition copyWith([
    String? id,
    User? creator,
    String? name,
    List<UserTeam>? teams,
    List<UserPlayer>? players,
    CompetitionFormat? format,
  ]) =>
      Competition(
        id: id ?? _id,
        creator: creator ?? _creator,
        name: name ?? _name,
        teams: teams ?? _teams,
        players: players ?? _players,
        format: format ?? _format,
      );

  Competition copyValuesFrom(Competition competition) => Competition(
        id: competition._id,
        creator: competition._creator,
        name: competition._name,
        teams: List.from(competition._teams),
        players: List.from(competition._players),
        format: competition.format,
      );
}

enum CompetitionFormat {
  league("Liga"),
  tournament("Torneo");

  const CompetitionFormat(this.name);

  final String name;

  List<CompetitionFormat> get formats =>
      [CompetitionFormat.league, CompetitionFormat.tournament];
}
