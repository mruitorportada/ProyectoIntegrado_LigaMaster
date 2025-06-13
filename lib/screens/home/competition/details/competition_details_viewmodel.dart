import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:liga_master/models/appstrings/appstrings_controller.dart';
import 'package:liga_master/models/competition/competition.dart';
import 'package:liga_master/models/enums.dart';
import 'package:liga_master/models/fixture/fixture.dart';
import 'package:liga_master/models/match/sport_match.dart';
import 'package:liga_master/models/user/entities/user_player.dart';
import 'package:liga_master/models/user/entities/user_team.dart';
import 'package:liga_master/screens/generic/appcolors.dart';
import 'package:liga_master/screens/generic/functions.dart';
import 'package:liga_master/services/competition_service.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';
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
    for (final team in _competition.teams) {
      team.removeListener(_sortTeamsByGoalsScored);
      team.removeListener(_sortTeamsByPoints);
      team.removeListener(_sortTeamsByGoalsConceded);
    }

    for (final player in _competition.players) {
      player.removeListener(_sortPlayersByGoalsScored);
      player.removeListener(_sortPlayersByAssists);
    }
    super.dispose();
  }

  void leagueFixturesGenerator(
      int timesEachTeamPlaysEachOther, BuildContext context) async {
    final competitionService = _getCompetitionServiceInstance(context);

    _generateLeagueFixtures(timesEachTeamPlaysEachOther, competitionService);

    await saveCompetition(context);

    fixturesGenerated = fixtures.isNotEmpty;

    notifyListeners();
  }

  void _generateLeagueFixtures(
      int timesEachTeamPlaysEachOther, CompetitionService competitionService) {
    for (int cycle = 0; cycle < timesEachTeamPlaysEachOther; cycle++) {
      final int numTeams = competition.teams.length;
      final int numFixturesPerCycle = numTeams - 1;

      List<UserTeam> rotatingTeams = List.from(competition.teams);

      for (int fixture = 0; fixture < numFixturesPerCycle; fixture++) {
        _generateLeagueFixture(
          rotatingTeams: rotatingTeams,
          numTeams: numTeams,
          competitionService: competitionService,
        );
        // Rotación para el algoritmo de round-robin
        final temp = rotatingTeams.removeAt(1);
        rotatingTeams.add(temp);
      }
    }
  }

  void _generateLeagueFixture(
      {required List<UserTeam> rotatingTeams,
      required int numTeams,
      required CompetitionService competitionService}) {
    List<SportMatch> matches = _generateLeagueFixtureMatches(
      rotatingTeams: rotatingTeams,
      numTeams: numTeams,
    );

    matches.sort((a, b) => a.date.compareTo(b.date));

    final int number = fixtures.length + 1;

    _competition.addFixture(Fixture("Jornada $number", number, matches));

    competitionService.saveFixture(_competition.fixtures.last, _competition.id);
  }

  List<SportMatch> _generateLeagueFixtureMatches({
    required List<UserTeam> rotatingTeams,
    required int numTeams,
  }) {
    final int matchesPerRound = numTeams ~/ 2;
    List<SportMatch> matches = [];

    for (int i = 0; i < matchesPerRound; i++) {
      matches.add(
        _generateLeagueMatch(
          rotatingTeams: rotatingTeams,
          numTeams: numTeams,
          index: i,
        ),
      );
    }
    return matches;
  }

  SportMatch _generateLeagueMatch({
    required List<UserTeam> rotatingTeams,
    required int numTeams,
    required int index,
  }) {
    final teamA =
        _competition.teams.firstWhere((t) => t.id == rotatingTeams[index].id);
    final teamB = _competition.teams
        .firstWhere((t) => t.id == rotatingTeams[numTeams - 1 - index].id);

    final homeTeam = _determineHomeTeamForMatch(teamA: teamA, teamB: teamB);
    final awayTeam = homeTeam == teamA ? teamB : teamA;

    final matchNumber = index + 1;

    final matchId = "M$matchNumber";

    return SportMatch(
      id: "J${fixtures.length + 1} - $matchId",
      number: matchNumber,
      teamA: homeTeam,
      teamB: awayTeam,
      date: DateTime.now(),
    );
  }

  UserTeam _determineHomeTeamForMatch(
      {required UserTeam teamA, required UserTeam teamB}) {
    final List<SportMatch> currentMatches = [];
    for (final fixture in _competition.fixtures) {
      currentMatches.addAll(fixture.matches);
    }
    final SportMatch match = currentMatches.lastWhere(
      (match) {
        final List<String> ids = List.from([match.teamA.id, match.teamB.id]);
        return ids.contains(teamA.id) && ids.contains(teamB.id);
      },
      orElse: () => SportMatch(
        id: "-1",
        number: 0,
        teamA: UserTeam(id: ""),
        teamB: UserTeam(id: ""),
        date: DateTime.now(),
      ),
    );

    if (match.id == "-1") return teamA;

    return match.teamA.id == teamA.id ? teamB : teamA;
  }

  void tournamentRoundGenerator(BuildContext context,
      {bool fixtureHasTwoLegs = false}) {
    final controller =
        Provider.of<AppStringsController>(context, listen: false);
    final strings = controller.strings!;

    final compService = _getCompetitionServiceInstance(context);

    bool isFirstRound = _competition.fixtures.isEmpty;

    final TournamentRounds currentRound = TournamentRounds.values.firstWhere(
        (round) => isFirstRound
            ? round.numTeams == _competition.teams.length
            : round.numTeams == _competition.fixtures.last.matches.length);

    final List<UserTeam> teamsThatPlayInRound =
        _getTeamsThatPlayInRound(isFirstRound: isFirstRound);

    if (teamsThatPlayInRound.length != currentRound.numTeams) {
      Fluttertoast.showToast(
        msg: strings.roundErrorMessage,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        textColor: LightThemeAppColors.textColor,
        toastLength: Toast.LENGTH_LONG,
      );
      return;
    }

    _generateTournamentRound(context,
        currentRound: currentRound, teamsThatPlayInRound: teamsThatPlayInRound);

    compService.saveFixture(_competition.fixtures.last, _competition.id);

    saveCompetition(context);

    notifyListeners();
  }

  void _generateTournamentRound(
    BuildContext context, {
    required TournamentRounds currentRound,
    required List<UserTeam> teamsThatPlayInRound,
  }) {
    List<SportMatch> matches = _generateTournamentMatches(
        currentRound: currentRound, teamsThatPlayInRound: teamsThatPlayInRound);
    final int fixtureNumber =
        _competition.fixtures.isEmpty ? 1 : _competition.fixtures.length + 1;

    _competition.fixtures.add(
      Fixture(
        getTournamentRoundLabel(context, currentRound),
        fixtureNumber,
        matches,
      ),
    );

    _fixturesGenerated = currentRound.name == TournamentRounds.round2.name;
  }

  List<SportMatch> _generateTournamentMatches(
      {required TournamentRounds currentRound,
      required List<UserTeam> teamsThatPlayInRound}) {
    final List<SportMatch> matches = [];
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
    return matches;
  }

  List<UserTeam> _getTeamsThatPlayInRound({required bool isFirstRound}) {
    if (isFirstRound) {
      return List.from(_competition.teams..shuffle());
    } else {
      final List<UserTeam> teamsThatPlayInRound = [];
      for (final match in _competition.fixtures.last.matches) {
        final UserTeam? winner = match.getMatchWinner();
        if (winner != null) {
          teamsThatPlayInRound.add(winner);
        }
      }
      return teamsThatPlayInRound;
    }
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

  Future<bool> saveMatchDetails(SportMatch match, BuildContext context) async {
    final controller =
        Provider.of<AppStringsController>(context, listen: false);
    final strings = controller.strings!;

    if (_competition.format == CompetitionFormat.tournament &&
        match.scoreA == match.scoreB) {
      Fluttertoast.showToast(
        msg: strings.matchTieInTournamentError,
        backgroundColor: Theme.of(context).primaryColor,
        textColor: LightThemeAppColors.textColor,
        toastLength: Toast.LENGTH_LONG,
      );
      return false;
    }

    final competitionService = _getCompetitionServiceInstance(context);
    final fixtureName = _getMatchFixtureName(match);

    match.updateMatchStats(fixtureNumber: getMatchFixtureNumber(match));
    try {
      await _saveMatch(match, context, fixtureName);
      await competitionService.saveCompetition(
          _competition, _competition.creator.id, () {});

      Fluttertoast.showToast(
        msg: strings.matchSavedMessage,
        backgroundColor: Colors.lightBlue,
        textColor: LightThemeAppColors.textColor,
        toastLength: Toast.LENGTH_LONG,
      );
    } catch (e, _) {
      Fluttertoast.showToast(
        msg: strings.matchNotSavedMessage,
        backgroundColor: Colors.red,
        textColor: LightThemeAppColors.textColor,
        toastLength: Toast.LENGTH_LONG,
      );
      notifyListeners();
      return false;
    }
    notifyListeners();
    return true;
  }

  CompetitionService _getCompetitionServiceInstance(BuildContext context) =>
      Provider.of<CompetitionService>(context, listen: false);

  void updateMatchDate(SportMatch match, DateTime date, BuildContext context) {
    match.date = date;
    final fixtureName = _getMatchFixtureName(match);
    _saveMatch(match, context, fixtureName);

    final fixture =
        fixtures.firstWhere((fixture) => fixture.name == fixtureName);

    fixture.matches.sort((a, b) => a.date.compareTo(b.date));
    notifyListeners();
  }

  void updateMatchLocation(
      SportMatch match, PickedData pickedLocation, BuildContext context) {
    match.updateLocation(pickedLocation);
    _saveMatch(match, context, _getMatchFixtureName(match));
    notifyListeners();
  }

  String _getMatchFixtureName(SportMatch match) => _competition.fixtures
      .firstWhere((fixture) => fixture.matches.contains(match))
      .name;

  int getMatchFixtureNumber(SportMatch match) {
    int number = _competition.fixtures
        .firstWhere((fixture) => fixture.matches
            .map((matchFix) => matchFix.id)
            .toList()
            .contains(match.id))
        .number;

    return number;
  }

  void resetStats() {
    for (final team in _competition.teams) {
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
    final List<UserPlayer> players = [
      ...currentMatch.teamA.players,
      ...currentMatch.teamB.players
    ]
        .where((player) => player.playerStatus.statusName != "Disponible")
        .toList();

    if (players.isNotEmpty) {
      for (final player in players) {
        player.resetStatusToAvaliable();
      }
    }

    currentMatch.resetMatch();
    notifyListeners();
  }

  Future<void> saveCompetition(BuildContext context) async {
    final compService = _getCompetitionServiceInstance(context);
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

  Future<void> _saveMatch(
      SportMatch match, BuildContext context, String fixtureName) async {
    final competitionService = _getCompetitionServiceInstance(context);
    await competitionService.saveMatch(match, _competition.id, fixtureName);
  }

  void setPlayerSuspension(SportMatch match, String name, int duration,
      String playerId, String teamName) {
    final team = _competition.teams.firstWhere((team) => team.name == teamName);
    final player = team.players.firstWhere((player) => player.id == playerId);

    player.setSuspension(
      name: name,
      fixtureNumber: getMatchFixtureNumber(match),
      duration: duration,
    );
  }

  bool playerIsElegibleForSelection(
      UserPlayer player, MatchEvents event, SportMatch match) {
    if (player.playerStatus.statusName == "Disponible") {
      return event != FootballEvents.assist
          ? true
          : match.checkPlayerCanAssist(player);
    }
    return false;
  }
}
