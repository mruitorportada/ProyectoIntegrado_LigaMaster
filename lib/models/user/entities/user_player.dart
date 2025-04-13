import 'package:liga_master/models/enums.dart';
import 'package:liga_master/models/user/entities/user_entity.dart';

class UserPlayer extends UserEntity {
  String? _currentTeamName;
  String? get currentTeamName => _currentTeamName;
  set currentTeamName(String? value) {
    _currentTeamName = value;
    notifyListeners();
  }

  UserPlayer(
    String id, {
    String name = "",
    double rating = 1,
    Sport sportPlayed = Sport.football,
    String? currentTeamName,
  })  : _currentTeamName = currentTeamName,
        super(id, name, rating, sportPlayed);

  UserPlayer copy() {
    return UserPlayer(
      id,
      name: name,
      rating: rating,
      sportPlayed: sportPlayed,
      currentTeamName: _currentTeamName,
    );
  }
}
