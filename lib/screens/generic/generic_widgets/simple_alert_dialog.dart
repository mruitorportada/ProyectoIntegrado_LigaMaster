import 'package:flutter/material.dart';
import 'package:liga_master/screens/generic/appcolors.dart';

AlertDialog simpleAlertDialog(BuildContext context,
        {required String title,
        String message = "",
        required List<Widget> actions}) =>
    AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Text(
        title,
        style: TextStyle(
            color: LightThemeAppColors.textColor, fontWeight: FontWeight.bold),
      ),
      content: Text(
        message,
        style: TextStyle(
          color: Theme.of(context).listTileTheme.subtitleTextStyle?.color,
        ),
      ),
      actions: actions,
    );
