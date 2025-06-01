import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:liga_master/models/user/app_user.dart';
import 'package:liga_master/screens/generic/appcolors.dart';
import 'package:liga_master/screens/home/home_screen.dart';
import 'package:liga_master/screens/home/home_screen_viewmodel.dart';
import 'package:liga_master/screens/login/login_screen.dart';
import 'package:liga_master/screens/profile/profile_screen.dart';

Drawer myDrawer(BuildContext context, HomeScreenViewmodel homeScreenViewModel) {
  final AppUser user = homeScreenViewModel.user;

  return Drawer(
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    child: ListView(
      children: <Widget>[
        UserAccountsDrawerHeader(
          currentAccountPicture: user.image != null
              ? CircleAvatar(
                  radius: 35,
                  backgroundImage: FileImage(
                    File(user.image!),
                  ),
                )
              : CircleAvatar(
                  radius: 35,
                  child: Icon(
                    Icons.person,
                    size: 35,
                  ),
                ),
          currentAccountPictureSize: const Size(70, 70),
          decoration:
              BoxDecoration(color: Theme.of(context).colorScheme.primary),
          accountName: Text(
            user.username,
            style: TextStyle(color: LightThemeAppColors.textColor),
          ),
          accountEmail: Text(
            user.email,
            style: TextStyle(
              color: Theme.of(context).listTileTheme.subtitleTextStyle?.color,
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
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => HomeScreen(
                user: user,
              ),
            ),
          ),
        ),
        ListTile(
          leading: Icon(Icons.person),
          title: Text(
            "Ver perfil",
          ),
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
}

void onLogoutTap(
    HomeScreenViewmodel homeScreenViewModel, BuildContext context) {
  homeScreenViewModel.onLogOut();
  FirebaseAuth.instance.signOut();
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => LoginScreen()));
}
