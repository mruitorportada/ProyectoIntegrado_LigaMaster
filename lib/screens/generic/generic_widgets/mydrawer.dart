import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:liga_master/screens/generic/appcolors.dart';
import 'package:liga_master/screens/home/home_screen.dart';
import 'package:liga_master/screens/home/home_screen_viewmodel.dart';
import 'package:liga_master/screens/login/login_screen.dart';
import 'package:liga_master/screens/profile/profile_screen.dart';

Drawer myDrawer(
        BuildContext context, HomeScreenViewmodel homeScreenViewModel) =>
    Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: LightThemeAppColors.background),
            accountName: Text(
              homeScreenViewModel.user.username,
              style: TextStyle(color: LightThemeAppColors.textColor),
            ),
            accountEmail: Text(
              homeScreenViewModel.user.email,
              style: TextStyle(
                color: LightThemeAppColors.subtextColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.home,
            ),
            title: Text(
              "Inicio",
            ),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => HomeScreen(
                user: homeScreenViewModel.user,
              ),
            )),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text("Ver perfil"),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ProfileScreen(
                  homeScreenViewmodel: homeScreenViewModel,
                ),
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.logout,
            ),
            title: Text(
              "Cerrar sesión",
            ),
            onTap: () => onLogoutTap(homeScreenViewModel, context),
          )
        ],
      ),
    );

void onLogoutTap(
    HomeScreenViewmodel homeScreenViewModel, BuildContext context) {
  homeScreenViewModel.onLogOut();
  FirebaseAuth.instance.signOut();
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => LoginScreen()));
}
