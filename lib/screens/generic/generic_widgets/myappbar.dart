import 'package:flutter/material.dart';

AppBar myAppBar(BuildContext context, String title, List<Widget> actions,
        IconButton? navIcon,
        {bool isHomeScreen = false}) =>
    AppBar(
      title: Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
      iconTheme: IconThemeData(color: Theme.of(context).colorScheme.secondary),
      actions: actions,
      leading: isHomeScreen ? null : navIcon,
    );
