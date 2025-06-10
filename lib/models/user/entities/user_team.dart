import 'package:liga_master/models/enums.dart';
import 'package:liga_master/models/user/entities/user_entity.dart';
import 'package:liga_master/models/user/entities/user_player.dart';

class UserTeam extends UserEntity {
  List<UserPlayer> _players;
  List<UserPlayer> get players => _players;
  set players(List<UserPlayer> value) {
    _players = value;
    notifyListeners();
  }

  int get points => matchesWon * 3 + matchesTied;

  int get goalDifference => goals - goalsConceded;

  UserTeam({
    required String id,
    String creatorId = "",
    String name = "",
    double rating = 1,
    Sport sportPlayed = Sport.football,
    List<UserPlayer>? players,
    int matchesWon = 0,
    int matchesTied = 0,
    int matchesLost = 0,
    int goals = 0,
    int goalsConceded = 0,
    int yellowCards = 0,
    int redCards = 0,
  })  : _players = players ?? [],
        super(id, name, rating, sportPlayed,
            goals: goals,
            goalsConceded: goalsConceded,
            yellowCards: yellowCards,
            redCards: redCards,
            matchesWon: matchesWon,
            matchesTied: matchesTied,
            matchesLost: matchesLost);

  UserTeam copy() => UserTeam(
        id: id,
        name: name,
        rating: rating,
        sportPlayed: sportPlayed,
        players: _players.map((player) => player.copy()).toList(),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "rating": rating,
        "sportPlayed": sportPlayed.name,
        "players": _players.map((player) => player.id).toList(),
      };

  factory UserTeam.fromMap(Map<String, dynamic> data,
      {List<UserPlayer> allPlayers = const []}) {
    final ids = (data["players"] as List?)?.cast<String>() ?? [];

    return UserTeam(
        id: data["id"],
        name: data["name"],
        rating: data["rating"],
        sportPlayed: Sport.values
            .firstWhere((sport) => sport.name == data["sportPlayed"]),
        players:
            allPlayers.where((player) => ids.contains(player.id)).toList());
  }

  Map<String, dynamic> toCompetitionMap() => {
        "id": id,
        "name": name,
        "rating": rating,
        "sportPlayed": sportPlayed.name,
        "players": _players.map((player) => player.id).toList(),
        "matches_won": matchesWon,
        "matches_tied": matchesTied,
        "matches_lost": matchesLost,
        "goals": goals,
        "goals_conceded": goalsConceded,
        "yellow_cards": yellowCards,
        "red_cards": redCards
      };

  factory UserTeam.fromCompetitionMap(Map<String, dynamic> data,
      {List<UserPlayer> allPlayers = const []}) {
    final ids = (data["players"] as List<dynamic>? ?? [])
        .map((e) => e.toString())
        .toSet();

    return UserTeam(
        id: data["id"],
        name: data["name"],
        rating: data["rating"],
        sportPlayed: Sport.values
            .firstWhere((sport) => sport.name == data["sportPlayed"]),
        players: allPlayers.where((player) => ids.contains(player.id)).toList(),
        matchesWon: data["matches_won"],
        matchesTied: data["matches_tied"],
        matchesLost: data["matches_lost"],
        goals: data["goals"],
        goalsConceded: data["goals_conceded"],
        redCards: data["red_cards"],
        yellowCards: data["yellow_cards"]);
  }

  void onStatsReset() {
    super.resetStats();
    for (var player in _players) {
      player.onStatsReset();
    }
  }

  int compareTeamsByPointsAndGoalDifference(UserTeam other) {
    int compareByPoints = points.compareTo(other.points);
    return compareByPoints != 0
        ? compareByPoints
        : goalDifference.compareTo(other.goalDifference);
  }
}
