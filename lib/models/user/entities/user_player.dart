import 'package:liga_master/models/user/entities/user_entity.dart';
import 'package:liga_master/models/user/entities/user_team.dart';

class UserPlayer extends UserEntity {
  List<UserTeam> _teams;
  List get teams => _teams;
  set teams(value) {
    _teams = value;
    notifyListeners();
  }

  UserPlayer(super.id, super.name, super.rating, super.sportPlayed,
      List<UserTeam>? teams)
      : _teams = teams ?? [];
}
