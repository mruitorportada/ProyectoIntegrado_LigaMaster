import 'package:liga_master/models/competition/competition.dart';

class League extends Competition {
  get points => matchesWon * 3 + matchesTied;

  League(super.id, /*super._creator,*/ super.name, super.teams, super.players);
}
