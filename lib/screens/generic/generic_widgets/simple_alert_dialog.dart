import 'package:flutter/material.dart';
import 'package:liga_master/screens/generic/appcolors.dart';

AlertDialog simpleAlertDialog(
        {required String title,
        String message = "",
        required List<Widget> actions}) =>
    AlertDialog(
      backgroundColor: LightThemeAppColors.background,
      title: Text(
        title,
        style: TextStyle(
            color: LightThemeAppColors.textColor, fontWeight: FontWeight.bold),
      ),
      content: Text(
        message,
        style: TextStyle(color: LightThemeAppColors.subtextColor),
      ),
      actions: actions,
    );
