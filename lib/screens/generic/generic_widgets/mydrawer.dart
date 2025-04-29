import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:liga_master/models/user/app_user.dart';
import 'package:liga_master/screens/generic/appcolors.dart';
import 'package:liga_master/screens/home/home_screen.dart';
import 'package:liga_master/screens/home/home_screen_viewmodel.dart';
import 'package:liga_master/screens/login/login_screen.dart';
import 'package:liga_master/screens/profile/profile_screen.dart';
import 'package:provider/provider.dart';

Drawer myDrawer(BuildContext context, AppUser user) => Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: AppColors.background),
            accountName: Text(
              user.username,
              style: TextStyle(color: Colors.white),
            ),
            accountEmail: Text(
              user.email,
              style: TextStyle(color: Colors.white70),
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
              builder: (context) => HomeScreen(),
            )),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text("Ver perfil"),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ProfileScreen(),
            )),
          ),
          ListTile(
            leading: Icon(
              Icons.logout,
            ),
            title: Text(
              "Cerrar sesión",
            ),
            onTap: () => onLogoutTap(context),
          )
        ],
      ),
    );

void onLogoutTap(BuildContext context) {
  var homeScreenViewModel =
      Provider.of<HomeScreenViewmodel>(context, listen: false);
  homeScreenViewModel.onLogOut();
  FirebaseAuth.instance.signOut();
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => LoginScreen()));
}
