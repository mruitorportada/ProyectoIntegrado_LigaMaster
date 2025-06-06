import 'package:liga_master/models/enums.dart';
import 'package:liga_master/models/user/entities/user_entity.dart';

class UserPlayer extends UserEntity {
  String? _currentTeamName;
  String? get currentTeamName => _currentTeamName;
  set currentTeamName(String? value) {
    _currentTeamName = value;
    notifyListeners();
  }

  PlayerPosition _position;
  PlayerPosition get position => _position;
  set position(PlayerPosition value) {
    _position = value;
    notifyListeners();
  }

  int _assists = 0;
  int get assists => _assists;
  set assists(int value) {
    _assists = value;
    notifyListeners();
  }

  int _cleanSheets = 0;
  int get cleanSheets => _cleanSheets;
  set cleanSheets(int value) {
    _cleanSheets = value;
    notifyListeners();
  }

  PlayerStatus _playerStatus;
  PlayerStatus get playerStatus => _playerStatus;
  set playerStatus(PlayerStatus value) {
    _playerStatus = value;
    notifyListeners();
  }

  UserPlayer({
    required String id,
    String name = "",
    double rating = 1,
    Sport sportPlayed = Sport.football,
    String? currentTeamName,
    PlayerPosition position = FootballPlayerPosition.portero,
    int goals = 0,
    int assists = 0,
    int cleanSheets = 0,
    int yellowCards = 0,
    int redCards = 0,
    PlayerStatus? status,
  })  : _currentTeamName = currentTeamName,
        _position = position,
        _assists = assists,
        _cleanSheets = cleanSheets,
        _playerStatus =
            status ?? PlayerStatus(statusName: "Disponible", duration: 999),
        super(id, name, rating, sportPlayed,
            goals: goals, yellowCards: yellowCards, redCards: redCards);

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "rating": rating,
        "sportPlayed": sportPlayed.name,
        "teamName": currentTeamName,
        "position": playerPositionToJson(position)
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

  Map<String, dynamic> toCompetitionMap() => {
        "id": id,
        "name": name,
        "rating": rating,
        "sportPlayed": sportPlayed.name,
        "teamName": currentTeamName,
        "position": playerPositionToJson(position),
        "goals": goals,
        "assists": _assists,
        "clean_sheets": _cleanSheets,
        "yellow_cards": yellowCards,
        "red_cards": redCards,
        "status": _playerStatus.toMap()
      };

  factory UserPlayer.fromCompetitionMap(Map<String, dynamic> data) =>
      UserPlayer(
        id: data["id"],
        name: data["name"],
        rating: data["rating"],
        sportPlayed: Sport.values.firstWhere(
          (sport) => sport.name == data["sportPlayed"],
        ),
        currentTeamName: data["teamName"],
        position: playerPositionFromJson(data["position"]),
        goals: data["goals"],
        assists: data["assists"],
        cleanSheets: data["clean_sheets"],
        redCards: data["red_cards"],
        yellowCards: data["yellow_cards"],
        status: data["status"] != null
            ? PlayerStatus.fromMap(data["status"])
            : PlayerStatus(
                statusName: "Disponible",
                duration: 999,
              ),
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

  void onStatsReset() {
    super.resetStats();
    _assists = 0;
    _cleanSheets = 0;
    resetStatusToAvaliable();
  }

  void resetStatusToAvaliable() {
    _playerStatus = PlayerStatus(statusName: "Disponible", duration: 999);
  }

  void setSuspension(
      {required String name,
      required int fixtureNumber,
      required int duration}) {
    _playerStatus = PlayerStatus(
        statusName: name,
        duration: duration,
        suspensionFixtureNumber: fixtureNumber);
  }
}

class PlayerStatus {
  final String _statusName;
  String get statusName => _statusName;

  int _duration;
  int get duration => _duration;

  final int _suspensionFixtureNumber;
  int get suspensionFixtureNumber => _suspensionFixtureNumber;

  PlayerStatus(
      {required String statusName,
      required int duration,
      int suspensionFixtureNumber = 1})
      : _statusName = statusName,
        _duration = duration,
        _suspensionFixtureNumber = suspensionFixtureNumber;

  Map<String, dynamic> toMap() => {
        "name": _statusName,
        "duration": _duration,
        "suspensionFixtureNumber": _suspensionFixtureNumber,
      };

  factory PlayerStatus.fromMap(Map<String, dynamic> data) => PlayerStatus(
      statusName: data["name"],
      duration: data["duration"],
      suspensionFixtureNumber: data["suspensionFixtureNumber"] ?? 0);

  void reduceSuspensionDuration() => _duration--;
}
