import 'package:flutter/material.dart';
import 'package:liga_master/models/competition/competition.dart';
import 'package:liga_master/models/enums.dart';
import 'package:liga_master/models/fixture/fixture.dart';
import 'package:liga_master/models/match/match.dart';
import 'package:liga_master/models/user/entities/user_team.dart';

class CompetitionDetailsViewmodel extends ChangeNotifier {
  Competition _competition;
  Competition get competition => _competition;
  set competition(Competition value) {
    _competition = value;
    notifyListeners();
  }

  bool _fixturesGenerated = false;
  bool get fixturesGenerated => _fixturesGenerated;
  set fixturesGenerated(bool value) {
    _fixturesGenerated = value;
    notifyListeners();
  }

  List<Fixture> get fixtures => _competition.fixtures;

  final ValueNotifier<List<UserTeam>> topTeamsByGoalsScored = ValueNotifier([]);

  final ValueNotifier<List<UserTeam>> teamsSortedByPoints = ValueNotifier([]);

  CompetitionDetailsViewmodel(this._competition) {
    for (final team in _competition.teams) {
      team.addListener(_sortTeamsByGoalsScored);
      team.addListener(_sortTeamsByPoints);
    }

    topTeamsByGoalsScored.value = [
      ..._competition.teams..sort((a, b) => b.goals.compareTo(a.goals))
    ];

    teamsSortedByPoints.value = [
      ..._competition.teams
        ..sort((a, b) => b.compareTeamsByPointsAndGoalDifference(a))
    ];
  }

  void _sortTeamsByGoalsScored() {
    topTeamsByGoalsScored.value = [...topTeamsByGoalsScored.value]
      ..sort((a, b) => b.goals.compareTo(a.goals));
  }

  void _sortTeamsByPoints() {
    teamsSortedByPoints.value = [...teamsSortedByPoints.value]
      ..sort((a, b) => b.compareTeamsByPointsAndGoalDifference(a));
  }

  @override
  void dispose() {
    for (var team in topTeamsByGoalsScored.value) {
      team.removeListener(_sortTeamsByGoalsScored);
      team.removeListener(_sortTeamsByPoints);
    }
    super.dispose();
  }

  void leagueFixturesGenerator(int timesEachTeamPlaysEachOther) {
    final teams = List<UserTeam>.from(_competition.teams);
    final int numTeams = teams.length;
    final int numRoundsPerCycle = numTeams - 1;
    final int matchesPerRound = numTeams ~/ 2;
    Map<String, bool> lastLocalTeamIsFirst = {};

    if (_fixturesGenerated) {
      resetStats();
      competition.fixtures = [];
    }

    for (int cycle = 0; cycle < timesEachTeamPlaysEachOther; cycle++) {
      List<UserTeam> rotatingTeams = List.from(teams);

      for (int round = 0; round < numRoundsPerCycle; round++) {
        List<SportMatch> matches = [];

        for (int i = 0; i < matchesPerRound; i++) {
          final teamA = rotatingTeams[i];
          final teamB = rotatingTeams[numTeams - 1 - i];

          final ids = [teamA.id, teamB.id]..sort();
          final key = "${ids[0]}_${ids[1]}";

          // Alternancia continua de localía
          bool lastFirstWasLocal = lastLocalTeamIsFirst[key] ?? false;
          bool currentFirstIsLocal = !lastFirstWasLocal;
          lastLocalTeamIsFirst[key] = currentFirstIsLocal;

          UserTeam home = currentFirstIsLocal
              ? (teamA.id == ids[0] ? teamA : teamB)
              : (teamA.id == ids[0] ? teamB : teamA);
          UserTeam away = (home == teamA) ? teamB : teamA;

          matches.add(SportMatch(home, away, DateTime.now()));
        }

        matches.sort((a, b) => a.date.compareTo(b.date));

        _competition.addFixture(
            Fixture("Jornada ${fixtures.length + 1}", DateTime.now(), matches));

        // Rotación para el algoritmo de round-robin
        var temp = rotatingTeams.removeAt(1);
        rotatingTeams.add(temp);

        _fixturesGenerated = competition.fixtures.isNotEmpty;
      }
    }

    notifyListeners();
  }

  void addEventToMatch(SportMatch match, MatchEvents event, String playerName,
      {bool playerIsFromTeamA = false}) {
    if (playerIsFromTeamA) {
      match.eventsTeamA.putIfAbsent(event, () => []);
      match.eventsTeamA[event]!.add(playerName);
    } else {
      match.eventsTeamB.putIfAbsent(event, () => []);
      match.eventsTeamB[event]!.add(playerName);
    }

    _updateMatchStats(event, match, playerName, playerIsFromTeamA);

    notifyListeners();
  }

  void saveMatchDetails(SportMatch match) {
    match.updateNumberOfMatchesStats();
    match.setMatchWinnerAndUpdateStats();
    match.played = true;
  }

  void _updateMatchScore(SportMatch match, String playerName, bool isTeamA) =>
      match.addGoalToTeamAndPlayer(playerName, isTeamA: isTeamA);

  void _updateMatchStats(
      MatchEvents event, SportMatch match, String playerName, bool isTeamA) {
    switch (match.teamA.sportPlayed) {
      case Sport.football || Sport.futsal:
        switch (event as FootballEvents) {
          case FootballEvents.goal:
            _updateMatchScore(match, playerName, isTeamA);
            break;
          case FootballEvents.assist:
            match.updateAssist(playerName, isTeamA: isTeamA);

          case FootballEvents.yellowCard:
            match.updateYellowCard(playerName, isTeamA: isTeamA);

          case FootballEvents.redCard:
            match.updateRedCard(playerName, isTeamA: isTeamA);
          case FootballEvents.injury:
            break;
          case FootballEvents.playerSubstitution:
            break;
        }
        break;
    }
  }

  void resetStats() {
    for (var team in _competition.teams) {
      team.onStatsReset();
    }
    notifyListeners();
  }
}
