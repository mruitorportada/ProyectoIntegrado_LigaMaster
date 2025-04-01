import 'package:liga_master/models/competition/competition.dart';
import 'package:liga_master/models/competition/formats/league.dart';
import 'package:liga_master/models/competition/formats/tournament.dart';
import 'package:liga_master/models/user/user.dart';

var user =
    User("1", "Mario", "Ruiz", "mruitor", "mruitor@gmail.com", "password");
List<Competition> competitions = [
  League("001", "Liga 1", [], []),
  League("002", "Liga 2", [], []),
  Tournament("003", "Torneo 1", [], []),
  League("004", "Liga 3", [], []),
  Tournament("005", "Torneo 2", [], []),
];
