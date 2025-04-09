import 'package:liga_master/models/competition/competition_entity.dart';
import 'package:liga_master/models/user/entities/user_entity.dart';
import 'package:liga_master/models/user/entities/user_player.dart';

class UserTeam extends UserEntity {
  List<UserPlayer> _players;
  List<UserPlayer> get players => _players;
  set players(value) {
    _players = value;
    notifyListeners();
  }

  UserTeam(
      {required String id,
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
}
