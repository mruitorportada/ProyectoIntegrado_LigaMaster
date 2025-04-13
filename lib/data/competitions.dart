import 'package:liga_master/models/competition/competition.dart';
import 'package:liga_master/models/enums.dart';
import 'package:liga_master/models/user/user.dart';

var user = User(
    id: "1",
    name: "Mario",
    surname: "Ruiz",
    username: "mruitor",
    email: "mruitor@gmail.com",
    password: "password");
List<Competition> competitionsData = [
  Competition(
      id: "001",
      creator: user,
      name: "Liga 1",
      teams: [],
      players: [],
      format: CompetitionFormat.league,
      sport: Sport.football),
  Competition(
      id: "002",
      creator: user,
      name: "Torneo 1",
      teams: [],
      players: [],
      format: CompetitionFormat.tournament,
      sport: Sport.football),
  Competition(
      id: "003",
      creator: user,
      name: "Liga 2",
      teams: [],
      players: [],
      format: CompetitionFormat.league,
      sport: Sport.futsal),
  Competition(
      id: "004",
      creator: user,
      name: "Torneo 2",
      teams: [],
      players: [],
      format: CompetitionFormat.tournament,
      sport: Sport.futsal),
  Competition(
      id: "005",
      creator: user,
      name: "Liga 3",
      teams: [],
      players: [],
      format: CompetitionFormat.league,
      sport: Sport.futsal),
];
