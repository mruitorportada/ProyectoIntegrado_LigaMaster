import 'package:flutter/material.dart';
import 'package:liga_master/models/user/entities/user_team.dart';

class Match extends ChangeNotifier {
  final UserTeam _teamA;
  get teamA => _teamA;
  final UserTeam _teamB;
  get teamB => _teamB;
  int _scoreA = 0;
  get scoreA => _scoreA;
  set scoreA(value) {
    if (value >= 0) {
      _scoreA = value;
      notifyListeners();
    }
  }

  int _scoreB = 0;
  get scoreB => _scoreB;
  set scoreB(value) {
    if (value >= 0) {
      _scoreB = value;
      notifyListeners();
    }
  }

  DateTime _date;
  get date => _date;
  set date(value) {
    _date = value;
    notifyListeners();
  }

  Match(this._teamA, this._teamB, this._date);
}
