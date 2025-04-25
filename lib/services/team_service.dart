import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:liga_master/models/user/app_user.dart';
import 'package:liga_master/models/user/entities/user_player.dart';
import 'package:liga_master/models/user/entities/user_team.dart';

class TeamService {
  final FirebaseFirestore _firestore;
  final String _uid;

  CollectionReference<Map<String, dynamic>> get _teams =>
      _firestore.collection("teams").doc(_uid).collection("user_teams");

  TeamService({required FirebaseFirestore firestore, required String uid})
      : _firestore = firestore,
        _uid = uid;

  Future<void> saveTeam(UserTeam team, String userId) async {
    await _teams.doc(team.id).set(team.toMap());
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
    await _teams.doc(team.id).delete();
    await _firestore.collection("users").doc(userId).update(({
          "teams": FieldValue.arrayRemove([team.id])
        }));
  }

  Stream<List<UserTeam>> getTeams({
    required AppUser creator,
    required List<UserPlayer> allPlayers,
  }) {
    return _teams.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => UserTeam.fromMap(
              doc.data(),
              allPlayers: allPlayers,
            ))
        .toList());
  }
}
