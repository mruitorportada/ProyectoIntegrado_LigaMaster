import 'package:flutter/material.dart';
import 'package:liga_master/screens/generic/appcolors.dart';

Card genericCard(
        {required String title,
        required String subtitle,
        required IconData trailIcon}) =>
    Card(
      color: LightThemeAppColors.primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(color: LightThemeAppColors.textColor),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
              color: LightThemeAppColors.subtextColor,
              fontWeight: FontWeight.w600),
        ),
        trailing: Icon(
          trailIcon,
          color: LightThemeAppColors.secondaryColor,
        ),
      ),
    );
