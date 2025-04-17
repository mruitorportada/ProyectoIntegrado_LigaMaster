import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:liga_master/models/competition/competition.dart';
import 'package:liga_master/models/user/app_user.dart';
import 'package:liga_master/models/user/entities/user_player.dart';
import 'package:liga_master/models/user/entities/user_team.dart';

class AppUserService {
  Future<AppUser?> loadAppUserFromFirestore(
    String id, {
    List<UserTeam> firebaseTeams = const [],
    List<UserPlayer> firebasePlayers = const [],
    List<Competition> firebaseCompetitions = const [],
  }) async {
    final document =
        await FirebaseFirestore.instance.collection("users").doc(id).get();

    if (!document.exists || document.data() == null) return null;

    return AppUser.fromMap(document.data()!,
        firebaseTeams: firebaseTeams,
        firebaseCompetitions: firebaseCompetitions,
        firebasePlayers: firebasePlayers);
  }

  Future<void> saveUserToFirestore(AppUser user) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user.id)
        .set(user.toMap());
  }
}
