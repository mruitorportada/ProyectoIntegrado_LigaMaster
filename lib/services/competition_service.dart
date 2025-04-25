import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:liga_master/models/competition/competition.dart';
import 'package:liga_master/models/user/app_user.dart';
import 'package:liga_master/models/user/entities/user_player.dart';
import 'package:liga_master/models/user/entities/user_team.dart';
import 'package:rxdart/rxdart.dart';

class CompetitionService {
  final FirebaseFirestore _firestore;
  final String _collectionName = "competitions";

  CompetitionService({required FirebaseFirestore firestore})
      : _firestore = firestore;

  Future<void> saveCompetition(Competition competition, String userId,
      VoidCallback onCompetitionsUpdated) async {
    if (competition.id != "") {
      DocumentReference docRef =
          _firestore.collection(_collectionName).doc(competition.id);
      await docRef.set(competition.toMap());
    } else {
      DocumentReference docRef = _firestore.collection(_collectionName).doc();
      String docId = docRef.id;

      competition.id = docId;
      competition.code = await CompetitionCodeGenerator.generateUniqueCode(
          competitionName: competition.name,
          creatorEmail: competition.creator.email,
          suffixLength: 3);

      await _firestore.runTransaction((transaction) async {
        await docRef.set(competition.toMap());

        transaction.update(
            _firestore.collection("users").doc(competition.creator.id), {
          "competitions": FieldValue.arrayUnion([docId])
        });
      });
    }
    onCompetitionsUpdated();
  }

  Future<void> addCompetitionToUserByCode(
      String code, String userId, VoidCallback onCompetitionsUpdated) async {
    CollectionReference<Map<String, dynamic>> collection =
        _firestore.collection(_collectionName);
    var query = await collection.where("code", isEqualTo: code).limit(1).get();

    if (query.docs.isEmpty) return;

    Map<String, dynamic> competitionData = query.docs.first.data();

    String creatorId = competitionData["creator_id"];
    List<String> teamsId =
        (competitionData["teams"] as List?)?.cast<String>() ?? [];

    List<UserPlayer> userPlayers = await _getCompetitionPlayers(creatorId);

    List<UserTeam> userTeams =
        await _getCompetitionTeams(creatorId, teamsId, userPlayers);

    var userDoc = await _firestore.collection("users").doc(creatorId).get();

    AppUser creator = AppUser.fromMap(userDoc.data()!);

    Competition competition =
        Competition.fromJson(competitionData, creator, userTeams, userPlayers);

    await _firestore.collection("users").doc(userId).update(({
          "competitions": FieldValue.arrayUnion([competition.id])
        }));

    onCompetitionsUpdated();
  }

  Future<void> deleteCompetition(Competition competition, String userId,
      VoidCallback onCompetitionsUpdated) async {
    if (competition.creator.id == userId) {
      await _firestore.runTransaction((transaction) async {
        transaction
            .delete(_firestore.collection(_collectionName).doc(competition.id));
        transaction.update(_firestore.collection("users").doc(userId), {
          "competitions": FieldValue.arrayRemove([competition.id])
        });
      });
    } else {
      await _firestore.collection("users").doc(userId).update({
        "competitions": FieldValue.arrayRemove([competition.id])
      });
      onCompetitionsUpdated();
    }
  }

  Stream<List<Competition>> getCompetitions({
    required String userId,
    required List<UserTeam> allTeams,
    required List<UserPlayer> allPlayers,
  }) {
    return _firestore
        .collection("users")
        .doc(userId)
        .snapshots()
        .asyncExpand((userSnapshot) {
      List<String> competitionsIds =
          List<String>.from(userSnapshot.data()?["competitions"] ?? []);

      if (competitionsIds.isEmpty) return Stream.value([]);

      final splittedIds = <List<String>>[];

      for (int i = 0; i < competitionsIds.length; i += 10) {
        splittedIds.add(competitionsIds.sublist(
          i,
          i + 10 > competitionsIds.length ? competitionsIds.length : i + 10,
        ));
      }

      final streams = splittedIds.map(
        (id) {
          return _firestore
              .collection(_collectionName)
              .where(FieldPath.documentId, whereIn: id)
              .snapshots()
              .asyncMap(
                (snapshot) async => Future.wait(
                  snapshot.docs.map(
                    (doc) async {
                      final data = doc.data();
                      final creatorId = data["creator_id"];
                      final userDoc = await _firestore
                          .collection("users")
                          .doc(creatorId)
                          .get();
                      final creator = AppUser.fromMap(userDoc.data()!);
                      if (creatorId == userId) {
                        return Competition.fromJson(
                            data, creator, allTeams, allPlayers);
                      } else {
                        List<String> teamsId =
                            (data["teams"] as List?)?.cast<String>() ?? [];
                        var players = await _getCompetitionPlayers(creatorId);
                        var teams = await _getCompetitionTeams(
                            creatorId, teamsId, players);
                        return Competition.fromJson(
                            data, creator, teams, players);
                      }
                    },
                  ),
                ),
              );
        },
      );
      return Rx.combineLatestList(streams).map(
        (chunkLists) => chunkLists.expand((e) => e).toList(),
      );
    });
  }

  Future<List<UserPlayer>> _getCompetitionPlayers(String creatorId) async {
    var snapshot = await _firestore
        .collection("players")
        .doc(creatorId)
        .collection("user_players")
        .get();

    return snapshot.docs.map((doc) => UserPlayer.fromMap(doc.data())).toList();
  }

  Future<List<UserTeam>> _getCompetitionTeams(String creatorId,
      List<String> teamsId, List<UserPlayer> userPlayers) async {
    var snapshot = await _firestore
        .collection("teams")
        .doc(creatorId)
        .collection("user_teams")
        .where(FieldPath.documentId, whereIn: teamsId)
        .get();

    return snapshot.docs
        .map((doc) => UserTeam.fromMap(doc.data(), allPlayers: userPlayers))
        .toList();
  }
}

class CompetitionCodeGenerator {
  static const _suffixChars = '23456789ABCDEFGHJKLMNPQRSTUVWXYZ';
  static const _maxPartLength = 4;
  static const _defaultSuffixLength = 3;

  static Future<String> generateUniqueCode({
    required String competitionName,
    required String creatorEmail,
    int suffixLength = _defaultSuffixLength,
  }) async {
    String code;
    bool exists;

    do {
      code = _generateCode(
        competitionName: competitionName,
        creatorEmail: creatorEmail,
        suffixLength: suffixLength,
      );

      exists = await _codeExists(code);
    } while (exists);

    return code;
  }

  static String _generateCode({
    required String competitionName,
    required String creatorEmail,
    required int suffixLength,
  }) {
    final rand = Random.secure();
    final username = _getUsernameFromEmail(creatorEmail);

    final cleanedName = _cleanString(competitionName)
        .substring(0, _maxPartLength.clamp(0, competitionName.length));
    final cleanedUser = _cleanString(username)
        .substring(0, _maxPartLength.clamp(0, username.length));

    final suffix = List.generate(suffixLength, (_) {
      return _suffixChars[rand.nextInt(_suffixChars.length)];
    }).join();

    return '$cleanedName$cleanedUser$suffix'.toUpperCase();
  }

  static Future<bool> _codeExists(String code) async {
    final query = await FirebaseFirestore.instance
        .collection('competitions')
        .where('code', isEqualTo: code)
        .limit(1)
        .get();

    return query.docs.isNotEmpty;
  }

  static String _getUsernameFromEmail(String email) {
    return email.split('@').first;
  }

  static String _cleanString(String input) {
    return input.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');
  }
}
