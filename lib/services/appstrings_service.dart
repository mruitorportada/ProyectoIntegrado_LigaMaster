import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:liga_master/models/appstrings/appstrings.dart';

class AppStringsService {
  final FirebaseFirestore _firestore;
  final String _collectionName = "appstrings";

  AppStringsService({required FirebaseFirestore firestore})
      : _firestore = firestore;

  Future<AppStrings?> getAppStringsFromFirestore(String language) async {
    final document = await _firestore
        .collection(_collectionName)
        .doc("app_strings_$language")
        .get();

    if (document.exists &&
        document.data() != null &&
        document.data()!.isNotEmpty) {
      return AppStrings.fromMap(document.data()!);
    }

    final jsonBackUp = await _loadFallbackJson(language);
    if (jsonBackUp != null) {
      setAppStringsFromFirestore(jsonBackUp, language);
    }

    return jsonBackUp;
  }

  Future<void> setAppStringsFromFirestore(
      AppStrings appStrings, String language) async {
    await _firestore
        .collection(_collectionName)
        .doc("app_strings_$language")
        .set(appStrings.toMap());
  }

  Future<AppStrings?> _loadFallbackJson(String language) async {
    try {
      final jsonString = await rootBundle
          .loadString('assets/stringsData/appstrings_$language.json');
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      return AppStrings.fromMap(jsonMap);
    } catch (e) {
      return null;
    }
  }
}
