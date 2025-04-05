// ignore_for_file: prefer_final_fields

import 'package:liga_master/models/competition/competition_entity.dart';
import 'package:liga_master/models/competition/entities/player.dart';
import 'package:liga_master/models/user/entities/user_team.dart';

class CompetitionTeam extends CompetitionEntity {
  List<CompetitionPlayer> _players;
  List<CompetitionPlayer> get players => _players;
  set players(value) {
    _players = value;
    notifyListeners();
  }

  int _matchesWon = 0;
  int get matchesWon => _matchesWon;

  int _matchesTied = 0;
  int get matchesTied => _matchesTied;

  int _matchesLost = 0;
  int get matchesLost => _matchesLost;

  int get points => _matchesWon * 3 + _matchesTied;

  CompetitionTeam(super.id, super.name, super.rating, super.sportPlayed,
      {List<CompetitionPlayer>? players})
      : _players = players ?? [];

  UserTeam toUserTeam() =>
      UserTeam(super.id, super.name, super.rating, super.sportPlayed,
          players: players);
}
