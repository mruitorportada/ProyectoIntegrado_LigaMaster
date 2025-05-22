import 'package:flutter/material.dart';
import 'package:liga_master/screens/generic/appcolors.dart';

SimpleDialog genericSelectionDialog(String title,
        {required List<SimpleDialogOption> options}) =>
    SimpleDialog(
      title: Text(
        title,
        style: TextStyle(color: LightThemeAppColors.textColor),
      ),
      backgroundColor: LightThemeAppColors.background,
      children: options,
    );
