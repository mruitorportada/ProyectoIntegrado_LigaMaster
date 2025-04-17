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

  UserEntity(this._id, this._name, this._rating, this._sportPlayed);

  @override
  String toString() => [
        "ID: $_id",
        "Name: $_name",
        "Rating: $_rating",
        "Sport: $_sportPlayed"
      ].map((e) => "$e -").join("\n");
}
