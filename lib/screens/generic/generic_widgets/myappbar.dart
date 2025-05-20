import 'package:flutter/material.dart';
import 'package:liga_master/screens/generic/appcolors.dart';

AppBar myAppBar(String title, Color backgroundColor, List<Widget> actions,
        IconButton? navIcon,
        {bool isHomeScreen = false}) =>
    AppBar(
      title: Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
      iconTheme: IconThemeData(color: AppColors.accent),
      backgroundColor: backgroundColor,
      actions: actions,
      leading: isHomeScreen ? null : navIcon,
    );
