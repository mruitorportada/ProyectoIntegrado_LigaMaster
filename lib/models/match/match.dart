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

  SportMatch(
      {required UserTeam teamA,
      required UserTeam teamB,
      required DateTime date,
      int scoreA = 0,
      int scoreB = 0,
      Map<MatchEvents, List<String>>? eventsA,
      Map<MatchEvents, List<String>>? eventsB})
      : _teamA = teamA,
        _teamB = teamB,
        _scoreA = scoreA,
        _scoreB = scoreB,
        _date = date,
        _eventsTeamA = eventsA ?? {},
        _eventsTeamB = eventsB ?? {};

  SportMatch copy() => SportMatch(
        teamA: _teamA.copy(),
        teamB: _teamB.copy(),
        date: _date,
        scoreA: _scoreA,
        scoreB: _scoreB,
        eventsA: Map.from(_eventsTeamA),
        eventsB: Map.from(_eventsTeamB),
      );

  void resetMatch(SportMatch originalMatch) {
    _scoreA = originalMatch._scoreA;
    _scoreB = originalMatch._scoreB;
    _eventsTeamA = originalMatch._eventsTeamA;
    _eventsTeamB = originalMatch._eventsTeamB;
    notifyListeners();
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
            _updateAssist(value, isTeamA: isTeamA);
          }
          break;
        case FootballEvents.yellowCard:
          for (var value in entry.value) {
            _updateYellowCard(value, isTeamA: isTeamA);
          }
          break;
        case FootballEvents.redCard:
          for (var value in entry.value) {
            _updateRedCard(value, isTeamA: isTeamA);
          }
          break;
        case FootballEvents.injury:
          break;
        case FootballEvents.playerSubstitution:
          break;
      }
    }
  }

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
    notifyListeners();
  }

  void _updateAssist(String playerName, {bool isTeamA = false}) {
    isTeamA
        ? _teamA.players
            .firstWhere((player) => player.name == playerName)
            .assists++
        : _teamB.players
            .firstWhere((player) => player.name == playerName)
            .assists++;
  }

  void _updateYellowCard(String playerName, {bool isTeamA = false}) {
    isTeamA
        ? _teamA.players
            .firstWhere((player) => player.name == playerName)
            .yellowCards++
        : _teamB.players
            .firstWhere((player) => player.name == playerName)
            .yellowCards++;
  }

  void _updateRedCard(String playerName, {bool isTeamA = false}) {
    isTeamA
        ? _teamA.players
            .firstWhere((player) => player.name == playerName)
            .redCards++
        : _teamB.players
            .firstWhere((player) => player.name == playerName)
            .redCards++;
  }
}
