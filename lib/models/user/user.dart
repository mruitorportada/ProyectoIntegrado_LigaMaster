import 'package:flutter/material.dart';

class User extends ChangeNotifier {
  final String _id;
  get id => _id;

  final String _name;
  get name => _name;

  final String _surname;
  get surname => _surname;

  final String _username;
  get username => _username;

  final String _email;
  get email => _email;

  final String _password;
  get password => _password;

  User(this._id, this._name, this._surname, this._username, this._email,
      this._password);
}
