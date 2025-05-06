import 'package:flutter/material.dart';
import 'package:liga_master/models/enums.dart';

abstract class UserEntity extends ChangeNotifier {
  final String _id;
  String get id => _id;

  String _name;
  String get name => _name;
  set name(value) {
    _name = value;
    notifyListeners();
  }

  Sport _sportPlayed;
  Sport get sportPlayed => _sportPlayed;
  set sportPlayed(value) {
    _sportPlayed = value;
    notifyListeners();
  }

  double _rating;
  double get rating => _rating;
  set rating(value) {
    if (value > 0 && value <= 5) {
      _rating = value;
      notifyListeners();
    }
  }

  int _goals = 0;
  int get goals => _goals;
  set goals(int value) {
    _goals += value;
    notifyListeners();
  }

  int _goalsConceded = 0;
  int get goalsConceded => _goalsConceded;
  set goalsConceded(int value) {
    _goalsConceded += value;
    notifyListeners();
  }

  int _matchesPlayed = 0;
  int get matchesPlayed => _matchesPlayed;
  set matchesPlayed(int value) {
    _matchesPlayed = value;
    notifyListeners();
  }

  int _matchesWon = 0;
  int get matchesWon => _matchesWon;
  set matchesWon(int value) {
    _matchesWon = value;
    notifyListeners();
  }

  int _matchesTied = 0;
  int get matchesTied => _matchesTied;
  set matchesTied(int value) {
    _matchesTied = value;
    notifyListeners();
  }

  int _matchesLost = 0;
  int get matchesLost => _matchesLost;
  set matchesLost(int value) {
    _matchesLost = value;
    notifyListeners();
  }

  int _yellowCards = 0;
  int get yellowCards => _yellowCards;
  set yellowCards(int value) {
    _yellowCards = value;
    notifyListeners();
  }

  int _redCards = 0;
  int get redCards => _redCards;
  set redCards(int value) {
    _redCards = value;
    notifyListeners();
  }

  UserEntity(this._id, this._name, this._rating, this._sportPlayed);

  void resetStats() {
    goals = 0;
    goalsConceded = 0;
    matchesPlayed = 0;
    matchesWon = 0;
    matchesTied = 0;
    matchesLost = 0;
    yellowCards = 0;
    redCards = 0;
  }
}
