import 'package:flutter/material.dart';
import 'package:liga_master/models/enums.dart';
import 'package:liga_master/models/match/sport_match_location.dart';
import 'package:liga_master/models/user/entities/user_player.dart';
import 'package:liga_master/models/user/entities/user_team.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';

class SportMatch extends ChangeNotifier {
  final String _id;
  String get id => _id;

  final int _number;
  int get number => _number;

  final UserTeam _teamA;
  UserTeam get teamA => _teamA;

  final UserTeam _teamB;
  UserTeam get teamB => _teamB;

  Map<MatchEvents, List<String>> _eventsTeamA;
  Map<MatchEvents, List<String>> get eventsTeamA => _eventsTeamA;
  set eventsTeamA(Map<MatchEvents, List<String>> value) {
    _eventsTeamA = value;
    notifyListeners();
  }

  Map<MatchEvents, List<String>> _eventsTeamB;
  Map<MatchEvents, List<String>> get eventsTeamB => _eventsTeamB;
  set eventsTeamB(Map<MatchEvents, List<String>> value) {
    _eventsTeamB = value;
    notifyListeners();
  }

  int _scoreA = 0;
  int get scoreA => _scoreA;

  set scoreA(int value) {
    if (value >= 0) {
      _scoreA = value;
      notifyListeners();
    }
  }

  int _scoreB = 0;
  int get scoreB => _scoreB;
  set scoreB(int value) {
    if (value >= 0) {
      _scoreB = value;
      notifyListeners();
    }
  }

  DateTime _date;
  DateTime get date => _date;
  set date(DateTime value) {
    _date = value;
    notifyListeners();
  }

  bool _edited = false;
  bool get edited => _edited;
  set edited(bool value) {
    _edited = value;
    notifyListeners();
  }

  SportMatchLocation _location;
  SportMatchLocation get location => _location;
  set location(SportMatchLocation value) {
    _location = value;
    notifyListeners();
  }

  SportMatch(
      {required String id,
      required int number,
      required UserTeam teamA,
      required UserTeam teamB,
      required DateTime date,
      int scoreA = 0,
      int scoreB = 0,
      Map<MatchEvents, List<String>>? eventsA,
      Map<MatchEvents, List<String>>? eventsB,
      bool edited = false,
      SportMatchLocation? location})
      : _id = id,
        _number = number,
        _teamA = teamA,
        _teamB = teamB,
        _scoreA = scoreA,
        _scoreB = scoreB,
        _date = date,
        _eventsTeamA = eventsA ?? {},
        _eventsTeamB = eventsB ?? {},
        _edited = edited,
        _location = location ?? SportMatchLocation(name: "N/A", address: "N/A");

  Map<String, dynamic> toMap() => {
        "id": _id,
        "number": number,
        "date": _date.toString(),
        "teamA_id": _teamA.id,
        "teamB_id": _teamB.id,
        "scoreA": _scoreA,
        "scoreB": _scoreB,
        if (_eventsTeamA.isNotEmpty)
          "eventsTeamA":
              _eventsTeamA.map((key, value) => MapEntry(key.name, value)),
        if (_eventsTeamB.isNotEmpty)
          "eventsTeamB":
              _eventsTeamB.map((key, value) => MapEntry(key.name, value)),
        if (_edited) "edited": _edited,
        "location": _location.toMap(),
      };

  factory SportMatch.fromMap(Map<String, dynamic> data, List<UserTeam> teams) {
    Map<MatchEvents, List<String>> eventsA = {};
    Map<MatchEvents, List<String>> eventsB = {};
    var eventsAFromFirestore =
        (data["eventsTeamA"] as Map<String, dynamic>? ?? {});

    var eventsBFromFirestore =
        (data["eventsTeamB"] as Map<String, dynamic>? ?? {});

    if (eventsAFromFirestore.isNotEmpty) {
      eventsA = eventsAFromFirestore.map((key, value) => MapEntry(
          FootballEvents.values.firstWhere((event) => event.name == key),
          (value as List).map((e) => e.toString()).toList()));
    }

    if (eventsBFromFirestore.isNotEmpty) {
      eventsB = eventsBFromFirestore.map((key, value) => MapEntry(
            FootballEvents.values.firstWhere((event) => event.name == key),
            (value as List).map((e) => e.toString()).toList(),
          ));
    }

    return SportMatch(
      id: data["id"],
      number: data["number"],
      teamA: teams.firstWhere((team) => team.id == data["teamA_id"]),
      teamB: teams.firstWhere((team) => team.id == data["teamB_id"]),
      date: DateTime.parse(data["date"]),
      scoreA: data["scoreA"],
      scoreB: data["scoreB"],
      eventsA: eventsA.isNotEmpty ? eventsA : {},
      eventsB: eventsB.isNotEmpty ? eventsB : {},
      edited: data["edited"] ?? false,
      location: SportMatchLocation.fromMap(
          (data["location"] as Map<String, dynamic>?) ?? {}),
    );
  }

  SportMatch copy() => SportMatch(
        id: _id,
        number: _number,
        teamA: _teamA.copy(),
        teamB: _teamB.copy(),
        date: _date,
        scoreA: _scoreA,
        scoreB: _scoreB,
        eventsA: Map.from(_eventsTeamA),
        eventsB: Map.from(_eventsTeamB),
      );

