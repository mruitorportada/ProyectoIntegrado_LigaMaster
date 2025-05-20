import 'package:flutter/material.dart';
import 'package:liga_master/screens/generic/appcolors.dart';

AlertDialog simpleAlertDialog(
        {required String title,
        String message = "",
        required List<Widget> actions}) =>
    AlertDialog(
      backgroundColor: AppColors.background,
      title: Text(
        title,
        style: TextStyle(color: AppColors.textColor),
      ),
      content: Text(
        message,
        style: TextStyle(color: AppColors.accent),
      ),
      actions: actions,
    );
