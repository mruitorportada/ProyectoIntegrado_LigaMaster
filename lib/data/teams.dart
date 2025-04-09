import 'package:liga_master/models/competition/competition_entity.dart';
import 'package:liga_master/models/user/entities/user_team.dart';

List<UserTeam> teamsData = [
  UserTeam(
      id: "T1", name: "Los Halcones", rating: 4.2, sportPlayed: Sport.football),
  UserTeam(
      id: "T2",
      name: "Tigres del Norte",
      rating: 3.8,
      sportPlayed: Sport.futsal),
  UserTeam(
      id: "T3",
      name: "Águilas Rojas",
      rating: 4.5,
      sportPlayed: Sport.football),
  UserTeam(
      id: "T4", name: "Leones del Sur", rating: 3.9, sportPlayed: Sport.futsal),
];
