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

  UserTeam(
      {required String id,
      String creatorId = "",
      String name = "",
      double rating = 1,
      Sport sportPlayed = Sport.football,
      List<UserPlayer>? players})
      : _players = players ?? [],
        super(id, name, rating, sportPlayed);

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

  bool equals(UserTeam other) =>
      id == other.id &&
      name == other.name &&
      rating == other.rating &&
      sportPlayed == other.sportPlayed &&
      players == other.players;

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
