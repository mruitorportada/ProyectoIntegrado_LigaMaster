import 'package:flutter/material.dart';
import 'package:liga_master/models/match/match.dart';

class Fixture extends ChangeNotifier {
  final String _name;
  String get name => _name;

  DateTime _fixtureDay;
  DateTime get fixtureDay => _fixtureDay;
  set fixtureDay(DateTime value) {
    _fixtureDay = value;
    notifyListeners();
  }

  final List<SportMatch> _matches;
  List<SportMatch> get matches => _matches;

  Fixture(this._name, this._fixtureDay, this._matches);
}
