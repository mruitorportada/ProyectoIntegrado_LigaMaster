import 'package:liga_master/models/competition/entities/player.dart';
import 'package:liga_master/models/competition/entities/team.dart';
import 'package:liga_master/models/user/entities/user_entity.dart';

class UserTeam extends UserEntity {
  List<CompetitionPlayer> _players;
  List<CompetitionPlayer> get players => _players;
  set players(value) {
    _players = value;
    notifyListeners();
  }

  UserTeam(super.id, super.name, super.rating, super.sportPlayed,
      {List<CompetitionPlayer>? players})
      : _players = players ?? [];

  CompetitionTeam toCompetitionTeam() {
    return CompetitionTeam(
        super.id, super.name, super.rating, super.sportPlayed,
        players: players);
  }
}
