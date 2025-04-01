import 'package:flutter/material.dart';

AppBar myAppBar(String title, List<Widget> actions, IconButton? navIcon,
        {bool isHomeScreen = false}) =>
    AppBar(
      title: Text(title),
      actions: actions,
      leading: isHomeScreen ? null : navIcon,
    );
