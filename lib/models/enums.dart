enum Sport {
  football("Futbol", 11, 23, "assets/icons/soccerBall.png"),
  futsal("Futbol sala", 5, 10, "assets/icons/futsalBall.png");

  const Sport(this.name, this.minPlayers, this.maxPlayers, this.iconPath);
  final String name;
  final int minPlayers;
  final int maxPlayers;
  final String iconPath;

  bool equals(Sport other) =>
      name == other.name &&
      minPlayers == other.minPlayers &&
      maxPlayers == other.maxPlayers &&
      iconPath == other.iconPath;
}

abstract class PlayerPosition {
  String get name;
  Sport get positionSport;

  bool equals(PlayerPosition other);
}

enum FootballPlayerPosition implements PlayerPosition {
  portero("Portero", Sport.football),
  defensa("Defensa", Sport.football),
  centrocampista("Centrocampista", Sport.football),
  delantero("Delantero", Sport.football);

  @override
  final String name;

  @override
  final Sport positionSport;

  const FootballPlayerPosition(this.name, this.positionSport);

  @override
  bool equals(PlayerPosition other) =>
      other is FootballPlayerPosition &&
      name == other.name &&
      positionSport == other.positionSport;
}

enum FutsalPlayerPosition implements PlayerPosition {
  portero("Portero", Sport.futsal),
  cierre("Cierre", Sport.futsal),
  alas("Alas", Sport.futsal),
  pivot("Pivot", Sport.futsal);

  @override
  final String name;

  @override
  final Sport positionSport;

  const FutsalPlayerPosition(this.name, this.positionSport);

  @override
  bool equals(PlayerPosition other) =>
      other is FutsalPlayerPosition &&
      name == other.name &&
      positionSport == other.positionSport;
}

Map<String, dynamic> playerPositionToJson(PlayerPosition position) {
  return {
    'name': position.name,
    'sport': position.positionSport.name,
  };
}

PlayerPosition playerPositionFromJson(Map<String, dynamic> json) {
  final String name = json['name'];
  final Sport sport =
      Sport.values.firstWhere((sport) => sport.name == json['sport']);

  switch (sport) {
    case Sport.football:
      return FootballPlayerPosition.values.firstWhere((p) => p.name == name);
    case Sport.futsal:
      return FutsalPlayerPosition.values.firstWhere((p) => p.name == name);
  }
}

abstract class MatchEvents {
  String get name;
  String get iconPath;
}

enum FootballEvents implements MatchEvents {
  goal("Gol", "assets/icons/goal.png"),
  assist("Asistencia", "assets/icons/shoe.png"),
  yellowCard("Tarjeta amarilla", "assets/icons/tarjeta-amarilla.png"),
  redCard("Tarjeta roja", "assets/icons/tarjeta-roja.png"),
  injury("Lesión", "assets/icons/red_cross.png");
  //playerSubstitution("Sustitución", "assets/icons/change.png");

  const FootballEvents(this.name, this.iconPath);

  @override
  final String name;
  @override
  final String iconPath;
}

enum TournamentRounds {
  round64(name: "Ronda de 32", numTeams: 64),
  round32(name: "Dieciseisavos de final", numTeams: 32),
  round16(name: "Octavos de final", numTeams: 16),
  round8(name: "Cuartos de final", numTeams: 8),
  round4(name: "Semifinal", numTeams: 4),
  round2(name: "Final", numTeams: 2);

  const TournamentRounds({required this.name, required this.numTeams});

  final String name;
  final int numTeams;
  int get numMatches => numTeams ~/ 2;
}
