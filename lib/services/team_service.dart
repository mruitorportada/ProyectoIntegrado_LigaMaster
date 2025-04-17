import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:liga_master/models/user/app_user.dart';
import 'package:liga_master/models/user/entities/user_player.dart';
import 'package:liga_master/models/user/entities/user_team.dart';

class TeamService {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  String get _uid => _auth.currentUser!.uid;

  Future<void> saveTeam(UserTeam team) async {
    await _firestore
        .collection("teams")
        .doc(_uid)
        .collection("user_teams")
        .doc(team.id)
        .set(team.toMap());
  }

  Future<void> deleteTeam(String teamId) async {
    await _firestore
        .collection("teams")
        .doc(_uid)
        .collection("user_teams")
        .doc(teamId)
        .delete();
  }

  Stream<List<UserTeam>> getTeams({
    required AppUser creator,
    required List<UserPlayer> allPlayers,
  }) {
    return _firestore
        .collection("teams")
        .doc(_uid)
        .collection("user_teams")
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => UserTeam.fromMap(
                  doc.data(),
                  allPlayers: allPlayers,
                ))
            .toList());
  }
}
