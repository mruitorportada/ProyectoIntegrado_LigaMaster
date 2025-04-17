import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:liga_master/models/competition/competition.dart';
import 'package:liga_master/models/user/entities/user_player.dart';
import 'package:liga_master/models/user/entities/user_team.dart';
import 'package:liga_master/models/user/app_user.dart';

class CompetitionService {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  String get _uid => _auth.currentUser!.uid;

  Future<void> saveCompetition(Competition competition) async {
    await _firestore
        .collection("competitions")
        .doc(_uid)
        .collection("user_competitions")
        .doc(competition.id)
        .set(competition.toMap());
  }

  Future<void> deleteCompetition(String competitionId) async {
    await _firestore
        .collection("competitions")
        .doc(_uid)
        .collection("user_competitions")
        .doc(competitionId)
        .delete();
  }

  Stream<List<Competition>> getCompetitions({
    required AppUser creator,
    required List<UserTeam> allTeams,
    required List<UserPlayer> allPlayers,
  }) {
    return _firestore
        .collection("competitions")
        .doc(_uid)
        .collection("user_competitions")
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Competition.fromJson(
                  doc.data(),
                  creator,
                  allTeams,
                  allPlayers,
                ))
            .toList());
  }
}
