import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:liga_master/models/competition/competition.dart';
import 'package:liga_master/models/fixture/fixture.dart';
import 'package:liga_master/models/match/sport_match.dart';
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
      competition.id = docRef.id;

      competition.code = await CompetitionCodeGenerator.generateUniqueCode(
          competitionName: competition.name,
          creatorEmail: competition.creator.email,
          suffixLength: 3);

      await _firestore.runTransaction((transaction) async {
        await docRef.set(competition.toMap());

        transaction.update(
            _firestore.collection("users").doc(competition.creator.id), {
          "competitions": FieldValue.arrayUnion([competition.id])
        });
      });
    }
    onCompetitionsUpdated();
  }

  Future<String> addCompetitionToUserByCode(
      {required String code,
      required String userId,
      required String successMessage,
      required String errorMessage,
      required VoidCallback onCompetitionsUpdated}) async {
    CollectionReference<Map<String, dynamic>> collection =
        _firestore.collection(_collectionName);
    final query =
        await collection.where("code", isEqualTo: code).limit(1).get();

    if (query.docs.isEmpty) return errorMessage;

    final competitionData = query.docs.first.data();

    final String creatorId = competitionData["creator_id"];

    final userPlayers = _getCompetitionPlayers(competitionData);
    final userTeams = _getCompetitionTeams(competitionData, userPlayers);

    final userDoc = await _firestore.collection("users").doc(creatorId).get();

    final fixtures = await _getFixtures(competitionData["id"]);

    final creator = AppUser.fromMap(userDoc.data()!);

    final competition = Competition.fromMap(
        competitionData, creator, userTeams, userPlayers, fixtures);

    await _firestore.collection("users").doc(userId).update(({
          "competitions": FieldValue.arrayUnion([competition.id])
        }));

    onCompetitionsUpdated();
    return successMessage;
  }

  Future<void> deleteCompetition(Competition competition, String userId,
      VoidCallback onCompetitionsUpdated) async {
    if (competition.creator.id == userId) {
      final snapshot = await _firestore
          .collection("users")
          .where("competitions", arrayContains: competition.id)
          .get();

      List<String> userIds = snapshot.docs.map((doc) => doc.id).toList();
      await removeFixtures(competition.id);
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

  Stream<List<Competition>> getCompetitions({required String userId}) =>
      _firestore.collection("users").doc(userId).snapshots().asyncExpand(
        (userSnapshot) {
          List<String> competitionsIds =
              List<String>.from(userSnapshot.data()?["competitions"] ?? []);

          if (competitionsIds.isEmpty) return Stream.value([]);

          final splittedIds = _splitCompetitionsIds(competitionsIds);

          final streams = _getCompetitionsStream(splittedIds);

          return Rx.combineLatestList(streams).map(
            (stream) => stream.expand((e) => e).toList(),
          );
        },
      );

  List<List<String>> _splitCompetitionsIds(List<String> competitionsIds) {
    final splittedIds = <List<String>>[];

    for (int i = 0; i < competitionsIds.length; i += 10) {
      splittedIds.add(competitionsIds.sublist(
        i,
        i + 10 > competitionsIds.length ? competitionsIds.length : i + 10,
      ));
    }

    return splittedIds;
  }

  Iterable<Stream<List<Competition>>> _getCompetitionsStream(
          List<List<String>> splittedIds) =>
      splittedIds.map(
        (id) => _firestore
            .collection(_collectionName)
            .where(FieldPath.documentId, whereIn: id)
            .snapshots()
            .asyncMap(
              (snapshot) async => Future.wait(
                snapshot.docs.map(
                  (doc) async {
                    final data = doc.data();
                    final creatorId = data["creator_id"];
                    final String competitionId = data["id"];
                    final userDoc = await _firestore
                        .collection("users")
                        .doc(creatorId)
                        .get();
                    final creator = AppUser.fromMap(userDoc.data()!);
                    final players = _getCompetitionPlayers(data);
                    final teams = _getCompetitionTeams(data, players);

                    final fixtures = await _getFixtures(competitionId);

                    return Competition.fromMap(
                        data, creator, teams, players, fixtures);
                  },
                ),
              ),
            ),
      );

  List<UserPlayer> _getCompetitionPlayers(Map<String, dynamic> data) =>
      (data["players"] as List)
          .cast<Map<String, dynamic>>()
          .map((player) => UserPlayer.fromCompetitionMap(player))
          .toList();

  List<UserTeam> _getCompetitionTeams(
          Map<String, dynamic> data, List<UserPlayer> players) =>
      (data["teams"] as List)
          .cast<Map<String, dynamic>>()
          .map((team) => UserTeam.fromCompetitionMap(team, allPlayers: players))
          .toList();

  Future<void> saveFixture(Fixture fixture, String competitionId) async {
    _firestore
        .collection(_collectionName)
        .doc(competitionId)
        .collection(_fixturesSubCollectionName)
        .doc(fixture.name)
        .set(fixture.toMap());

    for (final match in fixture.matches) {
      saveMatch(match, competitionId, fixture.name);
    }
  }

  Future<void> removeFixtures(String competitionId) async {
    final collection = _firestore
        .collection(_collectionName)
        .doc(competitionId)
        .collection(_fixturesSubCollectionName);

    final batch = _firestore.batch();

    await collection.get().then((snapshot) async {
      for (final doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
    });
    batch.commit();
  }

  Future<List<Fixture>> _getFixtures(String competitionId) async {
    QuerySnapshot<Map<String, dynamic>> snapshot;
    try {
      snapshot = await _firestore
          .collection(_collectionName)
          .doc(competitionId)
          .collection(_fixturesSubCollectionName)
          .orderBy("number")
          .get();

      if (snapshot.docs.isEmpty) return [];

      final docsData = snapshot.docs.map((doc) => doc.data()).toList();
      List<SportMatch> matches = [];
      List<Fixture> fixtures = [];
      for (final docData in docsData) {
        matches = await _getMatchesFromFixture(competitionId, docData["name"]);
        fixtures.add(Fixture.fromMap(docData, matches));
      }

      return fixtures;
    } on FirebaseException catch (_) {}

    return [];
  }

  Future<void> saveMatch(
          SportMatch match, String competitionId, String fixtureName) async =>
      await _firestore
          .collection(_collectionName)
          .doc(competitionId)
          .collection(_fixturesSubCollectionName)
          .doc(fixtureName)
          .collection(_matchesSubCollectionName)
          .doc(match.id)
          .set(match.toMap());

  Future<List<SportMatch>> _getMatchesFromFixture(
      String competitionId, String fixtureName) async {
    final snapshot = await _firestore
        .collection(_collectionName)
        .doc(competitionId)
        .collection(_fixturesSubCollectionName)
        .doc(fixtureName)
        .collection(_matchesSubCollectionName)
        .orderBy("date")
        .get();

    final docRef =
        await _firestore.collection(_collectionName).doc(competitionId).get();

    final data = docRef.data();

    if (data == null) return [];

    final players = _getCompetitionPlayers(data);
    final teams = _getCompetitionTeams(data, players);

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
