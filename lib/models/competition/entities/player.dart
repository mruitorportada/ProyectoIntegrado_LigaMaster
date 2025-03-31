import 'package:liga_master/models/competition/competition_entity.dart';
import 'package:liga_master/models/competition/entities/team.dart';

class CompetitionPlayer extends CompetitionEntity {
  CompetitionTeam? _team;
  get team => _team;
  set team(value) {
    _team = value;
    notifyListeners();
  }

  int _assists = 0;
  get assists => _assists;
  set assists(value) {
    _assists = value;
    notifyListeners();
  }

  CompetitionPlayer(super.id, super.name, super.rating, super.sportPlayed,
      {CompetitionTeam? team})
      : _team = team;
}
