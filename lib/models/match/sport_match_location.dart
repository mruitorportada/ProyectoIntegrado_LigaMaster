import 'package:flutter/material.dart';

class SportMatchLocation extends ChangeNotifier {
  String _name;
  String get name => _name;
  set name(String value) {
    _name = value;
    notifyListeners();
  }

  String _address;
  String get address => _address;
  set address(String value) {
    _address = value;
    notifyListeners();
  }

  SportMatchLocation({
    required String name,
    required String address,
  })  : _name = name,
        _address = address;

  factory SportMatchLocation.fromMap(Map<String, dynamic> data) =>
      SportMatchLocation(
          name: data["name"] ?? "N/A", address: data["address"] ?? "N/A");

  Map<String, dynamic> toMap() => {
        "name": _name,
        "address": _address,
      };
}
