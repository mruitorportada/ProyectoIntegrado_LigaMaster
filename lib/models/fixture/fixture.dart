import 'package:flutter/material.dart';
import 'package:liga_master/models/match/match.dart';

class Fixture extends ChangeNotifier {
  final String _name;
  String get name => _name;

  final int _number;
  int get number => _number;

  final List<SportMatch> _matches;
  List<SportMatch> get matches => _matches;

  Fixture(this._name, this._number, this._matches);

  Map<String, dynamic> toMap() => {
        "name": name,
        "number": number,
        "matchesId": _matches.map((match) => match.id).toList(),
      };

  factory Fixture.fromMap(
          Map<String, dynamic> data, List<SportMatch> matches) =>
      Fixture(
        data["name"],
        data["number"],
        matches,
      );
}
