import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:liga_master/models/user/app_user.dart';
import 'package:liga_master/models/user/entities/user_player.dart';

class PlayerService {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  String get _uid => _auth.currentUser!.uid;

  Future<void> savePlayer(UserPlayer player) async {
    await _firestore
        .collection("players")
        .doc(_uid)
        .collection("user_players")
        .doc(player.id)
        .set(player.toMap());
  }

  Future<void> deletePlayer(String playerId) async {
    await _firestore
        .collection("players")
        .doc(_uid)
        .collection("user_players")
        .doc(playerId)
        .delete();
  }

  Stream<List<UserPlayer>> getPlayers({
    required AppUser creator,
  }) {
    return _firestore
        .collection("players")
        .doc(_uid)
        .collection("user_players")
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map(
              (doc) => UserPlayer.fromMap(
                doc.data(),
              ),
            )
            .toList());
  }
}
