import 'package:flutter/material.dart';

abstract class CompetitionEntity extends ChangeNotifier {
  final String _id;
  String get id => _id;

  String _name;
  String get name => _name;
  set name(value) {
    _name = value;
    notifyListeners();
  }

  final Sport _sportPlayed;
  Sport get sportPlayed => _sportPlayed;
  double _rating;
  double get rating => _rating;
  set rating(value) {
    if (value > 0 && value <= 5) {
      _rating = value;
      notifyListeners();
    }
  }

  int _goals = 0;
  get goals => _goals;
  set goals(value) {
    _goals = goals;
    notifyListeners();
  }

  int _goalsConceded = 0;
  get goalsConceded => _goalsConceded;
  set goalsConceded(value) {
    _goalsConceded = value;
  }

  int _matchesPlayed = 0;
  get matchesPlayed => _matchesPlayed;
  set matchesPlayed(value) {
    _matchesPlayed = value;
    notifyListeners();
  }

  int _yellowCards = 0;
  get yellowCards => _yellowCards;
  set yellowCards(value) {
    _yellowCards = value;
    notifyListeners();
  }

  int _redCards = 0;
  get redCards => _redCards;
  set redCards(value) {
    _redCards = value;
    notifyListeners();
  }

  CompetitionEntity(this._id, this._name, this._rating, this._sportPlayed);

  @override
  String toString() => [
        "ID: $_id",
        "Name: $_name",
        "Rating: $_rating",
        "Sport: $_sportPlayed"
      ].map((e) => "$e -").join("\n");

  void increaseGoals(int amount) => _goals += amount;
}

enum Sport { football, futsal }
