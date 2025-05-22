import 'package:flutter/material.dart';
import 'package:liga_master/screens/generic/appcolors.dart';
import 'package:liga_master/screens/generic/generic_widgets/myappbar.dart';
import 'package:liga_master/screens/generic/generic_widgets/mydrawer.dart';
import 'package:liga_master/screens/home/home_screen_viewmodel.dart';

class ProfileScreen extends StatelessWidget {
  final HomeScreenViewmodel homeScreenViewmodel;
  const ProfileScreen({super.key, required this.homeScreenViewmodel});

  final _backgroundColor = LightThemeAppColors.background;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: myAppBar("Detalles del perfil", _backgroundColor, [], null),
      body: Placeholder(),
      drawer: myDrawer(context, homeScreenViewmodel),
    ));
  }
}
