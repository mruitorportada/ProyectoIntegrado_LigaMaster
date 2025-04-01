// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:liga_master/models/competition/competition.dart';
import 'package:liga_master/models/user/user.dart';

class CompetitionListViewmodel extends ChangeNotifier {
  List<Competition> _competitions = List.empty(growable: true);
  List<Competition> get competitions => _competitions;

  CompetitionListViewmodel(List<Competition> userCompetitions)
      : _competitions = userCompetitions.isNotEmpty
            ? userCompetitions
            : List.empty(growable: true);

  void addCompetition(Competition competition) {
    _competitions.add(competition);
    notifyListeners();
  }

  void updateCompetition(Competition competition) {
    int index = _competitions.indexOf(competition);
    if (index != -1) {
      _competitions[index] = competition;
      notifyListeners();
    }
  }

  void removeCompetition(Competition competition) {
    _competitions.remove(competition);
    notifyListeners();
  }

  void getCompetitionsFromUser(User user) {
    for (Competition c in user.competitions) {
      addCompetition(c);
    }
  }
}
