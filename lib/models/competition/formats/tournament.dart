import 'package:liga_master/models/competition/competition.dart';

class Tournament extends Competition {
  Tournament(
      super.id, /*super._creator,*/ super.name, super.teams, super.players);
}
