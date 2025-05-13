import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:liga_master/models/competition/competition.dart';
import 'package:liga_master/models/fixture/fixture.dart';
import 'package:liga_master/models/match/match.dart';
import 'package:liga_master/models/user/app_user.dart';
import 'package:liga_master/models/user/entities/user_player.dart';
import 'package:liga_master/models/user/entities/user_team.dart';
import 'package:rxdart/rxdart.dart';

class CompetitionService {
  final FirebaseFirestore _firestore;
  final String _collectionName = "competitions";
  final String _matchesSubCollectionName = "matches";
  final String _fixturesSubCollectionName = "fixtures";

  CompetitionService({required FirebaseFirestore firestore})
      : _firestore = firestore;

  Future<void> saveCompetition(Competition competition, String userId,
      VoidCallback onCompetitionsUpdated) async {
    if (competition.id != "") {
      DocumentReference docRef =
          _firestore.collection(_collectionName).doc(competition.id);
      try {
        await docRef.update(competition.toMap());
        onCompetitionsUpdated();
      } on FirebaseException catch (_) {}
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

    var userPlayers = (competitionData["players"] as List)
        .cast<Map<String, dynamic>>()
        .map((player) => UserPlayer.fromCompetitionMap(player))
        .toList();
    var userTeams = (competitionData["teams"] as List)
        .cast<Map<String, dynamic>>()
        .map((team) =>
            UserTeam.fromCompetitionMap(team, allPlayers: userPlayers))
        .toList();

    var userDoc = await _firestore.collection("users").doc(creatorId).get();

    var fixtures = await _getFixtures(competitionData["id"]);

    AppUser creator = AppUser.fromMap(userDoc.data()!);

    Competition competition = Competition.fromMap(
        competitionData, creator, userTeams, userPlayers, fixtures);

    await _firestore.collection("users").doc(userId).update(({
          "competitions": FieldValue.arrayUnion([competition.id])
        }));

    onCompetitionsUpdated();
  }

  Future<void> deleteCompetition(Competition competition, String userId,
      VoidCallback onCompetitionsUpdated) async {
    if (competition.creator.id == userId) {
      var snapshot = await _firestore
          .collection("users")
          .where("competitions", arrayContains: competition.id)
          .get();

      List<String> userIds = snapshot.docs.map((doc) => doc.id).toList();
      await _firestore.runTransaction((transaction) async {
        transaction
            .delete(_firestore.collection(_collectionName).doc(competition.id));
        for (String id in userIds) {
          transaction.update(_firestore.collection("users").doc(id), {
            "competitions": FieldValue.arrayRemove([competition.id])
          });
        }
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
                      String competitionId = data["id"];
                      final userDoc = await _firestore
                          .collection("users")
                          .doc(creatorId)
                          .get();
                      final creator = AppUser.fromMap(userDoc.data()!);
                      var players = _getCompetitionPlayers(data);
                      var teams = _getCompetitionTeams(data, players);

                      var fixtures = await _getFixtures(competitionId);

                      return Competition.fromMap(
                          data, creator, teams, players, fixtures);
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

  List<UserPlayer> _getCompetitionPlayers(Map<String, dynamic> data) {
    return (data["players"] as List)
        .cast<Map<String, dynamic>>()
        .map((player) => UserPlayer.fromCompetitionMap(player))
        .toList();
  }

  List<UserTeam> _getCompetitionTeams(
      Map<String, dynamic> data, List<UserPlayer> players) {
    return (data["teams"] as List)
        .cast<Map<String, dynamic>>()
        .map((team) => UserTeam.fromCompetitionMap(team, allPlayers: players))
        .toList();
  }

  Future<void> saveFixture(Fixture fixture, String competitionId) async {
    _firestore
        .collection(_collectionName)
        .doc(competitionId)
        .collection(_fixturesSubCollectionName)
        .doc(fixture.name)
        .set(fixture.toMap());

    for (var match in fixture.matches) {
      saveMatch(match, competitionId, fixture.name);
    }
  }

  Future<List<Fixture>> _getFixtures(String competitionId) async {
    var snapshot = await _firestore
        .collection(_collectionName)
        .doc(competitionId)
        .collection(_fixturesSubCollectionName)
        .orderBy("number")
        .get();

    if (snapshot.docs.isEmpty) return [];

    final docsData = snapshot.docs.map((doc) => doc.data()).toList();
    List<SportMatch> matches = [];
    List<Fixture> fixtures = [];
    for (var docData in docsData) {
      matches = await _getMatchesFromFixture(competitionId, docData["name"]);
      fixtures.add(Fixture.fromMap(docData, matches));
    }

    return fixtures;
  }

  Future<void> saveMatch(
      SportMatch match, String competitionId, String fixtureName) async {
    await _firestore
        .collection(_collectionName)
        .doc(competitionId)
        .collection(_fixturesSubCollectionName)
        .doc(fixtureName)
        .collection(_matchesSubCollectionName)
        .doc(match.id)
        .set(match.toMap());
  }

  Future<List<SportMatch>> _getMatchesFromFixture(
      String competitionId, String fixtureName) async {
    var snapshot = await _firestore
        .collection(_collectionName)
        .doc(competitionId)
        .collection(_fixturesSubCollectionName)
        .doc(fixtureName)
        .collection(_matchesSubCollectionName)
        .orderBy("date")
        .get();

    var docRef =
        await _firestore.collection(_collectionName).doc(competitionId).get();

    var data = docRef.data();

    if (data == null) return [];

    var players = _getCompetitionPlayers(data);
    var teams = _getCompetitionTeams(data, players);

    return snapshot.docs
        .map((doc) => SportMatch.fromMap(doc.data(), teams))
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
