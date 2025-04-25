import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:liga_master/models/user/app_user.dart';
import 'package:liga_master/models/user/entities/user_player.dart';

class PlayerService {
  final FirebaseFirestore _firestore;
  final String _uid;

  CollectionReference<Map<String, dynamic>> get _players =>
      _firestore.collection("players").doc(_uid).collection("user_players");

  PlayerService({required FirebaseFirestore firestore, required String uid})
      : _firestore = firestore,
        _uid = uid;

  Future<void> savePlayer(UserPlayer player, String userId) async {
    await _players.doc(player.id).set(player.toMap());
    await _firestore.collection("users").doc(userId).update(({
          "players": FieldValue.arrayUnion([player.id])
        }));
  }

  Future<void> deletePlayer(String playerId, String userId) async {
    await _players.doc(playerId).delete();
    await _firestore.collection("users").doc(userId).update(({
          "players": FieldValue.arrayRemove([playerId])
        }));
  }

  Stream<List<UserPlayer>> getPlayers({
    required AppUser creator,
  }) {
    return _players.snapshots().map((snapshot) => snapshot.docs
        .map(
          (doc) => UserPlayer.fromMap(
            doc.data(),
          ),
        )
        .toList());
  }
}
