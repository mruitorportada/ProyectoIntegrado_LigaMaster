// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:liga_master/models/user/entities/user_player.dart';

class PlayerListViewmodel extends ChangeNotifier {
  List<UserPlayer> _players = List.empty(growable: true);
  List<UserPlayer> get players => _players;

  PlayerListViewmodel(List<UserPlayer> userPlayers)
      : _players =
            userPlayers.isNotEmpty ? userPlayers : List.empty(growable: true);

  void addPlayer(UserPlayer player) {
    _players.add(player);
    notifyListeners();
  }
}
