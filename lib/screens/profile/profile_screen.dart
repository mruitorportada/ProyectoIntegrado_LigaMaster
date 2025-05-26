import 'package:flutter/material.dart';
import 'package:liga_master/models/user/app_user.dart';
import 'package:liga_master/screens/generic/generic_widgets/myappbar.dart';
import 'package:liga_master/screens/generic/generic_widgets/mydrawer.dart';
import 'package:liga_master/screens/home/home_screen_viewmodel.dart';

class ProfileScreen extends StatelessWidget {
  final HomeScreenViewmodel homeScreenViewmodel;
  const ProfileScreen({super.key, required this.homeScreenViewmodel});

  AppUser get _user => homeScreenViewmodel.user;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: myAppBar("Detalles del perfil", [], null),
        body: _body,
        drawer: myDrawer(context, homeScreenViewmodel),
      ),
    );
  }

  Widget get _body => ListView(
        padding: EdgeInsets.all(20),
        children: <Widget>[
          TextFormField(
            initialValue: _user.name,
            readOnly: true,
            decoration: InputDecoration(
              labelText: "Nombre",
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            initialValue: _user.surname,
            readOnly: true,
            decoration: InputDecoration(
              labelText: "Apellidos",
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            initialValue: _user.username,
            readOnly: true,
            decoration: InputDecoration(
              labelText: "Nombre de usuario",
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            initialValue: _user.email,
            readOnly: true,
            decoration: InputDecoration(
              labelText: "Email",
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            initialValue: "${_user.competitions.length}",
            readOnly: true,
            decoration: InputDecoration(
              labelText: "Competiciones guardadas",
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            initialValue: "${_user.teams.length}",
            readOnly: true,
            decoration: InputDecoration(
              labelText: "Equipos guardados",
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            initialValue: "${_user.players.length}",
            readOnly: true,
            decoration: InputDecoration(
              labelText: "Jugadores guardados",
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      );
}
