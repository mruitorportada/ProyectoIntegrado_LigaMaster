import 'package:flutter/material.dart';
import 'package:liga_master/models/competition/entities/player.dart';
import 'package:liga_master/models/competition/entities/team.dart';

abstract class Competition extends ChangeNotifier {
  final String _id;
  get id => _id;

  final String _name;
  get name => _name;

  final int _minTeams = 4;
  get minTeams => _minTeams;

  final int _maxTeams = 64;
  get maxTeams => _maxTeams;

  final List<CompetitionTeam> _teams;
  get teams => _teams;

  final List<CompetitionPlayer> _players;
  get players => _players;

  int _matchesWon = 0;
  get matchesWon => _matchesWon;
  set matchesWon(value) {
    _matchesWon = value;
  }

  int _matchesLost = 0;
  get matchesLost => _matchesLost;
  set matchesLost(value) {
    _matchesLost = value;
  }

  int _matchesTied = 0;
  get matchesTied => _matchesTied;
  set matchesTied(value) {
    _matchesTied = value;
  }

  Competition(this._id, this._name, this._teams, this._players);
}
