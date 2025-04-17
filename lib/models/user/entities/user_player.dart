import 'package:liga_master/models/enums.dart';
import 'package:liga_master/models/user/entities/user_entity.dart';

class UserPlayer extends UserEntity {
  String? _currentTeamName;
  String? get currentTeamName => _currentTeamName;
  set currentTeamName(String? value) {
    _currentTeamName = value;
    notifyListeners();
  }

  PlayerPosition? _position;
  PlayerPosition? get position => _position;
  set position(PlayerPosition? value) {
    _position = value;
    notifyListeners();
  }

  UserPlayer({
    required String id,
    String name = "",
    double rating = 1,
    Sport sportPlayed = Sport.football,
    String? currentTeamName,
    PlayerPosition? position,
  })  : _currentTeamName = currentTeamName,
        _position = position,
        super(id, name, rating, sportPlayed);

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "rating": rating,
        "sportPlayed": sportPlayed.name,
        "teamName": currentTeamName,
        "position": playerPositionToJson(position!)
      };

  factory UserPlayer.fromMap(Map<String, dynamic> data) => UserPlayer(
        id: data["id"],
        name: data["name"],
        rating: data["rating"],
        sportPlayed: Sport.values.firstWhere(
          (sport) => sport.name == data["sportPlayed"],
        ),
        currentTeamName: data["teamName"],
        position: playerPositionFromJson(data["position"]),
      );

  UserPlayer copy() {
    return UserPlayer(
        id: id,
        name: name,
        rating: rating,
        sportPlayed: sportPlayed,
        currentTeamName: _currentTeamName,
        position: _position);
  }

  void setPositionFromFirestore(String posName) {
    switch (sportPlayed) {
      case Sport.football:
        position = FootballPlayerPosition.values
            .firstWhere((pos) => pos.name == posName);
      case Sport.futsal:
        position = FutsalPlayerPosition.values
            .firstWhere((pos) => pos.name == posName);
    }
  }
}
