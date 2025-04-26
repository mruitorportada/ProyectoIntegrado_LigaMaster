import 'dart:math';
import 'package:flutter/material.dart';
import 'package:liga_master/models/enums.dart';
import 'package:liga_master/models/fixture/fixture.dart';
import 'package:liga_master/models/user/entities/user_player.dart';
import 'package:liga_master/models/user/entities/user_team.dart';
import 'package:liga_master/models/user/app_user.dart';

class Competition extends ChangeNotifier {
  String _id;
  String get id => _id;
  set id(String value) {
    _id = value;
    notifyListeners();
  }

  AppUser _creator;
  AppUser get creator => _creator;
  set creator(AppUser value) {
    _creator = value;
    notifyListeners();
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

  String _code;
  String get code => _code;
  set code(String value) {
    _code = value;
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

  List<Fixture> _fixtures;
  List<Fixture> get fixtures => _fixtures;
  set fixtures(List<Fixture> value) {
    _fixtures = value;
    notifyListeners();
  }

  Competition({
    required String id,
    AppUser? creator,
    String name = "",
    List<UserTeam>? teams,
    List<UserPlayer>? players,
    String code = "",
    CompetitionFormat? format,
    Sport? sport,
    List<Fixture>? fixtures,
  })  : _id = id,
        _creator = creator ?? AppUser(id: ""),
        _name = name,
        _code = code,
        _teams = teams ?? List.empty(growable: true),
        _players = players ?? List.empty(growable: true),
        _format = format ?? CompetitionFormat.league,
        _competitionSport = sport ?? Sport.football,
        _fixtures = fixtures ?? List.empty(growable: true);

  Map<String, dynamic> toMap() => {
        "id": id,
        "creator_id": creator.id,
        "name": name,
        "code": code,
        "competitionSport": competitionSport.name,
        "format": format.name,
        "teams": teams.map((team) => team.id).toList(),
        "players": players.map((player) => player.id).toList()
      };

  factory Competition.fromJson(
          Map<String, dynamic> competition,
          AppUser creator,
          List<UserTeam> userTeams,
          List<UserPlayer> userPlayers) =>
      Competition(
        id: competition["id"],
        creator: creator,
        name: competition["name"],
        code: competition["code"],
        sport: Sport.values.firstWhere(
          (sport) => sport.name == competition["competitionSport"],
        ),
        format: CompetitionFormat.values.firstWhere(
          (format) => format.name == competition["format"],
        ),
        teams: (competition["teams"] as List? ?? [])
            .map((id) => userTeams.firstWhere((t) => t.id == id))
            .toList(),
        players: (competition["players"] as List? ?? [])
            .map(
              (id) => userPlayers.firstWhere((p) => p.id == id),
            )
            .toList(),
      );

  bool equals(Competition other) =>
      _id == other._id &&
      _name == other._name &&
      _creator == other._creator &&
      _format == other._format;

  Competition copyWith(
          [String? id,
          AppUser? creator,
          String? name,
          String? code,
          List<UserTeam>? teams,
          List<UserPlayer>? players,
          CompetitionFormat? format,
          List<Fixture>? fixtures]) =>
      Competition(
          id: id ?? _id,
          creator: creator ?? _creator,
          name: name ?? _name,
          code: code ?? _code,
          teams: teams ?? _teams,
          players: players ?? _players,
          format: format ?? _format,
          fixtures: fixtures ?? _fixtures);

  Competition copyValuesFrom(Competition competition) => Competition(
      id: competition.id,
      creator: competition.creator,
      name: competition.name,
      code: competition.code,
      teams: List.from(competition.teams),
      players: List.from(competition.players),
      format: competition.format,
      fixtures: competition.fixtures);
}

enum CompetitionFormat {
  league("Liga"),
  tournament("Torneo");

  const CompetitionFormat(this.name);

  final String name;

  List<CompetitionFormat> get formats =>
      [CompetitionFormat.league, CompetitionFormat.tournament];
}
