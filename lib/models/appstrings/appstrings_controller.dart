import 'package:flutter/material.dart';
import 'package:liga_master/models/appstrings/appstrings.dart';
import 'package:liga_master/services/appstrings_service.dart';

class AppStringsController extends ChangeNotifier {
  AppStringsService _service;
  String _language;
  AppStrings? _strings;
  bool _loading = true;

  AppStrings? get strings => _strings;
  bool get isLoading => _loading;

  AppStringsController({
    required AppStringsService service,
    required String language,
  })  : _service = service,
        _language = language {
    _loadStrings();
  }

  void updateService(AppStringsService service) {
    _service = service;
    _loadStrings();
  }

  Future<void> _loadStrings() async {
    _loading = true;
    notifyListeners();

    _strings = await _service.getAppStringsFromFirestore(_language);
    _loading = false;
    notifyListeners();
  }

  void updateLanguage(String newLang) {
    _language = newLang;
    _loadStrings();
  }
}
