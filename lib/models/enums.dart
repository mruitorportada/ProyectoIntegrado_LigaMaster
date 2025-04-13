enum Sport {
  football("Futbol", 11, 23),
  futsal("Futbol sala", 5, 10);

  const Sport(this.name, this.minPlayers, this.maxPlayers);
  final String name;
  final int minPlayers;
  final int maxPlayers;

  bool equals(Sport other) =>
      name == other.name &&
      minPlayers == other.minPlayers &&
      maxPlayers == other.maxPlayers;
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
