import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:liga_master/models/user/entities/user_player.dart';
import 'package:liga_master/models/user/entities/user_team.dart';

class TeamService {
  final FirebaseFirestore _firestore;

  TeamService({required FirebaseFirestore firestore}) : _firestore = firestore;

  Future<void> saveTeam(UserTeam team, String userId) async {
    await _firestore
        .collection("teams")
        .doc(userId)
        .collection("user_teams")
        .doc(team.id)
        .set(team.toMap());
    if (team.players.isNotEmpty) {
      for (var player in team.players) {
        await _firestore
            .collection("players")
            .doc(userId)
            .collection("user_players")
            .doc(player.id)
            .update(({"teamName": team.name}));
      }
    }
    await _firestore.collection("users").doc(userId).update(({
          "teams": FieldValue.arrayUnion([team.id])
        }));
  }

  Future<void> deleteTeam(UserTeam team, String userId) async {
    if (team.players.isNotEmpty) {
      for (var player in team.players) {
        await _firestore
            .collection("players")
            .doc(userId)
            .collection("user_players")
            .doc(player.id)
            .update(({"teamName": null}));
      }
    }
    await _firestore
        .collection("teams")
        .doc(userId)
        .collection("user_teams")
        .doc(team.id)
        .delete();
    await _firestore.collection("users").doc(userId).update(({
          "teams": FieldValue.arrayRemove([team.id])
        }));
  }

  Stream<List<UserTeam>> getTeams({
    required String userId,
    required List<UserPlayer> allPlayers,
  }) {
    return _firestore
        .collection("teams")
        .doc(userId)
        .collection("user_teams")
        .orderBy("name")
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => UserTeam.fromMap(
                  doc.data(),
                  allPlayers: allPlayers,
                ))
            .toList());
  }

  Future<bool> checkTeamNameIsUnique(String teamName, String userId) async {
    CollectionReference collectionRef =
        _firestore.collection("teams").doc(userId).collection("user_teams");

    var query =
        await collectionRef.where("name", isEqualTo: teamName).limit(1).get();

    bool unique = query.docs.isEmpty;
    return unique;
  }
}