  void resetMatch() {
    _scoreA = 0;
    _scoreB = 0;
    _eventsTeamA = {};
    _eventsTeamB = {};
  }

  void updateMatchStats() {
    switch (_teamA.sportPlayed) {
      case Sport.football || Sport.futsal:
        _updateTeamMatchStats(true);
        _updateTeamMatchStats(false);
        break;
    }
  }

  void _updateTeamMatchStats(bool isTeamA) {
    for (var entry in isTeamA ? _eventsTeamA.entries : _eventsTeamB.entries) {
      switch (entry.key) {
        case FootballEvents.goal:
          for (var value in entry.value) {
            _addGoalToTeamAndPlayer(value, isTeamA: isTeamA);
          }
          break;
        case FootballEvents.assist:
          for (var value in entry.value) {
            _updateAssist(value, isFromTeamA: isTeamA);
          }
          break;
        case FootballEvents.yellowCard:
          for (var value in entry.value) {
            _updateYellowCard(value, isFromTeamA: isTeamA);
          }
          break;
        case FootballEvents.redCard:
          for (var value in entry.value) {
            _updateRedCard(value, isFromTeamA: isTeamA);
          }
          break;
        case FootballEvents.injury:
          break;
        case FootballEvents.playerSubstitution:
          break;
      }
    }
    notifyListeners();
  }

  void setMatchWinnerAndUpdateStats() {
    if (_scoreA > _scoreB) {
      _teamA.matchesWon++;
      _teamB.matchesLost++;
    } else if (_scoreA < _scoreB) {
      _teamB.matchesWon++;
      _teamA.matchesLost++;
    } else {
      _teamA.matchesTied++;
      _teamB.matchesTied++;
    }
    _edited = true;
    notifyListeners();
  }

  void _addGoalToTeamAndPlayer(String playerName, {bool isTeamA = false}) {
    if (isTeamA) {
      _teamA.goals++;
      _teamB.goalsConceded++;
      _teamA.players.firstWhere((player) => player.name == playerName).goals++;
    } else {
      _teamB.goals++;
      _teamA.goalsConceded++;
      _teamB.players.firstWhere((player) => player.name == playerName).goals++;
    }
  }

  void _updateAssist(String playerName, {bool isFromTeamA = false}) {
    isFromTeamA
        ? _teamA.players
            .firstWhere((player) => player.name == playerName)
            .assists++
        : _teamB.players
            .firstWhere((player) => player.name == playerName)
            .assists++;
  }

  void _updateYellowCard(String playerName, {bool isFromTeamA = false}) {
    isFromTeamA
        ? _teamA.players
            .firstWhere((player) => player.name == playerName)
            .yellowCards++
        : _teamB.players
            .firstWhere((player) => player.name == playerName)
            .yellowCards++;
  }

  void _updateRedCard(String playerName, {bool isFromTeamA = false}) {
    isFromTeamA
        ? _teamA.players
            .firstWhere((player) => player.name == playerName)
            .redCards++
        : _teamB.players
            .firstWhere((player) => player.name == playerName)
            .redCards++;
  }

  UserTeam? getMatchWinner() {
    if (_scoreA > 0 || _scoreB > 0) {
      return _scoreA > _scoreB ? _teamA : _teamB;
    }
    return null;
  }

  bool checkTeamHasScored(UserTeam team) {
    return _isTeamA(team) ? _scoreA > 0 : _scoreB > 0;
  }

  bool teamHasMoreThanOneScorer(UserTeam team) {
    return _isTeamA(team)
        ? (_scoreA > 1 &&
            _eventsTeamA.entries.any((entry) =>
                entry.key == FootballEvents.goal &&
                entry.value.toSet().length > 1))
        : (_scoreB > 1 &&
            _eventsTeamB.entries.any((entry) =>
                entry.key == FootballEvents.goal &&
                entry.value.toSet().length > 1));
  }

  bool _isTeamA(UserTeam team) => _teamA.id == team.id;

  bool _playerIsFromTeamA(UserPlayer player) =>
      _teamA.players.any((teamPlayer) => teamPlayer.id == player.id);

  bool checkPlayerIsTheOnlyScorer(UserPlayer player) {
    final goalEvents = _playerIsFromTeamA(player)
        ? (_eventsTeamA.entries
            .firstWhere((entry) => entry.key == FootballEvents.goal))
        : (_eventsTeamB.entries
            .firstWhere((entry) => entry.key == FootballEvents.goal));

    final scorers = goalEvents.value.toSet();

    return scorers.length == 1 && scorers.contains(player.name);
  }

  void updateLocation(PickedData pickedLocation) {
    Map<String, dynamic> address = pickedLocation.addressData;

    String road = address["road"] ?? "N/A";

    String city = address["city"] ?? address["town"] ?? "N/A";
    String province = address["province"] ?? "N/A";
    String country = address["country"];
    String postcode = address["postcode"];

    _location.name = road;
    _location.address = "$city, $postcode - $province, $country";

    notifyListeners();
  }
}
