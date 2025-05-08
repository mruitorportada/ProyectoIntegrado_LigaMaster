import 'package:flutter/material.dart';
import 'package:liga_master/models/enums.dart';
import 'package:liga_master/models/user/entities/user_team.dart';

class SportMatch extends ChangeNotifier {
  final UserTeam _teamA;
  UserTeam get teamA => _teamA;

  final UserTeam _teamB;
  UserTeam get teamB => _teamB;

  bool played = false;

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

  SportMatch(this._teamA, this._teamB, this._date,
      {Map<MatchEvents, List<String>>? eventsA,
      Map<MatchEvents, List<String>>? eventsB})
      : _eventsTeamA = eventsA ?? {},
        _eventsTeamB = eventsB ?? {};

  void updateNumberOfMatchesStats() {
    _teamA.matchesPlayed++;

    _teamB.matchesPlayed++;
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
    notifyListeners();
  }

  void addGoalToTeamAndPlayer(String playerName, {bool isTeamA = false}) {
    if (isTeamA) {
      _scoreA++;
      _teamA.goals++;
      _teamB.goalsConceded++;
      _teamA.players.firstWhere((player) => player.name == playerName).goals++;
    } else {
      _scoreB++;
      _teamB.goals++;
      _teamA.goalsConceded++;
      _teamB.players.firstWhere((player) => player.name == playerName).goals++;
    }
    notifyListeners();
  }

  void updateAssist(String playerName, {bool isTeamA = false}) {
    isTeamA
        ? _teamA.players
            .firstWhere((player) => player.name == playerName)
            .assists++
        : _teamB.players
            .firstWhere((player) => player.name == playerName)
            .assists++;
  }

  void updateYellowCard(String playerName, {bool isTeamA = false}) {
    isTeamA
        ? _teamA.players
            .firstWhere((player) => player.name == playerName)
            .yellowCards++
        : _teamB.players
            .firstWhere((player) => player.name == playerName)
            .yellowCards++;
  }

  void updateRedCard(String playerName, {bool isTeamA = false}) {
    isTeamA
        ? _teamA.players
            .firstWhere((player) => player.name == playerName)
            .redCards++
        : _teamB.players
            .firstWhere((player) => player.name == playerName)
            .redCards++;
  }
}
