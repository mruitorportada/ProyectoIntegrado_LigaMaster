import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:liga_master/models/user/entities/user_player.dart';

class PlayerService {
  final FirebaseFirestore _firestore;

  PlayerService({required FirebaseFirestore firestore})
      : _firestore = firestore;

  Future<void> savePlayer(UserPlayer player, String userId) async {
    await _firestore
        .collection("players")
        .doc(userId)
        .collection("user_players")
        .doc(player.id)
        .set(player.toMap());
    await _firestore.collection("users").doc(userId).update(
          ({
            "players": FieldValue.arrayUnion([player.id])
          }),
        );
  }

  Future<void> deletePlayer(String playerId, String userId) async {
    await _firestore
        .collection("players")
        .doc(userId)
        .collection("user_players")
        .doc(playerId)
        .delete();
    await _firestore.collection("users").doc(userId).update(({
          "players": FieldValue.arrayRemove([playerId])
        }));
  }

  Stream<List<UserPlayer>> getPlayers(String userId) {
    return _firestore
        .collection("players")
        .doc(userId)
        .collection("user_players")
        .orderBy("teamName")
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => UserPlayer.fromMap(
                  doc.data(),
                ),
              )
              .toList(),
        );
  }

  Future<bool> checkPlayerNameIsUnique(String playerName, String userId) async {
    CollectionReference collectionRef =
        _firestore.collection("players").doc(userId).collection("user_players");

    var query =
        await collectionRef.where("name", isEqualTo: playerName).limit(1).get();

    bool unique = query.docs.isEmpty;
    return unique;
  }
}
