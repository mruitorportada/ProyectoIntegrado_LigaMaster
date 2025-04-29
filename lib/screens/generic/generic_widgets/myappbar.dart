import 'package:flutter/material.dart';

AppBar myAppBar(String title, Color backgroundColor, List<Widget> actions,
        IconButton? navIcon,
        {bool isHomeScreen = false}) =>
    AppBar(
      title: Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
      iconTheme: IconThemeData(color: Colors.white),
      backgroundColor: backgroundColor,
      actions: actions,
      leading: isHomeScreen ? null : navIcon,
    );
