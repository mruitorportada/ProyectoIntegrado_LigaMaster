import 'dart:async';
import 'package:flutter/material.dart';
import 'package:liga_master/models/competition/competition.dart';
import 'package:liga_master/models/enums.dart';
import 'package:liga_master/models/fixture/fixture.dart';
import 'package:liga_master/models/match/match.dart';
import 'package:liga_master/models/user/entities/user_player.dart';
import 'package:liga_master/models/user/entities/user_team.dart';
import 'package:liga_master/services/competition_service.dart';
import 'package:provider/provider.dart';

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

  final ValueNotifier<List<UserTeam>> teamsSortedByGoalsScored =
      ValueNotifier([]);

  final ValueNotifier<List<UserTeam>> teamsSortedByPoints = ValueNotifier([]);

  final ValueNotifier<List<UserTeam>> teamsSortedByGoalsConceded =
      ValueNotifier([]);

  final ValueNotifier<List<UserPlayer>> playersSortedByGoalsScored =
      ValueNotifier([]);

  final ValueNotifier<List<UserPlayer>> playersSortedByAssists =
      ValueNotifier([]);

  StreamSubscription<List<Competition>>? _competitionsSubscription;

  CompetitionDetailsViewmodel(this._competition) {
    for (final team in _competition.teams) {
      team.addListener(_sortTeamsByGoalsScored);
      team.addListener(_sortTeamsByPoints);
      team.addListener(_sortTeamsByGoalsConceded);
    }

    for (final player in _competition.players) {
      player.addListener(_sortPlayersByGoalsScored);
      player.addListener(_sortPlayersByAssists);
    }

    _competitionsSubscription?.cancel();

    _fixturesGenerated = fixtures.isNotEmpty;

    _sortTeamsByGoalsScored();

    _sortTeamsByPoints();

    _sortTeamsByGoalsConceded();

    _sortPlayersByGoalsScored();

    _sortPlayersByAssists();
  }

  void _sortTeamsByGoalsScored() {
    final sortedTeams = [..._competition.teams]
      ..sort((a, b) => b.goals.compareTo(a.goals));
    int maxLength = competition.teams.length > 4 ? 5 : 4;
    teamsSortedByGoalsScored.value = sortedTeams.sublist(0, maxLength).toList();
  }

  void _sortTeamsByPoints() => teamsSortedByPoints.value = [
        ..._competition.teams
      ]..sort((a, b) => b.compareTeamsByPointsAndGoalDifference(a));

  void _sortTeamsByGoalsConceded() {
    final sortedTeams = [..._competition.teams]
      ..sort((a, b) => a.goalsConceded.compareTo(b.goalsConceded));
    int maxLength = competition.teams.length > 4 ? 5 : 4;
    teamsSortedByGoalsConceded.value =
        sortedTeams.sublist(0, maxLength).toList();
  }

  void _sortPlayersByGoalsScored() {
    final sortedPlayers = [..._competition.players]
      ..sort((a, b) => b.goals.compareTo(a.goals));
    playersSortedByGoalsScored.value = sortedPlayers.sublist(0, 5).toList();
  }

  void _sortPlayersByAssists() {
    final sortedPlayers = [..._competition.players]
      ..sort((a, b) => b.assists.compareTo(a.assists));
    playersSortedByAssists.value = sortedPlayers.sublist(0, 5).toList();
  }

  @override
  void dispose() {
    for (var team in _competition.teams) {
      team.removeListener(_sortTeamsByGoalsScored);
      team.removeListener(_sortTeamsByPoints);
      team.removeListener(_sortTeamsByGoalsConceded);
    }

    for (var player in _competition.players) {
      player.removeListener(_sortPlayersByGoalsScored);
      player.removeListener(_sortPlayersByAssists);
    }
    super.dispose();
  }

  void leagueFixturesGenerator(
      int timesEachTeamPlaysEachOther, BuildContext context) {
    final teams = List<UserTeam>.from(_competition.teams);
    final int numTeams = teams.length;
    final int numRoundsPerCycle = numTeams - 1;
    final int matchesPerRound = numTeams ~/ 2;
    Map<String, bool> lastLocalTeamIsFirst = {};
    var competitionService = _getCompetitionServiceInstance(context);

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

          final matchNumber = i + 1;

          final matchId = "M$matchNumber";

          matches.add(
            SportMatch(
              id: "J${fixtures.length + 1} - $matchId",
              number: matchNumber,
              teamA: home,
              teamB: away,
              date: DateTime.now(),
            ),
          );
        }

        matches.sort((a, b) => a.date.compareTo(b.date));

        _competition.addFixture(
            Fixture("Jornada ${fixtures.length + 1}", cycle + 1, matches));

        competitionService.saveFixture(
            _competition.fixtures.last, _competition.id);

        // Rotación para el algoritmo de round-robin
        var temp = rotatingTeams.removeAt(1);
        rotatingTeams.add(temp);

        _fixturesGenerated = true;
      }
    }

    competitionService.saveCompetition(_competition, _competition.creator.id,
        () {
      _loadUserCompetitions(competitionService);
    });

    notifyListeners();
  }

  void generateTournamentRound(
      bool fixtureHasTwoLegs, List<UserTeam> compTeams, BuildContext context) {
    var compService = _getCompetitionServiceInstance(context);

    if (_fixturesGenerated) {
      resetStats();
      _competition.fixtures = [];
      compService.removeFixtures(
          _competition.fixtures.map((fixture) => fixture.name).toList(),
          _competition.id);
    }

    List<SportMatch> matches = [];
    List<UserTeam> teamsThatPlayInRound = [];
    bool isFirstRound = _competition.fixtures.isEmpty;

    final TournamentRounds currentRound = TournamentRounds.values.firstWhere(
        (round) => isFirstRound
            ? round.numTeams == compTeams.length
            : round.numTeams == _competition.fixtures.last.matches.length);

    if (isFirstRound) {
      teamsThatPlayInRound = List.from(compTeams..shuffle());
    } else {
      for (var match in _competition.fixtures.last.matches) {
        final UserTeam? winner = match.getMatchWinner();
        if (winner != null) {
          teamsThatPlayInRound.add(winner);
        }
      }
    }

    if (teamsThatPlayInRound.length != currentRound.numTeams) return;

    for (int i = 0; i < currentRound.numMatches; i++) {
      matches.add(
        SportMatch(
          id: "${currentRound.name} - M${i + 1}",
          number: i + 1,
          teamA: teamsThatPlayInRound.first,
          teamB: teamsThatPlayInRound[1],
          date: DateTime.now(),
        ),
      );
      teamsThatPlayInRound.removeRange(0, 2);
    }
    final int fixtureNumber =
        _competition.fixtures.isEmpty ? 1 : _competition.fixtures.length + 1;

    _competition.fixtures
        .add(Fixture(currentRound.name, fixtureNumber, matches));

    _fixturesGenerated = currentRound.name == TournamentRounds.round2.name;

    compService.saveFixture(_competition.fixtures.last, _competition.id);

    compService.saveCompetition(_competition, _competition.creator.id, () {
      _loadUserCompetitions(compService);
    });

    notifyListeners();
  }

  void addEventToMatch(SportMatch match, MatchEvents event, String playerName,
      {bool playerIsFromTeamA = false}) {
    if (playerIsFromTeamA) {
      match.eventsTeamA.putIfAbsent(event, () => []);
      match.eventsTeamA[event]!.add(playerName);
      if (event == FootballEvents.goal) {
        match.scoreA++;
      }
    } else {
      match.eventsTeamB.putIfAbsent(event, () => []);
      match.eventsTeamB[event]!.add(playerName);
      if (event == FootballEvents.goal) {
        match.scoreB++;
      }
    }

    notifyListeners();
  }

  void saveMatchDetails(SportMatch match, BuildContext context) {
    if (_competition.format == CompetitionFormat.tournament &&
        match.scoreA == match.scoreB) {
      return;
    }

    match.updateMatchStats();
    match.setMatchWinnerAndUpdateStats();
    var competitionService = _getCompetitionServiceInstance(context);
    var fixtureName = _getMatchFixtureName(match);
    competitionService.saveMatch(match, _competition.id, fixtureName);
    competitionService.saveCompetition(
        _competition, _competition.creator.id, () {});
    notifyListeners();
  }

  CompetitionService _getCompetitionServiceInstance(BuildContext context) =>
      Provider.of<CompetitionService>(context, listen: false);

  void updateMatchDate(SportMatch match, DateTime date, BuildContext context) {
    match.date = date;
    String fixtureName = _getMatchFixtureName(match);
    var competitionService = _getCompetitionServiceInstance(context);
    competitionService.saveMatch(match, _competition.id, fixtureName);

    Fixture fixture =
        fixtures.firstWhere((fixture) => fixture.name == fixtureName);

    fixture.matches.sort((a, b) => a.date.compareTo(b.date));
    notifyListeners();
  }

  String _getMatchFixtureName(SportMatch match) => _competition.fixtures
      .firstWhere((fixture) => fixture.matches.contains(match))
      .name;

  void resetStats() {
    for (var team in _competition.teams) {
      team.onStatsReset();
    }
    teamsSortedByGoalsScored.value = _competition.teams;
    teamsSortedByPoints.value = _competition.teams;
    teamsSortedByGoalsConceded.value = _competition.teams;

    playersSortedByGoalsScored.value = _competition.players;
    playersSortedByAssists.value = _competition.players;
    notifyListeners();
  }

  void discardChanges(SportMatch currentMatch) {
    currentMatch.resetMatch();
    notifyListeners();
  }

  void saveCompetition(BuildContext context) async {
    var compService = _getCompetitionServiceInstance(context);
    await compService.saveCompetition(competition, competition.creator.id, () {
      _loadUserCompetitions(compService);
    });
  }

  void _loadUserCompetitions(CompetitionService compService) {
    _competitionsSubscription = compService
        .getCompetitions(userId: competition.creator.id)
        .listen((competitionsFirebase) {
      competition.creator.competitions = competitionsFirebase;
      notifyListeners();
    });
  }
}
