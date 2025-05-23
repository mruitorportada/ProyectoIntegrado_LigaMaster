import 'package:flutter/material.dart';
import 'package:liga_master/screens/generic/appcolors.dart';

AppBar myAppBar(String title, List<Widget> actions, IconButton? navIcon,
        {bool isHomeScreen = false}) =>
    AppBar(
      title: Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
      iconTheme: IconThemeData(color: LightThemeAppColors.secondaryColor),
      actions: actions,
      leading: isHomeScreen ? null : navIcon,
    );
