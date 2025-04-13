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
      id: "C1",
      creator: user,
      name: "Liga 1",
      teams: [],
      players: [],
      format: CompetitionFormat.league,
      sport: Sport.football),
  Competition(
      id: "C2",
      creator: user,
      name: "Torneo 1",
      teams: [],
      players: [],
      format: CompetitionFormat.tournament,
      sport: Sport.football),
  Competition(
      id: "C3",
      creator: user,
      name: "Liga 2",
      teams: [],
      players: [],
      format: CompetitionFormat.league,
      sport: Sport.futsal),
  Competition(
      id: "C4",
      creator: user,
      name: "Torneo 2",
      teams: [],
      players: [],
      format: CompetitionFormat.tournament,
      sport: Sport.futsal),
  Competition(
      id: "C5",
      creator: user,
      name: "Liga 3",
      teams: [],
      players: [],
      format: CompetitionFormat.league,
      sport: Sport.futsal),
];
